% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About - Reads the csv file conatining the state estimate parameter values 
%         And displays into the graphical plot
% 
% Input - 'plotStateEstimation_xx-xx-xxxx_xx:xx.csv'
% 
% Output - 3x2 Graphical plot containing North East Up Yaw Pitch Roll
% 
% Note - Run this file in the results folder
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

function plotStateEstimate(csvFilePath)
%clear all; clc
% addpath('./results');

% Reading the csv file data
%data = csvread('plotStateEstimate_03-29-2019_20:22.csv');

data = csvread(csvFilePath);
prRange = data(:,1);
prTime = data(:,2);
prNorth = data(:,3);
prEast = data(:,4);
prUp = data(:,5);
prYaw = data(:,6);
prPitch = data(:,7);
prRoll = data(:,8);

% Printing the figures
figure();
title('Altitude plot')

a1 = subplot(3,2,1);
plot(prTime,prNorth,'g','LineWidth',3);
xlabel('Time');
ylabel('North direction');
set(gca,'FontSize',25)
legend('North direction')
set(gca,'FontSize',16)
grid on;

a2 = subplot(3,2,3);
plot(prTime,prEast, 'c','LineWidth',3);
xlabel('Time');
ylabel('East direction');
set(gca,'FontSize',25)
legend('East direction')
set(gca,'FontSize',16)
grid on;

a3 = subplot(3,2,5);
plot(prTime,prUp,'b','LineWidth',3);
xlabel('Time');
ylabel('Altitude');
set(gca,'FontSize',25)
legend('Actual Altitude')
set(gca,'FontSize',16)
grid on;


a4 = subplot(3,2,2);
plot(prTime,prYaw, 'm','LineWidth',3);
xlabel('Time');
ylabel('Yaw');
set(gca,'FontSize',25)
legend('Yaw')
set(gca,'FontSize',16)
grid on;

a5 = subplot(3,2,4);
plot(prTime,prPitch, 'r','LineWidth',3);
xlabel('Time');
ylabel('Pitch');
set(gca,'FontSize',25)
legend('Pitch')
set(gca,'FontSize',16)
grid on;

a6 = subplot(3,2,6);
plot(prTime,prRoll, 'k','LineWidth',3);
xlabel('Time');
ylabel('Roll');
set(gca,'FontSize',25)
legend('Roll')
set(gca,'FontSize',16)
grid on;

% Title for subplots
sgt = sgtitle('Altitude plot'); %raw data
sgt.FontSize = 25;


linkaxes([a1,a2,a3,a4,a5,a6],'x')
% linkaxes([a3,a4],'xy')
end