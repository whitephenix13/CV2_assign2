function [ new_point_correspondance ] = normalize_coordinates( point_correspondance, x1,x2,y1,y2 )

new_point_correspondance = point_correspondance;
for i=x1:x2
    X = [];
    Y = [];
    for k=y1:y2
        %if point_view_matrix(i,k) == 1
            index = find(point_correspondance(i,:,3)==k);
            X = [X, point_correspondance(i,index(1),1)];
            Y = [Y, point_correspondance(i,index(1),2)];
         %end
    end   
    Xmean = mean(X);
    Ymean = mean(Y);
    for k=y1:y2
        %if point_view_matrix(i,k) == 1
            index = find(point_correspondance(i,:,3)==k);
            new_point_correspondance(i,index(1),1) = new_point_correspondance(i,index(1),1) - Xmean;
            new_point_correspondance(i,index(1),2) = new_point_correspondance(i,index(1),2) - Ymean;                     
         %end
    end
                 
end

end

