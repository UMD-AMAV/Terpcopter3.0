% AMAV Motion Capture Tracking Using OptiTrack
close all
clear
clc
% clearvars -except K_in

addpath('./WillsCode');
addpath('../');

%% Initialization
Np    = 1; % number of guardians
% Nt    = 0; % number of intruders
vIDs  = 1;%[1,2,3,4,6]; % vehicle ID specified in Motive (=ID on propeller)
inds  = 1:Np;      % vehicle index in this simulation
tend= 125;%55;%480; % Time that MATLAB collects Mocap data (seconds)
SE3 = 0;
linear = 1;

ROS_Master_ip = '192.168.1.69';

% intialize ros node
if(~robotics.ros.internal.Global.isNodeActive)
    rosinit(ROS_Master_ip);            % ip of ROS Master
end

% Subscribers
VIODataSubscriber = rossubscriber('/camera/odom/sample', 'nav_msgs/Odometry');
r = robotics.Rate(100);
reset(r);

VIOMsg = VIODataSubscriber.LatestMessage;

% % VIO Time
% VIOTime = VIOMsg.Header.Stamp.Sec;
% % VIO Pose
% % Position
% VIOPositionX = VIOMsg.Pose.Pose.Position.X;
% VIOPositionY = VIOMsg.Pose.Pose.Position.Y;
% VIOPositionZ = VIOMsg.Pose.Pose.Position.Z;
% 
% % Orientation
% VIOOrientationX = VIOMsg.Pose.Pose.Orientation.X;
% VIOOrientationY = VIOMsg.Pose.Pose.Orientation.Y;
% VIOOrientationZ = VIOMsg.Pose.Pose.Orientation.Z;
% VIOOrientationW = VIOMsg.Pose.Pose.Orientation.W;
% 
% VIOeuler = quat2eul([VIOOrientationW VIOOrientationX VIOOrientationY VIOOrientationZ]);
% 
% VIOpsi = rad2deg(VIOeuler(1));
% VIOtheta = rad2deg(VIOeuler(2));
% VIOphi = rad2deg(VIOeuler(3));

logFlag = 1;
dateString = datestr(now,'mmmm_dd_yyyy_HH_MM_SS_FFF');
MoCapLog = ['C:\Users\CDCL\Documents\GitHub\Terpcopter3.0\matlab\estimation\MoCapAndVIOLogs' '\MoCap_' dateString '.log'];
VIOLog = ['C:\Users\CDCL\Documents\GitHub\Terpcopter3.0\matlab\estimation\MoCapAndVIOLogs' '/VIO_' dateString '.log'];

if linear && SE3
    disp('Can''t have linear and SE3 at the same time!')
    return
end

% desired height
z_desired = 1.5;%1.3;%[0, .2, .35 , .2, 0] + 0.8;
xy_desired = [1; -0.5];

flowplot = 20;

trimkk = 1;
trim_stick_mtx = zeros(1,4);
trim_stick = zeros(1,4);
trimmed = 0;

% Other debugging variables
if linear
    u_max = 1;
    T_max = 12;
    T_scale = T_max/u_max;
    psi_max = 12;
    psi_scale = psi_max/u_max;
else
    z_desired = 1.55;%[0, .2, .35 , .2, 0] + 0.8;
    u_max = 12;
    T_scale = 1;
    psi_scale = 1;
end
    psi_des = 0*pi/4;% asin(cross([1;0;0],Eb1d))

if SE3
    % Best gains with a fresh battery, even showing adequate disturbance
    % rejection
    K_in(1,1) = 4; %0.67;
    K_in(2,1) = 2;%K_in(1)/1.5;%0.67;
    K_in(3,1) = 1500;%150;
    K_in(4,1) = K_in(3)/5;%K_in(3)/2;%/8
    kpsi = [1, 0.1, 0.01];
    
