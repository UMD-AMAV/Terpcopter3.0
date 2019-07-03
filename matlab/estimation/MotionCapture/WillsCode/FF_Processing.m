% CIFER data processing for plotting
%% General Data Processing

% Import data (import as column vectors so that dates come in nicely and
% the names of each variable are the same between tests


% return 

%% From the quadrotor
% script to convert motor inputs to mixer inputs (get roll, pitch, yaw
% directly)

cd '/Users/willcraig/Documents/University of Maryland/CDCL Research/CDCL Research Matlab/Mocap OL/Processed_Data'
clear
% % % uiopen('/Users/willcraig/Documents/Development/Blackbox/FreeFlight/181207_quad_FFon_2g_1.01.csv',1)
% % % uiopen('/Users/willcraig/Documents/Development/Blackbox/FreeFlight/181207_quad_FFon_2g_2.01.csv',1)
% % uiopen('/Users/willcraig/Documents/Development/Blackbox/FreeFlight/181207_quad_FFon_2g_3.01.csv',1)
% % uiopen('/Users/willcraig/Documents/Development/Blackbox/FreeFlight/181207_quad_FFoff_2g_1.01.csv',1)
% % uiopen('/Users/willcraig/Documents/Development/Blackbox/FreeFlight/181207_quad_FFoff_2g_2.01.csv',1)
% % uiopen('/Users/willcraig/Documents/Development/Blackbox/FreeFlight/181207_quad_FFoff_2g_3.01.csv',1)
% uiopen('/Users/willcraig/Documents/Development/Blackbox/FreeFlight/181207_quad_CF_2g_1.01.csv',1)
% uiopen('/Users/willcraig/Documents/Development/Blackbox/FreeFlight/181207_quad_CF_2g_2.01.csv',1)
% uiopen('/Users/willcraig/Documents/Development/Blackbox/FreeFlight/181207_quad_CF_2g_3.01.csv',1)
% % % % % % % % % save('181205_quad_FFoff_5g.mat');
% return


load('181207_quad_FFon_2g_1.mat')

motorin = [motor0, motor1, motor2, motor3];% table2array(FlowMtxAngleOn(:,32:35)); %check the columns
%motorin = table2array(AutoPitchSwp_180219(1:2:end,26:29)); % taking half the points
% time = timeus; % Time in microseconds %table2array(FlowMtxAngleOn(:,2));
time_s = timeus/1e6 - timeus(1)/1e6;
%time = table2array(AutoPitchSwp_180219(1:2:end,2)); % taking half the points
% gyro = [p, q, r] rad/s
gyro = [gyroADC0rads, gyroADC1rads, gyroADC2rads]; %table2array(FlowMtxAngleOn(:,22:24));
%gyro = table2array(AutoPitchSwp_180219(1:2:end,16:18));% taking half the points

accel = [accSmooth0mss, accSmooth1mss, accSmooth2mss];

mix = [1,-1,1,-1;1,-1,-1,1;1,1,1,1;1,1,-1,-1]/4;
% computing motorin as percent of max throttle
motor_min = 1070;
motor_max = 2000;
motorin = (motorin - motor_min) / (motor_max-motor_min);
% Attitude: [roll, pitch, yaw], deg
attitude = [roll, pitch, heading]; %table2array(FlowMtxAngleOn(:,36:38)); % check the columns
%attitude = table2array(AutoPitchSwp_180219(1:2:end,30:32)); % taking half of the points

% v = zeros(length(accel),1);
% for kk = 2:length(v)
%     v(kk) = trapz(time_s(1:kk),accel(1:kk,2) + 9.81.*cos(pitch(1:kk)).*sin(roll(1:kk)));
% end
% u = cumtrapz(time_s,accel(:,1) - 9.81.*sin(pitch) + gyro(:,3).*cumtrapz(accel(:,2)) - gyro(:,2).*cumtrapz(accel(:,3)-9.81));
% v = cumtrapz(time_s,accel(:,2) + 9.81.*cos(pitch).*sin(roll) + gyro(:,1).*cumtrapz(accel(:,3)-9.81) - gyro(:,3).*cumtrapz(accel(:,1)));
% w = cumtrapz(time_s,accel(:,3) + 9.81.*cos(pitch).*cos(roll) + gyro(:,2).*cumtrapz(accel(:,1)) - gyro(:,1).*cumtrapz(accel(:,2)));

% flow sensor data
flow = [debug2,debug3,debug0,debug1]; % for FFon181207 -> flow = [debug1,debug2]; %table2array(FlowMtxAngleOn(:,29));
N = length(motorin);
thrust = zeros(N,1);
roll_in = zeros(N,1);
pitch_in = zeros(N,1);
yaw_in = zeros(N,1);
for ii = 1:N
    thrust(ii) = motorin(ii,:)*mix(:,1);
    roll_in(ii) = motorin(ii,:)*mix(:,2);
    pitch_in(ii) = motorin(ii,:)*mix(:,3);
    yaw_in(ii) = motorin(ii,:)*mix(:,4);
end

% % adjust time for heave 50
% time_idx = time_s>42.75;
% attitude = attitude(time_idx,:);% motorin = motorin(time_idx,:);
% pitch_in = pitch_in(time_idx);% roll_in = roll_in(time_idx);
% thrust = thrust(time_idx);% timeus = timeus(time_idx)-42.75*1e6;
% time_s = time_s(time_idx)-42.75;% yaw_in = yaw_in(time_idx);
% gyro = gyro(time_idx,:);% flow = flow(time_idx);

yaw = attitude(:,3); yawrap = yaw>200; yaw(yawrap) = yaw(yawrap)-360;
yaw_rev = -yaw;
r = -gyro(:,3);

figure(101), clf, plot(time_s, flow(:,1:4)), hold on

figure(102), clf, plot(time_s, attitude(:,2))


% clearing and saving appropriate variables
clearvars -except  attitude motorin pitch_in roll_in thrust timeus time_s yaw_in gyro flow yaw yaw_rev r accel
% clear attitude motorin pitch_in roll_in thrust time yaw_in gyro flow

% Cleans up yaw a little since it tends to wrap
% for ii = 1:length(attitude)
%     if attitude(ii,3)>100
%         attitude(ii,3) = attitude(ii,3)-360;
%     end
% end
return

%% Mocap
cd '/Users/willcraig/Documents/University of Maryland/CDCL Research/CDCL Research Matlab/Mocap OL/Processed_Data'

load('181207_mocap_CF_2g_3.mat')

t_filt = time(1);%zeros(length(time),1);
y_filt = x_observer(1,1);%zeros(length(time),1);
y_raw_filt = x_mocap(1,1);
mocap_roll = attitude_mocap(1,2);
mocap_pitch = attitude_mocap(1,1);
v = 0;
count = 1;
for ii = 1:length(time)
    if t_filt(count) ~= time(ii)
        count = count + 1;
        t_filt(count,1) = time(ii);
        
        x_filt(count,1) = x_observer(ii,1);
        x_raw_filt(count,1) = x_mocap(ii,1);
        y_filt(count,1) = x_observer(ii,2);
        y_raw_filt(count,1) = x_mocap(ii,2);
        z_filt(count,1) = x_observer(ii,3);
        z_raw_filt(count,1) = x_mocap(ii,3);
        
        
        u_raw(count,1) = (x_raw_filt(count)-x_raw_filt(count-1))/(t_filt(count)-t_filt(count-1));
        u_obsv(count,1) = (x_filt(count)-x_filt(count-1))/(t_filt(count)-t_filt(count-1));
        v_raw(count,1) = (y_raw_filt(count)-y_raw_filt(count-1))/(t_filt(count)-t_filt(count-1));
        v_obsv(count,1) = (y_filt(count)-y_filt(count-1))/(t_filt(count)-t_filt(count-1));
        w_raw(count,1) = (z_raw_filt(count)-z_raw_filt(count-1))/(t_filt(count)-t_filt(count-1));
        w_obsv(count,1) = (z_filt(count)-z_filt(count-1))/(t_filt(count)-t_filt(count-1));
        
        
        mocap_roll(count,1) = attitude_mocap(ii,2);
        mocap_pitch(count,1) = attitude_mocap(ii,1);
    end
end
t_filt = t_filt*(1+0.158/60);

figure(1), clf, hold on, plot(time_s, attitude(:,1)), plot(t_filt, mocap_roll*57.3);
figure(2), clf, hold on, plot(time_s, attitude(:,2)), plot(t_filt, -mocap_pitch*57.3);
legend('quadrotor', 'mocap')

figure(80), clf, hold on, plot(t_filt, y_raw_filt)


%% Match the time series data
% Find when the chirp initializes in data set - look for spike in the data
%    Motors from quad and velocity from mocap showed the clearest spike for
%    this data set
% % 12/05 gust 1% tset_mocap = 1.455; % tset_quad = 10.35; % t0 = 9.33; %based on the quadrotor initial time
% 12/05 gust 2% tset_mocap = 46.34; % tset_quad = 55.78; % t0 = 9.88; %based on the quadrotor initial time
% 12/05 FFon 1 tset_mocap = 17.95; tset_quad = 23.28; t0 =  5.81; %based on the quadrotor initial time
% 12/05 FFon 2 tset_mocap = 10.4;  tset_quad = 16.81; t0 =  6.83; %based on the quadrotor initial time
% 12/05 FFon 3 tset_mocap = 10.1; tset_quad = 21.28; t0 =  11.55; %based on the quadrotor initial time
% 12/05 FFoff 1 tset_mocap = 12.34;  tset_quad = 18; t0 =  6.13; %based on the quadrotor initial time
% 12/05 FFoff 2 tset_mocap = 10.15; tset_quad = 16.98;  t0 =  7.31; %based on the quadrotor initial time
% 12/05 FFoff 3 tset_mocap = 9.47; tset_quad = 16.28; t0 =  7.4; %based on the quadrotor initial time
% 12/05 CF 1 tset_mocap = 11.06; tset_quad = 16.03; t0 =  5.42; %based on the quadrotor initial time
% 12/05 CF 2 tset_mocap = 5.02; tset_quad = 12.5; t0 =  8.08; %based on the quadrotor initial time
% 12/07 FFon 1z tset_mocap = 8.48; tset_quad = 8.47; t0 =  0.05; %based on the quadrotor initial time
% 12/07 FFon 2z tset_mocap = 9.42; tset_quad = 19.31; t0 =  10.27; %based on the quadrotor initial time
% 12/07 FFon 3z time_adjust = [8.46; 13.92; 5.85];
% 12/07 FFoff 1z time_adjust = [3.205; 8.52; 5.71]; %mocap, quad, t0_quad
% 12/07 FFoff 2z time_adjust = [9.88; 14.90; 5.45]; %mocap, quad, t0_quad
% 12/07 FFoff 2z
time_adjust0 = [9.88; 14.90];% 5.45]; %mocap, quad, t0_quad
% time_adjust0 = [3.2; 14.90];% 5.45]; %mocap, quad, t0_quad

