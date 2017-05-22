function [ F, F_den, s ] = main( img1, img2, points )

%img1 - image 1
%img1 - image 2
%points - number of matching pairs to detect

if(nargin==0)
    im1_nb = '10';
    im2_nb = '11';
    points = -1;%set to -1 to get all points
    img1 = strcat('House/frame000000',im1_nb,'.png');
    img2 = strcat('House/frame000000',im2_nb,'.png');
end
%Read input
img1 = imread(img1);
img2 = imread(img2);

%Remove background
[ image1, image2 ] = RemoveBackground( img1, img2 );

%Run Ransac, output matching pair coordinates
[ xa, xb, ya, yb ] = RANSAC2( image1, image2, points,true);

%Calculate Fundamental matrix for un-normalized data
[ F,inliers_index1] = Fundamental( xa, xb, ya, yb,false );
%test correctness of fundamental :
X=[xa(1,inliers_index1);ya(1,inliers_index1);ones(1,size(xa,2))];
Y=[xb(1,inliers_index1);yb(1,inliers_index1);ones(1,size(xb,2))];
diag(Y'*F*X)
%Compute Fundamental matrix for normalized data
[ F_den,inliers_index2] = Fundamental( xa, xb, ya, yb,true );
diag(Y'*F_den*X)

plot_epipolar(img1,img2,F,inliers_index1,[xa',ya'],[xb',yb'],'unormalized epipolar lines');
plot_epipolar(img1,img2,F_den,inliers_index2,[xa',ya'],[xb',yb'],'normalized epipolar lines');

%Create point_view and point_correspondance matrices
%Change the path in chaining for images folder
[ point_view_matrix ,point_correspondance ] = chaining(false,false);

%Look second half of lecture 2 for algorithm

%Normalize the data by the means
[ normalized_measurement_matrix ] = normalize_coordinates( measurement_matrix );

%Pick the biggest dense block(all values are 1) in the point_view_matrix
[ measurement_matrix, block_view] = build_dense_block( point_view_matrix, new_point_correspondance);

%Structure from Motion
% Filter out the cooridinates with big z values(more than 3), and scale the image by multiplying the z values by 10
[ structure, motion, s ] = SfM(measurement_matrix, 10, 3);

end

function [] = plot_epipolar(img1,img2,F,inliers_index,points,matches,tit)
%points : Mx2 matrix: [x1,y1;x2,y2;...]
figure;
set(gcf,'name',tit);
imshow([uint8(img1), uint8(img2)]);

hold on;
%Show inlier in first image
width = length(img1(1,:));

plot(points(inliers_index,1),points(inliers_index,2),'go');

X=[points(inliers_index,1)';points(inliers_index,2)';ones(size(inliers_index,2),1)'];
Y=[matches(inliers_index,1)';matches(inliers_index,2)';ones(size(inliers_index,2),1)'];
%Compute epipole as being the 3rd column of V matrix from svd of
%Fundamental.
[U,S,V] = svd(F);
epipole= V(:,3);

%plot epipolar line for first image
for k=1:size(inliers_index,2)
    plot([X(1,k) epipole(1)], [X(2,k) epipole(2)], 'b', 'LineWidth', 1);
end
%plot epipolar line for second image
for k=1:size(inliers_index,2)
    plot([matches(inliers_index(k),1)+width epipole(1)+width], [matches(inliers_index(k),2) epipole(2)],...
        'b', 'LineWidth', 1);
end
%RANSAAC predicted matched inliers
plot(matches(inliers_index,1)+width,matches(inliers_index,2),'go');
hold off;

end

