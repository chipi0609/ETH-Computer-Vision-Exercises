% Generate initial values for mu
% K is the number of segments

function mu = generate_mu(X, K)
    mu = zeros(K,3);
    
    idx = randsample(size(X,1), K);
    for k = 1:K 
        mu(k,:) = X(idx(k),:);
    end
end