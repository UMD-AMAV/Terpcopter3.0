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
controlParams = params.ctrl;
fprintf('Control Node Launching...\n');

% declare global variables
global altitudeError;
altitudeError.lastVal = 0;
altitudeError.lastSum = 0;
altitudeError.lastTime = 0;

global ahsCmdMsg;
ahsCmdMsg = rosmessage('terpcopter_msgs/ahsCmd');
ahsCmdMsg.AltitudeMeters = 0;
ahsCmdMsg.HeadingRad = 0;
ahsCmdMsg.ForwardSpeedMps = 0;
ahsCmdMsg.CrabSpeedMps = 0;

% initialize ROS
if(~robotics.ros.internal.Global.isNodeActive)
    rosinit;
end
controlNode = robotics.ros.Node('/control');
stickCmdPublisher = robotics.ros.Publisher(controlNode,'stickCmd','terpcopter_msgs/stickCmd');
stateEstimateSubscriber = robotics.ros.Subscriber(controlNode,'stateEstimate','terpcopter_msgs/stateEstimate',{@sendStickCmd,controlParams,stickCmdPublisher});
ahsCmdSubscriber = robotics.ros.Subscriber(controlNode,'ahsCmd','terpcopter_msgs/ahsCmd',{@receiveAhsCmd});