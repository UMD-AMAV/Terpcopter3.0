function  R = Euler2Rmat(angles,order)
% R = Euler2Rmat(angles,order)
% R is a rotation matrix that converts coordinates in body frame to
% inertial frame, i.e., R_IB= [b1,b2,b3] (columns are unit vectors that
% describe body frame).
%
% angels= [phi, theta, psi];
% order= 123 or 321
% https://en.wikipedia.org/wiki/Euler_angles
%
% Daigo 3/6/2016

switch order
    case 321
        ang= angles([3,2,1]); % psi, theta, phi
        c= cos(ang);
        s= sin(ang);
        % rotation matrix (see wiki)
        R= [c(1)*c(2),  c(1)*s(2)*s(3)-c(3)*s(1),  s(1)*s(3)+c(1)*c(3)*s(2);
            c(2)*s(1),  c(1)*c(3)+s(1)*s(2)*s(3),  c(3)*s(1)*s(2)-c(1)*s(3);
            -s(2)    ,   c(2)*s(3)              ,  c(2)*c(3)               ;];
        
    case 123
        ang= angles([1,2,3]); % phi, theta, psi
        c= cos(ang);
        s= sin(ang);
        % rotation matrix (see wiki)
        R= [c(2)*c(3)               ,  -c(2)*s(3)              ,   s(2)     ;
            c(1)*s(3)+c(3)*s(1)*s(2),  c(1)*c(3)-s(1)*s(2)*s(3),  -c(2)*s(1);
            s(1)*s(3)-c(1)*c(3)*s(2),  c(3)*s(1)+c(1)*s(2)*s(3),   c(1)*c(2);];
    
        
    case 213
        ang= angles([2,1,3]); % theta, phi, psi
        c= cos(ang);
        s= sin(ang);
        % rotation matrix (see wiki)
        R= [c(1)*c(3)+s(1)*s(2)*s(3), c(3)*s(1)*s(2)-c(1)*s(3) ,  c(2)*s(1) ;
            c(2)*s(3)               , c(2)*c(3)                , -s(2)      ;
            c(1)*s(2)*s(3)-c(3)*s(1), c(1)*c(3)*s(2)+s(1)*s(3) ,  c(1)*c(2) ];
        
    case 312
        ang= angles([3,1,2]); % psi, phi, theta
        c= cos(ang);
        s= sin(ang);
        % rotation matrix (see wiki)
        R= [c(1)*c(3)-s(1)*s(2)*s(3), -c(2)*s(1) , c(1)*s(3)+c(3)*s(1)*s(2);
            c(3)*s(1)+c(1)*s(2)*s(3),  c(1)*c(2) , s(1)*s(3)-c(1)*c(3)*s(2);
             -c(2)*s(3)             ,  s(2)      , c(2)*c(3)               ];

end
