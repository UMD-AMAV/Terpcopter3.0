
if numel(vIDs)<Np
    warning('vIDs not specified properly!')
    return
end

disp('Turn OFF trainer switch => press any key.')
pause    

%% Initialize (Main Plot)
fig= figure();
% set delete functions for uninitializing
set(fig,'closereq',@my_closereq)
set(fig,'deletefcn','client.Uninitialize(); clear(''client'');')
set(fig,'KeyPressFcn',@key_press_vehiclestate)
set(fig,'WindowScrollWheelFcn',@figScroll2)

%% Initialize: Motion Capture Interface
% Add NatNet library and java jar files
usr1= getenv('USERNAME');
if strcmp(usr1,'Daigo')
    Opti = NET.addAssembly('C:\Users\Daigo\Dropbox\Function_update\Quad_experiments\mocap_toolbox\NatNetSDK\lib\x64\NatNetML.dll');
elseif strcmp(usr1,'katar')
    Opti = NET.addAssembly('C:\Users\katar\Dropbox\Quad_experiments\mocap_toolbox\NatNetSDK\lib\x64\NatNetML.dll');
end
% Create client and connect to tracking stream
client = NatNetML.NatNetClientML();
% client.Initialize('192.168.1.145','192.168.1.145');
client.Initialize('192.168.1.131','192.168.1.131');


%% Parameters (Trim)
% Assumed inner-loop performance. (Larger values will lead to attenuated
% control input)
theta_max= 35/180*pi;
phi_max  = 35/180*pi;
dpsi_max = 4*pi;
ang_offset= zeros(3*Np,1);
for ind= inds
    % vehicle ID
    ID= vIDs(ind);
    % load from trim_data.mat (contains phi_0,theta_0, and stick_0)
    load(sprintf('..\\data\\trimData\\trim_data%.0f',ID))
    % Offset (angle from MoCap at hover)
    % only for phi and theta
    ang_offset([1,2]+3*(ind-1)) = ang_0(1:2);
    % Stick at trim
    stick_trim{ind}= stick_0;
    % Throttle at hover in [0 1] scale.(Accuracy of this parameter may be
    % very important for tracking performance. Maybe include adaptive control
    % technique in future version.  Trim data can also be used.)
    delT_trim{ind}= (stick_0(1)+1)/2;
end
% indeces corresponding to coordinates (not rates)
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
D= eye(3);                   % intensity of process noise (disturbance)
N1 = diag([1 1 1]*1e-5);     % intensity of measurement noise (position)
N2 = diag([1 1 1]*1e-5);     % intensity of measurement noise (angle)
[L_observer,~,~]= lqe(A,B,C,D,N1);
[L_obsAngle,~,~]= lqe(A,B,C,D,N2);

paramObsT= v2struct(A,B,C,L_observer,L_obsAngle);
paramObs= v2struct(A,B,C,L_observer,L_obsAngle);


%% Gain (Controller)
Q= diag([10 10 10 .001 .001 .001]);
R= diag([1 1 1]*1.2);
[K_lqr,~,~]= lqr(A,B,Q,R);
% integral term
K_int= diag([1.5, 1.5, 1]*0.8);
kpsi = [1, 0.1, 0.01];
% initial stick
u_des  = [0;0;0];
u_stick{1}=[-0.8;0;0;0]; % T,R,P,Y
u_stick{2}=[-0.8;0;0;0]; % T,R,P,Y

%% Disturbance observer
k_dist = 0.5;

%% Blockdiag for Multiple vehicles
Atmp= [];Btmp= [];Ctmp= [];
Ltmp1= [];Ltmp2= [];
Klqrtmp = [];  Kinttmp=[];
for ii= 1:Np
    Atmp= blkdiag(Atmp,A);
    Btmp= blkdiag(Btmp,B);
    Ctmp= blkdiag(Ctmp,C);
    %Ltmp1= blkdiag(Ltmp1,L_observer);
    %Ltmp2= blkdiag(Ltmp2,L_obsAngle);
    Klqrtmp= blkdiag(Klqrtmp,K_lqr);
    Kinttmp= blkdiag(Kinttmp,K_int);
end
A= Atmp;
B= Btmp;
C= Ctmp;
%L_observer= Ltmp1;
%L_obsAngle= Ltmp2;
K_lqr= Klqrtmp;
K_int= Kinttmp;

paramTracking = v2struct(K_lqr,K_int,ind_var);


%% Target intruder motion

load limits
XL = limits.xl;
YL = limits.yl;

% ONLY FOR NT=1
%vt0 = 2;
ang0 = 110/180*pi;

% Velocity
DXt0= vt0*cos(ang0);
DYt0= vt0*sin(ang0);
DZt0= 0;
% Position
Xt0= rref(1) - cos(ang0)*2;
Yt0= rref(2) - sin(ang0)*2;
Zt0= 0.5;

xhatT = [Xt0';Yt0';Zt0';DXt0';DYt0';DZt0'];
xhatT = xhatT(:);
dxhatT= [zeros(3,3),eye(3,3); zeros(3,6)]*xhatT;
posT  = xhatT(1:3);

target_reached = 0;
target_state = 0; % 0: waiting, 1: released, 2: reached

tswarm = 0;
twait  = 3;

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
strcom= {'COM21','COM22','COM23','COM24','COM25','COM26','COM27','COM28'};
for ind= inds
    sTrainerBox{ind} = serial(strcom{vIDs(ind)});
    sTrainerBox{ind}.BaudRate = 57600;
    sTrainerBox{ind}.terminator = '';
    fopen(sTrainerBox{ind});
end
