% Load training and test data using imageDatastore.
syntheticDir = fullfile(toolboxdir('vision'), 'visiondata', 'digits', 'synthetic');
handwrittenDir = fullfile(toolboxdir('vision'), 'visiondata', 'digits', 'handwritten');

% imageDatastore recursively scans the directory tree containing the images.
% Folder names are automatically used as labels for each image.
trainingSet = imageDatastore(syntheticDir, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
testSet = imageDatastore(handwrittenDir, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

% Display some sample images from the training and test sets.
figure;
subplot(2, 3, 1);
imshow(trainingSet.Files{102});
title('Training Image 102');
subplot(2, 3, 2);
imshow(trainingSet.Files{304});
title('Training Image 304');
subplot(2, 3, 3);
imshow(trainingSet.Files{809});
title('Training Image 809');
subplot(2, 3, 4);
imshow(testSet.Files{13});
title('Test Image 13');
subplot(2, 3, 5);
imshow(testSet.Files{37});
title('Test Image 37');
subplot(2, 3, 6);
imshow(testSet.Files{97});
title('Test Image 97');

% Show preprocessing results for an example test image.
exTestImage = readimage(testSet, 37);
processedImage = imbinarize(im2gray(exTestImage));

figure;
subplot(1, 2, 1);
imshow(exTestImage);
title('Original Test Image');
subplot(1, 2, 2);
imshow(processedImage);
title('Processed Test Image');
