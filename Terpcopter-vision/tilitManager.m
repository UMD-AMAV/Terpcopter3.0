% Load image
%vid = videoinput('winvideo',1);
%obj.SelectedSourceName = 'input1'
%src_obj = getselectedsource(obj);
%get(src_obj)
%img = getsnapshot(obj);
clc;
clear;
%vid = videoinput('linuxvideo', 2, 'UYVY_640x480');
vid = videoinput('linuxvideo', 1, 'UYVY_640x480');

% Set video input object properties for this application.
set(vid,'FramesPerTrigger',Inf);
%vid.FramesPerTrigger = 1000
set(vid,'ReturnedColorspace','rgb');
vid.FrameGrabInterval = 5;

% Set value of a video source object property.
%vid_src = getselectedsource(vid);
%vid_src.Tag = 'motion detection setup';

% Create a figure window.
%figure; 

% Start acquiring frames.
start(vid);

% Calculate difference image and display it.
%while(vid.FramesAvailable >= 1)
i = 1;
while true    
    %img = getdata(vid,2); 
    img = getsnapshot(vid);
% Full rotation matrix. Z-axis included, but not used.
    R_rot = R_y(30)*R_x(30)*R_z(30); 

% Strip the values related to the Z-axis from R_rot
    R_2d  = [   R_rot(1,1)  R_rot(1,2) 0; 
            R_rot(2,1)  R_rot(2,2) 0;
            0           0          1    ]; 

% Generate transformation matrix, and warp (matlab syntax)
    tform = affine2d(R_2d);
    outputImage = imwarp(img,tform);

% Display image
    disp(vid.FramesAvailable)
    %flushdata(vid,'triggers');
    if(vid.FramesAvailable > 5)
        flushdata(vid);
    end
    imshow(outputImage);
end
stop(vid);
flushdata(vid);
clear all;
%*** Rotation Matrix Functions ***%

function [R] = R_x(phi)
    R = [1 0 0;
        0 cosd(phi) -sind(phi);
        0 sind(phi)  cosd(phi)];
end
%% Matrix for Yaw-rotation about the Z-axis
function [R] = R_z(psi)
    R = [cosd(psi) -sind(psi) 0;
         sind(psi)  cosd(psi) 0;
         0          0         1];
end

%% Matrix for Pitch-rotation about the Y-axis
function [R] = R_y(theta)
    R = [cosd(theta)    0   sind(theta);
         0              1   0          ;
         -sind(theta)   0   cosd(theta)     ];
end