function [ F ] = Fundamental( xa, xb, ya, yb,method )

if(strcmp(method,'original'))
f = ones(length(xa),1);
A = [(xa.*xb).', (xa.*yb).', xa.', (ya.*xb).', (ya.*yb).', ya.', xb.', yb.', f];
[U,S,V] = svd(A);
[ ~, c ] = find(S==min(S(S>0)));
Fundamental = reshape(V(:,c),3,3);

[U_i,S_i,V_i] = svd(Fundamental);
[ r, c ] = find(S_i==min(S_i(S_i>0)));
S_i(r,c)=0;
F = U_i*S_i*V_i;
elseif(strcmp(method,'normalized'))
    
elseif(strcmp(method,'RANSAC'))
    threshold = 0.1;%TODO: tune it 
    max_nb_inlier = -1;
    max_num_iter = 10;
    %from xa,ya,xb,yb compute the normalized pairs p <-> q
    %p,q are of size 3,n
    p=NormalizedFundamental(xa,ya);
    q=NormalizedFundamental(xb,yb);
    for i=1:max_num_iter
        %First pick 8 point correspondences randomly from ^pi(p1) and
        %^pi'(p2)
        random_indexes= randperm(size(p,2),8);
        %p1 and p2 are 3xn n=8
        rand_p=p(:,random_indexes);
        rand_q=q(:,random_indexes);
        %compute normalized fundamental F2 for those 8 matches
        F2 = Fundamental( rand_p(1,:), rand_q(1,:), rand_p(2,:), rand_q(2,:),'normalized' );
        %count number of inliers among all points for this fundamental F2
        d=sampson_distance(p,q,F2);%1xn vector
        nb_inliers = sum(d<=threshold);
        %keep in memory F for which the number of inliers is the biggest 
        if(nb_inliers>max_nb_inlier)
            max_nb_inlier=nb_inliers;
            F=F2;
        end
    end  
end



