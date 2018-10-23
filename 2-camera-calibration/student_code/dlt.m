% computes DLT, xy and XYZ should be normalized before calling this function
function [P] = dlt(xy, XYZ)

% Ap = 0
A = zeros(12,12);

for i = 1:6
    A(2*i-1,(1:4)) = XYZ(:,i);
    A(2*i-1,(9:12)) = -xy(1,i) * XYZ(:,i);
    A(2*i,(5:8)) = -XYZ(:,i);
    A(2*i,(9:12)) = xy(2,i) * XYZ(:,i);
end

% Perform SVD on A
[U,S,V] = svd(A);

% Retrieve estimated P
P = reshape(V(:,12),[4,3]);
P = P';

