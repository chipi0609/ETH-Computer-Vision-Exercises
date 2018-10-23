function testClass = nn_classify(matchingCostVector,trainClasses,k)
    [A,idx] = mink(matchingCostVector,k);
    hitClass = trainClasses(idx);
    uniqueC = unique(hitClass);
    n = zeros(1,length(uniqueC));
    for i = 1:length(uniqueC)
        n(i) = length(find(strcmp(uniqueC{i},hitClass)));
    end
    
    [~,itemp] = max(n);
    testClass = uniqueC(itemp);
end