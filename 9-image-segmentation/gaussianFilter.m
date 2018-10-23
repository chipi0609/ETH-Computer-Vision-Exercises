% Filter the image using 5x5 Gaussian filter

function imageSmoothed = gaussianFilter(img,hsize,sigma)

G = fspecial('gaussian',[5 5],5.0);
imageSmoothed = imfilter(img,G);

end