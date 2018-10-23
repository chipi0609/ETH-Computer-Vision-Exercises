function costMatrixC = chi2_cost(ShapeDescriptors1,ShapeDescriptors2)
    costMatrixC = zeros(size(ShapeDescriptors1,3));
    for i = 1:size(ShapeDescriptors1,3)
        for j = 1:size(ShapeDescriptors1,3)
            %costMatrixC(i,j) = 0.5 * sum(sum(((ShapeDescriptors1(:,:,i) - ShapeDescriptors2(:,:,j)).^2)./ ((ShapeDescriptors1(:,:,i) + ShapeDescriptors2(:,:,j) + 0.00000001))));
            costMatrixC(i,j) = 0.5 * nansum(nansum(((ShapeDescriptors1(:,:,i) - ShapeDescriptors2(:,:,j)).^2)./ ((ShapeDescriptors1(:,:,i) + ShapeDescriptors2(:,:,j)))));
        end
    end
end