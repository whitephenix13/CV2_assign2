mode='house';%test house
if(strcmp(mode,'test'))
    measurement_matrix = importdata('PointViewMatrix.txt',' ');
    measurement_matrix=measurement_matrix-mean(measurement_matrix,2);
    [ structure, motion, s] = SfM( measurement_matrix, 400, 200, 0.5, 0.5 );
elseif(strcmp(mode,'house'))
    point_view_matrix=importdata('p_v.mat','');
    point_correspondance=importdata('p_c.mat','');
    
    [ measurement_matrix ] = myMeasurement(point_view_matrix, point_correspondance );
    measurement_matrix=measurement_matrix-mean(measurement_matrix,2);
    [ structure, motion, s] = SfM( measurement_matrix, 10, 100, 0.5, 0.5 );
end
figure();
scatter3(s(1,:),s(2,:),s(3,:));