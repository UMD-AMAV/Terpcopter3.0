% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About -Run this file to launch all plots.
% 
% Output - displays the plots.
% 
% Note :1) Before running this file add the latest csv files to the plot script
%          for the /stateEstimate, /Terarangerone, /pidSetting, /plotStickCmd, /terpcopter_flow_probe_node/flowProbe
%           /livePlotAhsCmd topics in each file respectively.
%       2) If you want to run the selected plots comment out other plot.
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

addpath('./plots/plotStateEstimate')
plotStateEstimate;

addpath('./plots/plotTerarangerone')
plotTerarangerone;

addpath('./plots/plotpidSetting')
plotPIDSetting;

addpath('./plots/plotStickCmd')
plotStickCmd;

addpath('./plots/plotflowProbe')
plotflowProbe;
