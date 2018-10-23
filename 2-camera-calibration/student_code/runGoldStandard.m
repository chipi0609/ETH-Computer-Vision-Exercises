function [K, R, t, error] = runGoldStandard(xy, XYZ)
xy_homo = [xy; ones(1,6)];
XYZ_homo = [XYZ; ones(1,6)];
%normalize data points
[xy_normalized, XYZ_normalized,T,U] = normalization(xy,XYZ);

%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%minimize geometric error
pn = [P_normalized(1,:) P_normalized(2,:) P_normalized(3,:)];
for i=1:20
    [pn] = fminsearch(@fminGoldStandard, pn, [], xy_normalized, XYZ_normalized, i/5);
end

%denormalize camera matrix
P = reshape(pn,[4,3]);
P = inv(T)*P'*U;

%factorize camera matrix in to K, R and t
[K,R,t] = decompose(P);
%xy_reprojected = P*XYZ_homo;
xy_reprojected = P*XYZ_homo;
for i = 1:6
    xy_reprojected(:,i) = xy_reprojected(:,i) / xy_reprojected(3,i);
end

IMG_NAME = 'images/image001.jpg';
draw_points(xy,xy_reprojected,IMG_NAME);

%compute reprojection error
distance = (xy - xy_reprojected(1:2,:)).^2;
error = sum(sqrt(sum(distance(:))));

% Code to plot corners
%img = imread(IMG_NAME);
%imshow(img);
%axis image
%hold on;
%for x = 0:7
%    for z = 0:9
%        point3D = [x;0;z;1];
%        point2D = P * point3D;
%        point2D = point2D./point2D(3,1);
%        plot(point2D(1,1),point2D(2,1), 'b-*','MarkerSize',10);
%    end
%end

%for y = 0:6
%    for z = 0:9
%        point3D = [0;y;z;1];
%        point2D = P * point3D;
%        point2D = point2D./point2D(3,1);
%        plot(point2D(1,1),point2D(2,1), 'b-*','MarkerSize',10);
%    end
%end
end
