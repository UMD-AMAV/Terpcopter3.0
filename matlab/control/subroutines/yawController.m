function [yawStickCmd, yawControl] = yawController(yawControl, curTime, yawDeg, yawDeg_d)

% gains/parameters
yawFiltTimeConstant = 0.1;
kp = 0.1;

% time elapsed since last control
dt = curTime - lastTime;

% low-pass filter
alpha = dt / ( yawFiltTimeConstant + dt);
yawFilt = (1-alpha)*prevYaw + alpha*yawDeg;

% altitude error
yawError = yawDeg_d - yawFilt;

% proportional control
yawStickCmd = kp*yawError;

%% display/debug
fprintf('Controller running at %3.2f Hz\n',1/dt);

displayFlag = 1;
if ( displayFlag )
    
    pFile = fopen( altControl.log ,'a');
    
    % write csv file
    fprintf(pFile,'%6.6f,',curTime);
    fprintf(pFile,'%6.6f,',dt);
    fprintf(pFile,'%6.6f,',zd);
    fprintf(pFile,'%6.6f,',zcur);
    fprintf(pFile,'%6.6f,',altFilt);
    fprintf(pFile,'%6.6f,',altRateCmd);

    % constant parameters
    fprintf(pFile,'%6.6f,',altFiltTimeConstant);
    fprintf(pFile,'%6.6f,',climbRateCmd);
    fprintf(pFile,'%6.6f,',descentRateCmd);
    fprintf(pFile,'%6.6f \n,',setpointDeadband);

    fclose(pFile);
    
end
end