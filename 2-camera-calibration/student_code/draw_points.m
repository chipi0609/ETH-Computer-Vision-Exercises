function [] = draw_points(xy,xy_reprojected,filename)
img = imread(filename);
imshow(img);
axis image
hold on;

for i = 1:6
    plot(xy(1,i),xy(2,i), 'b-*','MarkerSize',10);
    plot(xy_reprojected(1,i),xy_reprojected(2,i), 'ro','MarkerSize',12);
end

end