function [ measurement_matrix, block_view, sizes ] = build_dense_block( point_view_matrix, point_correspondance)

block_view = point_view_matrix(1:8,1:6);
%block_view = point_view_matrix(1:23,123:126);
measurement_matrix = [];
sizes = [];
images = 8;
points1 = 6;
points2 = 1000;
for i=1:images
    x_coordinates = [];
    y_coordinates = [];
    for k=1:points1
        %if block_view(i,k)==1
            for m=1:points2
                if k==point_correspondance(i,m,3)
                    x_coordinates = [x_coordinates, point_correspondance(i,m,1)];
                    y_coordinates = [y_coordinates, point_correspondance(i,m,2)];                    
                end
            end
        %end
    end
    %Wrong
    sizes = [sizes;length(x_coordinates),length(y_coordinates)];
   %measurement_matrix = [measurement_matrix; x_coordinates; y_coordinates];
end

end

