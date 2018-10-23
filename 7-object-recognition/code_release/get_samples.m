function X_nsamp = get_samples(X,nsamp)
    indices = randsample(1:size(X,1),nsamp);
    X_nsamp = X(indices,:);
end