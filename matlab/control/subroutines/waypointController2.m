function [yawStickCmd, pitchStickCmd, rollStickCmd,yawControl,pitchControl, rollControl] = waypointController2(yawControl,pitchControl, rollControl, curTime, yawDeg, x_d, x, y_d, y)

% gains/parameters
Kp_pitch = 0.10;
Kp_roll = 0.10;
% pitchStickLimit = 0.25;
% rollStickLimit = 0.25;
attitudeDeadbandMeters = 0.25;
relativeYawDeg = yawDeg - 90;  % This yaw is relative to the initial yaw when quad is turned on (90 Degrees)

% % unpack states
% prevPitchCmd = pitchControl.prevVal;
% prevRollCmd = rollControl.prevVal;

% calculate attitude error in inertial frame
x_error = x_d - x
y_error = y_d - y

% Rotation from inertial frame to quad body frame
x_error = x_error*cosd(relativeYawDeg) + y_error*sind(relativeYawDeg)
y_error = -x_error*sind(relativeYawDeg) + y_error*cosd(relativeYawDeg)

distanceErrorMeters = sqrt(x_error^2 + y_error^2);

% proportional control scaled to unit vector
pitchStickCmd = Kp_pitch*(y_error/distanceErrorMeters);
rollStickCmd = -Kp_roll*(x_error/distanceErrorMeters);

yawStickCmd = 0;

if (abs(distanceErrorMeters) <= attitudeDeadbandMeters)
    pitchStickCmd = 0;
    rollStickCmd = 0;
    yawStickCmd = 0;
end

% % pack up structure
% yawControl.lastTime = curTime;
% yawControl.prevVal = yawDeg;

% displayFlag = 1;
% if ( displayFlag )
%     
%     pFile1 = fopen(yawControl.log ,'a');
%     pFile2 = fopen(pitchControl.log, 'a');
%     pFile3 = fopen(rollControl.log, 'a');
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