elseif linear
    % % % flow sensing is still worse, so I'm trying to check the gains
    % again
    K_in(1,1:3) =   [12,12,6*7.2];%[6.18,6.12,6*5.94];% 0.2*[1,1,1]; %(34/24)* %Kx 
    K_in(2,1:3) =   [3.6,3.6,6*9.4];%[7.22,6.30,6*9.16];%   9*[1,1,1]; %Kv
    K_in(3,1:3) =   [500, 500, 45]; %KR %500*[1,1,1];%30*%[23.9, 24.08 197.6];
    K_in(4,1:3) =   [45, 45, 10];%KOmega % 75*[1,1,1];%10*%[9.68, 9.68, 15.56];
    kpsi        =   73*[K_in(3,3), K_in(4,3)];
    K_zi        =   0*6*25;
    k_ramp      =   [1.2; 1.2; 0.58];%[1.17; 1.20; 0.247];%[0.373; 0.333; 0.247]; 

else
    % CF Gains
    K_in(1,1) = 4; %0.67;
    K_in(2,1) = 2;%K_in(1)/3;%0.67;
    K_in(3,1) = 1.0;%150; Ki in cleanflight
    K_in(4,1) = 1.2;% Kp in cleanflight
    % Kd set to Ki/100
    kpsi = [1, 0.1, 0.01];
end


initialize_all_wsc

set(fig,'WindowScrollWheelFcn',@figScroll_hover)

Eb1d = [1;0;0];%[cos(pi*t); sin(pi*t); 0];%
% psi_des = 0*pi/6;% asin(cross([1;0;0],Eb1d))
psideslist = psi_des*ones(1,Np);%[pi/2, pi/2, pi/2, pi/2, pi/2];
for ii=1:Np
    paramStick{ii}.psi_des = psideslist(ii);
end

% indV4 = find(vIDs==4);
% paramStick{indV4}.psi_des = pi/2;
% indV3 = find(vIDs==3);
% paramStick{indV3}.psi_des = pi/2;

% This little loop helps to keep the quad from going crazy right off the
% bat
u_stick{1}(1) = -1;
u_stick{1}(2) = 0;
u_stick{1}(3) = 0;
u_stick{1}(4) = 0;
        ch1cmd = 1000;%5000+ 4000*u_stick{vID}(1);  % throttle (up)
        ch2cmd = 5000;%5000- 4000*u_stick{vID}(2);  % roll     (right)
        ch3cmd = 5000;%5000+ 4000*u_stick{vID}(3);  % pitch    (forward)
        ch4cmd = 5000;%5000+ 4000*u_stick{vID}(4);  % yaw
        ch5cmd = 2000;  % arm
        ch6cmd = 2000;  % angle mode
        
        strCmd1 = sprintf('a%.f%.f%.f%.fz',ch1cmd,ch2cmd,ch3cmd,ch4cmd);
        for nn = 1:1000
            fprintf(sTrainerBox{vID},strCmd1);
        end



%% Run Experiment
ii= 1;
tnow= 0;
% OL_dt = 0.01; % Artificially prescribed time to run the outer loop
abort= 0;

while tnow < tend+4
    tic
    pause(eps)
    
    %% - Mocap data
    [position_raw,angle_raw,t,Rmat] = get_PosAng_ID_wsc(client);

    position = position_raw(:,vIDs(inds));
    angle    = angle_raw(:,vIDs(inds));

    
    fprintf('Position is %1.4f %1.4f %1.4f; Time is %2.2f\n',...
        position(1), position(2), position(3),tnow)
