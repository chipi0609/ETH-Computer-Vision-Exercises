% extract descriptor
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
function descr = extractDescriptor(corners, img)
    [row,column] = size(corners);
    descr = [];
    
    % Fill points outside the boundry of the image as 0
    [height,width] = size(img);
    img_extended = zeros(height+8,width+8);
    xpos=5;
    ypos=5;
    img_extended(xpos:xpos+height-1,ypos:ypos+width-1)=img;
    
    % Add 9x9 patch for each feature
    for c = 1:column
        patch = 1:81;
        c_pos = corners(:,c);
        y = c_pos(1);
        x = c_pos(2);
        
        for j = -4:4
            for i = -4:4
                patch((j+4) * 9 + i + 5) = img_extended(y+j,x+i);
            end
        end        
        descr = [descr,patch'];
    end
end