% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About -Run this file to launch all live plots.
% 
% Output - displays the live plots.
% 
% Note :1) Before running this file check if the /stateEstimate,
%          /Terarangerone, /pidSetting, /plotStickCmd, /AhsCmd, /terpcopter_flow_probe_node/flowProbe.
%       2) If you want to run the selected live plots comment out otherplot.
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

addpath('./plots/plotStateEstimate')
livePlotStateEstimate;

addpath('./plots/plotTerarangerone')
livePlotTerarangerone;

addpath('./plots/plotpidSetting')
livePlotPIDSetting;

addpath('./plots/plotStickCmd')
livePlotStickCmd;

addpath('./plots/plotahsCmd')
livePlotAhsCmd;

addpath('./plots/plotflowProbe')
liveplotflowProbe;
