import math
import matplotlib.pyplot as plt

with open('./points.csv', 'r') as file:
  data1 = file.readlines()

points = [float.fromhex(point.strip()) for point in data1]

points_pred = []

# ic19 envelope lut
# some errors
# for i in range(0, 128):
#   points_pred.append(int(round(math.exp2(5 + i/8))))
# points_pred.append(0)
# for i in range(0, 127):
#   points_pred.append(0x200000 - int(round(math.exp2(5 + (i+1)/8))))

# rom c (ic11)
# perfectly matches!
# for i in range(0, len(points)):
#   points_pred.append(int(round(math.exp2(13.0 + i / 4096.0) - 4096*2)))

# ic9 phase lut
# some errors
# for i in range(0, len(points)):
#   if i > 0xc000:
#     points_pred.append(0)
#   else:
#     points_pred.append(int(math.exp2(7.0 + i / (0x10000 / 16))))

# ic8 interpolation lut
# very wrong!
# for i in range(0, len(points)):
#   points_pred.append(int(round(1 / ((i + 0.3) / 150))))

# rom ic10
# perfectly matches!
# for i in range(0, len(points)):
#   points_pred.append(int(round(math.exp2(11.0 + ~i / 1024.0) - 1024)))

# ic8 exp lut
# some errors
for i in range(0, 0x4000):
  points_pred.append(int(round((math.exp2(15.0 + ((0x4000-i) / 0x400)) - 0x1000) / (2048*32))))
for i in range(0, 0x4000):
  points_pred.append(int(round(0x8000 - (math.exp2(15.0 + ((0x4000-i) / 0x400)) - 0x1000) / (2048*32))))

# use this to compute the error with the original points
error = 0
for i in range(0, len(points)):
  error += abs(points[i] - points_pred[i])
print(error/len(points))

plt.plot(points)
plt.plot(points_pred)
plt.show()
