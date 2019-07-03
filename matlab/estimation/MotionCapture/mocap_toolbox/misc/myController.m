function  [u_stick,data]= myController(xhat,xref,euler321,dpsihat,tnow,dt,paramC)

persistent err_int epsi_int

g= 9.81;
% control gains
K_lqr     =   paramC.K_lqr;
K_int     =   paramC.K_int;
kpsi      =   paramC.kpsi;
% for normalization
delTstar  =   paramC.delTstar;
theta_max =   paramC.theta_max;
phi_max   =   paramC.phi_max;
dpsi_max  =   paramC.dpsi_max;
% bias terms (trim)
stick_0   =   paramC.stick_0;

bT = g/delTstar;

if isempty(err_int)
    err_int= [0;0;0]; %only for position
    epsi_int= 0;
end

% sin and cos in 3-2-1 order
c= cos(euler321([3,2,1]));  % psi, theta, phi
s= sin(euler321([3,2,1]));  % psi, theta, phi

% Desired translational acceleration
err_xdx= xhat-xref;
if tnow > 4
    err_int= err_int + dt*err_xdx(1:3);
end

% LQR + Integral
u_des= -K_lqr*err_xdx -K_int*err_int;
ux= u_des(1);
uy= u_des(2);
uz= u_des(3);

% % Just take off
% if tnow < 4
%     ux= 0;
%     uy= 0;
% end

% Desired attitude and thrust
theta_c    = atan( (ux*c(1)+uy*s(1)) / (uz+g));
phi_c      = asin( (ux*s(1)-uy*c(1)) / sqrt(ux^2+uy^2+(uz+g)^2));
thrust_c   =  ux*(s(2)*c(1)*c(3)+s(1)*s(3))...
             +uy*(s(2)*s(1)*c(3)-c(1)*s(3))...
             +uz*c(2)*c(3) + g*c(2)*c(3)  ;

% Desired yaw rate
epsi_int   = epsi_int + dt*s(3);
dpsi_c     = -kpsi(1)*s(3) - kpsi(2)*dpsihat - kpsi(3)*epsi_int;
% for output
Angd = [phi_c,theta_c,dpsi_c];

%----- sliding mode for height ----%
% parameters
w_s= 0.2;     % max. disturbance in [0,1]
eta_s= 0.2;   % max. allowable rate (m/s)
eps_e= 0.1;   % relaxed surface (m)
eps_de= 3;    % relaxed surface (m/s)
% controller
Nz= eta_s/eps_e;
e= xhat(3)-xref(3);
dz= xhat(6);
if abs(e) > eps_e
    eta2= dz + sign(e)*eta_s;
    sat_de= max(-1,min(1,eta2/eps_de));
    DdelT2= -sat_de*w_s;
else
    eta1= dz+Nz*e;
    sat_de= max(-1,min(1,eta1/eps_de));
    DdelT2= -sat_de*w_s ;%- (Nz/bT)*de;  
end
%----------------------------------%
DdelT1= thrust_c/bT;
DdelTint= -K_int(3,3)*err_int(3)/bT;

%**** Combine thrust controls ****
% delT = delTstar + DdelT1 + DdelT2; % ref + pid + slide
% delT = delTstar + DdelT2 + DdelTint; % ref + slide + integral
delT = DdelT1; % pid

% for saving
Td= [delTstar,DdelT1,DdelT2,DdelTint];

% Normalize for stick input
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

data= {u_des,Angd,Td,err_int,[w_s;eta_s;eps_e;eps_de]};
