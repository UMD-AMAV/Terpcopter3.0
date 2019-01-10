% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About - reads the csv file conatining the stick command parameter values 
%         And displays into the graphical plot
% 
% Input - 'plotStickCmd.csv'
% 
% Output - 4x1 Graphical plot containing Thrust Yaw Pitch Roll
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % c

lear all; close all; clc

 % Reading the csv file data
    data = csvread('plotStickCmd.csv');
    prThrust = data(:,1);
    prYaw = data(:,2);
    prPitch = data(:,3);
    prRoll = data(:,4);

% Printing the figures
    figure(1)
    subplot(4,1,1)
    plot(prThrust, 'r-');
    xlabel('iteration');
    ylabel('Thrust');
    grid on;

    subplot(4,1,2)
    plot(pyaw, 'r-');
    xlabel('iteration');
    ylabel('Yaw');
    grid on;
    
    subplot(4,1,3)
    plot( ppitch , 'r-');
    xlabel('iteration');
    ylabel('Pitch');
    grid on;
    
    subplot(4,1,4)
    plot(proll, 'r-');
    xlabel('iteration');
    ylabel('Roll');
    grid on;