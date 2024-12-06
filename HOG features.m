% Read an image from the training set.
img = readimage(trainingSet, 206);

% Extract HOG features with different cell sizes.
[hog_2x2, vis2x2] = extractHOGFeatures(img, 'CellSize', [2 2]);
[hog_4x4, vis4x4] = extractHOGFeatures(img, 'CellSize', [4 4]);
[hog_8x8, vis8x8] = extractHOGFeatures(img, 'CellSize', [8 8]);

% Display the original image and visualize the HOG features.
figure;
subplot(2, 3, 1:3);
imshow(img);
title('Original Image');

subplot(2, 3, 4);
plot(vis2x2);
title({'CellSize = [2 2]', ['Length = ' num2str(length(hog_2x2))]});

subplot(2, 3, 5);
plot(vis4x4);
title({'CellSize = [4 4]', ['Length = ' num2str(length(hog_4x4))]});

subplot(2, 3, 6);
plot(vis8x8);
title({'CellSize = [8 8]', ['Length = ' num2str(length(hog_8x8))]});
