% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About - Reads the csv file conatining the state estimate parameter values 
%         And displays into the graphical plot
% 
% Input - 'plotStateEstimation_xx-xx-xxxx_xx:xx.csv'
% 
% Output - 3x2 Graphical plot containing North East Up Yaw Pitch Roll
% 
% Note - Run this file in the results folder
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

clear all; clc
addpath('./results');

% Reading the csv file data
    data = csvread('plotStateEstimate_02-21-2019_18:21.csv');
    prRange = data(:,1);
    prTime = data(:,2);
    prNorth = data(:,3);
    prEast = data(:,4);
    prUp = data(:,5);
    prYaw = data(:,6);
    prPitch = data(:,7);
    prRoll = data(:,8);
%     y(1:250) =1;
% Printing the figures
    figure1 = figure();
    title('State Estimate')
%     a1 = subplot(3,2,1);
%     plot(prNorth,'g','LineWidth',3);
%     xlabel('Time');
%     ylabel('North direction');
%     set(gca,'FontSize',25)
%     legend('North direction')
%     set(gca,'FontSize',16)
%     grid on;
% 
%     a2 = subplot(3,2,3);
%     plot(prEast, 'c','LineWidth',3);
%     xlabel('Time');
%     ylabel('East direction');
%     set(gca,'FontSize',25)
%     legend('East direction')
%     set(gca,'FontSize',16)
%     grid on;
% %     linkaxes([a1,a2],'xy')
% 
%   a3 = subplot(3,2,5);
    subplot(1,2,1);
    hold on;
    plot(prUp, 'b','LineWidth',3);
%     plot(y(1:80),'k--','LineWidth',3);
    xlabel('Time in s');
    ylabel('Altitude in m');
    set(gca,'FontSize',25)
    legend('Actual Altitude')
    set(gca,'FontSize',16)
    grid on;
    hold off;
%     saveas(figure1,'Altitude.png');
    
%     a4 = subplot(3,2,2);
    subplot(1,2,2)
    plot(prYaw, 'm','LineWidth',3);
    xlabel('Time');
    ylabel('Yaw');
    set(gca,'FontSize',25)
    legend('Yaw')
    set(gca,'FontSize',16)
    grid on;

%     a5 = subplot(3,2,4);
%     plot(prPitch, 'r','LineWidth',3);
%     xlabel('Time');
%     ylabel('Pitch');
%     set(gca,'FontSize',25)
%     legend('Pitch')
%     set(gca,'FontSize',16)
%     grid on;

%     a6 = subplot(3,2,6);
%     plot(prRoll, 'k','LineWidth',3);
%     xlabel('Time');
%     ylabel('Roll');
%     set(gca,'FontSize',25)
%     legend('Roll')
%     set(gca,'FontSize',16)
%     grid on;
%     
% %     Title for subplots
%     sgt = sgtitle('State Estimate '); %raw data
%     sgt.FontSize = 25;
%     
%     linkaxes([a1,a2,a3,a4,a5,a6],'x')
%     % linkaxes([a3,a4],'xy')