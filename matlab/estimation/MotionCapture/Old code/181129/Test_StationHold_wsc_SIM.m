% Gyroscopic collision avoidance
% Swarming in Z direction
% Random forcing

% New swarming algorithm with alpha-lattice.
% mySwarmingAccel8
% function [pos_error] = Test_StationHold_wsc_SIM(K_in)
if exist('fig','var')
    close(fig)
end
clear
% clearvars -except K_in

%% Initialization
Np    = 1; % number of guardians
% Nt    = 0; % number of intruders
vIDs  = 1;%[1,2,3,4,6]; % vehicle ID specified in Motive (=ID on propeller)
inds  = 1:Np;      % vehicle index in this simulation

% desired height
z_desired = 0.8;%[0, .2, .35 , .2, 0] + 0.8;

vt0   = 0;%2;

% % These gains work well for following a constant velocity trajectory
% K_in(1) = 2;%1;%0.15;%5;
% K_in(2) = 1;%0.75;%1.2;
% K_in(3) = 5000;%-24;
% K_in(4) = 500;%-9.7;

% % These gains can handle all of the cases I've given it!!!
% K_in(1) = 0.36;
% K_in(2) = 0.72;
% K_in(3) = 150;
% K_in(4) = 25;

% These gains work even better!!!!!
K_in(1) = 5; %0.67;
K_in(2) = K_in(1)/1;%0.67;
K_in(3) = 1500;%150;
K_in(4) = K_in(3)/5;

initialize_all_wsc_SIM

set(fig,'WindowScrollWheelFcn',@figScroll_hover)

Eb1d = [1;0;0];%[cos(pi*t); sin(pi*t); 0];%
psi_des = pi/2;% asin(cross([1;0;0],Eb1d))
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
% u_stick{1}(1) = -1;
% u_stick{1}(2) = 0;
% u_stick{1}(3) = 0;
% u_stick{1}(4) = 0;
%         ch1cmd = 1000;%5000+ 4000*u_stick{vID}(1);  % throttle (up)
%         ch2cmd = 5000;%5000- 4000*u_stick{vID}(2);  % roll     (right)
%         ch3cmd = 5000;%5000+ 4000*u_stick{vID}(3);  % pitch    (forward)
%         ch4cmd = 5000;%5000+ 4000*u_stick{vID}(4);  % yaw
%         ch5cmd = 2000;  % arm
%         ch6cmd = 2000;  % angle mode
%         
%         strCmd1 = sprintf('a%.f%.f%.f%.fz',ch1cmd,ch2cmd,ch3cmd,ch4cmd);
%         for nn = 1:1000
%             fprintf(sTrainerBox{vID},strCmd1);
%         end


%% Parameters (Swarming)
% % Constant acceleration for swarming
% umax       = 0;
% % Pursuit
% rho_a = 1.3;
% rho_p = 0.5;
% % Central force
% Kcenter     =  0; % for crystalized swarm
% % Kcenter     =  0.7; % for random swarm
% Kdamp       =  1;
% % Spacing term
% Ksep        =  0;
% Bsep        =  0;
% x0          =  1;
% rho_sep     =  x0/0.9;
% % Gyro
% Kgyro       =  0;
% % Random
% Krand       =  0;
% intensity   =  2*pi;
% % Bound on the range from center
% Rmax       = 1;
% % For position control
% rref       = [.6;.9;.5];
% % Centroid of the swarm
% xcg = zeros(6*Np,1);
% for vID = 1:Np
%     xcg([1:3]+6*(vID-1)) = rref;
% end
% 
% paramSwarming = v2struct(rho_a,rho_p,pursuit_phase,Np,Nt,umax,...
%                          Rmax,Kcenter,Kdamp,x0,Ksep,Bsep,rho_sep,...
%                          Kgyro,Krand,intensity);
% 

