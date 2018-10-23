function run_ex5()

% load image
img = imread('zebra_b.jpg');
% for faster debugging you might want to decrease the size of your image
% (use imresize)
% (especially for the mean-shift part!)
img = im2double(img);

figure, imshow(img), title('original image')

% smooth image (6.1a)
% (replace the following line with your code for the smoothing of the image)
imgSmoothed = gaussianFilter(img,[5 5],5.0);
figure, imshow(imgSmoothed), title('smoothed image')

% convert to L*a*b* image (6.1b)
% (replace the following line with your code to convert the image to lab
% space
%imglab = conver2lab(img);
imglab = conver2lab(imgSmoothed);
figure, imshow(imglab), title('l*a*b* image')

% (6.2)
[mapMS,peak] = meanshiftSeg(imglab);
visualizeSegmentationResults (mapMS,peak);

% (6.3)
[mapEM,cluster] = EM(imglab);
visualizeSegmentationResults (mapEM,cluster);

end