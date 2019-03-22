% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About - Reads the csv file conatining the terarangerone parameter values 
%         And displays into the graphical plot
% 
% Input - 'terarangerone_xx-xx-xxxx_xx:xx.csv'
% 
% Output - Graphical plot containing Range for terarangerone
% 
% Note - Run this file in the results folder
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

clear all; clc;

% float32 field_of_view
% float32 min_range
% float32 max_range
% float32 range

% Reading the csv file data
    data = csvread('plotTerarangerone_02-21-2019_18:01.csv');
    prfield_of_view = data(:,1);
    prmin_range = data(:,2);
    prmax_range = data(:,3);
    prrange = data(:,4);
    
% Printing the figures
    figure()
%     a1 = subplot(3,2,1);
%     plot(prfield_of_view,'g');
%     xlabel('Time');
%     ylabel('FOV');
%     set(gca,'FontSize',25)
%     legend('Field of View')
%     set(gca,'FontSize',16)
%     grid on;
% 
%     a2 = subplot(3,2,3);
%     plot(prmin_range, 'c');
%     xlabel('Time');
%     ylabel('Min Range');
%     set(gca,'FontSize',25)
%     legend('Min Range')
%     set(gca,'FontSize',16)
%     grid on;
% %     linkaxes([a1,a2],'xy')
% 
%     a3 = subplot(3,2,5);
%     plot(prmax_range, 'b');
%     xlabel('Time');
%     ylabel('Max Range');
%     set(gca,'FontSize',25)
%     legend('Max Range')
%     set(gca,'FontSize',16)
%     grid on;
        
%     a4 = subplot(3,2,2);
    plot(prrange, 'g','LineWidth',3);
    xlabel('Time');
    ylabel('Range');
    set(gca,'FontSize',35)
    legend('Range')
    title('Lidar Raw data')
    set(gca,'FontSize',20 )
    grid on;
    
%     linkaxes([a1,a2,a3,a4],'x')
    % linkaxes([a3,a4],'xy')