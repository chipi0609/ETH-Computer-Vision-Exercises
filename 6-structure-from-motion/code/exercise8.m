% =========================================================================
% Exercise 8
% =========================================================================

% Initialize VLFeat (http://www.vlfeat.org/)

%K Matrix for house images (approx.)
K = [  670.0000     0     393.000
         0       670.0000 275.000
         0          0        1];

%Load images
imgName1 = '../data/house.000.pgm';
imgName2 = '../data/house.004.pgm';

img1 = single(imread(imgName1));
img2 = single(imread(imgName2));

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);

%don't take features at the top of the image - only background
filter = fa(2,:) > 100;
fa = fa(:,find(filter));
da = da(:,find(filter));

[matches, scores] = vl_ubcmatch(da, db);
showFeatureMatches(img1, fa(1:2, matches(1,:)), img2, fb(1:2, matches(2,:)), 20);

%% Compute essential matrix and projection matrices and triangulate matched points

%use 8-point ransac or 5-point ransac - compute (you can also optimize it to get best possible results)
%and decompose the essential matrix and create the projection matrices
[F,inliers] = ransacfitfundmatrix(fa(1:2, matches(1,:)),fb(1:2, matches(2,:)),0.002);
outliers = setdiff([1:1:size(matches,2)],inliers);
E = K' * F * K;

x1 = [fa(1:2, matches(1,:));ones(1,size(fa(1:2, matches(1,:)),2))];
x2 = [fb(1:2, matches(2,:));ones(1,size(fb(1:2, matches(2,:)),2))];
x1s = x1(:,inliers);
x2s = x2(:,inliers);

figure(1),hold off, imshow(img1, []); hold on, plot(x1s(1,:), x1s(2,:), '*r');
figure(2),hold off, imshow(img2, []); hold on, plot(x2s(1,:), x2s(2,:), '*g');

