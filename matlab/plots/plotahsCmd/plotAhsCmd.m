% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About - Reads the csv file conatining the Altitude heading and speed parameter values 
%         And displays into the graphical plot
% 
% Input - 'plotahsCmd_xx-xx-xxxx_xx:xx.csv'
% 
% Output - 4x1 Graphical plot containing Altitude ForwardSpeed CrabSpeed HeadingRad
% 
% Note -Run this file in the results folder
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

clear all; clc;

% Reading the csv file data
    data = csvread('plotahsCmd_01-17-2019_02:00.csv');
    prAltitudeMeters = data(:,1);
    prForwardSpeedMps = data(:,2);
    prCrabSpeedMps = data(:,3);
    prHeadingRad = data(:,4);

    % Printing the figures
    figure()
    a1 = subplot(4,1,1);
    plot(prAltitudeMeters, 'r','LineWidth',3);
    xlabel('iteration');
    ylabel('Altitude');
    set(gca,'FontSize',25)
    legend('Altitude in Meters')
    set(gca,'FontSize',16)
    grid on;

    a2 = subplot(4,1,2);
    plot(prForwardSpeedMps, 'g','LineWidth',3);
    xlabel('iteration');
    ylabel('Forward Speed');
    set(gca,'FontSize',25)
    legend('Forward Speed')
    set(gca,'FontSize',16)
    grid on;

    a3 = subplot(4,1,3);
    plot(prCrabSpeedMps, 'b','LineWidth',3);
    xlabel('iteration');
    ylabel('Crab speed');
    set(gca,'FontSize',25)
    legend('Crab speed')
    set(gca,'FontSize',16)
    grid on;

    a4 = subplot(4,1,4);
    plot(prHeadingRad, 'k','LineWidth',3);
    xlabel('iteration');
    ylabel('Heading Rad');
    set(gca,'FontSize',25)
    legend('Heading Rad')
    set(gca,'FontSize',16)
    grid on;
    
    %     Title for subplots
    sgt = sgtitle('AHS plots'); %raw data
    sgt.FontSize = 25;
    
    linkaxes([a1,a2,a3,a4],'x')