function params = loadParams()

% Environment (env) parameters
%------------------------------------------------
params.env.com_port = '/dev/ttyUSB0';
params.env.baud_rate = 57600;
params.env.ros_master_ip = '192.168.1.81'; %change master to Laptop 
params.env.catkinSrcDir = '/home/amav/catkin_ws/src';
%params.env.catkinSrcDir = '/home/wolek/catkin_ws/src';
%params.env.catkinSrcDir = '/home/zlacey/catkin_ws/src';
params.env.terpcopterMatlabMsgs = [params.env.catkinSrcDir '/matlab_gen/msggen'];
%params.env.matlabRoot = '/home/wolek/Desktop/Research/Projects/UMD/AMAV/Terpcopter3.0/matlab';
params.env.matlabRoot = '/home/amav/amav/Terpcopter3.0/matlab';

% Virtual transmitter (vtx) 
%------------------------------------------------
% mode of operation 
params.vtx.mode = 'flight'; % 'sim' or 'flight' 

% transmitter           throttle roll pitch yaw Aux
params.vtx.stick_lim = [100; 100; 100; 100; 100];
params.vtx.trim_lim = [29; 29; 29; 29; 29];
offset = [-5 -6 -5 -6 0]/29;% DO NOT CHANGE , AW
params.vtx.trim_val = offset; %25 30
%params.vtx.trim_val = [0 0 0 0 0];
%params.vtx.trim_val = offset;

% simulator
params.vtx.T = 30; % simulation time

% simulator - disturbance: standard deviations / sec. (zero-mean)
params.vtx.xi_dist_stdev = [0 0 0.2]; % xi = [x y z], m, inertial position in NED frame
params.vtx.vb_dist_stdev = [1 1 0]*0.25; % vb = [u v w], m/s, body velocities in IMU frame
params.vtx.eta_dist_stdev = [0 0 0]; % eta = [phi theta psi] = [roll pitch yaw], rad, orientation relative to NED
params.vtx.nu_dist_stdev = [0 0 0]; % nu = [p q r], rad/s, body angular rates in IMU frame

% simulator - initial conditions 
params.vtx.xi0 = [0 0 0]; % xi = [x y z], m, inertial position in NED frame
params.vtx.vb0 = [0 0 0]; % vb = [u v w], m/s, body velocities in IMU frame
params.vtx.eta0 = [0 0 0]; % eta = [phi theta psi] = [roll pitch yaw], rad, orientation relative to NED
params.vtx.nu0 = [0 0 0]; % nu = [p q r], rad/s, body angular rates in IMU frame

% simulator - arena
params.vtx.maxX = 10; % m,  boundary 
params.vtx.minX = -10;
params.vtx.maxY = 10;
params.vtx.minY = -10;
params.vtx.maxZ = 15;
params.vtx.minZ = -0.1;

% simulator - quadcopter dynamic model
params.vtx.Ixx = 4.856E-3; % kg-m^2, inertia
params.vtx.Iyy = 4.856E-3; % kg-m^2
params.vtx.Izz = 8.801E-3; % kg-m^2
params.vtx.g = 9.81; % m/s^2, gravity
params.vtx.m = 0.486; % kg, mass
params.vtx.l = 0.225; % m, length 
params.vtx.kf = 2.980E-6; %nondim
params.vtx.Im = 3.357; % kg-m^2;
params.vtx.Ax = 0.25; %kg/s % drag coefficients
params.vtx.Ay = 0.25; %kg/s
params.vtx.Az = 0.25; %kg/s
params.vtx.b = 1;

% simulator - inner loop control  gains
params.vtx.kp_phi = 1; % roll 
params.vtx.kp_psi = 1; % yaw
params.vtx.kp_theta = 1; % pitch 

% Control (ctrl)
%------------------------------------------------

% altitude control 
params.ctrl.altitudeGains.kp = 0.300;
params.ctrl.altitudeGains.ki = 0.1250000;
params.ctrl.altitudeGains.kd = 0.0180000;
params.ctrl.altitudeGains.ffterm = 0.4; % feed-forward term 

% yaw control 
params.ctrl.yawGains.kp = 0.200;
params.ctrl.yawGains.kd = 0.20000;
params.ctrl.yawGains.ki = 0.050000;


params.ctrl.forwardGains.kp = 0.4000;
params.ctrl.forwardGains.kd = 0.05000;
params.ctrl.forwardGains.ki = 0;%0.00500;

params.ctrl.stick_lim = [100; 100; 100; 100];
params.ctrl.trim_lim = [29; 29; 29; 29];

params.ctrl.umax_throttle = 1; %
params.ctrl.umax_rollPitch = 0.5;
params.ctrl.v_z_max = 3;
params.ctrl.m_quad = 0.359;%kg
params.ctrl.m_battery1 = 0.116;%kg
params.ctrl.m_net = params.ctrl.m_quad + params.ctrl.m_battery1;
params.ctrl.g = 9.81;%m/s^2
params.ctrl.tilt_max = deg2rad(45);%max allowed tilt angle
% tilt angle  = acos{cos(theta)*cos(phi)}
 


% Estimation (est)
%------------------------------------------------
% low-pass filters
params.est.altitudeLPFitler.timeConstant = 1.00000; % sec, 


% Vision (viz) 
%------------------------------------------------
% params.viz;

% Autonomy (auto)
%------------------------------------------------
params.auto.mode = 'auto'; % 'auto' or 'manual'



end
