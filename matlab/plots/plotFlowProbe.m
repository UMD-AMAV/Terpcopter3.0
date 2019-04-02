% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About - Reads the csv file conatining the flowProbe parameter values 
%         And displays into the graphical plot
% 
% Input - 'plotflowProbe_mm-dd-yyyy_HH:MM.csv' and 'plotStateEstimate_mm-dd-yyyy_HH:MM.csv'
% 
% Output - Graphical plot containing Velocity for Flow Probe
% 
% Note - Run this file in the results folder
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

function plotFlowProbe(csvFlowProbe,csvStateEstimate)
% clear all; clc

% Reading the FlowProbe csv file data
dataFlowProbe = csvread(csvFlowProbe); %old 17:24 % 0.1kd old 17:42,17:53 
prvelocity = dataFlowProbe(:,1);

% Reading StateEatimate csv file for Time
dataStateEstimate = csvread(csvStateEstimate);
prTime = dataStateEstimate(:,2);

% Printing the figures
figure()
plot(prTime, prvelocity, 'b','LineWidth',3);
xlabel('Time');
ylabel('Forward Velocity');
set(gca,'FontSize',25)
legend('Forward Velocity ')
set(gca,'FontSize',16)
grid on;

% Title for subplots
sgt = sgtitle('Flow Probe'); %raw data
sgt.FontSize = 25;

end
