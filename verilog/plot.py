import matplotlib.pyplot as plt

# Load the data from the CSV file
with open('/Users/giuliozausa/personal/programming/rdpiano/verilog/points.csv', 'r') as file:
  data = file.readlines()

# Convert the data to a list of numbers (hex to float)
points = [float.fromhex(point.strip()) for point in data]

# Plot the data
plt.plot(points)
plt.show()