fun = @(x)FF_Processing_minimizer(x,time_s,t_filt,attitude,mocap_pitch);

time_adjust = fminsearch(fun,time_adjust0)

tset_mocap = time_adjust(1); tset_quad = time_adjust(2);% t0 = time_adjust(3);

t_diff = tset_mocap - tset_quad;
% t_end = t0 + 45; %test length

if t_diff > 0
    t_set = t_filt > t_diff;
    t_match = t_filt(t_set)-t_diff;
    t_match = t_match - t_match(1); % make sure the first value is 0 like time_s

else
    t_set = true(size(t_filt));
    t_match = t_filt;
    t_diff = -t_diff;
    t_quad = time_s > t_diff;
%     t_fit = time_s; % try not to self-reference the time_s variable (too
%     late, everything else is self-referencing too, just need to run 
%     the whole script at a time)
%     t_m_quad = time_s(t_quad) - t_diff;
%     t_m_quad = t_m_quad - t_m_quad(1);
%     time_s = t_m_quad;
    attitude = attitude(t_quad,:);
    motorin  = motorin(t_quad,:);
    pitch_in = pitch_in(t_quad);
    roll_in = roll_in(t_quad);
    thrust = thrust(t_quad);
    yaw_in = yaw_in(t_quad);
    gyro = gyro(t_quad,:);
    flow = flow(t_quad,:);
    yaw = yaw(t_quad);
    yaw_rev = yaw_rev(t_quad);
    r = r(t_quad,:);
    accel = accel(t_quad,:);
    timeus = timeus(t_quad); 
    timeus = timeus - timeus(1);
    time_s = time_s(t_quad);
    time_s = time_s - time_s(1);

