function [ new_point_correspondance ] = normalize_coordinates( point_correspondance, point_view_matrix )

new_point_correspondance = point_correspondance;
%Numberof images
images=49;
%Number of points
points1 = length(point_view_matrix(1,:));
%For each image
for i=1:images
    X = [];
    Y = [];
    %For each point
    for k=1:points1
        %if point is in frame
        if point_view_matrix(i,k) == 1
            %Find where indices of columns are equal to point_correspondance(i,:,3), to get points data  
            index = find(point_correspondance(i,:,3)==k);
            %Get X and Y coordinates, take only once for each match
            X = [X, point_correspondance(i,index(1),1)];
            Y = [Y, point_correspondance(i,index(1),2)];
         end
    end 
    %Get mean values
    Xmean = mean(X);
    Ymean = mean(Y);
    %For each points
    for k=1:points1
        %if point is in frame
        if point_view_matrix(i,k) == 1
            %Find where indices of columns are equal to point_correspondance(i,:,3), to get points data
            index = find(point_correspondance(i,:,3)==k);
            %Normalize by subtracting means from each point in frame
            new_point_correspondance(i,index(1),1) = new_point_correspondance(i,index(1),1) - Xmean;
            new_point_correspondance(i,index(1),2) = new_point_correspondance(i,index(1),2) - Ymean;                     
         end
    end
                 
end

end

