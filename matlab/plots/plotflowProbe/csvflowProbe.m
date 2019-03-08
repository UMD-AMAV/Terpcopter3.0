% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About -Subscribes to the flowProbe topic and creates a csv file of
%        of the incoming data. The generated csv file is used by
%        plotflowProbe.m file to plot the graphs.
% 
% Input - 'std_msgs/Float32'
% 
% Output - plotflowProbe_xx-xx-xxxx_xx:xx.csv file
% 
% Note - 1) Values are added to .csv file at a constant rate.
%        2) Have to run this file for creating the .csv file won't start 
%           without the Terarangerone node.
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

clear all; close all; clc;
% addpath('./results');
directory = '/home/kapil/Desktop/ROSTerpcopterModule/Terpcopter3.0/matlab/results';
% flowProbe
% float32 Data

global flowProbeMsg;
flowProbeMsg = rosmessage('std_msgs/Float32');
flowProbeMsg.Data =0;

plotflowProbeNode = robotics.ros.Node('/plotflowProbe');
plotflowProbeSub = robotics.ros.Subscriber(plotflowProbeNode,'terpcopter_flow_probe_node/flowProbe','std_msgs/Float32',{@flowProbeCallback});

msg = receive(plotflowProbeSub,20);
% msgTime = receive(pStateEstimateSub,20);

fname = sprintf('plotflowProbe_%s.csv', datestr(now,'mm-dd-yyyy_HH:MM'));
fileDest  = fullfile(directory,fname);
fid=fopen(fileDest,'a');
 
while(1) 
 pvelocity = flowProbeMsg.Data;
 data = [pvelocity];
 fprintf(fid,'%6.6f\n',data(1));
 pause(0.1);
end
fclose(fid);