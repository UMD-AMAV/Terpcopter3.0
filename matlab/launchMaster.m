% prepare workspace, shutdown past ROS sessions
clear; close all; clc;
rosshutdown;
params = loadParams();

% start ROS master and Initialize
master = robotics.ros.Core;
rosinit(params.env.ros_master_ip);

disp('ROS master intialized.')


