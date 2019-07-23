function [yawStickCmd, pitchStickCmd, rollStickCmd,yawControl] = waypointController(yawControl, curTime, yawDeg, x_d, x, y_d, y);
% Note: clockwise is negative stick cmd

% gains/parameters
yawFiltTimeConstant = 0.2; %sec
Kp_yaw = 3/180; % estimate : 10 deg error gives 0.1 stick cmd with kp = 0.1/10;
yawStickLimit = 0.45;
deadbandDeg = 0.5;
largerDeadbandDeg = 10;

Kp_pitch = 0.25;
pitchStickLimit = 0.25;
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
distanceErrorMeters = sqrt(x_error^2 + y_error^2)
yawDesDeg = rad2deg(atan2(y_error,x_error));

% altitude error
yawErrorDeg = 180/pi*signedAngularDist( yawFiltDeg*pi/180,yawDesDeg*pi/180 )

% proportional control
yawStickCmd = Kp_yaw*yawErrorDeg; 

% saturate
yawStickCmd = max(-yawStickLimit,min(yawStickCmd,yawStickLimit));
pitchStickCmd = 0;
rollStickCmd = 0;

% deadband
if ( abs(yawErrorDeg) <= deadbandDeg )
   yawStickCmd = 0; 
end
if ( abs(yawErrorDeg) <= largerDeadbandDeg )
   pitchStickCmd = Kp_pitch*distanceErrorMeters;
   pitchStickCmd = max(-pitchStickLimit, min(pitchStickCmd, pitchStickLimit));
end
if (distanceErrorMeters <= attitudeDeadbandMeters)
    yawStickCmd = 0;
    pitchStickCmd = 0;
end

% pack up structure
yawControl.lastTime = curTime;
yawControl.prevVal = yawDeg;

displayFlag = 1;
if ( displayFlag )
    
    pFile = fopen( yawControl.log ,'a');
    
    % write csv file
    fprintf(pFile,'%6.6f,',curTime);
    fprintf(pFile,'%6.6f,',dt);
    fprintf(pFile,'%6.6f,',yawDesDeg);
    fprintf(pFile,'%6.6f,',yawDeg);
    fprintf(pFile,'%6.6f,',yawFiltDeg);
    fprintf(pFile,'%6.6f,',yawErrorDeg);
    fprintf(pFile,'%6.6f,',yawStickCmd);
    [u_yaw, u_pitch, u_roll,yawControl,pitchControl, rollControl] = waypointController2(yawControl,pitchControl, rollControl, t, yawDeg, x_d, x, y_d, y);
    
    % constant parameters
    fprintf(pFile,'%6.6f,',yawFiltTimeConstant);
    fprintf(pFile,'%6.6f,',Kp_yaw);
    fprintf(pFile,'%6.6f,\n',yawStickLimit);

    fclose(pFile);
end
end