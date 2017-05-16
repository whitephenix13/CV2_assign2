function [ measurement_matrix, s ] = SfM_run( point_correspondance, scale_z, threshold)

% x1=1; x2=2; y1=1; y2=284;
% [ new_point_correspondance ] = normalize_coordinates( point_correspondance, x1,x2,y1,y2 );
% [ measurement_matrix1] = build_measurement_matrix( new_point_correspondance, x1,x2,y1,y2);
% x1=2; x2=3; y1=292; y2=310;
% [ new_point_correspondance ] = normalize_coordinates( point_correspondance, x1,x2,y1,y2 );
% [ measurement_matrix2] = build_measurement_matrix( new_point_correspondance, x1,x2,y1,y2);
% x1=4; x2=5; y1=269; y2=277;
% [ new_point_correspondance ] = normalize_coordinates( point_correspondance, x1,x2,y1,y2 );
% [ measurement_matrix3] = build_measurement_matrix( new_point_correspondance, x1,x2,y1,y2);
% x1=12; x2=13; y1=585; y2=623;
% [ new_point_correspondance ] = normalize_coordinates( point_correspondance, x1,x2,y1,y2 );
% [ measurement_matrix4] = build_measurement_matrix( new_point_correspondance, x1,x2,y1,y2);
% x1=28; x2=29; y1=1021; y2=1064;
% [ new_point_correspondance ] = normalize_coordinates( point_correspondance, x1,x2,y1,y2 );
% [ measurement_matrix5] = build_measurement_matrix( new_point_correspondance, x1,x2,y1,y2);
% x1=29; x2=30; y1=1065; y2=1091;
% [ new_point_correspondance ] = normalize_coordinates( point_correspondance, x1,x2,y1,y2 );
% [ measurement_matrix6] = build_measurement_matrix( new_point_correspondance, x1,x2,y1,y2);

x1=1; x2=3; y1=1; y2=13;
[ measurement_matrix1] = build_measurement_matrix( point_correspondance, x1,x2,y1,y2);
measurement_matrix1=measurement_matrix1-mean(measurement_matrix1,2);
x1=4; x2=6; y1=1; y2=6;
[ measurement_matrix2] = build_measurement_matrix( point_correspondance, x1,x2,y1,y2);
measurement_matrix2=measurement_matrix2-mean(measurement_matrix2,2);

x1=7; x2=9; y1=1; y2=3;
[ measurement_matrix3] = build_measurement_matrix( point_correspondance, x1,x2,y1,y2);
measurement_matrix3=measurement_matrix3-mean(measurement_matrix3,2);

x1=1; x2=3; y1=50; y2=54;
[ measurement_matrix4] = build_measurement_matrix( point_correspondance, x1,x2,y1,y2);
measurement_matrix4=measurement_matrix4-mean(measurement_matrix4,2);

x1=1; x2=3; y1=156; y2=172;
[ measurement_matrix5] = build_measurement_matrix( point_correspondance, x1,x2,y1,y2);
measurement_matrix5=measurement_matrix5-mean(measurement_matrix5,2);

x1=1; x2=3; y1=185; y2=212;
[ measurement_matrix6] = build_measurement_matrix( point_correspondance, x1,x2,y1,y2);
measurement_matrix6=measurement_matrix6-mean(measurement_matrix6,2);

x1=1; x2=3; y1=242; y2=282;
[ measurement_matrix7] = build_measurement_matrix( point_correspondance, x1,x2,y1,y2);
measurement_matrix7=measurement_matrix7-mean(measurement_matrix7,2);

%measurement_matrix = measurement_matrix1;
%measurement_matrix = [ measurement_matrix1, measurement_matrix2, measurement_matrix3, measurement_matrix4,measurement_matrix5, measurement_matrix6]; 
measurement_matrix = [measurement_matrix1, measurement_matrix2,  measurement_matrix3,  measurement_matrix4, measurement_matrix5, measurement_matrix6,  measurement_matrix7];
step = 5/10;
[ structure, motion, s] = SfM( measurement_matrix, scale_z, threshold, step, 1-step );
scatter3(s(1,:),s(2,:),s(3,:));

end

