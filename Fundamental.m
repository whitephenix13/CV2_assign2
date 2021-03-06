function [ F,inliers_index] = Fundamental( xa, xb, ya, yb,normalize )
%Eight-points algorithm
if(~normalize)
    F=compute_F(xa, xb, ya, yb,eye(3),eye(3));
    inliers_index=linspace(1,size(xa,2),size(xa,2));
%Normalized Eight-point Algorithm with RANSAC
else     
    threshold = 1;
    max_nb_inlier = -1;
    inliers_index=[];
    max_num_iter = 100;
    %from xa,ya,xb,yb compute the normalized pairs p <-> q
    %p,q are of size 3,n
    [p,pT]=NormalizedFundamental(xa,ya);
    [q,qT]=NormalizedFundamental(xb,yb);
    for i=1:max_num_iter
        %First pick 8 point correspondences randomly from ^pi(p1) and
        %^pi'(p2)
        random_indexes= randperm(size(p,2),8);
        %p1 and p2 are 3xn n=8
        rand_p=p(:,random_indexes);
        rand_q=q(:,random_indexes);
        %compute normalized fundamental F2 for those 8 matches
        F2 = compute_F(rand_p(1,:), rand_q(1,:), rand_p(2,:), rand_q(2,:),pT,qT);
        %count number of inliers among all points for this fundamental F2
        d=sampson_distance(p,q,F2);%1xn vector
        nb_inliers = sum(d<=threshold);
        %keep in memory F for which the number of inliers is the biggest
        if(nb_inliers>max_nb_inlier)
            max_nb_inlier=nb_inliers;
            index= linspace(1,size(d,2),size(d,2));
            inliers_index=index(d<=threshold);
            F=F2;
        end
    end
end
end

%Eight-points algorithm
function F_=compute_F(xa_,xb_,ya_,yb_,pT,qT)
%in case where we don't want to normalize, p(1,:)=xa, p(2,:)=ya, ...
p=[xa_;ya_;ones(1,length(xa_))];
q=[xb_;yb_;ones(1,length(xb_))];
%Create the A matrix
%x1x2//x1y2//x1//y1x2//y1y2//y1//x2//y2//1
%p1q1//p1q2//p1//p2q1//p2q2//p2//q1//q2//1
A = [(p(1,:).*q(1,:)).', (p(1,:).*q(2,:)).', p(1,:).', (p(2,:).*q(1,:)).', (p(2,:).*q(2,:)).', p(2,:).',...
    q(1,:).', q(2,:).',ones(length(p(1,:)),1)];
%Find svd of A
[U,S,V] = svd(A);
%Find the smallest singular value index in S
%[ ~, c ] = find(S==min(S(S>0)));
[~,c]= min(diag(S));
%Reshape V to get a 3x3 matrix according to this index
Fundamental = reshape(V(:,c),3,3);
%Compute the SVD once again
[U_i,S_i,V_i] = svd(Fundamental);
%Find the smallest singular value
%[ r, c ] = find(S_i==min(S_i(S_i>0)));
[val,ind]= min(diag(S_i));
%Set it to 0
S_i(ind,ind)=0;
%Recompute F
F = U_i*S_i*V_i';
%Denormalize
F_=qT'*F*pT;
end



