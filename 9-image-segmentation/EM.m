function [map cluster] = EM(img)
    [height,width,~] = size(img);
    X = reshape(img,[height * width,3]);
    
    K = 5;
    alpha = repmat(1/K,[K 1]);

    % use function generate_mu to initialize mus
    mu = generate_mu(X,K);
    % use function generate_cov to initialize covariances
    cov = generate_cov(X,K);

    % iterate between maximization and expectation
   
    while true
        lastMu = mu;
        % use function expectation   
        P = expectation(mu,cov,alpha,X);
        % use function maximization
        [mu,cov,alpha] = maximization(P,X);
        
        if sqrt(sum(sum((lastMu-mu).^2))) < 0.001
            break;
        end
    end
    
    cluster = mu;
    [m,map] = max(P,[],2);
    map = reshape(map,[height,width]);
    mu
    alpha
    cov

end