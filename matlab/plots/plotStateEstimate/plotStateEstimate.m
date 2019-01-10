% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About - reads the csv file conatining the state estimate parameter values 
%         And displays into the graphical plot
% 
% Input - 'plotStateEstimation.csv'
% 
% Output - 3x2 Graphical plot containing North East Up Yaw Pitch Roll
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

clear all; close all; clc

% Reading the csv file data
    data = csvread('plotStateEstimate.csv');
    prNorth = data(:,1);
    prEast = data(:,2);
    prUp = data(:,3);
    prYaw = data(:,4);
    prPitch = data(:,5);
    prRoll = data(:,6);
    
% Printing the figures
    figure(1)
    subplot(3,2,1)
    plot(prNorth, 'r-');
    xlabel('iteration');
    ylabel('North direction');
    grid on;

    subplot(3,2,3)
    plot(prEast, 'r-');
    xlabel('iteration');
    ylabel('East direction');
    grid on;

    subplot(3,2,5)
    plot(prUp, 'r-');
    xlabel('iteration');
    ylabel('Up direction');
    grid on;

    subplot(3,2,2)
    plot(prYaw, 'r-');
    xlabel('iteration');
    ylabel('Yaw');
    grid on;

    subplot(3,2,4)
    plot(prPitch, 'r-');
    xlabel('iteration');
    ylabel('Pitch');
    grid on;

    subplot(3,2,6)
    plot(prRoll, 'r-');
    xlabel('iteration');
    ylabel('Roll');
    grid on;