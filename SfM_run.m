function [ normalized_measurement_matrix ] = SfM_run( point_view_matrix, point_correspondance, images, point1, point2, scale_z, threshold)

[ measurement_matrix] = build_measurement_matrix( point_view_matrix, point_correspondance,images,point1,point2);
[ normalized_measurement_matrix ] = normalize_coordinates( measurement_matrix );

step = 5/10;

[ structure, motion, s] = SfM( normalized_measurement_matrix, scale_z, threshold, step, 1-step );
figure(1);
scatter3(structure(1,:),structure(2,:),structure(3,:));
figure(2);
scatter3(s(1,:),s(2,:),s(3,:));

end