%     
%     % target intruder
%     if Nt>0
%         positionT = position_raw(:,Np+1);
%         angT      = [0;0;0];
%         [posT, t_miss]   = augment_data(positionT,xhatT(1:3));
%     else
%         posT = [1;1;1]*(-10);
%     end
    
    % Augment missing position
    [pos, vid_miss1] = augment_data(position,xhat(ind_var));
    % Augment missing angles
    [ang, vid_miss2] = augment_data(angle,zhat(ind_var));
    
    % Subtract bias
    ang= ang-ang_offset;

    VIOMsg = VIODataSubscriber.LatestMessage;

    % VIO Time
    VIOTime = VIOMsg.Header.Stamp.Sec;
    % VIO Pose
    % Position
    VIOPositionX = VIOMsg.Pose.Pose.Position.X;
    VIOPositionY = VIOMsg.Pose.Pose.Position.Y;
    VIOPositionZ = VIOMsg.Pose.Pose.Position.Z;
    
    % Orientation
    VIOOrientationX = VIOMsg.Pose.Pose.Orientation.X;
    VIOOrientationY = VIOMsg.Pose.Pose.Orientation.Y;
    VIOOrientationZ = VIOMsg.Pose.Pose.Orientation.Z;
    VIOOrientationW = VIOMsg.Pose.Pose.Orientation.W;
    
    VIOeuler = quat2eul([VIOOrientationW VIOOrientationX VIOOrientationY VIOOrientationZ]);
    
    VIOpsi = rad2deg(VIOeuler(1));
    VIOtheta = rad2deg(VIOeuler(2));
    VIOphi = rad2deg(VIOeuler(3));
    
    x = pos(1);
    y = pos(2);
    z = pos(3);
    
    phi = ang(1);
    theta = ang(2);
    psi = ang(3);
    
    if( logFlag )
        
        [pFile1, msg] = fopen( MoCapLog, 'a');
        [pFile2, msg2] = fopen( VIOLog ,'a');
        if pFile1 < 0
            error('Failed to open file "%s" for writing, because "%s"', MoCapLog, msg);
        end
        if pFile2 < 0
            error('Failed to open file "%s" for writing, because "%s"', VIOLog, msg2);
        end
        
        %write csv file Motion Capture
        fprintf(pFile1, '%6.6f,', tnow);
        fprintf(pFile1, '%6.6f,', x);
        fprintf(pFile1, '%6.6f,', y);
        fprintf(pFile1, '%6.6f,', z);
        fprintf(pFile1, '%6.6f,', phi);
        fprintf(pFile1, '%6.6f,', theta);
        fprintf(pFile1, '%6.6f\n', psi);
    
        % write csv file Realsense VIO
        fprintf(pFile2,'%6.6f,',VIOTime);
        
        fprintf(pFile2,'%6.6f,',VIOPositionX);
        fprintf(pFile2,'%6.6f,',VIOPositionY);
        fprintf(pFile2,'%6.6f\n',VIOPositionZ);
        
        fclose(pFile1);
        fclose(pFile2);
    end
    
    % Initialization
    if ii==1
        tstart= t;
        tprev= 0;
        xhat(ind_var)= pos;
        zhat(ind_var)= ang;
        psi_err_old = 0;
        psi_dot_err_old = zeros(5,1);
%         xhatT(1:3) = posT;
        % Set desired position to where it begins since it's a station hold
        % mission
        for vID= 1:Np
            X0(1:2+2*(vID-1),1) = pos(1:2+(vID-1)*3);
            xref(1:6+6*(vID-1),1)= [pos(1:2+(vID-1)*3);z_desired(vID);0;0;0];
        end
        disp('Running...')
        disp('Turn ON trainer switch')
        disp('  [space] : proceed')
        disp('  [c]     : quit')
        
        % Initialize thrust input for the observer
        Thrust_in = 5;
        
        % Initialize position error
        e_x_prev  = zeros(3,1);
        e_z_int_prev = 0;
    end
    
    t_ramp = 3;
    if tnow < t_ramp
         xref(1:6+6*(vID-1),1) = [X0;(tnow/t_ramp)*z_desired(vID);0;0;0];
    else
%          xref(1:6+6*(vID-1),1) = [xy_desired;z_desired(vID);0;0;0];
        xref(1:6+6*(vID-1),1) = [X0 + min((tnow-t_ramp),1)*(xy_desired-X0);z_desired(vID);0;0;0];
%         xref(1:6+6*(vID-1),1) = [(1-min((tnow-t_ramp),1))*X0 + min((tnow-t_ramp),1)*xy_desired;z_desired(vID);0;0;0];
    end
%   
    
    % Time
    tnow= t-tstart;
    dt= tnow-tprev;
    tprev = tnow;
