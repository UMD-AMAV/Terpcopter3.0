%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Node: control
%
% Purpose:  
% The purpose of the control node is to regulate the quadcopter to desired
% setpoints of [altitude, heading, forward speed, crab speed]. We refer to
% this as a 'ahsCmd' which is generated by a behavior in the autonomy node.
% The control node determines the appropriate 'stickCmd' [yaw, pitch, roll,
% thrust] to send to the virtual_transmitter.
%
% Input:
%   - ROS topic: /stateEstimate (generated by estimation)
%   - ROS topic: /ahsCmd (generated by autonomy)
%   
% Output:
%   - ROS topic: /stickCmd (used by virtual_transmitter)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% prepare workspace
clear; close all; clc; format compact;
addpath('../')
params = loadParams();

global controlParams
controlParams = params.ctrl;
fprintf('Control Node Launching...\n');

% declare global variables
% Determine usage in other scripts - change to local if no other usage
global altitudeErrorHistory;
altitudeErrorHistory.lastVal = 0;
altitudeErrorHistory.lastSum = 0;
altitudeErrorHistory.lastTime = 0;

yawError.lastVal = 0;
yawError.lastSum = 0;
yawError.lastTime = 0;


% initialize ROS
if(~robotics.ros.internal.Global.isNodeActive)
    rosinit;
end

% Subscribers
stateEstimateSubscriber = rossubscriber('/stateEstimate');
ahsCmdSubscriber = rossubscriber('/ahsCmd');
pidSettingSubscriber = rossubscriber('/pidSetting');
pidResetPublisher = rospublisher('/pidReset', 'std_msgs/Bool');
pidResetSubscriber = rossubscriber('/pidReset');


% Publishers
stickCmdPublisher = rospublisher('/stickCmd', 'terpcopter_msgs/stickCmd');

pause(2)
stickCmdMsg = rosmessage(stickCmdPublisher);
stickCmdMsg.Thrust = 0;
stickCmdMsg.Yaw = 0;

stateEstimateMsg = stateEstimateSubscriber.LatestMessage;
ahsCmdMsg = ahsCmdSubscriber.LatestMessage;
pidSettingMsg = pidSettingSubscriber.LatestMessage;

% timestamp
t0 = []; timeMatrix=[];
ti= rostime('now');
%abs_t = eval([int2str(ti.Sec) '.' ...
    %int2str(ti.Nsec)]);

abs_t = double(ti.Sec)+double(ti.Nsec)*10^-9;

if isempty(t0), t0 = abs_t; end


altitudeErrorHistory.lastTime = 0; %stateEstimateMsg.Time;
display("alt meters")
display(ahsCmdMsg.AltitudeMeters)
%display("alt meters")
%display(altitudeErrorHistory.lastVal)
altitudeErrorHistory.lastVal = ahsCmdMsg.AltitudeMeters;
altitudeErrorHistory.lastSum = 0;
u_t_alt = controlParams.altitudeGains.ffterm;

yawError.lastTime = stateEstimateMsg.Time;
yawError.lastVal = ahsCmdMsg.HeadingRad;
yawError.lastSum = 0;
u_t_yaw = 0; 

disp('initialize loop');

r = robotics.Rate(100);
reset(r);

send(stickCmdPublisher, stickCmdMsg);

while(1)
    stateEstimateMsg = stateEstimateSubscriber.LatestMessage;
    ahsCmdMsg = ahsCmdSubscriber.LatestMessage;
    pidSettingMsg = pidSettingSubscriber.LatestMessage;

    % timestamp
    ti= rostime('now');
    abs_t = double(ti.Sec)+double(ti.Nsec)*10^-9;
    t = abs_t-t0;
    %timeMatrix = [timeMatrix;t];
    %if isempty(t0), t0 = abs_t; end
   
    fprintf("t %6.4f",t);

    % unpack statestimate
    %t = stateEstimateMsg.Time;
    z = stateEstimateMsg.Range;
    yaw = stateEstimateMsg.Yaw;
    fprintf('Current Quad Alttiude is : %3.3f m\n', z );

    % get setpoint
    z_d = ahsCmdMsg.AltitudeMeters;
    yaw_d = ahsCmdMsg.HeadingRad;
    
   
    % update errors
    altError = z_d - z;
    
    % reset Integral
    pidResetMsg = rosmessage('std_msgs/Bool');
    pidResetMsg.Data = false;
    pidResetMsg = pidResetSubscriber.LatestMessage;
    if ~isempty(pidResetMsg)
        if pidResetMsg.Data == true 
            disp("Resetting PID ...")
            altitudeErrorHistory.lastVal = ahsCmdMsg.AltitudeMeters;
            altitudeErrorHistory.lastSum = 0;
            pidResetMsg.Data = false;
            send(pidResetPublisher, pidResetMsg);
        end
    end

    % compute controls
    % FF_PID(gains, error, newTime, newErrVal)
    [u_t_alt, altitudeErrorHistory] = FF_PID(pidSettingMsg, altitudeErrorHistory, t, altError);
    disp('pid loop');
    disp(pidSettingMsg)
    
      if (abs(yaw-yaw_d) >= abs(yaw_d-yaw))
        yawSetpointError = yaw - yaw_d;
      else 
        yawSetpointError = yaw_d - yaw;
      end
    
    % compute controls
%     [u_t_yaw, yawError] = PID(controlParams.yawGains, yawError, t, yawSetpointError);
%     disp('pid loop');
%     disp(controlParams.yawGains)
    

    % publish
    stickCmdMsg.Thrust = 2*max(min(1,u_t_alt),0)-1;
    stickCmdMsg.Yaw = u_t_yaw;
    send(stickCmdPublisher, stickCmdMsg);
    fprintf('Published Stick Cmd., Thrust : %3.3f, Altitude : %3.3f, Altitude_SP : %3.3f, Error : %3.3f \n', stickCmdMsg.Thrust , stateEstimateMsg.Up, z_d, ( z - z_d ) );

    time = r.TotalElapsedTime;
	fprintf('Iteration: %d - Time Elapsed: %f\n',i,time)
	waitfor(r);
 end

