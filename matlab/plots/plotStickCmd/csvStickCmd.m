% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author- Team AMAV 2018-2019
% 
% About -Subscribes to stick commands and state estimation topic and 
%        creates a csv file of the incoming data. The generated csv file 
%        is used by plotStateEstimate.m file to plot the graphs.
% 
% Input -  'terpcopter_msgs/stickCmd'
%          'terpcopter_msgs/stateEstimate'
% 
% Output - plotStickCmd.csv file 
% 
% Note - 1) Values are added to .csv file at a constant rate.
%        2) Have to run this file for creating the .csv file won't start 
%           with the stick command node.
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

clear all; close all; clc;
addpath('./results and plots');

% stickCmd
% float32 thrust
% float32 yaw
% float32 pitch
% float32 roll

global stickCmdMsg;
stickCmdMsg = rosmessage('terpcopter_msgs/stickCmd');
stickCmdMsg.Thrust =0;
stickCmdMsg.Yaw= 0;
stickCmdMsg.Pitch= 0;
stickCmdMsg.Roll=0;

global stateEstimateMsg;
stateEstimateMsg = rosmessage('terpcopter_msgs/stateEstimate');
stateEstimateMsg.Time = 0 ;

plotStickCmdNode = robotics.ros.Node('/plotStickCmd');
plotStickCmdSub = robotics.ros.Subscriber(plotStickCmdNode,'stickCmd','terpcopter_msgs/stickCmd',{@stickCmdCallback});
pStateEstimateSub = robotics.ros.Subscriber(plotStickCmdNode,'stateEstimate','terpcopter_msgs/stateEstimate',{@stateEstimateCallback});


msg = receive(plotStickCmdSub);
msgTime = receive(pStateEstimateSub);

pthrust = msg.Thrust;
pyaw = msg.Yaw;
ppitch = msg.Pitch;
proll = msg.Roll;
ptime = msgTime.Time;


% if isempty(t1), t1 = state.dt; else, t1 = t1+state.dt; end
while(1) 
 data = [ptime pthrust pyaw ppitch proll];
 fname = sprintf('plotStickCmd_%s.csv', datestr(now,'mm-dd-yyyy_HH:MM:SS'));
 fid=fopen(fname,'a');
 fprintf(fid,'%6.6f,%6.6f,%6.6f,%6.6f,%6.6f\n',data(1),data(2),data(3),data(4), data(5));
 pause(0.1);
 fclose(fid);
end
