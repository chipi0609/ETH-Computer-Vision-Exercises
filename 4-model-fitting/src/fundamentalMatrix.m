% Compute the fundamental matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences
%
% Output
% 	Fh 			Fundamental matrix with the det F = 0 constraint
% 	F 			Initial fundamental matrix obtained from the eight point algorithm
%
function [Fh, F] = fundamentalMatirx(x1s, x2s)
    % Normalize data
    [x1s_n,T1] = normalizePoints2d(x1s);
    [x2s_n,T2] = normalizePoints2d(x2s);
    
    % Taking 8 correspondences
    A = ones(8,9);
    u1 = x1s_n(1,1:8);
    v1 = x1s_n(2,1:8);
    u2 = x2s_n(1,1:8);
    v2 = x2s_n(2,1:8);
    
    A(:,1) = u2.*u1;
    A(:,2) = u2.*v1;
    A(:,3) = u2;
    A(:,4) = u1.*v2;
    A(:,5) = v1.*v2;
    A(:,6) = v2;
    A(:,7) = u1;
    A(:,8) = v1;
    
    % Solve using SVD
    [U,S,V] = svd(A);
    F = transpose(reshape(V(:,9),[3,3]));
    
    % Set constraint on Fh
    [Uh,Dh,Vh] = svd(F);
    Dh(3,3) = 0;
    
    % Denormalize
    F = T2' * F * T1;
    Fh = T2' * (Uh * Dh * Vh') * T1;
    
end