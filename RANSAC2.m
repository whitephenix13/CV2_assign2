function [ xa, xb, ya, yb ] = RANSAC2( img1, img2, points )

img1 = single(img1);
img2 = single(img2);

[fa,da] = vl_sift(img1);
[fb,db] = vl_sift(img2);

[matches, ~] = vl_ubcmatch(da, db);

coordinates_a = fa(1:2,matches(1,:));
coordinates_b = fb(1:2,matches(2,:));

pick_coordinates_a = [];
pick_coordinates_b = [];

for amount=1:points
    i = randi([1,length(matches(1,:))-1],1,1);
    pick_coordinates_a = [pick_coordinates_a, coordinates_a(1:2,i)];
    pick_coordinates_b = [pick_coordinates_b, coordinates_b(1:2,i)];
end

xa = pick_coordinates_a(1,:);
ya = pick_coordinates_a(2,:);
xb = pick_coordinates_b(1,:);
yb = pick_coordinates_b(2,:);

width = length(img1(1,:));

%Plots
figure(2); 
imshow([uint8(img1), uint8(img2)])

hold on; 

scatter(xa, ya, 20, [1,0,0]);
scatter(xb+width, yb ,20, [1,0,0]);

for k=1:length(xa)
    plot([xa(k) xb(k)+width], [ya(k) yb(k)], 'b', 'LineWidth', 1)
end

hold off;

end