%     IL_tspan = [tnow, tnow + OL_dt];
%     fprintf('Time is %3.3f\n', tnow)
%     disp(tnow)
    
    %% - Safety
    % count lost time
    vid_miss = (vid_miss1 + vid_miss2) > 0;
    if nnz(vid_miss)
        disp('Nonzero vid miss')
        disp(tnow)
        ID_For_Missed = vIDs(vid_miss)
    end
    duration_lost = duration_lost + vid_miss*dt;
    % back to 0 when it's seen
    duration_lost(~vid_miss) = 0;
    if abort==0
        ind_z = 3+6*[0:Np-1];
        criteria(1) = max(duration_lost) > 0.1;
        criteria(2) = max(xhat(ind_z)) > 3;
        criteria(3) = nnz(isnan(zhat)) > 0;
        if sum(criteria)
            abort = 1;
            abort_time = tnow;
            tend = tnow; % start landing sequence
            if criteria(1) || criteria(3)
                disp('aborting! (missing mocap data)')
                disp([' vehicle:#',num2str(vIDs(duration_lost>0))])
            elseif criteria(2)
                disp('aborting! (altitude exceeded limit)')
            end
        end
    end
    %% - Sequential Launch
%     % continue the code while launching
%     if abort==0 && prod(vehicle_state)==0
%         tend = dt + tend;
%     end
    % integral term in different phase
    for vID = 1:Np
        if vehicle_state(vID) == 0
            err_int([1:3]+(vID-1)*3) = 0;
            z_dist([1:3]+(vID-1)*3) = 0; % refresh Dist. observer
        elseif vehicle_state(vID) == 1
        end
    end
    
    
    %% - Estimation
    [xhat,zhat] = myObserverAll_wsc(xhat,zhat,pos,ang,dt,paramObs,...
                    Rmat{1,1},Thrust_in,paramQuad,linear,T_scale);
    
    % Disturbance observer
    Dhat   = z_dist - k_dist*xhat(ind_var+3);
    % find index for .20 sec ago
    [~,ind_1]  = min(abs(time-(tnow-0.2)));
    % what I think my input is (with extimated delay)
    uhat   = accel_desired(ind_1,:)';
    % update
    zdot   = k_dist*(uhat-Dhat);
    z_dist = z_dist + dt*zdot; % update state
%     obs_err = xhat - [position;velocity0]
    %% - Target motion
%     if Nt>0
%         xhatTprev   = xhatT;
%         xhatT       = myObserverAll(xhatT,zhatT,posT,angT,dt,paramObsT);
%         if nnz(xhatT)~=6 || t_miss
%             xhatT(1:3)= xhatTprev(1:3);
%         end
%     else
%         xhatT = [[1;1;1]*(-10);zeros(3,1)];
%         zhatT = zeros(6,1);
%     end
    
    %% - Controller (Acceleration)
% %     xhat_target = xhatT;
% %     xhat_target(1)= min(XL(2),max(XL(1),xhat_target(1)));
% %     xhat_target(2)= min(YL(2),max(YL(1),xhat_target(2)));
% %     xhatAll = [xhat;xhat_target];
%        
% I Don't think I need this since it's prescribed initially and doesn't
% change
%     for vID= 1:Np
%         xref(3+6*(vID-1),1)= z_desired(vID);
%     end
    % Tracking reference
    if linear == 0
        [udes,err_int] = myTrackingCtrl_wsc(xhat,xref,err_int,tnow,dt,paramQuad,paramControl);
    else
        [udes,err_int,e_x_prev,e_x,e_x_std,e_z_int_prev]...
            = myTrackingCtrl_wsc_linear(xhat,xref,err_int,tnow,dt,...
            paramQuad,paramControl,paramLinear,k_ramp,e_x_prev,e_z_int_prev);
    end
    Thrust_in = T_scale*u_max*udes(1);
    
    % Augment udes with estimated disturbance
    %udes = udes + Dhat;
    
    %% - Controller (Stick Input)
    for vID = 1:Np
        % convert udes to u_stick (and obtain desired yaw rate)
        udes_i = udes([1:3]+3*(vID-1));
        zhat_i = zhat([1:6]+6*(vID-1));
        if SE3
            [u_stick{vID},psi_int{vID},angdes{vID},thrustdes(vID)] =...
                accel2stick_wsc(udes_i,zhat_i,psi_int{vID},dt,paramStick{vID});
        elseif linear
            [u_stick{vID},psi_int{vID},angdes{vID},thrustdes(vID),psi_err_old,psi_dot_err_old] =...
                accel2stick_wsc_linear(udes_i,zhat_i,psi_int{vID},dt,paramStick{vID},...
                paramQuad,paramLinear,psi_err_old(vID),dt,psi_dot_err_old);
        else
            [u_stick{vID},psi_int{vID},angdes{vID},thrustdes(vID)] =...
                accel2stick_wsc_CF(udes_i,zhat_i,psi_int{vID},dt,paramStick{vID});
        end
