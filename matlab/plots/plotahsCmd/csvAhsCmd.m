% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author- Team AMAV 2018-2019
% 
% About - Subscribes to ahs command and state estimation topic and 
%        creates a csv file of the incoming data. The generated csv 
%        file is used by plotAhsCmd.m file to plot the graphs.
% 
% Input - 'terpcopter_msgs/ahsCmd'
%         'terpcopter_msgs/stateEstimate'
% 
% Output - plotAhsCmd.csv file 
% 
% Note - 1) Values are added to .csv file at a constant rate.
%        2) Have to run this file for creating the .csv file won't start 
%           with the ahsCmd node.
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

clear all; close all; clc;
% savepath('./matlab/results');
directory = '/home/kapil/Desktop/ROSTerpcopterModule/Terpcopter3.0/matlab/results';

%  ahsCmd
%  altitudeMeters
%  headingRad
%  forwardSpeedMps
%  crabSpeedMps

global ahsCmdMsg;
ahsCmdMsg = rosmessage('terpcopter_msgs/ahsCmd');
ahsCmdMsg.AltitudeMeters = 0;
ahsCmdMsg.HeadingRad = 0;
ahsCmdMsg.ForwardSpeedMps = 0;
ahsCmdMsg.CrabSpeedMps = 0;

% global stateEstimateMsg;
% stateEstimateMsg = rosmessage('terpcopter_msgs/stateEstimate');
% stateEstimateMsg.Time = 0 ;

plotahsCmdNode = robotics.ros.Node('/plotahsCmd1');
pahsCmdMsg = robotics.ros.Subscriber(plotahsCmdNode,'ahsCmd','terpcopter_msgs/ahsCmd',{@ahsCmdCallback});
% pStateEstimateSub = robotics.ros.Subscriber(plotahsCmdNode,'stateEstimate','terpcopter_msgs/stateEstimate',{@stateEstimateCallback});


msg = receive(pahsCmdMsg,20);
% msgTime = receive(pStateEstimateSub,20);

fname = sprintf('plotahsCmd_%s.csv', datestr(now,'mm-dd-yyyy_HH:MM'));
fileDest  = fullfile(directory,fname);
fid=fopen(fileDest,'a');

% Creating the csv file for the ahs Command data.
%     if isempty(t1), t1 = state.dt; else, t1 = t1+state.dt; end 
   while(1)
 pAltitudeMeters = ahsCmdMsg.AltitudeMeters;
 pForwardSpeedMps = ahsCmdMsg.ForwardSpeedMps;
 pCrabSpeedMps = ahsCmdMsg.CrabSpeedMps;
 pHeadingRad = ahsCmdMsg.HeadingRad; 
%  pTime = stateEstimateMsg.Time;
 data = [pAltitudeMeters pForwardSpeedMps pCrabSpeedMps pHeadingRad];
 fprintf(fid,'%6.6f,%6.6f,%6.6f,%6.6f\n',data(1),data(2),data(3),data(4));
 pause(0.1); 
   end
fclose(fid);
