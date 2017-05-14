function [ measurement_matrix] = build_measurement_matrix( new_point_correspondance,x1,x2,y1,y2)

measurement_matrix = [];
for i=x1:x2
    x_coordinates = [];
    y_coordinates = [];
    for k=y1:y2
        index = find(new_point_correspondance(i,:,3)==k);
        x_coordinates = [x_coordinates, new_point_correspondance(i,index(1),1)];
        y_coordinates = [y_coordinates, new_point_correspondance(i,index(1),2)];
    end
    measurement_matrix = [measurement_matrix; x_coordinates; y_coordinates];
end

end

