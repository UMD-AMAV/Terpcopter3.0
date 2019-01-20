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

clear all; close all; clc;

% Reading the csv file data
    data = csvread('plotahsCmd.csv');
    prAltitudeMeters = data(:,1);
    prForwardSpeedMps = data(:,2);
    prCrabSpeedMps = data(:,3);
    prHeadingRad = data(:,4);

    % Printing the figures
    figure(1)
    a1 = subplot(4,1,1);
    plot(prAltitudeMeters, 'r-');
    xlabel('iteration');
    ylabel('Altitude');
    set(gca,'FontSize',25)
    legend('Altitude in Meters')
    set(gca,'FontSize',16)
    grid on;

    a2 = subplot(4,1,2);
    plot(prForwardSpeedMps, 'g');
    xlabel('iteration');
    ylabel('Forward Speed');
    set(gca,'FontSize',25)
    legend('Forward Speed')
    set(gca,'FontSize',16)
    grid on;

    a3 = subplot(4,1,3);
    plot(prCrabSpeedMps, 'b');
    xlabel('iteration');
    ylabel('Crab speed');
    set(gca,'FontSize',25)
    legend('Crab speed')
    set(gca,'FontSize',16)
    grid on;

    a4 = subplot(4,1,4);
    plot(prHeadingRad, 'k');
    xlabel('iteration');
    ylabel('Heading Rad');
    set(gca,'FontSize',25)
    legend('Heading Rad')
    set(gca,'FontSize',16)
    grid on;
    
    linkaxes([a1,a2,a3,a4],'x')