% Generate initial values for the K
% covariance matrices

function cov = generate_cov(X,K)
    cov = zeros(size(X,2),size(X,2),K);
    idx = randsample(size(X,1), K);
    for k = 1:K
        cov(:,:,k) = diag(X(idx(k), :));
    end
end