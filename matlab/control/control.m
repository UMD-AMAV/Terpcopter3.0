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

% initialize ROS
if(~robotics.ros.internal.Global.isNodeActive)
    rosinit;
end

% Subscribers
stateEstimateSubscriber = rossubscriber('/stateEstimate');
ayprCmdSubscriber = rossubscriber('/ayprCmd');
controlStartSubscriber = rossubscriber('/startControl', 'std_msgs/Bool');

% Publishers
stickCmdPublisher = rospublisher('/stickCmd', 'terpcopter_msgs/stickCmd');

% timestamp
ti = rostime('now');
t0 = [];
abs_t = double(ti.Sec)+double(ti.Nsec)*10^-9;
if isempty(t0), t0 = abs_t; end

% initialize messages to publish
stickCmdMsg = rosmessage(stickCmdPublisher);
stickCmdMsg.Thrust = -1;
stickCmdMsg.Yaw = 0;
stickCmdMsg.Pitch = 0;
stickCmdMsg.Roll = 0;

% initialize altiude controller state
dateString = datestr(now,'mmmm_dd_yyyy_HH_MM_SS_FFF');
altControl.log=[params.env.matlabRoot '/altControl_' dateString '.log'];
altControl.lastTime = 0;
altControl.prevVal = 0;
altControl.setpointReached = 0;
altControl.setpointVal = 0;

% initialize yaw controller state
yawControl.log=[params.env.matlabRoot '/yawControl_' dateString '.log'];
yawControl.lastTime = 0;
yawControl.prevVal = 0;

% initialize yaw controller state
pitchControl.log=[params.env.matlabRoot '/pitchControl_' dateString '.log'];
pitchControl.lastTime = 0;
pitchControl.prevVal = 0;

% initialize yaw controller state
rollControl.log=[params.env.matlabRoot '/rollControl_' dateString '.log'];
rollControl.lastTime = 0;
rollControl.prevVal = 0;


disp('initialize loop');
r = robotics.Rate(90);
reset(r);
send(stickCmdPublisher, stickCmdMsg); % send initial stick command.


disp('Waiting for Start...')
controlStartFlag = controlStartSubscriber.LatestMessage;
while ( ~controlStartFlag.Data )
    controlStartFlag = controlStartSubscriber.LatestMessage;
end
disp('Entering loop...');

while(1)
    
    % get latest messages
    stateEstimateMsg = stateEstimateSubscriber.LatestMessage;
    ayprCmdMsg = ayprCmdSubscriber.LatestMessage;
    
    % unpack state estimate
    z = stateEstimateMsg.Range;
    pitchDeg = stateEstimateMsg.Pitch; 
    yawDeg = stateEstimateMsg.Yaw;
    rollDeg = stateEstimateMsg.Roll;
    
    % unpack command
    z_d = ayprCmdMsg.AltDesiredMeters;
    yaw_d = ayprCmdMsg.YawDesiredDegrees;
    pitch_d = ayprCmdMsg.PitchDesiredDegrees;
    roll_d = ayprCmdMsg.RollDesiredDegrees;
    
    % timestamp
    ti = rostime('now');
    abs_t = double(ti.Sec)+double(ti.Nsec)*10^-9;
    t = abs_t-t0;
    
    % altitude control
    if ( ayprCmdMsg.AltSwitch==1 )
        [u_alt, altControl] = altModeController(altControl, t, z, z_d);
    else
        u_alt = 0;
    end
    
    % yaw control
    if ( ayprCmdMsg.YawSwitch==1 )
        [u_yaw, yawControl] = yawController(yawControl, t, yawDeg, yaw_d);
    else
        u_yaw = 0;
    end
   
    % pitch control
    if ( ayprCmdMsg.PitchSwitch==1 )
        [u_pitch, pitchControl] = pitchController(pitchControl, t, pitchDeg, pitch_d);
    else
        u_pitch = 0;
    end
    
    % roll control
    if ( ayprCmdMsg.RollSwitch==1 )
        [u_roll, rollControl] = rollController(rollControl, t, rollDeg, roll_d);
    else
        u_roll = 0;
    end
    
    % publish
    stickCmdMsg.Thrust = u_alt;
    stickCmdMsg.Yaw = u_yaw;
    stickCmdMsg.Pitch = u_pitch;
    stickCmdMsg.Roll = u_roll;

    
    % send stick commands
    fprintf('Stick Cmd.Thrust : %3.3f, Stick Cmd.Pitch: %3.3f, Stick Cmd.Roll: %3.3f, Altitude : %3.3f, Altitude_SP : %3.3f, Error : %3.3f \n', stickCmdMsg.Thrust, stickCmdMsg.Pitch, stickCmdMsg.Roll , stateEstimateMsg.Up, z_d, ( z - z_d ) );
    send(stickCmdPublisher, stickCmdMsg);
    waitfor(r);
end
