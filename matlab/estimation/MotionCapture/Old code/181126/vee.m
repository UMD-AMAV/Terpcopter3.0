function [ a ] = vee( A )
%VEE is the vee operator, converting a matrix in SO(3) to R^3
a = [-A(2,3); A(1,3); -A(1,2)];


end

