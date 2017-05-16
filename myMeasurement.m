function [ measurement_matrix ] = myMeasurement(point_view_matrix, point_correspondance )
mode='denseblock'; %all,topnrow, topncol, denseblock
n=10;
m=12;
if(strcmp(mode,'all'))
    %get the column that have only ones
    new_indexes = (sum(point_view_matrix==1,1)== size(point_view_matrix,1));
    all_indexes=linspace(1,size(point_view_matrix,2),size(point_view_matrix,2));
    new_indexes=all_indexes(new_indexes)';
    last_frame=49;
elseif(strcmp(mode,'topnrow'))
    %get the column that have only ones on their first n rows
    new_indexes = (sum(point_view_matrix(1:n,:)==1,1)== n);
    all_indexes=linspace(1,size(point_view_matrix,2),size(point_view_matrix,2));
    new_indexes=all_indexes(new_indexes)';
    last_frame=n;
elseif(strcmp(mode,'topncol'))
    %get m columns that have only ones on their first n rows
    new_indexes = (sum(point_view_matrix(1:n,:)==1,1)== n);
    all_indexes=linspace(1,size(point_view_matrix,2),size(point_view_matrix,2));
    new_indexes=all_indexes(new_indexes)';
    new_indexes=new_indexes(1:m)
    last_frame=n;
elseif(strcmp(mode,'denseblock'))
    %get a copy of the point view matrix
    pvm_copy = point_view_matrix;
    %get the indexes of the column that have a one in the first row 
    ind = linspace(1,size(point_view_matrix,2),size(point_view_matrix,2));
    row_one_indexes = ind(pvm_copy(1,:)==1)';
    %memorize for each of the previous columns the number of dense 1 they
    %have
    number_dense_one=zeros(size(row_one_indexes));
    for i=1:size(row_one_indexes)
        all_zeros_indexes = find(pvm_copy(:,row_one_indexes(i))==0);
        if(isempty(all_zeros_indexes))
            number_dense_one(i)=49;
        else
            number_dense_one(i)=all_zeros_indexes(1)-1;
        end
    end
    [ordered,corresp_index]= sort(number_dense_one,'descend');
    %reorganise the corresponding above columns to get the biggest dense block
    pvm_copy(:,row_one_indexes)=pvm_copy(:,corresp_index);
    figure();
    nb_pt = min(size(point_view_matrix,2),1000);
    imshow(point_view_matrix(:,1:nb_pt));
    figure();
    nb_pt = min(size(pvm_copy,2),1000);
    imshow(pvm_copy(:,1:nb_pt));
    %extract the biggest dense block with n frames 
    ingored_column = find(ordered<n);
    if(isempty(ingored_column))
        last_considered_point= size(ordered,1)+1;
    else
        last_considered_point=ingored_column(1);
    end
    
    %indexes we want to consider are 1 : last_considered_point-1 for the
    %transformed one, hence 
    new_indexes=corresp_index(1:last_considered_point-1);
    last_frame=n;
end

measurement_matrix = [];
for frame=1:last_frame
    x_coordinates = [];
    y_coordinates = [];
    %construct the line for frame "frame" of the measurement matrix
    for i=1:size(new_indexes)
        index=new_indexes(i);
        point = find(point_correspondance(frame,:,3)==index);
        x_coordinates = [x_coordinates, point_correspondance(frame,point(1),1)];
        y_coordinates = [y_coordinates, point_correspondance(frame,point(1),2)];
    end
    measurement_matrix = [measurement_matrix; x_coordinates; y_coordinates];
end
end

