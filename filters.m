img7 = imread('256x256bmptype.bmp'); 
img9 = rgb2gray(img7);

% Define kernel size for average filter
kernel_size = 5;
average_filter = fspecial('average', kernel_size);
img12 = imfilter(img9, average_filter, 'replicate');

% Define size for median filter
median_filter_size = 5;
img13 = medfilt2(img9, [median_filter_size median_filter_size]);

% Display the images
figure;
subplot(3, 1, 1); 
imshow(img7);
title('Original Image');

subplot(3, 1, 2); 
imshow(img12);
title('Average Filtered Image');

subplot(3, 1, 3); 
imshow(img13);
title('Median Filtered Image');