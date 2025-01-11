import math
import matplotlib.pyplot as plt

with open('/Users/giuliozausa/personal/programming/rdpiano/verilog/points.csv', 'r') as file:
  data1 = file.readlines()
# with open('/Users/giuliozausa/personal/programming/mame/samples_exp_table.csv', 'r') as file:
# with open('/Users/giuliozausa/personal/programming/mame/phase_exp_table.csv', 'r') as file:
#   data2 = file.readlines()

points1 = [float.fromhex(point.strip()) for point in data1]
# points2 = [float(point.strip()) for point in data2]

points_pred = []
for i in range(0, 128):
  points_pred.append(int(round(math.exp2(5 + i/8))))
points_pred.append(0)
for i in range(0, 127):
  points_pred.append(0x200000 - int(round(math.exp2(5 + (i+1)/8))))

# points_pred = []
# for i in range(0, 128):
#   points_pred.append(int(round(math.exp2(5 + i/8))))

# points_pred = []
# for i in range(0, 4096):
#   points_pred.append(int(round(math.exp2(13.0 + i / 4096.0) - 4096*2)))

# points_pred = []
# for i in range(0, 1024):
#   points_pred.append(int(round(math.exp2(11.0 + ~i / 1024.0) - 1024)))

# for i in range(0, 16384):
#   points_pred.append(int(math.exp2(11.0 + ~i / 1024.0) * 16))
# for i in range(0, 16384):
#   points_pred.append(int((16384*2) - math.exp2(11.0 + ~i / 1024.0) * 16))

error = 0
# for i in range(0, 256):
for i in range(0, 128):
  error += abs(points1[i] - points_pred[i])
print(error)

# error = 0
# for i in range(0, 4096):
#   error += abs(points1[i] - points_pred[i])
# print(error)

# error = 0
# for i in range(0, 16384):
#   error += abs(points[i] - points_pred[i])
# print(error/16384)

plt.plot(points1)
# plt.plot(points2)
plt.plot(points_pred)
plt.show()
