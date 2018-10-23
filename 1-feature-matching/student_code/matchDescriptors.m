% match descriptors
%
% Input:
%   descr1        - k x n descriptor of first image
%   descr2        - k x m descriptor of second image
%   thresh        - scalar value to threshold the matches
%   
% Output:
%   matches       - 2 x w matrix storing the indices of the matching
%                   descriptors
function matches = matchDescriptors(descr1, descr2, thresh)
    matches = [];
    [r1,c1] = size(descr1);
    [r2,c2] = size(descr2);
    
    % compare each descriptor in image 1 with each descriptor in image 2
    for i = 1 : c1
        matches_candidate = [];
        minimum = 1000;
        for j = 1:c2
            d1 = descr1(:,i);
            d2 = descr2(:,j);
            difference = d1-d2;
            ssd = sum(difference(:).^2);
            
            % Check if SSD is smaller than a threshold
            if ssd <= thresh
                %matches = [matches, [i;j]];
                if ssd < minimum
                    minimum = ssd;
                    matches_candidate = [i;j];
                end
            end
        end
        if ~isempty(matches_candidate)
            matches = [matches, matches_candidate];
        end
    end           
end