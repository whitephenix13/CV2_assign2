function [ structure, motion, s, C ] = SfM( measurement_matrix, scale_z, threshold )

[U,S,V] = svd(measurement_matrix);

U3 = U(:,1:3);
S3 = S(1:3,1:3);
Vt = V.';
V3 = Vt(1:3,:);

motion = U3;
structure = S3*V3;

% Ai*L*Ai.' = Id
% motion*L*motion.' = Id
L = mrdivide(mldivide(motion,eye(length(motion(:,1)))), transpose(motion));
%L = mldivide(motion,mrdivide(eye(length(motion(:,1))),transpose(motion)));
C = chol(L);
structure = mldivide(C,structure);

%Filter by threshold
s = [];
for i=1:length(structure(1,:))
   if sum(abs(structure(:,i))>threshold)==0
       s = [s, structure(:, i)];
   end  
end

%Scale z
s(3,:) = s(3,:)*scale_z;

%Plots
figure(2);
scatter3(s(1,:),s(2,:),s(3,:));
figure(3);
scatter3(structure(1,:),structure(2,:),structure(3,:));
end

