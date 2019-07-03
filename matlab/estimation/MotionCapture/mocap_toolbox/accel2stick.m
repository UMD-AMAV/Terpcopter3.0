function  [u_stick,psi_int,angdes,thrust_c] = accel2stick(udes,zhat,psi_int,dt,params)

% params = v2struct(kpsi,stick_0,delTstar)

g = 9.8;

% yaw control is also done here
dpsihat     = zhat(6);
kpsi        = params.kpsi;
% Trim parameters
stick_0     = params.stick_0;
delTstar    = params.delTstar;
% Hardcoded because of infrequent modification
theta_max = 35/180*pi;
phi_max   = 35/180*pi;
dpsi_max  = 4*pi;

% From input
ux= udes(1);
uy= udes(2);
uz= udes(3);
% sin and cos in 3-2-1 order
euler321= zhat(1:3);
c= cos(euler321([3,2,1]));  % psi, theta, phi
s= sin(euler321([3,2,1]));  % psi, theta, phi

%% Desired attitude and thrust
theta_c    = atan( (ux*c(1)+uy*s(1)) / (uz+g));
phi_c      = asin( (ux*s(1)-uy*c(1)) / sqrt(ux^2+uy^2+(uz+g)^2));
thrust_c   =  ux*(s(2)*c(1)*c(3)+s(1)*s(3))...
             +uy*(s(2)*s(1)*c(3)-c(1)*s(3))...
             +uz*c(2)*c(3) + g*c(2)*c(3)  ;
         
%**[thrust_c == g] corresponds to [delT=delTstar]
% delT is thrust in [0 1] scale
delT = (thrust_c/g)*delTstar;


%% Desired yaw rate
psi_int   = psi_int + dt*s(1);
dpsi_c     = -kpsi(1)*s(1) - kpsi(2)*dpsihat - kpsi(3)*psi_int;
% for output
angdes = [phi_c,theta_c,dpsi_c];

%% Normalize for stick input
u_stick= zeros(4,1);
u_stick(1)  = 2*delT-1;                   % thrust
u_stick(2:4)= [phi_c/phi_max;             % roll
               theta_c/theta_max;         % pitch
               dpsi_c/dpsi_max];          % yaw

%**** Compensate for the offset ****
% (throttle is already trimmed in the main code with delTstar)
u_stick(2:4) = u_stick(2:4) + stick_0(2:4)';

% Saturate
for jj= 1:4
    u_stick(jj)= max(-1,min(1,u_stick(jj)));
end

