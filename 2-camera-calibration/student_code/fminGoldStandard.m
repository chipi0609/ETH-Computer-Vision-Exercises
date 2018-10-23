function f = fminGoldStandard(p, xy, XYZ, w)

%reassemble P
P = [p(1:4);p(5:8);p(9:12)];

%compute squared geometric error
xy_reprojected = P*XYZ;
xy_reprojected = xy_reprojected ./ xy_reprojected(3,:);

distance = (xy - xy_reprojected).^2;
%compute cost function value
f = sum(distance(:));
end
