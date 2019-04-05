%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Node: virtual_transmitter
%
% Purpose:
% The purpose of the virtual transmitter node is to interface with the
% quadcopter -- both to send commands and receive telemetry.
%
% Commands are sent using the standard four channels of a radio-controlled
% transmitter. Those four channels are [yaw, pitch, roll, thrust].
% On a hand-held transmitter, these correspond to the four degrees of
% freedom of the two control sticks that a pilot controls.
%
% Telemetry (sensor data) is received over the WiFi network from a number
% of different rostopics.
%
% The virtual transmitter can operate in one of two modes:
%
% 1) Flight Mode: This mode is used during actual flight tests. Stick
% commands are sent as serial data to an Arduino Nano that converts them to
% appropriate PWM signals that are passed, via a trainer cable, to
% hand-held transmitter that is connected to the quad.
%
% 2) Simulation Mode: This mode is used to simualte the dynamics of the
% quadcopter and the command/communication interface for use during
% testing.
%
% Input:
%   - ROS topic: /stickCmds (generated by the control node)
%
% Output:
%   - Serial commands: to Arduino Nano (Flight Mode)
%   - ROS topic: /sensorData (used by the estimation node)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% prepare workspace
clear; close all; clc; format compact;

% intialize ros node
if(~robotics.ros.internal.Global.isNodeActive)
    rosinit;
end

% Clear COM ports -----------------------
if ~isempty(instrfind())
fclose(instrfind());
delete(instrfind);
end
%----------------------------------------

addpath('../')
params = loadParams();
fprintf('Virtual Transmitter Node Launching...\n');

first_run = 1;


% initialize first input msg
stickCmdMsg = rosmessage('terpcopter_msgs/stickCmd');
stickCmdMsg.Thrust = -1;
stickCmdMsg.Yaw = 0;
stickCmdMsg.Pitch = 0;
stickCmdMsg.Roll = 0;

u_stick_cmd = [0 0 0 0];

global lastStickCmd_time
lastStickCmd_time = rostime('now');
idleDuration = rosduration(1,0);


% if we are running in flight mode the connection to the transmitter
% through the trainer cable is initialized as follows:
foundComPort = false;
if ( strcmp(params.vtx.mode,'flight') )
    % avialable serial ports
    comlist = seriallist();
    for i = 1:size(comlist,2)
        if contains(comlist(i),'USB0')
            params.env.com_port = comlist(i);
            foundComPort = true;
            disp('Found USB COM port')
            break;
        end
    end
    if foundComPort == false
        disp('No USB COM Port found')
    elseif foundComPort == true
        trainerBox = serial(params.env.com_port); 
        trainerBox.BaudRate = params.env.baud_rate;
        trainerBox.terminator = '';
        fopen(trainerBox);
        disp('com port initialised');  
        disp(params.env.com_port)
    end
end

% simulatorNode = robotics.ros.Node('/simulator1');
% stateEstimatePublisher = robotics.ros.Publisher(simulatorNode,'stateEstimate','terpcopter_msgs/stateEstimate');
% stickCmdSubscriber = robotics.ros.Subscriber(simulatorNode,'stickCmd','terpcopter_msgs/stickCmd',@receiveStickCmd);
% vtxStatusPublisher = robotics.ros.Publisher(simulatorNode,'vtxStatus','std_msgs/Bool');
stateEstimatePublisher = rospublisher('stateEstimate','terpcopter_msgs/stateEstimate');
vtxStatusPublisher = rospublisher('vtxStatus','std_msgs/Bool');

stickCmdSubscriber = rossubscriber('stickCmd','terpcopter_msgs/stickCmd');

if ( strcmp(params.vtx.mode,'flight') )
    r = robotics.Rate(100);
    reset(r);
    
    while(1)
        stickCmdMsg = stickCmdSubscriber.LatestMessage;
        %fprintf(stickCmdMsg);
        %waitfor(r);
        % extract u_stick_cmd from the latest stickCmd ROS message
        if ~isempty(stickCmdMsg)
            u_stick_cmd(1) = stickCmdMsg.Thrust;
            u_stick_cmd(2) = stickCmdMsg.Roll;
            u_stick_cmd(3) = stickCmdMsg.Pitch;
            u_stick_cmd(4) = stickCmdMsg.Yaw;
            disp("transmitting")
        else
            disp('Empty AHSCmd!')
            end
        % if the controller is off for more than 1 second enter emergency
        % decent mode
