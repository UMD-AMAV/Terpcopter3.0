clear all;
close all;

clc;

[file,path] = uigetfile('*.log');

file
filepath = [path file ];
data = csvread(filepath);

% parse out
t = data(:,1);
t = t - t(1);
PositionX = data(:,2);
PositionY = data(:,3);
PositionZ = data(:,4);

figure(1)
plot3(PositionX, PositionY, PositionZ);
xlabel('Position X (m)');
ylabel('Position Y (m)');
zlabel('Position Z (m)');

zlim([-10 10]);
