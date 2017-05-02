%Compute the Sampson distance d for match vectors p,q such that p1 <-> q1, p2 <-> q2 ... with respect to the
%fundamental matrix F 
%p,q is size 3xn, F is 3x3
%d is a 1xn vector 
function [ d ] = sampson_distance( p,q,F )
Fp= F*p; %size 3xn
FTq= F'*q; %size 3 x n 

%numerator: 1xn,  by computing q'Fp we have a nxn matrix where the i,j value is q_i' F p_j 
%we are only interested in the q_i'Fp_i values hence, we take the diagonnal
%of this matrix and square each elements. Note that we have to transpose
%the final result to get a 1xn vector 
%denominator: 1xn is the same as the normal formula but the squared is applied
%to every element of the vector
%The division is then done elementwise. 
d= ( diag(q'*F*p).^2)' ./ (Fp(1,:).^2 + Fp(2,:).^2 +FTq(1,:).^2 + FTq(2,:).^2);
end

