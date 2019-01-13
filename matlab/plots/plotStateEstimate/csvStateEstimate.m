% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About -Subscribes to the state estimation topic and creates a csv file of
%        of the incoming data. The generated csv file is used by
%        plotStateEstimate.m file to plot the graphs.
% 
% Input - 'terpcopter_msgs/stateEstimate'
% 
% Output - plotStateEstimate.csv file
% 
% Note - 1) Values are added to .csv file at a constant rate.
%        2) Have to run this file for creating the .csv file won't start 
%           with the estimation node.
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

clear all; close all; clc;
% addpath('./results and plots');

% stateEstimate
% float32 time
% float32 north
% float32 east
% float32 up
% float32 yaw
% float32 pitch
% float32 roll

global stateEstimateMsg;
stateEstimateMsg = rosmessage('terpcopter_msgs/stateEstimate');
stateEstimateMsg.Time = 0 ;
stateEstimateMsg.North = 0 ;
stateEstimateMsg.East = 0 ;
stateEstimateMsg.Up = 0 ;
stateEstimateMsg.Yaw = 0 ;
stateEstimateMsg.Pitch = 0 ;
stateEstimateMsg.Roll = 0 ;

plotStateEstimateNode = robotics.ros.Node('/plotStateEstimate');
pStateEstimateSub = robotics.ros.Subscriber(plotStateEstimateNode,'stateEstimate','terpcopter_msgs/stateEstimate',{@stateEstimateCallback});

msg = receive(pStateEstimateSub);

pTime = msg.Time;
pNorth = msg.North;
pEast = msg.East;
pUp = msg.Up;
pYaw = msg.Yaw;
pPitch = msg.Pitch;
pRoll = msg.Roll;
    
% Add loop to check if the command is received
  while(1)
% if isempty(t1), t1 = state.dt; else, t1 = t1+state.dt; end   
    data = [pTime pNorth pEast pUp pYaw pPitch pRoll];
    fname = sprintf('plotStateEstimate_%s.csv', datestr(now,'mm-dd-yyyy_HH:MM:SS'));
    fid=fopen(fname,'a');
    fprintf(fid,'%6.6f,%6.6f,%6.6f,%6.6f,%6.6f, %6.6f,%6.6f\n',data(1),data(2),data(3),data(4), data(5), data(6), data(7));
    pause(0.1);
    fclose(fid); 
  end
