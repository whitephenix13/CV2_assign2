function [ normalized_measurement_matrix ] = normalize_coordinates( measurement_matrix )

shape=size(measurement_matrix);
%x_mean = sum(sum(measurement_matrix(1:2:end,:)))/(shape(1)/2*shape(2));
%y_mean = sum(sum(measurement_matrix(2:2:end,:)))/(shape(1)/2*shape(2));
x_mean = sum(measurement_matrix(1:2:end,:),2)/(shape(2));
y_mean = sum(measurement_matrix(2:2:end,:),2)/(shape(2));
normalized_measurement_matrix = measurement_matrix;
normalized_measurement_matrix(1:2:end,:) = normalized_measurement_matrix(1:2:end,:) - x_mean;
normalized_measurement_matrix(2:2:end,:) = normalized_measurement_matrix(2:2:end,:) - y_mean;

end

