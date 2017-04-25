function [ image1, image2 ] = RemoveBackground( img1, img2 )

level1 = graythresh(img1);
level2 = graythresh(img2);

BW1 = im2bw(img1,level1);
BW2 = im2bw(img2,level2);

image1 = uint8(BW1).*img1;
image2 = uint8(BW2).*img2;

end

