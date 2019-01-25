% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About - reads the csv file conatining the state estimate parameter values 
%         And displays into the graphical plot
% 
% Input - 'plotPIDSetting_xx-xx-xxxx_xx:xx.csv'
% 
% Output - 4x1 Graphical plot containing Kp Ki Kd Ff
% 
% Note - Run this file in the results folder
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

clear all;  clc
 
% Reading the csv file data
    data = csvread('plotPIDSetting_01-17-2019_02:09.csv');
    prKp = data(:,1);
    prKi = data(:,2);
    prKd = data(:,3);
    prFf = data(:,4);
    
% Printing the figures
    figure()
    a1 = subplot(4,1,1);
    plot(prKp, 'r','LineWidth',3);
    xlabel('Time');
    ylabel('Kp');
    set(gca,'FontSize',25)
    legend('Proportional gain')
    set(gca,'FontSize',16)
    grid on;

    a2 = subplot(4,1,2);
    plot(prKi, 'g','LineWidth',3);
    xlabel('Time');
    ylabel('Ki');
    set(gca,'FontSize',25)
    legend('Integral gain')
    set(gca,'FontSize',16)
    grid on;

    a3 = subplot(4,1,3);
    plot(prKd, 'b','LineWidth',3);
    xlabel('Time');
    ylabel('Kd');
    set(gca,'FontSize',25)
    legend('Differential gain')
    set(gca,'FontSize',16)
    grid on;

    a4 = subplot(4,1,4);
    plot(prFf, 'k','LineWidth',3);
    xlabel('Time');
    ylabel('Ff');
    set(gca,'FontSize',25)
    legend('FeedForward')
    set(gca,'FontSize',16)
    grid on;
    
    %     Title for subplots
    sgt = sgtitle('PID Gains'); %raw data
    sgt.FontSize = 25;
    
    linkaxes([a1,a2,a3,a4],'x')