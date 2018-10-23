function [xyn, XYZn, T, U] = normalization(xy, XYZ)

%data normalization
xy_homo = [xy; ones(1,6)];
XYZ_homo = [XYZ; ones(1,6)];

%first compute centroid
xy_centroid = mean(xy, 2);
XYZ_centroid = mean(XYZ,2);

%then, compute scale
s2D = sqrt(2)/mean(sqrt(sum((xy-xy_centroid).^2)));
s3D = sqrt(3)/mean(sqrt(sum((XYZ-XYZ_centroid).^2)));

%create T and U transformation matrices
T_diag = [s2D s2D 1];
U_diag = [s3D s3D s3D 1];
T = diag(T_diag);
U = diag(U_diag);
T(1:2,3) = -xy_centroid * s2D;
U(1:3,4) = -XYZ_centroid * s3D;

%and normalize the points according to the transformations
xyn = T*xy_homo;
XYZn = U*XYZ_homo;

end