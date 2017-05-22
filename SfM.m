function [ structure, motion, s] = SfM( measurement_matrix, scale_z, threshold, p1, p2)

[U,S,V] = svd(measurement_matrix);

U3 = U(:,1:3);
S3 = S(1:3,1:3);
Vt = V.';
V3 = Vt(1:3,:);

motion = U3*S3^p1;
structure = S3^p2*V3;


% % Ai*L*Ai.' = Id
% % motion*L*motion.' = Id
% L = mrdivide(mldivide(motion,eye(length(motion(:,1)))), transpose(motion));
% %L = mldivide(motion,mrdivide(eye(length(motion(:,1))),transpose(motion)));
% C = chol(L);
% structure = mldivide(C.',structure);


%Filter by threshold
s = [];
for i=1:length(structure(1,:))
   if abs(structure(3,i))>threshold==0
       s = [s, structure(:, i)];
   end  
end

%Scale z
s(3,:) = s(3,:)*scale_z;

figure(5);
scatter3(structure(1,:),structure(2,:),structure(3,:));
figure(6);
scatter3(s(1,:),s(2,:),s(3,:));

end

