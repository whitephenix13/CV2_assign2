function [ xa, xb, ya, yb ] = RANSAC2( img1, img2, points,plot_,fa_,da_,fb_,db_)

img1 = single(img1);
img2 = single(img2);

use_subsample=true;
if(points<0)
    use_subsample=false;
end
if(nargin> 4)
    fa=fa_;
    da=da_;
    fb=fb_;
    db=db_;
else
    [fa,da] = vl_sift(img1);
    [fb,db] = vl_sift(img2);
end

[matches, ~] = vl_ubcmatch(da, db);
coordinates_a = fa(1:2,matches(1,:));
coordinates_b = fb(1:2,matches(2,:));

pick_coordinates_a = [];
pick_coordinates_b = [];

if(use_subsample)
    for amount=1:points
        i = randi([1,length(matches(1,:))-1],1,1);
        pick_coordinates_a = [pick_coordinates_a, coordinates_a(1:2,i)];
        pick_coordinates_b = [pick_coordinates_b, coordinates_b(1:2,i)];
    end
else
    pick_coordinates_a=coordinates_a;
    pick_coordinates_b=coordinates_b;
end
xa = pick_coordinates_a(1,:);
ya = pick_coordinates_a(2,:);
xb = pick_coordinates_b(1,:);
yb = pick_coordinates_b(2,:);

width = length(img1(1,:));

%Plots
if(plot_)
    figure(1);
    imshow([uint8(img1), uint8(img2)])
    hold on;
    
    scatter(xa, ya, 20, [1,0,0]);
    scatter(xb+width, yb ,20, [1,0,0]);
    
    for k=1:length(xa)
        plot([xa(k) xb(k)+width], [ya(k) yb(k)], 'b', 'LineWidth', 1);
    end
    
    hold off;
end

end

