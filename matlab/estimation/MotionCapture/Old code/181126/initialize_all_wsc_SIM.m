
% disp('Turn OFF trainer switch => press any key.')
% pause    

%% Initialize (Main Plot)
fig= figure(1);
% set delete functions for uninitializing
set(fig,'closereq',@my_closereq)
set(fig,'deletefcn','client.Uninitialize(); clear(''client'');')
set(fig,'KeyPressFcn',@key_press_vehiclestate)
set(fig,'WindowScrollWheelFcn',@figScroll2)

%% Initialize: Motion Capture Interface
% % Add NatNet library and java jar files
% usr1= getenv('USERNAME');
% if strcmp(usr1,'Daigo')
%     Opti = NET.addAssembly('C:\Users\Daigo\Dropbox\Function_update\Quad_experiments\mocap_toolbox\NatNetSDK\lib\x64\NatNetML.dll');
% elseif strcmp(usr1,'katar')
%     Opti = NET.addAssembly('C:\Users\katar\Dropbox\Quad_experiments\mocap_toolbox\NatNetSDK\lib\x64\NatNetML.dll');
% end
% % Create client and connect to tracking stream
% client = NatNetML.NatNetClientML();
% % client.Initialize('192.168.1.145','192.168.1.145');
% client.Initialize('192.168.1.131','192.168.1.131');

%% Quadrotor Parameters
%     Vehicle Parameters
% % % Larger 250 size vehicle
Cd_frame = 0.8; %(from wikipedia drag coefficient table)
D = (5*2.54)*1/100;% rotor diameter [m] 
R = D/2; % [m], main rotor radius
c = 1.5/100; % Main blade chord [m]D/10; % Main blade chord [m]
m_r = 0.0027; %0.0016; % [kg], measured
m_b = m_r/2; % [kg], mass of one blade
m_m = 0.03;%0.016; % [kg], mass of motor: measured
ell = 0.21;
d = 0.02;
cm = 0.0085;% tz(1,:)./(9.81*fz(1,:)) Relation of thrust produced to torque
m_l = 0.03;% 1.75*0.136*ell; % [kg], mass of rod, maker beam has mass 0.136g/mm
%    Adjusted for QAV210 mass calculation
I1 = m_l*ell^2/12 + 2*m_m*ell^2;
I2 = m_l*ell^2/12 + 2*m_m*ell^2;
I3 = m_l*ell^2/6 + 4*m_m*ell^2;
I = diag([I1;I2;I3]);
mass = 0.510; %[kg], mass with battery and motion capture markers