end

    
    v_raw_interp = v_raw(t_set);
    v_raw_match = interp1(t_match,v_raw_interp,time_s);
    v_obsv_interp = v_obsv(t_set);
    v_obsv_match = interp1(t_match,v_obsv_interp,time_s);
    u_raw_interp = u_raw(t_set);
    u_raw_match = interp1(t_match,u_raw_interp,time_s);
    u_obsv_interp = u_obsv(t_set);
    u_obsv_match = interp1(t_match,u_obsv_interp,time_s);
    w_raw_interp = w_raw(t_set);
    w_raw_match = interp1(t_match,w_raw_interp,time_s);
    w_obsv_interp = w_obsv(t_set);
    w_obsv_match = interp1(t_match,w_obsv_interp,time_s);
    
    x_obsv_interp = x_filt(t_set);
    x_obsv_match = interp1(t_match,x_obsv_interp,time_s);
    y_obsv_interp = y_filt(t_set);
    y_obsv_match = interp1(t_match,y_obsv_interp,time_s);
    z_obsv_interp = z_filt(t_set);
    z_obsv_match = interp1(t_match,z_obsv_interp,time_s);
    
    mocap_roll_interp = mocap_roll(t_set);
    mocap_roll_match = interp1(t_match,mocap_roll_interp,time_s);
    mocap_pitch_interp = mocap_pitch(t_set);
    mocap_pitch_match = interp1(t_match,mocap_pitch_interp,time_s);

figure(3), clf, hold on, plot(time_s, attitude(:,2)), plot(time_s, -mocap_pitch_match*57.3)
figure(4), clf, hold on, plot(time_s, z_obsv_match)
figure(5), clf, hold on
subplot(2,1,2), plot(time_s(100:end), flow(100:end,1)/1000), xlim([0 50])
subplot(2,1,1), plot(time_s(100:end), x_obsv_match(100:end)), xlim([0 50])%plot(t_fit, mocap_pitch_match), hold on, 
% legend('pitch', 'x')
return
%%
% cd '/Users/willcraig/Documents/University of Maryland/CDCL Research/CDCL Research Matlab/Mocap OL/Processed_Data'
% % return
% clear time
% time = time_s;
% clearvars -except  attitude motorin pitch_in roll_in yaw_in thrust time gyro flow v_raw_match v_obsv_match u_raw_match u_obsv_match w_raw_match w_obsv_match yaw yaw_rev r x_obsv_match y_obsv_match z_obsv_match mocap_roll_match mocap_pitch_match
% save('181207_CF_2g_3.mat');


return
