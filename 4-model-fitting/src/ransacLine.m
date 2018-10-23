function [k, b] = ransacLine(data, dim, iter, threshDist, inlierRatio)
% data: a 2xn dataset with #n data points
% num: the minimum number of points. For line fitting problem, num=2
% iter: the number of iterations
% threshDist: the threshold of the distances between points and the fitting line
% inlierRatio: the threshold of the number of inliers

number = size(data,2); % Total number of points
bestInNum = 0;         % Best fitting line with largest number of inliers
k=0; b=0;              % parameters for best fitting line

inliers = data;

for i=1:iter
    % Randomly select 2 points
    p1 = data(:,randi(number));
    p2 = data(:,randi(number));

    % Compute the distances between all points with the fitting line 
    k_candidate = (p1(2,1) - p2(2,1)) / (p1(1,1) - p2(1,1));
    b_candidate = p1(2,1) - k * p1(1,1);
    %dist = abs(k_candidate * data(1,:) - data(2,:) + b_candidate) / sqrt(k^2 + 1);
    dist = distPointLine(data,[k_candidate,-1,b_candidate]);
    
    % Compute the inliers with distances smaller than the threshold
    inlierIndices = find(dist < threshDist);
    inliers_candidates = data(:,inlierIndices);
    
    % Update the number of inliers and fitting model if better model is found
    if size(inlierIndices,2) <= inlierRatio * number
        continue;
    end
        
    if size(inlierIndices,2) > inlierRatio * number
        if size(inlierIndices,2) > bestInNum
            bestInNum = size(inlierIndices,2);
            inliers = inliers_candidates;
        end
    end
end

    coefficients = polyfit(inliers(1,:),inliers(2,:),1);
    k = coefficients(1);
    b = coefficients(2);

end
