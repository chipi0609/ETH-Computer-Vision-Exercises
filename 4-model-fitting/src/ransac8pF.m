function [in1, in2, out1, out2, m, F] = ransac8pF(xy1, xy2, threshold)

iteration = 1000;
number = size(xy1,2);
bestInNum = 0; 
in1 = xy1;
in2 = xy2;
out1 = [];
out2 = [];
N = 8;
m = 0;
p = 0;
inlierRatio = 0;


for i = 1:iteration
    %if p > 0.99
        %break;
    %end
    % Randomly select 8 points in each data set
    xy1_s = ones(3,8);
    xy2_s = ones(3,8);
    
    for j = 1:8
        xy1_s(1:2,j) = xy1(:,randi(number));
        xy2_s(1:2,j) = xy2(:,randi(number));
    end
    
    [Fh,F] = fundamentalMatrix(xy1_s,xy2_s);
    xy1_homo = [xy1;ones(1,number)];
    xy2_homo = [xy2;ones(1,number)];
    
    d1 = distPointLine(xy2,Fh * xy1_homo); 
    %d1 = zeros(1,number);
    %d2 = zeros(1,number);
    %A1 = Fh*xy1_homo;
    %A2 = Fh' * xy2_homo;
    %for j = 1:number
        %d1(j) = distPointLine(xy2_homo(:,j),A1(:,j));
        %d2(j) = distPointLine(xy1_homo(:,j),A2(:,j));
    %end
    
    %d2 = (Fh'*xy2_homo - xy1_homo).^2;
    %d2 = sqrt(sum(d2,1));
    %d2 = sum((xy1_homo' * Fh' * xy2_homo).^2,1);
    %A1 = Fh' * xy2_homo
    d2 = distPointLine(xy1,Fh' * xy2_homo);
    
    % Compute the inliers with distances smaller than the threshold
    inlierIndices = find(d1+d2 < threshold);
    in1_candidates = xy1(:,inlierIndices);
    in2_candidates = xy2(:,inlierIndices);
    
    % Update the number of inliers and fitting model if better model is found
    %if size(inlierIndices,2) <= inlierRatio * number
        %continue;
    %end
    if size(inlierIndices,2) <= 1000
        continue;
    end
    
    if size(inlierIndices,2) > 1000
    %if size(inlierIndices,2) > inlierRatio * number
        if size(inlierIndices,2) > bestInNum
            bestInNum = size(inlierIndices,2);
            in1 = in1_candidates;
            in2 = in2_candidates;
            outlierIndices = setdiff(linspace(1,number,number),inlierIndices);
            out1 = xy1(:,outlierIndices);
            out2 = xy2(:,outlierIndices);
        end
    end
    
    inlierRatio = bestInNum/number;
    p = 1 - (1-inlierRatio^N)^m;
    m = m+1;
end

[F,f] = fundamentalMatrix([in1;ones(1,size(in1,2))],[in2;ones(1,size(in2,2))]);

end


