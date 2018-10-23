% extract SIFT descriptor
%
% Input:
%   keyPoints     - detected keypoints in a 2 x n matrix holding the key
%                   point coordinates
%   img           - the gray scale image
%   
% Output:
%   descr         - w x n matrix, stores for each keypoint a
%                   descriptor. m is the size of the image patch,
%                   represented as vector
function descr = extractSIFTDescriptor(corners, img)
    [row,column] = size(corners);
    descr = [];
    
    % Compute the gradient Ix and Iy 
    [Ix, Iy] = imgradientxy(img);
    [height, width] = size(Ix);
    magnitude = zeros(height,width);
    orientation = zeros(height,width);
    
    % Fill points outside the boundary as 0
    Ix_extended = zeros(height+8,width+8);
    Iy_extended = zeros(height+8,width+8);
    xpos=9;
    ypos=9;
    Ix_extended(xpos:xpos+height-1,ypos:ypos+width-1)=Ix;
    Iy_extended(xpos:xpos+height-1,ypos:ypos+width-1)=Iy;
    
    for c = 1:column
        patch = 1:128;
        c_pos = corners(:,c);
        y = c_pos(1);
        x = c_pos(2);
        histograms = zeros(16,16);
        blocks = mat2cell(histograms,[4 4 4 4],[4 4 4 4]);
             
        for j = -8:8
            for i = -8:8
                % Compute the orientation and magnitude
                Gx = Ix_extended(y+j,x+i);
                Gy = Iy_extended(y+j,x+i);
                orientation(y+j,x+i) = atan(Gy/Gx);
                magnitude(y+j,x+i) = sqrt(Gx^2 + Gy^2);
                
                % Add orientation to blocks weighted by magnitude
            end
        end  
        
        % For each block, compute a weighted histogram with 8 bins
        for j = 1:4
            for i = 1:4
                histogram = histcounts(blocks{j,i},8);
                % Apply Gaussian filter
                G = fspecial('gaussian');
                histogram_filtered = imfilter(histogram,G);
                % Concatenate the histograms to patch
                patch = [patch,histogram_filtered];
            end
        end
        
        % Ammend patch to the final result
        descr = [descr,patch'];
    end
end