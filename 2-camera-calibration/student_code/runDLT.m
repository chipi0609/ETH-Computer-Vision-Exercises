function [K, R, t, error] = runDLT(xy, XYZ)
xy_homo = [xy; ones(1,6)];
XYZ_homo = [XYZ; ones(1,6)];

% normalize data points
[xy_normalized, XYZ_normalized,T,U] = normalization(xy,XYZ);

%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized);
%denormalize camera matrix
P = inv(T)*P_normalized*U;

%factorize camera matrix in to K, R and t
[K,R,t] = decompose(P);
%disp(K);

%compute reprojection error
xy_reprojected = P*XYZ_homo;
for i = 1:6
    xy_reprojected(:,i) = xy_reprojected(:,i) / xy_reprojected(3,i);
end

%disp(xy_reprojected);
IMG_NAME = 'images/image001.jpg';
draw_points(xy,xy_reprojected,IMG_NAME);
distance = (xy_homo - xy_reprojected).^2;
error = sum(sqrt(sum(distance,1)),2);


% Code to plot corners
%{img = imread(IMG_NAME);
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
%end%}

end