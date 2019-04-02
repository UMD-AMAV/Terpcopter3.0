% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About - reads the csv file conatining the stick command parameter values 
%         And displays into the graphical plot
% 
% Input - 'plotStickCmd_mm-dd-yyyy_HH:MM.csv' and 'plotStateEstimate_mm-dd-yyyy_HH:MM.csv'
% 
% Output - 4x1 Graphical plot containing Thrust Yaw Pitch Roll
% 
% Note - Run this file in the results folder
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

function plotStickCmd(csvFileStickCmd,csvFileStateEstimate)
% clear all; clc

% Reading the StickCmd csv file data 
dataStickCmd = csvread(csvFileStickCmd);
prThrust = dataStickCmd(:,1);
prYaw = dataStickCmd(:,2);
prPitch = dataStickCmd(:,3);
prRoll = dataStickCmd(:,4);

% Reading StateEatimate csv file for Time
dataStateEstimate = csvread(csvFileStateEstimate);
% prRange = data(:,1);
prTime = dataStateEstimate(:,2);
% prNorth = data(:,3);
% prEast = data(:,4);
% prUp = data1(:,5);
% prYaw = data1(:,6);


% Printing the figures
figure()
a1 = subplot(4,1,1);
plot(prTime,prThrust, 'r','LineWidth',3);
hold on
xlabel('Iterations');
ylabel('Thrust');
set(gca,'FontSize',20)
legend('Thrust')
set(gca,'FontSize',25)
grid on;

a2 = subplot(4,1,2);
plot(prTime,prYaw, 'r','LineWidth',3);
hold on
xlabel('Time');
ylabel('Yaw');
set(gca,'FontSize',25)
legend('Yaw')
set(gca,'FontSize',16)
grid on;

a3 = subplot(4,1,3);
plot(prTime,prPitch , 'b','LineWidth',3);
xlabel('Time');
ylabel('Pitch');
set(gca,'FontSize',25)
legend('Pitch')
set(gca,'FontSize',16)
grid on;

a4 = subplot(4,1,4);
plot(prTime,prRoll, 'k','LineWidth',3);
xlabel('Time');
ylabel('Roll');
set(gca,'FontSize',25)
legend('Roll')
set(gca,'FontSize',16)
grid on;

% Title for subplots
sgt = sgtitle('Stick Cmd '); %raw data
sgt.FontSize = 25;

linkaxes([a1,a2,a3,a4],'x')
end
