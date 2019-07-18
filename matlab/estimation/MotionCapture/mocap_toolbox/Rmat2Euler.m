function PhiThetaPsi= Rmat2Euler(Rmat,order)
% phi_theta_psi = Rmat2Euler(Rmat,order)
% Rmat: rotation matrix I^R^B that converts body coord. to inertail.
%       columns are Rmat= [b1,b2,b3] unit vectors that describe body frame.
% order: 321 for now.
% order: 313

    
switch order
    case 321
        r11= Rmat(1,1);
        r21= Rmat(2,1);
        r31= Rmat(3,1);
        r32= Rmat(3,2);
        r33= Rmat(3,3);
        
        theta = asin(-r31);
        Delta = sqrt(1-r31^2);
        phi   = sign(r32)*acos(r33/Delta);
        psi   = sign(r21)*acos(r11/Delta);
        
    case 313
        
        r13= Rmat(1,3);
        r23= Rmat(2,3);
        r31= Rmat(3,1);
        r32= Rmat(3,2);
        r33= Rmat(3,3);
        
        phi=atan2(r13,r23);
        theta=acos(r33);
        psi=-atan2(r31,r32);
        
end

PhiThetaPsi= [phi,theta,psi];



