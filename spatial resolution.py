import cv2
image = cv2.imread('exp1img.jpg')
new_width, new_height = 200, 200
resized_image = cv2.resize(image, (new_width, new_height))
cv2.imshow('Image', image)
cv2.imshow('Resized Image', resized_image)
cv2.waitKey(0)
cv2.destroyAllWindows()