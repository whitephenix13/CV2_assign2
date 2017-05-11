function [ structure, motion, s ] = SfM( measurement_matrix, scale_z, threshold )
%All in lecture 2
[U,S,V] = svd(measurement_matrix);

U3 = U(:,1:3);
S3 = S(1:3,1:3);
Vt = V.';
V3 = Vt(1:3,:);

motion = U3*sqrtm(S3);
structure = sqrtm(S3)*V3;

%Filter points with big z values
s = [];
for i=1:length(structure(1,:))
    if sum(abs(structure(3,i))>threshold)==0
        s = [s, structure(:, i)];
    end  
end
%Scale up z values
s(3,:) = s(3,:)*scale_z;
%Plots
figure(3);
scatter3(s(1,:),s(2,:),s(3,:));
end

