function [n] = nTrialNeeded(inlierRatio,nSamples,desiredConfidence)
    n = ceil(log(1-inlierRatio^nSamples,1-desiredConfidence));
end