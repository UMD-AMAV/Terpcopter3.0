function [position, angle, t, Rmat, Quat] = get_PosAngDummy(Np)

if nargin == 0
    Np = 1;
end

position= [0 0 0; 0 0 0];
angle= [0 0 0; 0 0 0];
Rmat= {eye(3), eye(3)};
Quat= [0 1 0 0; 0 1 0 0];

time= clock;
t= time(6);