function [ K, R, t ] = decompose(P)
%decompose P into K, R and t
inv_P = inv(P(1:3,(1:3)));
[R_1,K_1] = qr(inv_P);
R = inv(R_1);
K = inv(K_1);

[U,S,V] = svd(P);
C_homo = V(:,4);
C = C_homo((1:3),:)/C_homo(4,1);

t = -K*R*C;
end