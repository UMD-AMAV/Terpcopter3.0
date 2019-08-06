function [yawStickCmd, uStickCmd, vStickCmd, yawControl] = waypointPointAndMoveForwardController(yawControl, curTime, yawDeg, x_d, x, y_d, y)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% gains/parameters
yawFiltTimeContsant = 0.2; % sec
Kp_yaw = 3/180; 
yawStickLimit = 0.45;
innerYawDeadbandDeg = 0.5; % When yaw is within this deadband, yawStickCmd is zero (desired yaw was reached)
outerYawDeadbandDeg = 5;   % When yaw is within outer deadband, quad moves forward (uStickCmd is controlled)
realtiveYawDeg = yawDeg - 90;  % This yaw is relative to the initial yaw when quad is turned on (90 Degrees)

Kp_u = 0.10;
attitudeDeadbandMeters = 0.25;

% unpack states
prevYawDeg = yawControl.prevVal;
lastTime = yawControl.lastTime;

% time elapsed since last control
dt = curTime - lastTime;

% low-pass filter
alpha = dt / ( yawFiltTimeConstant + dt);
yawFiltDeg = (1-alpha)*prevYawDeg + alpha*yawDeg;

x_error = x_d - x;
y_error = y_d - y;
yawDesDeg = rad2deg(atan2(y_error,x_error));

% Rotation from inertial frame to quad body frame
x_error_body = x_error*cosd(relativeYawDeg) + y_error*sind(relativeYawDeg)
y_error_body = -x_error*sind(relativeYawDeg) + y_error*cosd(relativeYawDeg)

distanceErrorMeters = sqrt(x_error_body^2 + y_error_body^2);

% yaw error
yawErrorDeg = 180/pi*signedAngularDist( yawFiltDeg*pi/180,yawDesDeg*pi/180 )

% proportional control
yawStickCmd = Kp_yaw*yawErrorDeg; 

% saturate
yawStickCmd = max(-yawStickLimit,min(yawStickCmd,yawStickLimit));
uStickCmd = 0;
vStickCmd = 0;

% deadband
if ( abs(yawErrorDeg) <= innerYawDeadbandDeg )
    yawStickCmd = 0;
end
if ( abs(yawErrorDeg) <= outerYawDeadbandDeg )
    uStickCmd = Kp_u*(y_error_body/distanceErrorMeters);
end
if (distanceErrorMeters <= attitudeDeadbandMeters)
    yawStickCmd = 0;
    uStickCmd = 0;
end

% pack up structure
yawControl.lastTime = curTime;
yawControl.prevVal = yawDeg;

% displayFlag = 0;
% if ( displayFlag )
%     
%     pFile = fopen( yawControl.log ,'a');
%     
%     % write csv file
%     fprintf(pFile,'%6.6f,',curTime);
%     fprintf(pFile,'%6.6f,',dt);
%     fprintf(pFile,'%6.6f,',yawDesDeg);
%     fprintf(pFile,'%6.6f,',yawDeg);
%     fprintf(pFile,'%6.6f,',yawFiltDeg);
%     fprintf(pFile,'%6.6f,',yawErrorDeg);
%     fprintf(pFile,'%6.6f,',yawStickCmd);
%     [u_yaw, u_pitch, u_roll,yawControl,pitchControl, rollControl] = waypointController2(yawControl,pitchControl, rollControl, t, yawDeg, x_d, x, y_d, y);
%     
%     % constant parameters
%     fprintf(pFile,'%6.6f,',yawFiltTimeConstant);
%     fprintf(pFile,'%6.6f,',Kp_yaw);
%     fprintf(pFile,'%6.6f,\n',yawStickLimit);
% 
%     fclose(pFile);
% end
end