%         psi_des = pi/2*tnow;
%         u_stick{1}(4) = psi_des/12;

        % restrict them depending on time & state
%         if vehicle_state(vID)==0
        if tnow < 0.05
%             % Before launch
%             u_stick{vID}(1:3)= [-0.5;0;0];
%             u_stick{vID}(4)= 0;
        elseif tnow > tend && tnow < tend+2.0
            % Landing
            if abort
                if nnz(criteria)
                    u_stick{vID}(2:4)= stick_trim{vID}(2:4);
                end
            end
            u_stick{vID}(1)= (1.35*delT_trim{vID}*2 - 1);%0.95*(delT_trim{vID});%%
        elseif tnow >= tend+2.0 && tnow < tend+3.7
            % Landing
            if abort
                if nnz(criteria)
                    u_stick{vID}(2:4)= stick_trim{vID}(2:4);
                end
            end
            u_stick{vID}(1)= (1.2*delT_trim{vID}*2 - 1);%0.95*(delT_trim{vID});%%
        elseif tnow > tend+3.7
            % Put stick to zero
            u_stick{vID}(2:4)= 0;
            u_stick{vID}(1)= -1;
        end
%         % restrict them depending on time & state
%         if vehicle_state(vID)==0
%             % Before launch
%             u_stick{vID}(2:4)= 0;
%             u_stick{vID}(1)= -.6;
%         elseif tnow > tend && tnow < tend+2.7
%             % Landing
%             if abort
%                 if nnz(criteria)
%                     u_stick{vID}(2:4)= stick_trim{vID}(2:4);
%                 end
%             end
%             u_stick{vID}(1)= (delT_trim{vID}*2 - 1)*0.9;
%         elseif tnow > tend+2.7
%             % Put stick to zero
%             u_stick{vID}(2:4)= 0;
%             u_stick{vID}(1)= -1;
%         end
    end
    
    %% - Store values
%{k
    time(ii)              = tnow;
    for vID= 1:Np
        stick_input(ii,[1:4]+(vID-1)*4)     = u_stick{vID};
        attitude_desired(ii,[1:3]+(vID-1)*3)= angdes{vID};
    end
    x_observer(ii,:)          = xhat;
    x_mocap_raw(ii,:)         = position(:)';
    x_mocap(ii,:)             = pos;
    attitude_mocap(ii,:)      = ang;
    attitude_mocap_raw(ii,:)  = angle(:)';
    attitude_filter(ii,:)     = zhat;
    accel_desired(ii,:)       = udes;
    thrust_desired(ii,:)      = thrustdes';
%     x_target(ii,:)            = xhatT';
%     adj_all{ii}               = adj_tt;
%     x0_save(ii,:)             = x0;
    Dhat_save(ii,:)           = Dhat;
%     angrand_save(ii,:)        = adj_tt.ang_rand(1:Np);
    vstate_save(ii,:)         = vehicle_state;
    error_x(ii,:)             = e_x;
    error_x_std(ii,:)         = e_x_std;
    % for computation
    run_time(ii,1) = toc;
%}

% Trim x and y position by adjusting nominal input
t_trim = 8;
if tnow > t_trim-2 && tnow < t_trim
    trim_stick_mtx(trimkk,:) = stick_input(ii,:);
    trimkk = trimkk + 1;
end
if tnow >= t_trim && trimmed == 0
    trim_stick = mean(trim_stick_mtx,1);
    trimmed = 1;
end
if tnow > t_trim && tnow < t_trim+1
    u_stick{1}(2) = u_stick{1}(2) + (tnow-t_trim)*trim_stick(2);
    u_stick{1}(3) = u_stick{1}(3) + (tnow-t_trim)*trim_stick(3);
elseif tnow >= 8
    u_stick{1}(2) = u_stick{1}(2) + trim_stick(2);
    u_stick{1}(3) = u_stick{1}(3) + trim_stick(3);
end
    
    
    %% - Send command to trainer box
    tic
