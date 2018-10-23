function [mu sigma] = computeMeanStd(vBoW)
    for i = 1:size(vBoW,2)
        mu(i) = mean(vBoW(:,i));
        sigma(i) = std(vBoW(:,i));
    end
end