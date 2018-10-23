% Normalization of 2d-pts
% Inputs: 
%           x1s = 2d points
% Outputs:
%           nxs = normalized points
%           T = normalization matrix
function [nxs, T] = normalizePoints2d(x1s)
    x1s_centroid = mean(x1s,2);
    s = sqrt(2)/mean(sqrt(sum((x1s-x1s_centroid).^2)));
    T = diag([s s 1]);
    T(1:2,3) = -x1s_centroid(1:2,:) * s;
    nxs = T*x1s;
end
