function [ point_view_matrix ,point_correspondance ] = chaining(number_points)
number_image = 49;
point_view_matrix=zeros(number_image,number_image*number_points);
point_correspondance=zeros(number_image*number_points,2);%point_correspondance(i,:) = [x;y] where x and y are the 
%points corresponding to the ith column of point_view_matrix
current_nb_points = 0;

for i=1:number_image
%i and j corresponds to the image we match 
j=i+1;%match i,i+1
if(j>number_image)
    j=1;%match number_image,1
end
pad1='';
pad2='';
if(i<10)
    pad1='0';
end
if(j<10)
    pad2='0';
end
img1 = strcat('House/frame000000',pad1,num2str(i),'.png');
img2 = strcat('House/frame000000',pad2,num2str(j),'.png');

%Remove background
[ image1, image2 ] = RemoveBackground( img1, img2 );
%Run Ransac, output matching pair coordinates
[ xa, xb, ya, yb ] = RANSAC2( image1, image2, points );
%Calculate Fundamental matrix for un-normalized data
[ F,inliers_index] = Fundamental( xa, xb, ya, yb,true );

%TODO: loop over all new matches
%TODO: test if the match is in the matrix
%TODO: if yes, find its position and complete the matrix
%TODO: if no, add it and complete the matrix

%removed unused entries
if(current_nb_points>0)
    point_view_matrix(:,current_nb_points+1:end)=[];
    point_correspondance(current_nb_points+1:end,:)=[];
end
end

