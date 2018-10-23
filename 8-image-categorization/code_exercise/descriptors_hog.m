function [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight)
    nBins = 8;
    w = cellWidth; % set cell dimensions
    h = cellHeight;   

    descriptors = zeros(0,nBins*4*4); % one histogram for each of the 16 cells
    patches = zeros(0,4*w*4*h); % image patches stored in rows    
    
    [grad_x,grad_y]=gradient(img);    
    
    for i = [1:size(vPoints,1)] % for all local feature points
        vPoint = vPoints(i,:);
        xIds = [vPoint(1)-2*w : vPoint(1)-1,vPoint(1) + 1 : vPoint(1) + 2*w];
        yIds = [vPoint(2)-2*h : vPoint(2)-1,vPoint(2) + 1 : vPoint(2) + 2*h];
        
        xs = vPoint(1)-2*w:vPoint(1) + 2*w;
        ys = vPoint(2)-2*h:vPoint(2) + 2*h;
        
        cells = img(xIds,yIds);
        
        patch = reshape(cells,[1,4*w*4*h]);
        cellArray = mat2cell(cells,[h,h,h,h],[w,w,w,w]);
        descriptor = [];
        angles = atan2(grad_x(xs,ys),grad_y(xs,ys));
        magnitudes = sqrt(grad_x(xs,ys).^2 + grad_y(xs,ys).^2); 
        for j = 1:4:16
            for k = 1:4:16
                [n,~] = histcounts(angles(j:j+3,k:k+3),8);
                [m,~] = histcounts(magnitudes(j:j+3,k:k+3),8);
                
                descriptor = [descriptor n.*m];
            end
        end
        patches = [patches;patch];
        descriptors = [descriptors;descriptor];
    end % for all local feature points
    
end