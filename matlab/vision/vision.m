%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Node: vision
%
% Purpose:  
% The purpose of the vision node is to receive and process images obtain
% from the quad in flight to identify features of interest. Images from an
% onboard camera will be transmitted to an Audio/Video (A/V) receiver,
% which in turn will coonect to an A/V Digitzer, and stream over USB to a
% connected laptop.
%
% Features of interest include:
%   - Targets
%   - Obstacles
%   - Arena boundaries
%   - Other landmarks
%
% The vision node can operate in one of two modes:
%
% 1) Flight Mode: This mode is used during actual flight tests. Image
% processing occurs on streaming video transmitted from the quad. 
%
% 2) Simulation Mode: This mode is used to simualte the output of the
% image processing system for testing. We will develop vision-based 
% behaviors (e.g., to keep a target centered in the camera's view, or to
% pan the vehicle) in the autonomy node that will benefit from such
% synthetic data.
%
% Input:
%   - Video Stream over USB
%   - ROS topic: /stateEstimate
%   
% Output:
%   - ROS topic: /features (used by the autonomy node)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% prepare workspace
clear; close all; clc; format compact;
run('loadParams.m');
fprintf('Vision Node Launching...\n');

% initialize ROS
rosinit;
visionNode = robotics.ros.Node('/vision');
%featuresPublisher = robotics.ros.Publisher(visionNode,'features','terpcopter/features');
stateEstSubscriber = robotics.ros.Subscriber(visionNode,'stateEstimate','terpcopter/stateEstimate');

% main loop 
while (1)    
   % receive images over USB
   
   % process images
   
   % publish result as /features topic 
   
   % update GUI / display 
   printf('Vision: Published /features message.');   
   pause(1);
end



