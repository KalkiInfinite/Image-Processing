function [features, labels] = helperExtractHOGFeaturesFromImageSet(imageSet, featureSize, cellSize)
    numImages = numel(imageSet.Files);
    features = zeros(numImages, featureSize, 'single');
    labels = imageSet.Labels;
    
    for i = 1:numImages
        img = readimage(imageSet, i);
        img = im2gray(img);  % Convert to grayscale
        img = imbinarize(img);  % Apply binarization for preprocessing
        features(i, :) = extractHOGFeatures(img, 'CellSize', cellSize);  % Extract HOG features
    end
end

function helperDisplayConfusionMatrix(confMat)
    figure;
    confusionchart(confMat);
    title('Confusion Matrix');
end