% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About - reads the csv file conatining the Altitude heading and speed parameter values 
%         And displays into the graphical plot
% 
% Input - 'plotahsCmd.csv'
% 
% Output - 4x1 Graphical plot containing Altitude ForwardSpeed CrabSpeed HeadingRad
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
    subplot(4,1,1)
    plot(prAltitudeMeters, 'r-');
    xlabel('iteration');
    ylabel('Altitude in meters');
    grid on;

    subplot(4,1,2)
    plot(prForwardSpeedMps, 'r-');
    xlabel('iteration');
    ylabel('Forward Speed');
    grid on;

    subplot(4,1,3)
    plot(prCrabSpeedMps, 'r-');
    xlabel('iteration');
    ylabel('Crab speed ');
    grid on;

    subplot(4,1,4)
    plot(prHeadingRad, 'r-');
    xlabel('iteration');
    ylabel('Heading Rad');
    grid on;