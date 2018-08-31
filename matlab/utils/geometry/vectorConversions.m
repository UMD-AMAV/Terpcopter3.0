function vecB = vectorConversions(vecA, frameid, angles)
% Description:
%   Converts a vector 'vecA' expressed in Frame A into an equivalent vector
%   'vecB' expressed in Frame B. The 'frameid' variable specifies Frame A
%   and B. The 'angles' parameter is required when the conversion involves
%   a rotating reference frame.
% 
% Inputs:
%   vecA : 3 x 1 vector expressed in the 'A' frame
%
%   frameid : a string with the format 'A2B' where 'A' or 'B' represent
%             reference frames identified by the following keywords:
%             'imu' , 'enu' , 'nwu', 'ned' 'hbf' (see below for details).
%             e.g., valid options for 'frameid' are: 'imu2enu'
%                   or 'enu2hbf' 
%
%   angles : 3 x 1 vector of yaw-pitch-roll angles:
%            angles(1) : yaw (rad)
%            angles(2) : pitch (rad) 
%            angles(3) : roll (rad) 
%            
%   Note: we assume the angles gives the transformation from an inertial
%   'enu' frame to the 'imu' frame. 
% 
%   Rotating Reference Frames:
%
%	'imu' : IMU frame 
%        X : front of vehicle (in lateral-dir. plane, perp. to thrust)
%        Y : left side of vehicle (in lateral-dir. plane, perp. to thrust)
%        Z : up (aligned with thrust)
%   
%   'hbf' : Horizontal body frame
%       X : front of vehicle (defined by proj. of imu X onto NE horizontal plane)
%       Y : right of vehicle (defined by proj. of imu Y onto NE horizontal plane)
%       Z : down 
%       Notes: - this reference frame only rotates around the z axis
%              - this frame is not suitable for large deviations 
%                from an upright orientation because the project of imu 'X' 
%                axis onto horizontal plane has a discontinuity when the
%                vehicle pitches through 90 deg. 
%
%   Inertial Reference Frames
%
%	'enu' : east-north-up 
%        X : east
%        Y : north
%        Z : up
%
% 	'ned' : north-east-down 
%        X : north
%        Y : east
%        Z : down
%
% 	'nwu' : north-west-up 
%        X : north
%        Y : west
%        Z : up


vecA = vecA(:); % force column vector

% Note: R = rotationMatrixYPR(psi,theta,phi) defines the conversion
% from 'enu2imu' using the 'angles' input
if exist('angles') ~= 0
    yaw = angles(1);
    pitch = angles(2);
    roll = angles(3);
end

% conversion between inertial frames (fixed offsets, 'angles' not required)
if(strcmp(frameid,'enu2ned'))
    R = rotationMatrixYPR(pi/2,0,pi);
elseif(strcmp(frameid,'enu2nwu'))
    R = rotationMatrixYPR(pi/2,0,0);
elseif(strcmp(frameid,'ned2enu'))
    R = (rotationMatrixYPR(pi/2,0,pi))';
elseif(strcmp(frameid,'ned2nwu'))
    R = (rotationMatrixYPR(0,0,pi));
elseif(strcmp(frameid,'nwu2enu'))
    R = (rotationMatrixYPR(pi/2,0,0))';
elseif(strcmp(frameid,'nwu2ned'))
    R = (rotationMatrixYPR(0,0,pi))';    

% conversion between two rotating frames (requires 'angles')
elseif(strcmp(frameid,'imu2hbf'))
    R = R_imu2bhf(angles);
elseif(strcmp(frameid,'hbf2imu'))
    R = (R_imu2bhf(angles))';
    
% conversion between inertial and rotating frames (requires 'angles')
elseif(strcmp(frameid,'enu2imu'))
    % R_imu2enu = this comes from defn. of imu's reported angles with
    % a standard YPR rotation
    R = rotationMatrixYPR(yaw,pitch,roll);
elseif(strcmp(frameid,'enu2hbf'))
    % R_enu2hbf = R_imu2hbf*R_enu2imu;
    R = R_imu2bhf(angles) * rotationMatrixYPR(yaw,pitch,roll);  
elseif(strcmp(frameid,'nwu2imu'))
    % R_nwu2imu = R_enu2imu * R_nwu2enu
    R = rotationMatrixYPR(yaw,pitch,roll) * (rotationMatrixYPR(0,0,pi));
elseif(strcmp(frameid,'nwu2hbf'))
    % R_nwu2imu = R_imu2hbf * R_enu2imu * R_nwu2enu
    R = R_imu2bhf(angles) * rotationMatrixYPR(yaw,pitch,roll) * (rotationMatrixYPR(0,0,pi));    
elseif(strcmp(frameid,'ned2imu'))
    % R_ned2imu = R_enu2imu * R_ned2enu
	R = rotationMatrixYPR(yaw,pitch,roll) * (rotationMatrixYPR(pi/2,0,pi))';
elseif(strcmp(frameid,'ned2hbf'))
    % R_ned2imu = R_imu2hbf * R_enu2imu * R_ned2enu
	R = R_imu2bhf(angles) * rotationMatrixYPR(yaw,pitch,roll) * (rotationMatrixYPR(pi/2,0,pi))';    
elseif(strcmp(frameid,'imu2enu'))
    % R_imu2enu = R_enu2imu'
    R = (rotationMatrixYPR(yaw,pitch,roll))';    
elseif(strcmp(frameid,'imu2ned'))
    % R_ned2imu = R_ned2imu'
	R = ( rotationMatrixYPR(yaw,pitch,roll) * (rotationMatrixYPR(pi/2,0,pi))' )';
elseif(strcmp(frameid,'imu2nwu'))
    % R_imu2nwu = R_nwu2imu'
	R = ( rotationMatrixYPR(yaw,pitch,roll) * (rotationMatrixYPR(0,0,pi)) )';
elseif(strcmp(frameid,'hbf2enu'))
    % R_hbf2enu = R_enu2hbf';
    R = (  R_imu2bhf(angles) * rotationMatrixYPR(yaw,pitch,roll) )';  
elseif(strcmp(frameid,'hbf2ned'))
    % R_hbf2ned = R_ned2hbf';
    R = (  R_imu2bhf(angles) * rotationMatrixYPR(yaw,pitch,roll) * (rotationMatrixYPR(pi/2,0,pi))' )';   
elseif(strcmp(frameid,'hbf2nwu'))
    % R_hbf2nwu = R_nwu2hbf';
    R = ( R_imu2bhf(angles) * rotationMatrixYPR(yaw,pitch,roll) * (rotationMatrixYPR(0,0,pi)) )';      
end    
    
vecB = R * vecA;
end