%     u_stick{1}(3)
    for vID= mod(ii,Np)+1
        ch1cmd = 4800+ 2720*u_stick{vID}(1);  % throttle (up)
        ch2cmd = 4800- 2720*u_stick{vID}(2);  % roll     (right)
        ch3cmd = 4800+ 2720*u_stick{vID}(3);  % pitch    (forward)
        ch4cmd = 4800+ 2720*u_stick{vID}(4);  % yaw
        ch5cmd = 2000;  % arm
        ch6cmd = 2000;  % angle mode
%         cmds = [ch1cmd;ch2cmd;ch3cmd;ch4cmd]
%         ch1cmd2 = 5000+ 4000*2*u_stick{vID}(1);  % throttle (up)
%         ch2cmd2 = 5000- 4000*7*u_stick{vID}(2);  % roll     (right)
%         ch3cmd2 = 5000+ 4000*7*u_stick{vID}(3);  % pitch    (forward)
%         ch4cmd2 = 5000+ 4000*7*u_stick{vID}(4);  % yaw
        
%         strCmd2 = sprintf('a%.f%.f%.f%.fz',ch1cmd2,ch2cmd2,ch3cmd2,ch4cmd2);
        strCmd1 = sprintf('a%.f%.f%.f%.f%.f%.fz',ch1cmd,ch2cmd,ch3cmd,ch4cmd,ch5cmd,ch6cmd);
        fprintf(sTrainerBox{vID},strCmd1);

%         % Run the simulation here
%         [t, position_raw, velocity, angle_raw, Rmat, omega_rate, R_d_old, ~, ~, paramCF,nu,att_des_old] = ...
%             Quadrotor_SIM_IL_Dynamics(strCmd1,IL_tspan,pos0,velocity0,...
%                                       Rmat0,omega_rate0, R_d_old,paramQuad,...
%                                       K_in,paramCF,SE3,linear,paramLinear,att_des_old);
                                  
    
%     nu_input(ii,:)            = nu;
                                  
    end
    % for signal sending
    run_time(ii,2) = toc;
    
    ii= ii+1;
    
    waitfor(r);
end

disp('Stopped')


%% Plot results
inde= find(time>0,1,'last');
strdim= {'X','Y','Z'};

for dim= 1:3*Np
    dx_diff(:,dim)= gradient(x_mocap(:,dim))./gradient(time);
    dv_diff(:,dim)= gradient(dx_diff(:,dim))./gradient(time);
end
 
time= time(1:inde);
x_target         = x_target(1:inde,:);
x_mocap          = x_mocap(1:inde,:);
x_mocap_raw      = x_mocap_raw(1:inde,:);
x_observer       = x_observer(1:inde,:);
dx_diff          = dx_diff(1:inde,:);
dv_diff          = dv_diff(1:inde,:);
attitude_mocap   = attitude_mocap(1:inde,:);
attitude_mocap_raw = attitude_mocap_raw(1:inde,:);
attitude_filter  = attitude_filter(1:inde,:);
attitude_desired = attitude_desired(1:inde,:);
% thrust_desired   = thrust_desired(1:inde,:);
stick_input      = stick_input(1:inde,:);
accel_desired    = accel_desired(1:inde,:);
run_time         = run_time(1:inde,:);
% x0_save          = x0_save(1:inde,:);
angrand_save     = angrand_save(1:inde,:);
% nu_input         = nu_input(1:inde,:);
e_x_plot         = error_x(1:inde,:);
e_x_std_plot     = error_x_std(1:inde,:);

%% Position
figure(2+flowplot), clf
for ii= 1:Np
R= x_observer(:,[1:3]+(ii-1)*6);
plot3(R(:,1)-xy_desired(1),R(:,2)-xy_desired(2),R(:,3),'.');hold on
% plot(R(:,1),R(:,2),'.');hold on

end
zlim([-.02,1.5])
daspect([1,1,1])
angc= linspace(0,2*pi,50); angc(end+1)= angc(1); 
plot3(cos(angc),sin(angc),ones(size(angc))*rref(3),'--','color',[.5,.5,.5],'linewidth',1)
% plot(cos(angc),sin(angc),'--','color',[.5,.5,.5],'linewidth',1)
grid on
xlabel('x')
ylabel('y')
axis equal

%% Save workspace
%{k
folder = 'data/LinearFlow';
header = 'testIN_';
save_workspace(folder,header)
%}