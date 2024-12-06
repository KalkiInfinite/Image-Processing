% Step 1: Read the input image
image = imread('/MATLAB Drive/RoundObjectsExample_01.png'); % Replace with your image file

% Step 2: Convert to grayscale
grayImage = rgb2gray(image);

% Step 3: Convert to binary image using thresholding
binaryImage = imbinarize(grayImage);

% Step 4: Remove noise using morphological operations
binaryImage = imfill(binaryImage, 'holes'); % Fill holes
binaryImage = bwareaopen(binaryImage, 50); % Remove small objects

% Step 5: Detect edges using the Canny edge detector
edges = edge(binaryImage, 'Canny');

% Step 6: Find contours of the shapes
[contours, ~] = bwboundaries(binaryImage, 'noholes');

% Step 7: Analyze shapes using region properties
stats = regionprops(binaryImage, 'Area', 'Perimeter', 'BoundingBox', 'Centroid');

% Step 8: Display the original, binary, and edge-detected images
figure;
subplot(1, 3, 1);
imshow(image);
title('Original Image');
subplot(1, 3, 2);
imshow(binaryImage);
title('Binary Image');
subplot(1, 3, 3);
imshow(edges);
title('Edges (Canny)');

% Step 9: Display classified image with shape type annotations
figure;
imshow(image);
hold on;

% Step 10: Loop through each detected contour and classify the shape
for i = 1:length(contours)
    boundary = contours{i};
    
    % Calculate roundness metric
    perimeter = stats(i).Perimeter;
    area = stats(i).Area;
    roundness = (4 * pi * area) / (perimeter^2);
    
    % Get the centroid of the shape
    centroid = stats(i).Centroid;
    
    % Classify shape based on roundness and aspect ratio
    if roundness > 0.85
        shapeType = 'Circle';
    elseif roundness > 0.5 && roundness <= 0.85
        shapeType = 'Ellipse';
    elseif roundness <= 0.5 && area / (stats(i).BoundingBox(3) * stats(i).BoundingBox(4)) > 0.9
        shapeType = 'Square/Rectangle';
    else
        shapeType = 'Triangle/Polygon';
    end
    
    % Display the shape type on the image
    text(centroid(1), centroid(2), shapeType, 'Color', 'r', 'FontSize', 12);
end

hold off;
