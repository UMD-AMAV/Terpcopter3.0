% % % % % % % % % % % % % % % % % % % % % % % % %09 % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About - Reads the csv file conatining the Altitude heading and speed parameter values 
%         And displays into the graphical plot
% 
% Input - 'plotahsCmd_mm-dd-yyyy_HH:MM.csv' and 'plotStateEstimate_mm-dd-yyyy_HH:MM.csv'
% 
% Output - 4x1 Graphical plot containing Altitude ForwardSpeed CrabSpeed HeadingRad
% 
% Note -Run this file in the results folder
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

function plotAhsCmd(csvAhsCmd,csvStateEstimate)
% clear all; clc;

% Reading the csv file data
dataAhsCmd = csvread(csvAhsCmd);
prAltitudeMeters = dataAhsCmd(:,1);
prForwardSpeedMps = dataAhsCmd(:,2);
prCrabSpeedMps = dataAhsCmd(:,3);
prHeadingRad = dataAhsCmd(:,4);


dataStateEstimate = csvread(csvStateEstimate);
% prRange = data(:,1);
prTime = dataStateEstimate(:,2);
% prNorth = data(:,3);
% prEast = data(:,4);
% prUp = dataStateEstimate(:,5);
% prYaw = dataStateEstimate(:,6);
% prPitch = data(:,7);
% prRoll = data(:,8);
    
% Printing the figures
figure()
a1 = subplot(4,1,1);
plot(prTime,prAltitudeMeters, 'r','LineWidth',3);
xlabel('Time');
ylabel('Altitude');
set(gca,'FontSize',25)
legend('Altitude') 
set(gca,'FontSize',16)
grid on;

a2 = subplot(4,1,2);
plot(prTime,prForwardSpeedMps, 'g','LineWidth',3);
xlabel('Time');
ylabel('Forward Speed');
set(gca,'FontSize',25)
legend('Forward Speed')
set(gca,'FontSize',16)
grid on;

a3 = subplot(4,1,3);
plot(prTime,prCrabSpeedMps, 'b','LineWidth',3);
xlabel('Time');
ylabel('Crab speed');
set(gca,'FontSize',25)
legend('Crab speed')
set(gca,'FontSize',16)
grid on;
     
a4 = subplot(4,1,4);
plot(prTime,prHeadingRad, 'm','LineWidth',3);
xlabel('Time');
ylabel('HeadingRad');
set(gca,'FontSize',25)
legend('HeadingRad')
set(gca,'FontSize',16)
grid on;

% Title for subplots
sgt = sgtitle('Altitude plot'); %raw data
sgt.FontSize = 25;
    
linkaxes([a1,a2,a3,a4],'x')
end
