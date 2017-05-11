function [ measurement_matrix, block_view] = build_dense_block( point_view_matrix, point_correspondance)

block_view = point_view_matrix(1:2,1:284);
measurement_matrix = [];
images = length(block_view(:,1));
points1 = length(block_view(1,:));
for i=1:images
    x_coordinates = [];
    y_coordinates = [];
    for k=1:points1
        index = find(point_correspondance(i,:,3)==k);
        x_coordinates = [x_coordinates, point_correspondance(i,index(1),1)];
        y_coordinates = [y_coordinates, point_correspondance(i,index(1),2)];
    end
    measurement_matrix = [measurement_matrix; x_coordinates; y_coordinates];
end

end

