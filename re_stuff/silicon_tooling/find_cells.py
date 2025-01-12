import cv2
import numpy as np

def find_pattern_instances(image, pattern):
  # Convert both images to grayscale
  gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
  gray_pattern = cv2.cvtColor(pattern, cv2.COLOR_BGR2GRAY)

  # Find the pattern in the image using template matching
  result = cv2.matchTemplate(gray_image, gray_pattern, cv2.TM_CCOEFF_NORMED)
  threshold = 0.8  # Adjust this threshold as needed
  locations = np.where(result >= threshold)

  # Draw rectangles around the matched instances
  for pt in zip(*locations[::-1]):
    cv2.rectangle(image, pt, (pt[0] + pattern.shape[1], pt[1] + pattern.shape[0]), (0, 255, 0), 2)

  # Display the result
  cv2.imshow('Result', image)
  cv2.waitKey(0)
  cv2.destroyAllWindows()

image_path = '/Users/giuliozausa/personal/programming/rdpiano/roland_r15229837_mz_nikon20x.jpg'
pattern_path = '/Users/giuliozausa/personal/programming/rdpiano/ident_cells/1_N2N/2_0.jpg'
pattern = cv2.imread(pattern_path)

image = cv2.imread(image_path)
# imS = cv2.resize(image, (2048, 2048))
imS = image[4800:4800+2048,23080:23080+2048]
# cv2.imshow('Result', imS)
# cv2.waitKey(0)
# cv2.destroyAllWindows()
