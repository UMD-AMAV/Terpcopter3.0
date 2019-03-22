% % % % % % % % % % % % % % % % % % % % % % % % %09 % % % % % % % % % % % % %
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
    data = csvread('plotahsCmd_03-08-2019_14:54.csv');
    prAltitudeMeters = data(:,1);
    prForwardSpeedMps = data(:,2);
    prCrabSpeedMps = data(:,3);
    prHeadingRad = data(:,4);

    data = csvread('plotStateEstimate_03-08-2019_14:54.csv');
%     prRange = data(:,1);
%     prTime = data(:,2);
%     prNorth = data(:,3);
%     prEast = data(:,4);
    prUp = data(:,5);
    prYaw = data(:,6);
%     prPitch = data(:,7);
%     prRoll = data(:,8);
    
    % Printing the figures
    figure()
%     a1 = subplot(4,1,1);
   subplot(1,2,1)
    plot(prAltitudeMeters, 'r','LineWidth',3);
    hold on
    plot(prUp, 'b','LineWidth',3);  %here 
    xlabel('iteration');
    ylabel('Altitude');
    set(gca,'FontSize',25)
    legend('Ahs Actual Altitude','stateEstimate Altitude in Meters')
%     legend('Actual Altitude') %here 
    set(gca,'FontSize',16)
    grid on;

%     a2 = subplot(4,1,2);
%     plot(prForwardSpeedMps, 'g','LineWidth',3);
%     xlabel('iteration');
%     ylabel('Forward Speed');
%     set(gca,'FontSize',25)
%     legend('Forward Speed')
%     set(gca,'FontSize',16)
%     grid on;
% 
%     a3 = subplot(4,1,3);
%     plot(prCrabSpeedMps, 'b','LineWidth',3);
%     xlabel('iteration');
%     ylabel('Crab speed');
%     set(gca,'FontSize',25)
%     legend('Crab speed')
%     set(gca,'FontSize',16)
%     grid on;

%     a4 = subplot(4,1,4);
        subplot(1,2,2)
        plot(prHeadingRad, 'k','LineWidth',3);
        hold on
        plot(prYaw, 'm','LineWidth',3);
        xlabel('iteration');
        ylabel('Heading Rad');
        set(gca,'FontSize',25)
        legend('Ahs Heading Rad','stateEstimate Yaw')
    %     legend('Yaw')
        set(gca,'FontSize',16)
        grid on;
        
    
%     subplot(1,2,1);
%     hold on;
%     plot(prUp, 'b','LineWidth',3);
% %     plot(y(1:80),'k--','LineWidth',3);
%     xlabel('Time in s');
%     ylabel('Altitude in m');
%     set(gca,'FontSize',25)
%     legend('Actual Altitude')
%     set(gca,'FontSize',16)
%     grid on;
%     hold off;
% %     saveas(figure1,'Altitude.png');
%     
% %     a4 = subplot(3,2,2);
%     subplot(1,2,2)
%     plot(prYaw, 'm','LineWidth',3);
%     xlabel('Time');
%     ylabel('Yaw');
%     set(gca,'FontSize',25)
%     legend('Yaw')
%     set(gca,'FontSize',16)
%     grid on;
%     
    
    %     Title for subplots
    sgt = sgtitle('AHS plots'); %raw data
    sgt.FontSize = 25;
    
%     linkaxes([a1,a2,a3,a4],'x')