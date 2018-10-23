% Exercise 1
%
close all;
IMG_NAME1 = 'images/I1.jpg';
IMG_NAME2 = 'images/I2.jpg';

% read in image
img1 = im2double(imread(IMG_NAME1));
img2 = im2double(imread(IMG_NAME2));

% For faster computation, I resized the image, the original image can be
% tested as well (in the report the original size is used)
%img1 = imresize(img1, 1);
%img2 = imresize(img2, 1);
img1 = imresize(img1, 0.3);
img2 = imresize(img2, 0.3);

% convert to gray image
imgBW1 = rgb2gray(img1);
imgBW2 = rgb2gray(img2);

% Task 1.1 - extract Harris corners
[corners1, H1] = extractHarrisCorner(imgBW1', 0.05);
[corners2, H2] = extractHarrisCorner(imgBW2', 0.05);

% show images with Harris corners
showImageWithCorners(img1, corners1, 10);
showImageWithCorners(img2, corners2, 11);

% Task 1.2 - extract your own descriptors
descr1 = extractDescriptor(corners1, imgBW1');
descr2 = extractDescriptor(corners2, imgBW2');

% Task 1.3 - match the descriptors
matches = matchDescriptors(descr1, descr2, 0.1);
showFeatureMatches(img1, corners1(:, matches(1,:)), img2, corners2(:, matches(2,:)), 20);

% Task 1.4 - use SIFT
imgS1 = single(imgBW1);
imgS2 = single(imgBW2);
[fa, da] = vl_sift(imgS1);
[fb, db] = vl_sift(imgS2);

[fa, da] = vl_sift(imgS1,'PeakThresh', 0.01);
[fb, db] = vl_sift(imgS2,'PeakThresh', 0.01);
[matches, scores] = vl_ubcmatch(da, db);

showFeatureMatches(img1, fa(1:2, matches(1,:)), img2, fb(1:2, matches(2,:)), 30);

% Bonus - my SIFT descriptor - unfinished
%descrSIFT1 = extractSIFTDescriptor(corners1, imgBW1');
%descrSIFT2 = extractSIFTDescriptor(corners2, imgBW2');
%matchesSIFT = matchDescriptors(descrSIFT1, descrSIFT2, 0.1);
%showFeatureMatches(img1, corners1(:, matchesSIFT(1,:)), img2, corners2(:, matchesSIFT(2,:)), 40);
