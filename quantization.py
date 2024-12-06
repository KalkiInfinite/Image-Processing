import cv2
image = cv2.imread('exp1img.jpg')
levels = 2
quantized_image = (image // (256 // levels)) * (256 // levels)
cv2.imshow('Image', image)
cv2.imshow('Quantized Image', quantized_image)
cv2.waitKey(0)
cv2.destroyAllWindows()