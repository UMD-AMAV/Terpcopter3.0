% prepare workspace, shutdown past ROS sessions
clear; close all; clc;
rosshutdown;
params = loadParams();

% start ROS master and Initialize
master = robotics.ros.Core;
rosinit;

disp('ROS master intialized.')


