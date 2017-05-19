function [ measurement_matrix] = build_measurement_matrix( point_view_matrix, point_correspondance,images,point1,point2)

measurement_matrix = [];
for k=point1:point2
    coordinates = [];
    if sum(point_view_matrix(:,k))>=images
        frame = find(point_view_matrix(:,k)==1);
        for i=1:length(frame)
            index = find(point_correspondance(frame(i),:,3)==k);
            coordinates = [coordinates; point_correspondance(frame(i),index(1),1); point_correspondance(frame(i),index(1),2)];
        end
        coordinates = coordinates(1:images*2);
    end
    measurement_matrix = [measurement_matrix, coordinates];
end

end

