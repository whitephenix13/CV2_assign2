function [ measurement_matrix] = build_measurement_matrix( new_point_correspondance,x1,x2,y1,y2)

measurement_matrix = [];
for frame=x1:x2
    x_coordinates = [];
    y_coordinates = [];
    %construct the line for frame "frame" of the measurement matrix 
    for index=y1:y2
        point = find(new_point_correspondance(frame,:,3)==index);
        x_coordinates = [x_coordinates, new_point_correspondance(frame,point(1),1)];
        y_coordinates = [y_coordinates, new_point_correspondance(frame,point(1),2)];
    end
    measurement_matrix = [measurement_matrix; x_coordinates; y_coordinates];
end

end

