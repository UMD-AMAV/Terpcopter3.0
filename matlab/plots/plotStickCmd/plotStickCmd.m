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

clear all; clc

 % Reading the csv file data
    data = csvread('plotStickCmd_03-08-2019_14:54.csv'); %old 17:24 % 0.1kd old 17:42,17:53 
    prThrust = data(:,1);
    prYaw = data(:,2);
    prPitch = data(:,3);
    prRoll = data(:,4);

% Printing the figures
    figure()
    a1 = subplot(2,1,1);
    plot(prThrust, 'r','LineWidth',3);
    xlabel('Time');
    ylabel('Thrust');
    set(gca,'FontSize',25)
    legend('Thrust')
    set(gca,'FontSize',16)
    grid on;

    a2 = subplot(2,1,2);
    plot(prYaw, 'g','LineWidth',3);
    xlabel('Time');
    ylabel('Yaw');
    set(gca,'FontSize',25)
    legend('Yaw')
    set(gca,'FontSize',16)
    grid on;
    
%     a3 = subplot(4,1,3);
%     plot( prPitch , 'b','LineWidth',3);
%     xlabel('Time');
%     ylabel('Pitch');
%     set(gca,'FontSize',25)
%     legend('Pitch')
%     set(gca,'FontSize',16)
%     grid on;
%     
%     a4 = subplot(4,1,4);
%     plot(prRoll, 'k','LineWidth',3);
%     xlabel('Time');
%     ylabel('Roll');
%     set(gca,'FontSize',25)
%     legend('Roll')
%     set(gca,'FontSize',16)
%     grid on;
        
    %     Title for subplots
    sgt = sgtitle('Stick Cmd '); %raw data
    sgt.FontSize = 25;
    
%     linkaxes([a1,a2,a3,a4],'x')