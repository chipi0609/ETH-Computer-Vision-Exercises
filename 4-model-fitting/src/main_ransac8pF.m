% =========================================================================
% Exercise 4
% =========================================================================

%don't forget to initialize VLFeat

%Load images
dataset = 0;   % Your pictures
 %dataset = 1; % ladybug
 %dataset = 2; % rect

% image names
if(dataset==0)
    imgName1 = 'images/I1.jpg';
    imgName2 = 'images/I2.jpg';
elseif(dataset==1)
    imgName1 = 'images/ladybug_Rectified_0768x1024_00000064_Cam0.png';
    imgName2 = 'images/ladybug_Rectified_0768x1024_00000080_Cam0.png';
elseif(dataset==2)
    imgName1 = 'images/rect1.jpg';
    imgName2 = 'images/rect2.jpg';
end


img1 = single(rgb2gray(imread(imgName1)));
img2 = single(rgb2gray(imread(imgName2)));

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);
[matches, scores] = vl_ubcmatch(da, db);

%show matches
showFeatureMatches(img1, fa(1:2, matches(1,:)), img2, fb(1:2, matches(2,:)), 20);

% =========================================================================

%run 8-point RANSAC
[inliers1, inliers2, outliers1, outliers2, M, F] = ransac8pF(fa(1:2, matches(1,:)), fb(1:2, matches(2,:)), 20);

%show inliers and outliers
showFeatureMatches(img1,inliers1,img2,inliers2,30);
showFeatureMatches(img1,outliers1,img2,outliers2,40);

%show number of iterations needed

%show inlier ratio

%and check the epipolar geometry of the computed F


% =========================================================================