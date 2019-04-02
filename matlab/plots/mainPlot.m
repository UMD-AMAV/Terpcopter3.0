% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About -Subscribes to the /stateEstimate, /ahsCmd, /stcikCmd and /flowprobe
%        topic and creates a csv file in the results folder.
%        The generated csv file is used by plotTopicName function to plot the graphs.
% 
% Input - Topics to be subscribed
% 
% Output - results/topicname_mm-dd-yyyy_HH:MM.csv file
% 
% Note - 1) Before running this file Create a folder named results in matlab
%        2) Have to run this file for creating the .csv file.
%	 3) Values are added to .csv file as a msg is received using callback.
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


rosshutdown
rosinit

global directory
global date

% Set path to matlab results
directory = './Terpcopter3.0/matlab/results';

% Start time
date = datestr(now,'mm-dd-yyyy_HH:MM');

% Creates csv files for topics
stateEstimateCSVsub = rossubscriber('/stateEstimate',@callBackStateEstimate);
ahsCmdCSVsub = rossubscriber('/ahsCmd',@callBackAhsCmd);
stickCmdCSVsub = rossubscriber('/stickCmd',@callBackStickCmd);
flowprobeCSVsub = rossubscriber('terpcopter_flow_probe_node/flowProbe',@callBackFlowProbe);

% Plot functions for graph, For each topics Copy and paste below command in matlab terminal to display plots.
%plotStateEstimate(sprintf('plotStateEstimate_%s.csv',date));
%plotAhsCmd(sprintf('plotAhsCmd_%s.csv',date),sprintf('plotStateEstimate_%s.csv',date));
%plotStickCmd(sprintf('plotStickCmd_%s.csv',date),sprintf('plotStateEstimate_%s.csv',date));
%plotFlowProbe(sprintf('plotflowProbe_%s.csv',date),sprintf('plotStateEstimate_%s.csv',date));
