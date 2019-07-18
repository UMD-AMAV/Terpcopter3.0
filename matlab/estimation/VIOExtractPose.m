% prepare workspace
clear; close all; clc; format compact;
addpath('../')
params = loadParams();

%run('updatePaths.m');
fprintf('Estimation Node Launching...\n');

% intialize ros node
if(~robotics.ros.internal.Global.isNodeActive)
    rosinit('192.168.1.68');            % ip of ROS Master
end

% Subscribers
VIODataSubscriber = rossubscriber('/camera/odom/sample', 'nav_msgs/Odometry');

pause(2)
t0 = [];

r = robotics.Rate(100);
reset(r);

VIOMsg = VIODataSubscriber.LatestMessage;

% VIO Time
VIOTime = VIOMsg.Header.Stamp.Sec;
% VIO Pose
% Position
VIOPositionX = VIOMsg.Pose.Pose.Position.X;
VIOPositionY = VIOMsg.Pose.Pose.Position.Y;
VIOPositionZ = VIOMsg.Pose.Pose.Position.Z;

% Orientation
VIOOrientationX = VIOMsg.Pose.Pose.Orientation.X;
VIOOrientationY = VIOMsg.Pose.Pose.Orientation.Y;
VIOOrientationZ = VIOMsg.Pose.Pose.Orientation.Z;
VIOOrientationW = VIOMsg.Pose.Pose.Orientation.W;

VIOeuler = quat2eul([VIOOrientationW VIOOrientationX VIOOrientationY VIOOrientationZ]);

VIOpsi = rad2deg(VIOeuler(1));
VIOtheta = rad2deg(VIOeuler(2));
VIOphi = rad2deg(VIOeuler(3));

logFlag = 1;
dateString = datestr(now,'mmmm_dd_yyyy_HH_MM_SS_FFF');
VIOLog = ['C:\Users\CDCL\Documents\GitHub\Terpcopter3.0\matlab\estimation' '/VIO_' dateString '.log'];

while(1)
tic
    
VIOMsg = VIODataSubscriber.LatestMessage;

% VIO Time
VIOTime = VIOMsg.Header.Stamp.Sec;
% VIO Pose
% Position
VIOPositionX = VIOMsg.Pose.Pose.Position.X
VIOPositionY = VIOMsg.Pose.Pose.Position.Y;
VIOPositionZ = VIOMsg.Pose.Pose.Position.Z;

% Orientation
VIOOrientationX = VIOMsg.Pose.Pose.Orientation.X;
VIOOrientationY = VIOMsg.Pose.Pose.Orientation.Y;
VIOOrientationZ = VIOMsg.Pose.Pose.Orientation.Z;
VIOOrientationW = VIOMsg.Pose.Pose.Orientation.W;

VIOeuler = quat2eul([VIOOrientationW VIOOrientationX VIOOrientationY VIOOrientationZ]);

VIOpsi = rad2deg(VIOeuler(1));
VIOtheta = rad2deg(VIOeuler(2));
VIOphi = rad2deg(VIOeuler(3));

if ( logFlag )
            pFile = fopen( VIOLog ,'a');
            
            % write csv file
            fprintf(pFile,'%6.6f,',VIOTime);
            
            fprintf(pFile,'%6.6f,',VIOPositionX);
            fprintf(pFile,'%6.6f,',VIOPositionY);
            fprintf(pFile,'%6.6f\n',VIOPositionZ);
            
            fclose(pFile);
end
waitfor(r);
        
end