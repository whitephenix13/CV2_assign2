function [ structure, motion, s ] = SfM( measurement_matrix, scale_z, threshold )

[U,S,V] = svd(measurement_matrix);

U3 = U(:,1:3);
S3 = S(1:3,1:3);
Vt = V.';
V3 = Vt(1:3,:);

motion = U3*sqrtm(S3);
structure = sqrtm(S3)*V3;
s = [];
for i=1:length(structure(1,:))
    if sum(abs(structure(:,i))>threshold)==0
        s = [s, structure(:, i)];
    end  
end
s(3,:) = s(3,:)*scale_z;
%Plots
figure(1);
scatter3(structure(1,:),structure(2,:),structure(3,:));
figure(2);
scatter3(s(1,:),s(2,:),s(3,:));
end

