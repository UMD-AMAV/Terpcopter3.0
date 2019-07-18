function [ A ] = skew( a )
%skew turns a vector into its skew symmetric cross product matrix
%   such that: axb = c, and Ab = c

A = [ 0,   -a(3),  a(2); 
     a(3),  0,    -a(1); 
    -a(2), a(1),    0 ];

end

