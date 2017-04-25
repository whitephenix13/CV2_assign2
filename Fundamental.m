function [ F ] = Fundamental( xa, xb, ya, yb )

f = ones(length(xa),1);
A = [(xa.*xb).', (xa.*yb).', xa.', (ya.*xb).', (ya.*yb).', ya.', xb.', yb.', f];
[U,S,V] = svd(A);
[ ~, c ] = find(S==min(S(S>0)));
Fundamental = reshape(V(:,c),3,3);

[U_i,S_i,V_i] = svd(Fundamental);
[ r, c ] = find(S_i==min(S_i(S_i>0)));
S_i(r,c)=0;
F = U_i*S_i*V_i;

end