%         if (rostime('now') > lastStickCmd_time + idleDuration)
%             u_stick_cmd(1) = -0.6;
%             u_stick_cmd(2) = 0;
%             u_stick_cmd(3) = 0;
%             u_stick_cmd(4) = 0;
%             disp('Emergency Decent!')
%         end

        % transmit to quad
        
        transmitCmd( trainerBox, u_stick_cmd, params.vtx.trim_val, params.vtx.stick_lim, params.vtx.trim_lim );
        %if (first_run), send(vtxStatusPublisher,rosmessage(vtxStatusPublisher)), first_run=0; end
        send(vtxStatusPublisher,rosmessage(vtxStatusPublisher))
        waitfor(r);
    end
    
elseif ( strcmp(params.vtx.mode,'sim') )
    
    % unpack params
    T = params.vtx.T; % simulation time
    
    % simulator - disturbance: standard deviations / sec. (zero-mean)
    xi_dist_stdev = params.vtx.xi_dist_stdev; % xi = [x y z], m, inertial position in NED frame
    vb_dist_stdev = params.vtx.vb_dist_stdev; % vb = [u v w], m/s, body velocities in IMU frame
    eta_dist_stdev = params.vtx.eta_dist_stdev; % eta = [phi theta psi] = [roll pitch yaw], rad, orientation relative to NED
    nu_dist_stdev = params.vtx.nu_dist_stdev; % nu = [p q r], rad/s, body angular rates in IMU frame
    
    % simulator - initial conditions
    xi(1,:) = params.vtx.xi0; % xi = [x y z], m, inertial position in NED frame
    vb(1,:) = params.vtx.vb0; % vb = [u v w], m/s, body velocities in IMU frame
    eta(1,:) = params.vtx.eta0; % eta = [phi theta psi] = [roll pitch yaw], rad, orientation relative to NED
    nu(1,:) = params.vtx.nu0; % nu = [p q r], rad/s, body angular rates in IMU frame

    % simulator - arena
    maxX = params.vtx.maxX; % m,  boundary
    minX = params.vtx.minX;
    maxY = params.vtx.maxY;
    minY = params.vtx.minY;
    maxZ = params.vtx.maxZ;
    minZ = params.vtx.minZ;
    
    % simulator - quadcopter dynamic model
    Ixx = params.vtx.Ixx; % kg-m^2, inertia
    Iyy = params.vtx.Iyy; % kg-m^2
    Izz = params.vtx.Izz; % kg-m^2
    g = params.vtx.g; % m/s^2, gravity
    m = params.vtx.m; % kg, mass
    l = params.vtx.l; % m, length
    kf = params.vtx.kf; %nondim
    Im = params.vtx.Im; % kg-m^2;
    Ax = params.vtx.Ax; %kg/s % drag coefficients
    Ay = params.vtx.Ay; %kg/s
    Az = params.vtx.Az; %kg/s
    b = params.vtx.b;
    
    % simulator - inner loop control  gains
    kp_phi = params.vtx.kp_phi; % roll
    kp_psi = params.vtx.kp_psi; % yaw
    kp_theta = params.vtx.kp_theta; % pitch
   
    % derived values
    G = -[0 0 1]'*g;
    D = diag([Ax Ay Az]);
    I = diag([Ixx Iyy Izz]);
    invI = inv(I); %
    
    % initialize simulation
    t(1) = 0;
    elapsedTime = 0;
    startTime = tic;
    k = 2;
    
    % send first simulator output
    msg = rosmessage('terpcopter_msgs/stateEstimate');
    msg.Up = -xi(1,3);
    msg.East = xi(1,2);
    msg.North = xi(1,1);
    send(stateEstimatePublisher, msg);
    fprintf('Published Message at Time %3.3f \n', 0);
    
    while ( elapsedTime <= T )
        % xi = [x y z], inertial position in NED frame
        % vb = [u v w], body velocities in IMU frame
        % eta = [phi theta psi] = [roll pitch yaw] orientation relative to NED
        % nu = [p q r], body angular rates in IMU frame
        
        % unpack variables for convenience
        u = vb(k-1,1);
        v = vb(k-1,2);
        w = vb(k-1,3);
        
        p = nu(k-1,1);
        q = nu(k-1,2);
        r = nu(k-1,3);
        
        phi = eta(k-1,1);
        theta = eta(k-1,2);
        psi = eta(k-1,3);
        
        % rotation matrices
        R = rotationMatrixYPR( psi, theta, phi );
        W = [1  sin(phi)*tan(theta)  cos(phi)*tan(theta);    ...
            0  cos(phi)             -sin(phi);              ...
            0  sin(phi)/cos(theta)  cos(phi)/cos(theta)];
        
        % convert stick command to desired yaw, pitch, roll, and thrust
        psi_d = 0; %stickCmdMsg.Yaw;
        theta_d = 0; %stickCmdMsg.Pitch;
        phi_d = 0; %stickCmdMsg.Roll;
        T_d = stickCmdMsg.Thrust;
        
        % errors
        e_phi = phi - phi_d;
        e_psi = psi - psi_d;
        e_theta = theta - theta_d;
        
        % proportional controllers
        tau_phi_d = kp_phi*e_phi;
        tau_psi_d = kp_psi*e_psi;
        tau_theta_d = kp_theta*e_theta;
        
        % mixer
        w_l = T_d/(4*kf) - tau_theta_d   / (2*kf*l)	- tau_psi_d / (4*b);
        w_r = T_d/(4*kf) - tau_phi_d     / (2*kf*l)	+ tau_psi_d / (4*b);
        w_f = T_d/(4*kf) + tau_theta_d   / (2*kf*l)	- tau_psi_d / (4*b);
        w_b = T_d/(4*kf) + tau_phi_d     / (2*kf*l)	+ tau_psi_d / (4*b);
        
        % forces and moments, assume each motor produces a force and a torque
        tau_r = b * w_l^2;
        tau_l = b * w_r^2;
        tau_f = b * w_f^2;
        tau_b = b * w_b^2;
        
        F_l = kf * w_l^2;
        F_r = kf * w_r^2;
        F_f = kf * w_f^2;
        F_b = kf * w_b^2;
        
        F = T_d; %F_l + F_r + F_f + F_b
        tau_phi = l * (F_l - F_r);
        tau_theta = l * (F_f - F_b);
        tau_psi = tau_r + tau_l - tau_f - tau_b;
        
        % kinematics and dynamics
        % p. 15, Randal Beard, BYU
        % https://scholarsarchive.byu.edu/cgi/viewcontent.cgi?article=2324&context=facpub
        xidot = R*[u v w]';
        vbdot = [r*v - q*w; p*w - r*u; q*u - p*v] + g*[-sin(theta); cos(theta)*sin(phi); cos(theta)*cos(phi)] + 1/m * [0 0 -F]';
        etadot = W*[p q r]';
        nudot = [(Iyy-Izz)/Ixx*q*r; (Izz-Ixx)/Iyy*p*r; (Ixx-Iyy)/Izz*p*q] + ...
            [(1/Ixx)*tau_phi; (1/Iyy)*tau_theta; (1/Izz)*tau_psi];
        
        % time update
        t(k) = toc(startTime);
        dt = t(k) - t(k-1);
        
        % euler update
        xi(k,:) = xi(k-1,:) + xidot'*dt + randn(1,3).*xi_dist_stdev*dt;
        vb(k,:) = vb(k-1,:) + vbdot'*dt + randn(1,3).*vb_dist_stdev*dt;
        eta(k,:) = eta(k-1,:) + etadot'*dt + randn(1,3).*eta_dist_stdev*dt;
        nu(k,:) = nu(k-1,:) + nudot'*dt + randn(1,3).*nu_dist_stdev*dt;
        
        % publish message
        msg = rosmessage('terpcopter_msgs/stateEstimate');
        msg.Time = t(k);
        msg.Up = -xi(k,3) + randn()*xi_dist_stdev(3)*dt;
        msg.East = xi(k,2);
        msg.North = xi(k,1);
        send(stateEstimatePublisher, msg);
        fprintf('Published Message at Time %3.3f \n', t);
        
        % plot
        figure(1)
        plotRefFrame(xi(k,1),xi(k,2),-xi(k,3),eta(k,3),eta(k,2),eta(k,1))
        view(3);
        grid on;
        axis equal;
        xlim([minX maxX])
        ylim([minY maxY])
        zlim([minZ maxZ])
        set(gca,'FontSize',16)
        xlabel('North (m)')
        ylabel('East (m)')
        zlabel('Up(m)')
        plotQuad(xi(k,1),xi(k,2),-xi(k,3),eta(k,3),eta(k,2),eta(k,1))
        patch([minX minX maxX maxX],[minY maxY maxY minY],[0 0 0 0],'FaceColor',[1 1 1]*0.9);
        plot3(xi(:,1),xi(:,2),-xi(:,3),'k--');
        drawnow;
        hold off;
        
        % increment index and elapsedTime
        k = k + 1;
        elapsedTime = toc(startTime);
    end
    fprintf('Simulation Complete.\n');
    
end
