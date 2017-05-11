function [ measurement_matrix, block_view] = build_dense_block( point_view_matrix, point_correspondance)
%Create dense block manually
block_view = point_view_matrix(1:2,1:284);
measurement_matrix = [];
%Number of images
images = length(block_view(:,1));
%Number of points
points1 = length(block_view(1,:));
%For each image
for i=1:images
    x_coordinates = [];
    y_coordinates = [];
    %For each point
    for k=1:points1
        %Check the index of the column(points index) and point_correspondance(i,:,3)
        index = find(point_correspondance(i,:,3)==k);
        %If equal take the x and y corrdinates of the first match only
        x_coordinates = [x_coordinates, point_correspondance(i,index(1),1)];
        y_coordinates = [y_coordinates, point_correspondance(i,index(1),2)];
    end
    %Create matrix x x x x...
    %              y y y y... 
    %              x x x x...
    %              y y y y... 
    %              .......
    measurement_matrix = [measurement_matrix; x_coordinates; y_coordinates];
end

end