figure(1)
for k = 1:size(x1s,2)
    drawEpipolarLines(F' * x2s(:,k),img1);
end

%figure(2)
for k = 1:size(x2s,2)
    %drawEpipolarLines(F' * x1s(:,k),img2);
end

showFeatureMatches(img1, fa(1:2, matches(1,inliers)), img2, fb(1:2, matches(2,inliers)), 30);
showFeatureMatchesOutliers(img1, fa(1:2, matches(1,outliers)), img2, fb(1:2, matches(2,outliers)), 40);

x1_calibrated = K \ x1s;
x2_calibrated = K \ x2s;

Ps{1} = eye(4);
Ps{2} = decomposeE(E, x1_calibrated, x2_calibrated);

%triangulate the inlier matches with the computed projection matrix
[Xs,err] = linearTriangulation(Ps{1},x1_calibrated,Ps{2},x2_calibrated);
%% Add an addtional view of the scene 
imgName3 = '../data/house.002.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);

%match against the features from image 1 that where triangulated
[matches1, scores1] = vl_ubcmatch(da(:,matches(1,inliers)), dc);
                     
%run 6-point ransac
x3 = [fc(1:2, matches1(2,:)); ones(1,size(fc(1:2, matches1(2,:)),2))];
x3_calibrated = K \ x3;

[Ps{3},inliers1] = ransacfitprojmatrix(x3_calibrated(1:2,:),Xs(1:3,matches1(1,:)),0.002);
outliers1 = setdiff(matches1(1,:),inliers1); % in order to show outliers
showFeatureMatches(img1, x1s(1:2, matches1(1,:)), img3, fc(1:2, matches1(2,:)), 50);
showFeatureMatchesOutliers(img1, fa(1:2, outliers1), img3, fc(1:2, outliers1), 60);

if (det(Ps{3}(1:3,1:3)) < 0 )
    Ps{3} =  -Ps{3};
end

%triangulate the inlier matches with the computed projection matrix
[Xs1,err1] = linearTriangulation(Ps{1},x1_calibrated(:,matches1(1,inliers1)),Ps{3},x3_calibrated(:,inliers1));

%% Add more views...
imgName4 = '../data/house.003.pgm';
img4 = single(imread(imgName4));
[fd, dd] = vl_sift(img4);

%match against the features from image 1 that where triangulated
[matches2, scores2] = vl_ubcmatch(da(:,matches(1,inliers)), dd);

%run 6-point ransac
x4 = [fd(1:2, matches2(2,:)); ones(1,size(fd(1:2, matches2(2,:)),2))];
x4_calibrated = K \ x4;

[Ps{4},inliers2] = ransacfitprojmatrix(x4_calibrated(1:2,:),Xs(1:3,matches2(1,:)),0.002);
if (det(Ps{4}(1:3,1:3)) < 0 )
    Ps{4} =  -Ps{4};
end

outliers2 = setdiff(matches2(1,:),inliers2);
showFeatureMatches(img1, x1s(1:2, matches2(1,:)), img4, fd(1:2, matches2(2,:)), 70);
showFeatureMatchesOutliers(img1, fa(1:2, outliers2), img4, fd(1:2, outliers2), 80);

%triangulate the inlier matches with the computed projection matrix
[Xs2,err2] = linearTriangulation(Ps{1},x1_calibrated(:,matches2(1,inliers2)),Ps{4},x4_calibrated(:,inliers2));

imgName5 = '../data/house.001.pgm';
img5 = single(imread(imgName5));
[fe, de] = vl_sift(img5);

%match against the features from image 1 that where triangulated
[matches3, scores3] = vl_ubcmatch(da(:,matches(1,inliers)), de);

%run 6-point ransac
x5 = [fe(1:2, matches3(2,:)); ones(1,size(fe(1:2, matches3(2,:)),2))];
x5_calibrated = K \ x5;

[Ps{5},inliers3] = ransacfitprojmatrix(x5_calibrated(1:2,:),Xs(1:3,matches3(1,:)),0.002);
outliers3 = setdiff(matches3(1,:),inliers3);
showFeatureMatches(img1, x1s(1:2, matches3(1,:)), img5, fe(1:2, matches3(2,:)), 90);
showFeatureMatchesOutliers(img1, fa(1:2, outliers3), img5, fd(1:2, outliers3), 100);
if (det(Ps{5}(1:3,1:3)) < 0 )
    Ps{5} =  -Ps{5};
end
%triangulate the inlier matches with the computed projection matrix
[Xs3,err3] = linearTriangulation(Ps{1},x1_calibrated(:,matches3(1,inliers3)),Ps{5},x5_calibrated(:,inliers3));
%% Plot stuff

fig = 10;
figure(fig);

%use plot3 to plot the triangulated 3D points
plot3(Xs(1,:),Xs(2,:),Xs(3,:),'r.','markers',7); hold on;
plot3(Xs1(1,:),Xs1(2,:),Xs1(3,:),'g.','markers',7); hold on;
plot3(Xs2(1,:),Xs2(2,:),Xs2(3,:),'b.','markers',7); hold on;
plot3(Xs3(1,:),Xs3(2,:),Xs3(3,:),'k.','markers',7); hold on;
%draw cameras
drawCameras(Ps, fig);


%% Dense Reconstruction
% Rectify images - uncalibrated version
[t1,t2] = estimateUncalibratedRectification(F,fa(1:2, matches(1,inliers))',fb(1:2, matches(2,inliers))',size(img1));
tform1 = projective2d(t1);
tform2 = projective2d(t2);
[img1_rec,img2_rec] = rectifyStereoImages(img1,img2,tform1,tform2);

% Rectify images - calibrated version
cameraPrameters = K;
transformation = inv(K) * Ps{2}(1:3,:);
rotation = transformation(:,1:3);
translation = transformation(:,4);
stereoParams = stereoParameters(cameraParameters,cameraParameters,rotation,translation);
[i1,i2] = rectifyStereoImages(img1,img2,stereoParams);

% Depth map
%disparityRange = [-70,26];
%disparityMap = disparity(img1_rec,img2_rec,'BlockSize',17,'DisparityRange',disparityRange);

%disMap = disparity(i1,i2,'BlockSize',[0,64]);

%disparityMap = disparity(img1,img2,'BlockSize',31);
%figure(3)
%imshow(disparityMap,disparityRange);
%colormap(gca,jet)
%colorbar

%I1 = cat(3,img1,img1,img1);

%depthMap = reconstructScene(disMap,stereoParams);
%create3DModel(depthMap,I1,4)






