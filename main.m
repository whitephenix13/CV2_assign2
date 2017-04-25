function [ F ] = main( img1, img2, points )

%img1 - image 1
%img1 - image 2
%points - number of matching pairs to detect

if(nargin==0)
    im1_nb = '01';
    im2_nb = '02';
    points = 10;
    img1 = strcat('House/frame000000',im1_nb,'.png');
    img2 = strcat('House/frame000000',im2_nb,'.png');
end
%Read input
img1 = imread(img1);
img2 = imread(img2);

%Remove background
[ image1, image2 ] = RemoveBackground( img1, img2 );

%Run Ransac, output matching pair coordinates
[ xa, xb, ya, yb ] = RANSAC2( image1, image2, points );
 
%Calculate Fundamental matrix
[ F ] = Fundamental( xa, xb, ya, yb,'original');

end

