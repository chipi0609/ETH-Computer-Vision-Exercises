function peak = find_peak(X,xl,r)
    while true
        % Compute distances between xl and all the other pixels
        distances = sqrt(bsxfun(@minus,X(xl,1),X(:,1)').^2 + bsxfun(@minus,X(xl,2),X(:,2)').^2 + bsxfun(@minus,X(xl,3),X(:,3)').^2);
        neighbours = X(find(distances < r),:);
        if(size(neighbours,1) > 1)
            p_candidate = mean(neighbours);
        else
            p_candidate = neighbours;
        end
        
        if sqrt(sum(((p_candidate-X(xl,:)).^2))) < 0.001
            peak = p_candidate;
            break;
        else
            X(xl,:) = p_candidate;
        end
    end
end