clear all;
close all;

clc;

[file1,path1] = uigetfile('*.log');
[file2,path2] = uigetfile('*.log');
file1
filepath1 = [path1 file1 ];
data1 = csvread(filepath1);

% parse out
TimeVIO = data1(:,1);
TimeVIO = TimeVIO - TimeVIO(1);
PositionXVIO = data1(:,2);
PositionYVIO = data1(:,3);
PositionZVIO = data1(:,4);

% Motion Capture
file2
filepath2 = [path2 file2];
data2 = csvread(filepath2);

%parse out
t = data2(:,1);

x = data2(:,2);
y = data2(:,3);
z = data2(:,4);

phi = data2(:,2);
theta = data2(:,2);
psi = data2(:,2);


figure(1)
plot3(x,y,z);
hold on
plot3(PositionX, PositionY, PositionZ);
xlabel('Position X (m)');
ylabel('Position Y (m)');
zlabel('Position Z (m)');
