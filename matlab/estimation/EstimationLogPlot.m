% Plotting both the Realsense VIO and the Motion Capture 
clear;
close all;
clc;

global pathToEstimationLogs
pathToEstimationLogs = '/home/amav/amav/Terpcopter3.0/matlab/estimation/EstimationLogs';
%pathToEstimationLogs = '/home/wolek/Desktop/Research/Projects/UMD/AMAV/Terpcopter3.0/matlab/estimation/EstimationLogs';
%pathToEstimationLogs = '/home/zlacey/Terpcopter3.0/matlab/estimation/EstimationLogs';

cd(pathToEstimationLogs)


% Local Position Log file should be selected FIRST
[file1,path1] = uigetfile('*.log');

% VIO Log file should be selected SECOND
[file2,path2] = uigetfile('*.log');

% Lidar Log file should be selected THIRD
[file3,path3] = uigetfile('*.log');

% State Estimate Log file should be selected FOURTH
[file4,path4] = uigetfile('*.log');
%% Local Position 
file1
filepath1 = [path1 file1];
data1 = csvread(filepath1);

% parse out
TimeLocalPosition = data1(:,1);
TimeLocalPosition = TimeLocalPosition - TimeLocalPosition(1);
PositionXLocalPosition = data1(:,2);
PositionYLocalPosition = data1(:,3);
PositionZLocalPosition = data1(:,4);

OrientationPhiLocalPosition = data1(:,5);
OrientationThetaLocalPosition = data1(:,6);
OrientationPsiLocalPosition = data1(:,7);

LinearVelocityXLocalPosition = -data1(:,8);
LinearVelocityYLocalPosition = -data1(:,9);
LinearVelocityZLocalPosition = data1(:,10);
AngularVelocityXLocalPosition = data1(:,11);
AngularVelocityYLocalPosition = data1(:,12);
AngularVelocityZLocalPosition = data1(:,13);

%% Realsense VIO
file2
filepath2 = [path2 file2];
data2 = csvread(filepath2);

% parse out
TimeVIO = data2(:,1);
TimeVIO = TimeVIO - TimeVIO(1);
PositionXVIO = data2(:,2);
PositionYVIO = data2(:,3);
PositionZVIO = data2(:,4);
PositionXVIOBodyFrame = -PositionYVIO;
PositionYVIOBodyFrame = PositionXVIO;
PositionZVIOBodyFrame = PositionZVIO;

OrientationPhiVIO = data2(:,5);
OrientationThetaVIO = data2(:,6);
OrientationPsiVIO = data2(:,7);

LinearVelocityXVIO = -data2(:,8);
LinearVelocityYVIO = -data2(:,9);
LinearVelocityZVIO = data2(:,10);
AngularVelocityXVIO = data2(:,11);
AngularVelocityYVIO = data2(:,12);
AngularVelocityZVIO = data2(:,13);

%% Lidar
file3
filepath3 = [path3 file3];
data3 = csvread(filepath3);

PositionZLidar = data3(:,1);

%% State Estimate
file4
filepath4 = [path4 file4];
data4 = csvread(filepath4);

stateEstimateYaw = data4(:,1);
stateEstimatePitch = data4(:,2);
stateEstimateRoll = data4(:,3);
stateEstimateUp = data4(:,4);


%% Plotting
figure(1)
hold on;
plot3(PositionXLocalPosition,PositionYLocalPosition,PositionZLocalPosition);
plot3(PositionXVIOBodyFrame, PositionYVIOBodyFrame, PositionZVIOBodyFrame);
title('3D Plot of Local Position vs Realsense VIO Position');
xlabel('Position X (m)');
ylabel('Position Y (m)');
zlabel('Position Z (m)');
legend('Local Position','Realsense VIO');
set(gca, 'FontSize', 16);
axis equal
grid on
hold off

figure(2)
subplot(3,1,1)
plot(TimeLocalPosition,PositionXLocalPosition);
hold on
plot(TimeLocalPosition,PositionXVIOBodyFrame);
title('Position Y vs Time Comparision for Local Position and Realsense VIO');
xlabel('Time (seconds)');
ylabel('Position X (meters)');
legend('Local Position','Realsense VIO');
grid on
set(gca, 'FontSize', 12);
hold off

subplot(3,1,2)
plot(TimeLocalPosition,PositionYLocalPosition);
hold on
plot(TimeLocalPosition,PositionYVIOBodyFrame);
title('Position Y vs Time Comparision for Local Position and Realsense VIO');
xlabel('Time (seconds)');
ylabel('Position Y (meters)');
legend('Local Position','Realsense VIO');
grid on
set(gca, 'FontSize', 12);
hold off

subplot(3,1,3)
plot(TimeLocalPosition,PositionZLocalPosition);
hold on
plot(TimeLocalPosition,PositionZVIOBodyFrame);
plot(TimeLocalPosition,PositionZLidar);
title('Position Z vs Time Comparision for Local Position, Realsense VIO, and Lidar')
xlabel('Time (seconds)');
ylabel('Position Z (meters)');
legend('Local Position','Realsense VIO','Lidar');
grid on
set(gca, 'FontSize', 12);
hold off

%% Plotting Difference in Phi, Theta, Psi
figure(3)
subplot(3,1,1)
hold on
plot(TimeLocalPosition, OrientationPhiLocalPosition);
plot(TimeLocalPosition, OrientationPhiVIO);
plot(TimeLocalPosition, stateEstimateRoll);
title('Angle Phi vs Time Comparision for Motion Capture and Realsense VIO');
xlabel('Time (seconds)');
ylabel('Roll (Degrees)');
legend('Local Position','Realsense VIO','State Estimate');
grid on
set(gca, 'FontSize', 12);
hold off

subplot(3,1,2)
hold on
plot(TimeLocalPosition, OrientationThetaLocalPosition);
plot(TimeLocalPosition, OrientationThetaVIO);
plot(TimeLocalPosition, stateEstimatePitch);
title('Angle Theta vs Time Comparision for Motion Capture and Realsense VIO');
xlabel('Time (seconds)');
ylabel('Pitch (Degrees)');
legend('Local Position','Realsense VIO','State Estimate');
grid on
set(gca, 'FontSize', 12);
hold off

subplot(3,1,3)
hold on
plot(TimeLocalPosition, OrientationPsiLocalPosition);
plot(TimeLocalPosition, OrientationPsiVIO);
plot(TimeLocalPosition, stateEstimateYaw);
title('Angle Psi vs Time Comparision for Motion Capture and Realsense VIO');
xlabel('Time (seconds)');
ylabel('Yaw (Degrees)');
legend('Local Position','Realsense VIO','State Estimate');
grid on
set(gca, 'FontSize', 12);
hold off