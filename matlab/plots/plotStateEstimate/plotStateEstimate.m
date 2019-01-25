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

% Reading the csv file data
    data = csvread('plotStateEstimate_01-17-2019_02:08.csv');
    prRange = data(:,1);
    prNorth = data(:,2);
    prEast = data(:,3);
    prUp = data(:,4);
    prYaw = data(:,5);
    prPitch = data(:,6);
    prRoll = data(:,7);
    
% Printing the figures
    figure()
    title('State Estimate')
    a1 = subplot(3,2,1);
    plot(prNorth,'g','LineWidth',3);
    xlabel('Time');
    ylabel('North direction');
    set(gca,'FontSize',25)
    legend('North direction')
    set(gca,'FontSize',16)
    grid on;

    a2 = subplot(3,2,3);
    plot(prEast, 'c','LineWidth',3);
    xlabel('Time');
    ylabel('East direction');
    set(gca,'FontSize',25)
    legend('East direction')
    set(gca,'FontSize',16)
    grid on;
%     linkaxes([a1,a2],'xy')

    a3 = subplot(3,2,5);
    plot(prRange, 'b','LineWidth',3);
    xlabel('Time');
    ylabel('Up');
    set(gca,'FontSize',25)
    legend('Up')
    set(gca,'FontSize',16)
    grid on;
        
    a4 = subplot(3,2,2);
    plot(prYaw, 'm','LineWidth',3);
    xlabel('Time');
    ylabel('Yaw');
    set(gca,'FontSize',25)
    legend('Yaw')
    set(gca,'FontSize',16)
    grid on;

    a5 = subplot(3,2,4);
    plot(prPitch, 'r','LineWidth',3);
    xlabel('Time');
    ylabel('Pitch');
    set(gca,'FontSize',25)
    legend('Pitch')
    set(gca,'FontSize',16)
    grid on;

    a6 = subplot(3,2,6);
    plot(prRoll, 'k','LineWidth',3);
    xlabel('Time');
    ylabel('Roll');
    set(gca,'FontSize',25)
    legend('Roll')
    set(gca,'FontSize',16)
    grid on;
    
%     Title for subplots
    sgt = sgtitle('State Estimate '); %raw data
    sgt.FontSize = 25;
    
    linkaxes([a1,a2,a3,a4,a5,a6],'x')
    % linkaxes([a3,a4],'xy')