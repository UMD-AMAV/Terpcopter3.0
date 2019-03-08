% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About -Subscribes to the Terarangerone topic and creates a csv file of
%        of the incoming data. The generated csv file is used by
%        plotTerarangerone.m file to plot the graphs.
% 
% Input - 'sensor_msgs/Range'
% 
% Output - plotTerarangerone_xx-xx-xxxx_xx:xx.csv file
% 
% Note - 1) Values are added to .csv file at a constant rate.
%        2) Have to run this file for creating the .csv file won't start 
%           without the Terarangerone node.
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

clear all; close all; clc;
% addpath('./results');
directory = '/home/kapil/Desktop/ROSTerpcopterModule/Terpcopter3.0/matlab/results';

% float32 field_of_view
% float32 min_range
% float32 max_range
% float32 range

global terarangeroneMsg;
terarangeroneMsg = rosmessage('sensor_msgs/Range');
terarangeroneMsg.FieldOfView = 0;
terarangeroneMsg.MinRange = 0;
terarangeroneMsg.MaxRange = 0;
terarangeroneMsg.Range_= 0;

plotTerarangeroneNode = robotics.ros.Node('/plotTerarangerone');
pTerarangeroneSub = robotics.ros.Subscriber(plotTerarangeroneNode,'/terarangerone','sensor_msgs/Range',{@terarangeroneCallback});

msg = receive(pTerarangeroneSub,20);

fname = sprintf('plotTerarangerone_%s.csv', datestr(now,'mm-dd-yyyy_HH:MM'));
fileDest  = fullfile(directory,fname);
fid=fopen(fileDest,'a');

% Add loop to check if the command is received
  while(1)
% if isempty(t1), t1 = state.dt; else, t1 = t1+state.dt; end   
    field_of_view = terarangeroneMsg.FieldOfView;
    min_range = terarangeroneMsg.MinRange;
    max_range = terarangeroneMsg.MaxRange;
    range = terarangeroneMsg.Range_;
    data = [field_of_view min_range max_range range];
    fprintf(fid,'%6.6f,%6.6f,%6.6f,%6.6f\n',data(1),data(2),data(3),data(4));
    pause(0.1);
  end
fclose(fid);