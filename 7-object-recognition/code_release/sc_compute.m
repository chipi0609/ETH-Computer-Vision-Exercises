function d = sc_compute(X,nbBins_theta,nbBins_r,smallest_r,biggest_r)
   d = zeros(nbBins_theta,nbBins_r,size(X,2));
   distances = sqrt(bsxfun(@minus,X(1,:),X(1,:)').^2 + bsxfun(@minus,X(2,:),X(2,:)').^2);
   normalized_distances = distances/mean(mean(distances));
   angles = bsxfun(@atan2,bsxfun(@minus,X(2,:),X(2,:)'),bsxfun(@minus,X(1,:),X(1,:)'));
   bins_r = [0,logspace(smallest_r,biggest_r,nbBins_r)];
   bins_theta = -pi:(2*pi)/nbBins_theta:pi;
  
   
   for i = 1:size(distances,2)
       for j = 1:size(distances,2)
           if j ~= i
               r_index = discretize(normalized_distances(i,j),bins_r);
               theta_index = discretize(angles(i,j),bins_theta);
               d(theta_index,r_index,i) = d(theta_index,r_index,i) + 1;
           end
       end
   end
end

