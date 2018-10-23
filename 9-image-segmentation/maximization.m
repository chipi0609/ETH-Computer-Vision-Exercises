function [mu, var, alpha] = maximization(P, X)

K = size(P,2);
N = size(X,1);
n = size(X,2);
alpha = zeros(K,1);
mu = zeros(K,n);
var = zeros(n,n,K);


for k = 1:K
    total_pk = sum(P(:,k));
    total_xlpk = 0;
    total_xluk = 0;
    
    alpha(k) =  total_pk / N;
    
    for l = 1:N
        total_xlpk = total_xlpk + X(l,:) * P(l,k);
    end
    mu(k,:) = total_xlpk /total_pk;
    
    for l = 1:N
        total_xluk = total_xluk  + P(l,k) * (X(l,:) - mu(k,:))' * (X(l,:) - mu(k,:));  
    end
    
    var(:,:,k) = total_xluk / total_pk;

end