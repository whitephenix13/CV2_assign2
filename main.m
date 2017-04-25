function [ F_un, F_n, F_den ] = main( img1, img2, points )

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
 
%Calculate Fundamental matrix for un-normalized data
[ F_un ] = Fundamental( xa, xb, ya, yb );

%Normalize points
[ pa, Ta ] = NormalizedFundamental( xa, ya );
[ pb, Tb ] = NormalizedFundamental( xb, yb );

%Compute Fundamental matrix for normalized data
[ F_n ] = Fundamental( pa(1,:), pb(1,:), pa(2,:), pb(2,:) );

%Denormalize
F_den = Tb*F_n*Ta.';

end

