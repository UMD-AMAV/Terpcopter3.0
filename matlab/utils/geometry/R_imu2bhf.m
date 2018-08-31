function R = R_imu2bhf(angles)
% Description:
%   Computes the rotation matrix converting from the 'imu' to 'bhf' frames.
%
% Inputs:
%   angles : 3 x 1 vector of yaw-pitch-roll angles:
%            angles(1) : yaw (rad)
%            angles(2) : pitch (rad)
%            angles(3) : roll (rad)
% Outputs:
%   R : 3 x 3 rotation matrix (i.e., vec_bhv = R * vec_imu)
%
% Notes:
%	'imu' : IMU frame
%        X : front of vehicle (in lateral plane)
%        Y : left side of vehicle (in lateral plane)
%        Z : up (perp. to lateral frame, alligned to thrust)
%
%   'hbf' : Horizontal body frame
%       X : front of vehicle (proj. of imu X onto horizontal plane)
%       Y : right side of vehicle (in horizontal plane)
%       Z : down

% unpack angles
yaw = angles(1);
pitch = angles(2);
roll = angles(3);

% unit vector pointing in 'front' (along IMU x axis)
vecX_imu = [1 0 0]'; 

% convert x unit vector in imu frame to enu frame
R_imu2enu = (rotationMatrixYPR(yaw,pitch,roll))';
vecX_enu = R_imu2enu*vecX_imu;

% the first two components of vecX_enu give a vector in the E-N plane
% compute the yaw angle of that vector, measured CCW from E)
yaw_EN = atan2(vecX_enu(2), vecX_enu(1));

% Warning: 
% yaw angle not well defined when above 2 components are zero (quapd 
% pointing directly up or down)

% Rotation matrix from bhf to enu is a yaw-only rotation
R_enu2hbf = rotationMatrixYPR(yaw_EN,0,0);
R = R_enu2hbf*R_imu2enu;
end