function vPoints = grid_points(img,nPointsX,nPointsY,border)
    [height,width,~] = size(img);
    h = height - 2*border;
    w = width - 2*border;
    grid_Y = ceil(h/nPointsY);
    grid_X = ceil(w/nPointsX);
    
    Y = border+1:grid_Y:height-border;
    X = border+1:grid_X:width-border;
    
    [y,x] = meshgrid(Y,X);
    c=cat(2,y',x');
    vPoints=reshape(c,[],2);
end
