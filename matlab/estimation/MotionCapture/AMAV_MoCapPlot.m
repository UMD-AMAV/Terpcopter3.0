% AMAV 2019 Motion Capture Plotting Logs
%
% Author: Zachary Lacey
% Email: zlacey@umd.edu

clear all
close all
clc

[file,path] = uigetfile('*.log');

file
filepath = [path file];
data = csvread(filepath);

%parse out
t = data(:,1);

x = data(:,2);
y = data(:,3);
z = data(:,4);

phi = data(:,2);
theta = data(:,2);
psi = data(:,2);


figure(1)
plot3(x,y,z);
xlabel('Position X (m)');
ylabel('Position Y (m)');
zlabel('Position Z (m)');
axis equal
grid on