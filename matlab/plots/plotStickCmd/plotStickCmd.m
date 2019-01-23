% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About - reads the csv file conatining the stick command parameter values 
%         And displays into the graphical plot
% 
% Input - 'plotStickCmd_xx-xx-xxxx_xx:xx.csv'
% 
% Output - 4x1 Graphical plot containing Thrust Yaw Pitch Roll
% 
% Note - Run this file in the results folder
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

clear all; close all; clc

 % Reading the csv file data
    data = csvread('plotStickCmd_01-17-2019_01:28.csv');
    prThrust = data(:,1);
    prYaw = data(:,2);
    prPitch = data(:,3);
    prRoll = data(:,4);

% Printing the figures
    figure(1)
    a1 = subplot(4,1,1);
    plot(prThrust, 'r');
    xlabel('Time');
    ylabel('Thrust');
    set(gca,'FontSize',25)
    legend('Thrust')
    set(gca,'FontSize',16)
    grid on;

    a2 = subplot(4,1,2);
    plot(prYaw, 'g');
    xlabel('Time');
    ylabel('Yaw');
    set(gca,'FontSize',25)
    legend('Yaw')
    set(gca,'FontSize',16)
    grid on;
    
    a3 = subplot(4,1,3);
    plot( prPitch , 'b');
    xlabel('Time');
    ylabel('Pitch');
    set(gca,'FontSize',25)
    legend('Pitch')
    set(gca,'FontSize',16)
    grid on;
    
    a4 = subplot(4,1,4);
    plot(prRoll, 'k');
    xlabel('Time');
    ylabel('Roll');
    set(gca,'FontSize',25)
    legend('Roll')
    set(gca,'FontSize',16)
    grid on;
    
    linkaxes([a1,a2,a3,a4],'x')