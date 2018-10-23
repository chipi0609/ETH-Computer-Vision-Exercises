function matchingCostMatrix = compute_matching_costs(objects,nbSamples)
    matchingCostMatrix = zeros(size(objects,2));
    for i = 1:size(objects,2)
        for j = 1:size(objects,2)
            if i~=j
                s1 = get_samples_1(objects(i).X,nbSamples);
                s2 = get_samples_1(objects(j).X,nbSamples);
                matchingCostMatrix(i,j) = shape_matching(s1,s2,false);
            end
        end
    end
end