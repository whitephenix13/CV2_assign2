function [ F ] = main( img1, img2, points )

%img1 - image 1
%img1 - image 2
%points - number of matching pairs to detect

%Read input
img1 = imread(img1);
img2 = imread(img2);

%Remove background
[ image1, image2 ] = RemoveBackground( img1, img2 );

%Run Ransac, output matching pair coordinates
[ xa, xb, ya, yb ] = RANSAC2( image1, image2, points );

%Calculate Fundamental matrix
[ F ] = Fundamental( xa, xb, ya, yb );

end

