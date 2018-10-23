function [map,peak] = meanshiftSeg(img)
     [height,width,~] = size(img);
     X = reshape(img,[height * width,3]);
     r = 7;
     [m,peak] = mean_shift(X,r);
     map = reshape(m,[height,width]);
end