% Read and display the first image
I = imread('coins.png');
figure;
imshow(I);
title('Figure 1: Original Image');

% Apply an averaging filter
h = ones(5, 5) / 25;
b = imfilter(I, h);

% Display the filtered image
figure;
imshow(b);
title('Filtered Image');

% Perform edge detection using the Canny operator
f = edge(b, 'canny');
figure;
imshow(f);
title('Figure 2: Edge Detected Output by Canny Operator');

% Read and process the second image
I = imread('/MATLAB Drive/photos/pngtype.png');
grayI = rgb2gray(I); % Convert to grayscale

% Apply an averaging filter
h = ones(5, 5) / 25;
b = imfilter(grayI, h);

% Perform edge detection using the Canny operator
C = edge(b, 'canny');

% Display the results
figure;
subplot(2, 1, 1);
imshow(I);
title('Original Image');

subplot(2, 1, 2);
imshow(C);
title('Canny Edge Detection');