Nb = 2; % [] Number of blades per rotor
e = 0.1; % [] hinge offset (percent of R; e' from derivation pages) From Hoffmann
k_beta = 3; %.23% [N*m/rad] blade spring constant % 113330 for BO-105
Ib = (m_b)*(R^3-(e*R)^3)/(3*R); % [kg*m^2] Blade moment of inertia Integrate from e to R
Cla = 2*pi; % lift curve slope
rho = 1.225; %[kg/m^3]
Lock = rho*Cla*c*R^4/Ib;

th0 = 0.28;%0.14;%0.1575;%0.24;%0.24; % Root angle of attack
th_tw = 0.165-th0;%0.10-th0;%(0.19-th0); % Blade linear twist

% To find nu_beta
rpm =  12000;
Omega   = rpm*2*pi/60; % [rad/s] % For gemfan
% h = m_r*D^2/12*Omega; % angular momentum of blades (I guess we ignore h of motor)
w_B     = sqrt(k_beta/Ib); % Blade natural frequency (omega_beta_0 in HeliAero notes)
nu_beta = sqrt(1 + (3/2)*(e/(1-e)) + w_B^2/Omega^2); % Formula from HeliAero, 
    % with further accuracy from derivation pages
    
% zeta = (gamma/(16*nu_beta))*(1-(8*e/3)+2*e^2-e^4/3);
% w_n  = Omega*nu_beta; % natural frequency of blade flapping (from eqns)

lam  = 0.075;%0.11; % Inflow ratio %0.08 is max, gets down to 0.05 or 0.03 at high gust
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Max thrust sum
u_max = 12;
    
% Earth parameters
g = 9.81; %[m/s] gravity

paramQuad = v2struct(mass,m_b,R,c,Nb,e,k_beta,nu_beta,Cla,Lock,th0,...
    th_tw,Omega,lam,ell,d,cm,I1,I2,I3,I,Cd_frame,rho,g,u_max);

%% Parameters (Trim)
% Assumed inner-loop performance. (Larger values will lead to attenuated
% control input)
theta_max= 35/180*pi;
phi_max  = 35/180*pi;
dpsi_max = 4*pi;
ang_offset= zeros(3*Np,1);

for ind= inds
%     % vehicle ID
%     ID= vIDs(ind);
%     % load from trim_data.mat (contains phi_0,theta_0, and stick_0)
    load('trim_data0.mat') % data0 is zeros for each trim value
    % Offset (angle from MoCap at hover)
    % only for phi and theta    
    ang_offset([1,2]+3*(ind-1)) = ang_0(1:2);
    % Stick at trim
    stick_trim{ind}= stick_0;
    % Throttle at hover in [0 1] scale.(Accuracy of this parameter may be
    % very important for tracking performance. Maybe include adaptive control
    % technique in future version.  Trim data can also be used.)
    delT_trim{ind}= (stick_0(1)+1)/2;%(stick_0(1)+1)/2;
        % Divide by 8 just to keep things a little low at first
        % Nominal tx output should be about 1407
end

% indices corresponding to coordinates (not rates)
% i.e., [1 2 3 7 8 9 13 14 15...]
ind_var = repmat(6*[0:Np-1],3,1)+repmat([1;2;3],1,Np);
ind_var = ind_var(:);

% Desired yaw angle
psi_star = zeros(Np,1);


%% reference position
rref       = [.6;.9;.5];


%% Gain (Observer)
A= [zeros(3), eye(3);
    zeros(3), zeros(3)];
C= [eye(3), zeros(3)];
B= [zeros(3); eye(3)];
D= 1e0*eye(3);                   % intensity of process noise (disturbance)
N1 = diag([1 1 1]*1e-5);     % intensity of measurement noise (position)
N2 = diag([1 1 1]*1e-5);     % intensity of measurement noise (angle)
[L_observer,~,~]= lqe(A,B,C,D,N1);
[L_obsAngle,~,~]= lqe(A,B,C,D,N2);

% paramObsT= v2struct(A,B,C,L_observer,L_obsAngle);
paramObs= v2struct(A,B,C,L_observer,L_obsAngle);


%% Gain (Controller)
% Q= diag([10 10 10 .001 .001 .001]);
% R= diag([1 1 1]*1.2);
% [K_lqr,~,~]= lqr(A,B,Q,R);
% % integral term
% K_int= diag([1.5, 1.5, 1]*0.8);
kpsi = [1, 0.1, 0.01];

Kx = K_in(1);%5;
Kv = K_in(2);%Kx/2;

Eb1d = [1;0;0];%[cos(pi*t); sin(pi*t); 0];%


% initial stick
u_des  = [0;0;0];
u_stick{1}=[-0.8;0;0;0]; % T,R,P,Y
u_stick{2}=[-0.8;0;0;0]; % T,R,P,Y

%% Disturbance observer
k_dist = 0.5;

%% Blockdiag for Multiple vehicles
% Atmp= [];Btmp= [];Ctmp= [];
% Ltmp1= [];Ltmp2= [];
% Klqrtmp = [];  Kinttmp=[];
% for ii= 1:Np
%     Atmp= blkdiag(Atmp,A);
%     Btmp= blkdiag(Btmp,B);
%     Ctmp= blkdiag(Ctmp,C);
%     %Ltmp1= blkdiag(Ltmp1,L_observer);
%     %Ltmp2= blkdiag(Ltmp2,L_obsAngle);
%     Klqrtmp= blkdiag(Klqrtmp,K_lqr);
%     Kinttmp= blkdiag(Kinttmp,K_int);
% end
% A= Atmp;
% B= Btmp;
% C= Ctmp;
% %L_observer= Ltmp1;
% %L_obsAngle= Ltmp2;
% K_lqr= Klqrtmp;
% K_int= Kinttmp;

paramControl = v2struct(Kx,Kv,ind_var);


%% Target intruder motion

% load limits
% XL = limits.xl;
% YL = limits.yl;
% 
% % ONLY FOR NT=1
% %vt0 = 2;
% ang0 = 110/180*pi;
% 
% % Velocity
% DXt0= vt0*cos(ang0);
% DYt0= vt0*sin(ang0);
% DZt0= 0;
% % Position
% Xt0= rref(1) - cos(ang0)*2;
% Yt0= rref(2) - sin(ang0)*2;
% Zt0= 0.5;
% 
% xhatT = [Xt0';Yt0';Zt0';DXt0';DYt0';DZt0'];
% xhatT = xhatT(:);
% dxhatT= [zeros(3,3),eye(3,3); zeros(3,6)]*xhatT;
% posT  = xhatT(1:3);
% 
% target_reached = 0;
% target_state = 0; % 0: waiting, 1: released, 2: reached
% 
% tswarm = 0;
% twait  = 3;

%% Initialize (Variables)
paramStick= cell(Np,1);
psi_int= cell(Np,1);
for vID= 1:Np
    delTstar= delT_trim{vID};
    stick_0= stick_trim{vID};
    psi_des= psi_star(vID);
    paramStick{vID}= v2struct(delTstar,stick_0,kpsi,psi_des);
    psi_int{vID,1} = 0;
end

tmax= 200;
freqM= 100;
time              = zeros(tmax*freqM,1);
run_time          = zeros(tmax*freqM,2);
x_observer        = zeros(tmax*freqM,6*Np);
x_mocap           = zeros(tmax*freqM,3*Np);
x_mocap_raw       = zeros(tmax*freqM,3*Np);
attitude_mocap    = zeros(tmax*freqM,3*Np);
attitude_mocap_raw= zeros(tmax*freqM,3*Np);
attitude_filter   = zeros(tmax*freqM,6*Np);
attitude_desired  = zeros(tmax*freqM,3*Np);
attitude_desired2 = zeros(tmax*freqM,3*Np);
thrust_desired    = zeros(tmax*freqM,1*Np);
stick_input       = zeros(tmax*freqM,4*Np);
accel_desired     = zeros(tmax*freqM,3*Np);
% error_int        = zeros(tmax*freqM,3*Np);
x_target          = zeros(tmax*freqM,6);
adj_all           = cell(tmax*freqM,Np);
x0_save           = zeros(tmax*freqM,1);
Dhat_save         = zeros(tmax*freqM,3*Np);
zdist_save        = zeros(tmax*freqM,3*Np);
angrand_save      = zeros(tmax*freqM,Np);
vstate_save       = zeros(tmax*freqM,Np);
captured_save     = zeros(tmax*freqM,Np+1);


udes= zeros(3*Np,1);
xref= zeros(6*Np,1);
xhat= zeros(6*Np,1);
zhat= zeros(6*Np,1);
err_int = zeros(3*Np,1);
angdes = cell(4,1);
thrustdes = zeros(Np,1);
zhatT = zeros(6,1);
pursuit_phase = zeros(Np,1);
vehicle_state = zeros(Np,1); % 0: landed, 1: launch/idle, 2: swarming
duration_lost = zeros(Np,1); % duration of time that mocap has lost track of vID
% disturbance observer
% Dhat   = zeros(Np*3,1); % estimated disturbance
z_dist = zeros(Np*3,1); % observer state
captured = zeros(Np+1,1);  % target state captured or not

%% Initialize: Serial communication
disp('Initializing...')
% strcom= {'COM21','COM22','COM23','COM24','COM25','COM26','COM27','COM28'};
strcom= {'COM6'};
for ind= inds
    sTrainerBox{ind} = serial(strcom{vIDs(ind)});
    sTrainerBox{ind}.BaudRate = 57600;
    sTrainerBox{ind}.terminator = '';
    fopen(sTrainerBox{ind});
end
