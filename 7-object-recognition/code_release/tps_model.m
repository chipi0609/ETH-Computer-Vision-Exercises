function [w_x,w_y,E] = tps_model(X,Y,lambda)
    d = sqrt(bsxfun(@minus,X(:,1),X(:,1)').^2 + bsxfun(@minus,X(:,2),X(:,2)').^2);
    K = d.^2 .* log(d);
    K(isnan(K)) = 0;
    P = [ones(size(X,1),1),X];
    
    A = [K + lambda * eye(size(K)) P; P' zeros(3)];
    w_x = A\[Y(:,1);zeros(3,1)];
    w_y = A\[Y(:,2);zeros(3,1)];
    wx = w_x(1:end-3);
    wy = w_y(1:end-3);
    E = wx' * K * wx + wy' * K * wy;    
end