%% Run Experiment
ii= 1;
tnow= 0;
tend= 10;%480; % (s)
OL_dt = 0.01; % Artificially prescribed time to run the outer loop
abort= 0;

while tnow < tend+0
    tic
    pause(eps)
    
    %% - Mocap data
%     [position_raw,angle_raw,t,Rmat] = get_PosAng_ID(client);

if ii == 1
    position_raw = [-0.4; 0.3; 0.15];zeros(3,vIDs(inds));
    pos0 = position_raw(:,1);
    velocity0 = zeros(3,vIDs(inds));
    angle_raw = zeros(3,vIDs(inds));
    t = 0;
    Rmat0 = eye(3);
    omega_rate0 = zeros(3,vIDs(inds));
    R_d_old = eye(3);
else
    pos0 = position_raw(:,vIDs(inds));
    velocity0 = velocity(:,vIDs(inds));
    Rmat0 = Rmat(:,:,end);
    omega_rate0 = omega_rate(:,end);
end

    position = position_raw(:,vIDs(inds));
    angle    = angle_raw(:,vIDs(inds));
    
%     if position(3) < -1
%         break
%     end
    
%     fprintf('Position is %1.4f %1.4f %1.4f; Time is %2.2f\n',...
%         position(1), position(2), position(3),tnow)
    
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

    % Initialization
    if ii==1
        tstart= t;
        tprev= 0;
        xhat(ind_var)= pos;
        zhat(ind_var)= ang;
%         xhatT(1:3) = posT;
        % Set desired position to where it begins since it's a station hold
        % mission
        for vID= 1:Np
            xref(1:6+6*(vID-1),1)= [pos(1:2+(vID-1)*3);z_desired(vID);0;0;0];
        end
        disp('Running...')
        disp('Turn ON trainer switch')
        disp('  [space] : proceed')
        disp('  [c]     : quit')
    end
    
%     for vID= 1:Np
%             xref(1:6+6*(vID-1),1) = [0;0;z_desired(vID);0;0;0]... 
%                 + 0*[0;tnow/2;0;0;1/2;0]...
%                 + 0*[sin(tnow);cos(tnow);...
%                 0;cos(tnow);-sin(tnow);0];
%             
% %             psi_des = 0;
% %             psideslist = psi_des*ones(1,Np);%[pi/2, pi/2, pi/2, pi/2, pi/2];
% %             for ii=1:Np
% %                 paramStick{ii}.psi_des = psideslist(ii);
% %             end
%     end
    
    t_ramp = 2;
    if tnow < t_ramp
         xref(1:6+6*(vID-1),1) = [0;0;(tnow/t_ramp)*z_desired(vID);0;0;0];
    else
         xref(1:6+6*(vID-1),1) = [0;0;z_desired(vID);0;0;0];
    end
    
    pos_error = norm(xhat-xref);
    % Time
    tnow= t-tstart;
    dt= tnow-tprev;
    tprev = tnow;
    IL_tspan = [tnow, tnow + OL_dt];
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
%         if sum(criteria)
%             abort = 1;
%             abort_time = tnow;
%             tend = tnow; % start landing sequence
%             if criteria(1) || criteria(3)
%                 disp('aborting! (missing mocap data)')
%                 disp([' vehicle:#',num2str(vIDs(duration_lost>0))])
%             elseif criteria(2)
%                 disp('aborting! (altitude exceeded limit)')
%             end
%         end
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
    [xhat,zhat] = myObserverAll_wsc(xhat,zhat,pos,ang,dt,paramObs);
    
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
    [udes,err_int] = myTrackingCtrl_wsc(xhat,xref,err_int,tnow,dt,paramQuad,paramControl);
    
    % Augment udes with estimated disturbance
    %udes = udes + Dhat;
    
    %% - Controller (Stick Input)
    for vID = 1:Np
        % convert udes to u_stick (and obtain desired yaw rate)
        udes_i = udes([1:3]+3*(vID-1));
        zhat_i = zhat([1:6]+6*(vID-1));
        [u_stick{vID},psi_int{vID},angdes{vID},thrustdes(vID)] =...
            accel2stick_wsc(udes_i,zhat_i,psi_int{vID},dt,paramStick{vID});

