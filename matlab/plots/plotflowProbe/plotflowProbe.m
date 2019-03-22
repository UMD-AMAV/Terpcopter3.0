% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About - Reads the csv file conatining the flowProbe parameter values 
%         And displays into the graphical plot
% 
% Input - 'plotflowProbe_xx-xx-xxxx_xx:xx.csv'
% 
% Output - Graphical plot containing Velocity for Flow Probe
% 
% Note - Run this file in the results folder
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

clear all; clc

 % Reading the csv file data
    data = csvread('plotflowProbe_03-08-2019_15:56.csv'); %old 17:24 % 0.1kd old 17:42,17:53 
    prvelocity = data(:,1);

% Printing the figures
    figure()
%     a1 = subplot(2,1,1);
    plot(prvelocity, 'b','LineWidth',3);
    xlabel('Time');
    ylabel('velocity');
    set(gca,'FontSize',25)
    legend('Velocity')
    set(gca,'FontSize',16)
    grid on;
        
    %     Title for subplots
    sgt = sgtitle('Flow Probe'); %raw data
    sgt.FontSize = 25;