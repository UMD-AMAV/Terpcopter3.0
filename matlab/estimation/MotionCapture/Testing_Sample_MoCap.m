clear all; clc; close all;

usr1= getenv('USERNAME');
if strcmp(usr1,'Daigo')
    Opti = NET.addAssembly('C:\Users\Daigo\Dropbox\Function_update\Quad_experiments\mocap_toolbox\NatNetSDK\lib\x64\NatNetML.dll');
elseif strcmp(usr1,'katar')
    Opti = NET.addAssembly('C:\Users\katar\Dropbox\Quad_experiments\mocap_toolbox\NatNetSDK\lib\x64\NatNetML.dll');
elseif strcmp(usr1,'CDCL')
    Opti = NET.addAssembly('C:\Users\Daigo\Dropbox\Function_update\Quad_experiments\mocap_toolbox\NatNetSDK\lib\x64\NatNetML.dll');
end
client = NatNetML.NatNetClientML(0); % Input = iConnectionType: 0 = Multicast, 1 = Unicast
% client.Initialize('192.168.1.131','192.168.1.131');
client.Initialize('127.0.0.1','127.0.0.1'); % for Local Loopback
% client.Initialize('192.168.1.22','192.168.1.22');
% client.Initialize('192.168.1.145','192.168.1.145');

RigidBody_ID=1 %set acording to your need

frameOfData = theClient.GetLastFrameOfData()
rigidBodyData = frameOfData.RigidBodies(RigidBody_ID)

% angle
q = quaternion( rigidBodyData.qx, rigidBodyData.qy, rigidBodyData.qz, rigidBodyData.qw ) % extrnal file quaternion.m
qRot = quaternion( 0, 0, 0, 1);    % rotate pitch 180 to avoid 180/-180 flip for nicer graphing
q = mtimes(q, qRot)
angles = EulerAngles(q,'zyx')
yaw = angles(2) * 180.0 / pi
pitch = -angles(1) * 180.0 / pi  % must invert due to 180 flip above
roll = -angles(3) * 180.0 / pi  % must invert due to 180 flip above

theClient.Uninitialize % disconnect