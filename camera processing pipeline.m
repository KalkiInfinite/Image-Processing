fileName = "Lab1.dng";

% Read the RAW CFA image
cfaImage = rawread(fileName);
whos cfaImage
imshow(cfaImage, [])
title("RAW CFA Image")

% Extract CFA information
cfaInfo = rawinfo(fileName);
disp(cfaInfo.ImageSizeInfo)

% Get color information
colorInfo = cfaInfo.ColorInfo;

% Plot the linearization table
maxLinValue = 10^4;
linTable = colorInfo.LinearizationTable;
plot(0:maxLinValue-1, linTable(1:maxLinValue))
title("Linearization Table")

% Handle black level
blackLevel = colorInfo.BlackLevel;
blackLevel = reshape(blackLevel, [1 1 numel(blackLevel)]);
blackLevel = planar2raw(blackLevel);
repeatDims = cfaInfo.ImageSizeInfo.VisibleImageSize ./ size(blackLevel);
blackLevel = repmat(blackLevel, repeatDims);
cfaImage = cfaImage - blackLevel;
cfaImage = max(0, cfaImage);
cfaImage = double(cfaImage);

% Normalize the image
maxValue = max(cfaImage(:));
cfaImage = cfaImage ./ maxValue;

% Apply white balance
whiteBalance = colorInfo.CameraAsTakenWhiteBalance;
gLoc = strfind(cfaInfo.CFALayout, "G");
gLoc = gLoc(1);
whiteBalance = whiteBalance / whiteBalance(gLoc);
whiteBalance = reshape(whiteBalance, [1 1 numel(whiteBalance)]);
whiteBalance = planar2raw(whiteBalance);
whiteBalance = repmat(whiteBalance, repeatDims);
cfaWB = cfaImage .* whiteBalance;
cfaWB = im2uint16(cfaWB);

% Demosaic the image
cfaLayout = cfaInfo.CFALayout;
imDebayered = demosaic(cfaWB, cfaLayout);
imshow(imDebayered)
title("Demosaiced RGB Image in Linear Camera Space")

% Convert to XYZ color space using PCS
cam2xyzMat = colorInfo.CameraToXYZ;
whiteBalanceD65 = colorInfo.D65WhiteBalance;
wbIdx(1) = strfind(cfaLayout, "R");
gIdx = strfind(cfaLayout, "G");
wbIdx(2) = gIdx(1);
wbIdx(3) = strfind(cfaLayout, "B");
wbCoeffs = whiteBalanceD65(wbIdx);
cam2xyzMat = cam2xyzMat ./ wbCoeffs;
imXYZ = imapplymatrix(cam2xyzMat, im2double(imDebayered));
srgbPCS = xyz2rgb(imXYZ, OutputType="uint16");
imshow(srgbPCS)
title("sRGB Image Using PCS")

% Convert to sRGB using transformation matrix
cam2srgbMat = colorInfo.CameraTosRGB;
imTransform = imapplymatrix(cam2srgbMat, imDebayered, "uint16");
srgbTransform = lin2rgb(imTransform);
imshow(srgbTransform)
title("sRGB Image Using Transformation Matrix")

% Convert to sRGB using raw2rgb function
srgbAuto = raw2rgb(fileName);
imshow(srgbAuto)
title("sRGB Image Using raw2rgb Function")

% Display a montage of results
montage({srgbPCS, srgbTransform, srgbAuto}, 'Size', [1 3]);
title("sRGB Image Using PCS, raw2rgb Function, and Transformation Matrix (Left to Right)")
