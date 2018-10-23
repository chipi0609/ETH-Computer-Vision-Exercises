% extract harris corner
%
% Input:
%   img           - n x m gray scale image
%   thresh        - scalar value to threshold corner strength
%   
% Output:
%   corners       - 2 x k matrix storing the keypoint coordinates
%   H             - n x m gray scale image storing the corner strength
function [corners, H] = extractHarrisCorner(img, thresh) 
    % blur image
    img = imgaussfilt(img,1.2);
    
    % Compute the gradient Ix and Iy 
    [Ix, Iy] = imgradientxy(img);
    [height, width] = size(Ix);
    
    % Fill points outside the boundary as 0
    Ix_extended = zeros(height+2,width+2);
    Iy_extended = zeros(height+2,width+2);
    xpos=2;
    ypos=2;
    Ix_extended(xpos:xpos+height-1,ypos:ypos+width-1)=Ix;
    Iy_extended(xpos:xpos+height-1,ypos:ypos+width-1)=Iy;
    
    % Compute the Harris response for each pixel
    corners = [];
    for y = 2 : height
        for x = 2 : width
            Ix2 = 0; IxIy = 0; Iy2 = 0;
            H_measure = [Ix2 IxIy, IxIy Iy2];
            for j = -1 : 1
                for i = -1 : 1
                    Ix2 = Ix2 + Ix_extended(y+j,x+i)^2;
                    IxIy = IxIy + Ix_extended(y+j,x+i) * Iy_extended(y+j,x+i);
                    Iy2 = Iy2 + Iy_extended(y+j,x+i)^2;
                    H_measure = [Ix2 IxIy;IxIy Iy2];
                end
            end
            % Compute Harris response measure K
            H(y,x) = det(H_measure)/trace(H_measure);
        end
    end
    
    % Extract key points
    % Fill points outside the boundary as 0
    H_extended = zeros(height+2,width+2);
    xpos=2;
    ypos=2;
    H_extended(xpos:xpos+height-1,ypos:ypos+width-1)=H;
    
    corners = [];
    neighbours = zeros(3);
    for y = 2 : height
        for x = 2 : width
            % Check for corners bigger than the threshold
            if H_extended(y,x) >= thresh
                for j = -1 : 1
                    for i = -1 : 1
                        neighbours(j+2,i+2) = H_extended(y+j,x+i);
                    end
                end
                
                % Apply non-maximum suppression
                if H_extended(y,x) >= max(neighbours)
                    corners = [corners,[y-1;x-1]];
                end
            end
        end
    end
  
end