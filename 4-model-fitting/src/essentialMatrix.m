% Compute the essential matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences 3xn matrices
%
% Output
% 	Eh 			Essential matrix with the det F = 0 constraint and the constraint that the first two singular values are equal
% 	E 			Initial essential matrix obtained from the eight point algorithm
%

function [Eh, E] = essentialMatrix(x1s, x2s)    
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
    E = transpose(reshape(V(:,9),[3,3]));
    
    [Uh,Dh,Vh] = svd(E);
    s = (Dh(1,1) + Dh(2,2))/2;
    Dh(1,1) = s;
    Dh(2,2) = s;
    Dh(3,3) = 0;
    
    E = T2' * E * T1;
    Eh = T2' * (Uh * Dh * Vh') * T1;
    
end
