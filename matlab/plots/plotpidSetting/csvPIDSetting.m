% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About -Subscribes to the pid settings topic and creates a csv file of
%        of the incoming data. The generated csv file is used by
%        plotPIDSetting.m file to plot the graphs.
% 
% Input - 'terpcopter_msgs/ffpidSettting'
% 
% Output - plotPIDSetting.csv file
% 
% Note - 1) Values are added to .csv file at a constant rate.
%        2) Have to run this file for creating the .csv file won't start 
%           with the estimation node.
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

clear all; close all; clc;
% addpath('./results');

% pidSetting
% float32 kp
% float32 ki
% float32 kd
% float32 ff

global ffpidSettingMsg;
ffpidSettingMsg= rosmessage('terpcopter_msgs/ffpidSetting');
ffpidSettingMsg.Kp = 0 ;
ffpidSettingMsg.Ki = 0 ;
ffpidSettingMsg.Kd = 0 ;
ffpidSettingMsg.Ff = 0 ;

plotpidSettingNode = robotics.ros.Node('/plotpidSetting');
pidSettingSub = robotics.ros.Subscriber(plotpidSettingNode,'pidSetting','terpcopter_msgs/ffpidSetting',{@ffpidSettingCallback});

msg = receive(pidSettingSub,20);

fname = sprintf('plotPIDSetting_%s.csv', datestr(now,'mm-dd-yyyy_HH:MM'));
fid=fopen(fname,'a');

% Add loop to check if the command is received
  while(1)
% if isempty(t1), t1 = state.dt; else, t1 = t1+state.dt; end   
    pKp =  ffpidSettingMsg.Kp;
    pKi =  ffpidSettingMsg.Ki;
    pKd =  ffpidSettingMsg.Kd;
    pFf =  ffpidSettingMsg.Ff;
    data = [pKp pKi pKd pFf];
    fprintf(fid,'%6.6f,%6.6f,%6.6f,%6.6f\n',data(1),data(2),data(3),data(4));
    pause(0.1); 
  end
fclose(fid);