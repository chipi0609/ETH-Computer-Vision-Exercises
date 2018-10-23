function [map, peaks] = mean_shift(X,r) 
   peaks = zeros(size(X,1),3);
   p_merged = [];
   map = zeros(size(X,1),1);
   
   for i = 1:size(X)
       peak = find_peak(X,i,r);
       peaks(i,:) = peak;
   end
   
   % Calculate distances between the peaks
   %distances = sqrt(bsxfun(@minus,peaks(:,1),peaks(:,1)').^2 + bsxfun(@minus,peaks(:,2),peaks(:,2)').^2 + bsxfun(@minus,peaks(:,3),peaks(:,3)').^2);
   
   % Merge peaks
   merged = zeros(1,size(peaks,1));
   peak_id = 0;
   for j = 1:size(peaks,2)
       if merged(j) ~= 1
            distances = sqrt(bsxfun(@minus,peaks(j,1),peaks(:,1)').^2 + bsxfun(@minus,peaks(j,2),peaks(:,2)').^2 + bsxfun(@minus,peaks(j,3),peaks(:,3)').^2);
            ids = intersect(find(distances < r/2),find(merged ~= 1));
            if isempty(ids) ~= 1
                peak_id = peak_id + 1;
                merged(ids) = 1;
                pm = peaks(ids,:);
                map(ids) = peak_id;
                
                p = mean(pm,1);
                p_merged = [p_merged;p];
            end            
       end
   end
   
   peaks = p_merged;
   
end