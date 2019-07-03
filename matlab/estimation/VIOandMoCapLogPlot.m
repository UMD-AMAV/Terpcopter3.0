% Plotting both the Realsense VIO and the Motion Capture 
clear;
close all;
clc;

% VIO Log file should be selected FIRST
[file1,path1] = uigetfile('*.log');
% Motion Capture Log file should be selected SECOND
[file2,path2] = uigetfile('*.log');

%% Realsense VIO
file1
filepath1 = [path1 file1];
data1 = csvread(filepath1);

% parse out
TimeVIO = data1(:,1);
TimeVIO = TimeVIO - TimeVIO(1);
PositionXVIO = data1(:,2);
PositionYVIO = data1(:,3);
PositionZVIO = data1(:,4);

%% Motion Capture
file2
filepath2 = [path2 file2];
data2 = csvread(filepath2);

%parse out
TimeMOCAP = data2(:,1);

PositionXMOCAP = data2(:,2);
PositionYMOCAP = data2(:,3);
PositionZMOCAP = data2(:,4);

phi = data2(:,2);
theta = data2(:,2);
psi = data2(:,2);

%% Plotting functions
figure(1)
plot3(PositionXMOCAP,PositionYMOCAP,PositionZMOCAP);
hold on;
plot3(PositionX, PositionY, PositionZ);
xlabel('Position X (m)');
ylabel('Position Y (m)');
zlabel('Position Z (m)');