%         psi_des = pi/2*tnow;
%         u_stick{1}(4) = psi_des/12;

        % restrict them depending on time & state
%         if vehicle_state(vID)==0
        if tnow < 0.05
%             % Before launch
%             u_stick{vID}(1:3)= [-0.5;0;0];
%             u_stick{vID}(4)= 0;
        elseif tnow > tend && tnow < tend+2.7
            % Landing
            if abort
                if nnz(criteria)
                    u_stick{vID}(2:4)= stick_trim{vID}(2:4);
                end
            end
            u_stick{vID}(1)= -0.18;%(delT_trim{vID}*2 - 1)*0.9;%0.95*(delT_trim{vID});%%
        elseif tnow > tend+2.7
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
    
    % for computation
    run_time(ii,1) = toc;
%}
    %% - Send command to trainer box
    tic
    
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

        % Run the simulation here
        [t, position_raw, velocity, angle_raw, Rmat, omega_rate, R_d_old, ~, ~] = ...
            Quadrotor_SIM_IL_Dynamics(strCmd1,IL_tspan,pos0,velocity0,...
                                      Rmat0,omega_rate0, R_d_old,paramQuad,K_in);
                                  
    end
    % for signal sending
    run_time(ii,2) = toc;
    
    ii= ii+1;
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

%% Position
figure(2), clf
for ii= 1:Np
R= x_observer(:,[1:3]+(ii-1)*6);
plot3(R(:,1),R(:,2),R(:,3),'.');hold on
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
% axis square

figure(3), clf
plot(time, attitude_mocap(:,1:3))
grid on
legend('roll', 'pitch', 'yaw')
title('measured angles')

figure(4), clf
for ii= 1:Np
    R= x_observer(:,[1:3]+(ii-1)*6);
    V= x_observer(:,[4:6]+(ii-1)*6);
    plot(time,R(:,1:3));hold on
%     strlegend(ii) = num2str(vIDs(ii));
end
legend('x','y','z')
% plot([tstart, tend],[z_desired(1), z_desired(1)], '--k')

figure(5), clf
plot(time, stick_input(:,1)), hold on
plot(time, stick_input(:,2))
plot(time, stick_input(:,3))
plot(time, stick_input(:,4))
legend('thrust', 'roll', 'pitch', 'yaw')
title('Stick Inputs, roughly corresponding to trpy at ICs')
%{

figure(2), clf
for ii= 1:Np
R= x_observer(:,[1:3]+(ii-1)*6);
% plot3(R(:,1),R(:,2),R(:,3),'.');hold on
plot(R(:,1),R(:,2),'.');hold on

end
% zlim([-.02,1.5])
% daspect([1,1,1])
angc= linspace(0,2*pi,50); angc(end+1)= angc(1); 
% plot3(cos(angc),sin(angc),ones(size(angc))*rref(3),'--','color',[.5,.5,.5],'linewidth',1)
plot(cos(angc),sin(angc),'--','color',[.5,.5,.5],'linewidth',1)
grid on
xlabel('x')
ylabel('y')
axis equal
% axis square

figure(3), clf
for ii= 1:Np
    R= x_observer(:,[1:3]+(ii-1)*6);
    V= x_observer(:,[4:6]+(ii-1)*6);
    plot(time,R(:,3));hold on
    strlegend(ii) = num2str(vIDs(ii));
end
legend(strlegend)
% plot([tstart, tend],[z_desired(1), z_desired(1)], '--k')

%}

%% Save workspace
%{a
% folder = '..\data\exp_Intensity';
% header = 'testIN_';
% save_workspace(folder,header)
%}