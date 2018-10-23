function P = expectation(mu,var,alpha,X)

K = length(alpha);
N = size(X,1);
n = size(X,2);
P = zeros(N,K);

for k = 1:K
    for i = 1:N
        P(i,k) = alpha(k) / ((2 * pi)^(n/2) * det(var(:,:,k))^(0.5)) * exp(-0.5*(X(i,:) - mu(k,:)) * var(:,:,k)^(-1) * (X(i,:) - mu(k,:))');  
    end  
end
P = P ./ sum(P,2);

end