% Extract HOG features for all images in the training set.
numImages = numel(trainingSet.Files);
cellSize = [4 4];
hogFeatureSize = length(hog_4x4);
trainingFeatures = zeros(numImages, hogFeatureSize, 'single');

for i = 1:numImages
    img = readimage(trainingSet, i);
    img = im2gray(img);  % Convert to grayscale
    img = imbinarize(img);  % Apply binarization for preprocessing
    trainingFeatures(i, :) = extractHOGFeatures(img, 'CellSize', cellSize);  % Extract HOG features
end

% Get the labels for each image.
trainingLabels = trainingSet.Labels;

% Train a classifier using SVM (fitcecoc) with One-vs-One encoding scheme.
classifier = fitcecoc(trainingFeatures, trainingLabels);
