function [altRateCmd, altControl] = altModeController(altControl, curTime, zcur, zd)

% gains/tuning parameters (constants)
altFiltTimeConstant = 0.1;
climbRateCmd = 0.6;
descentRateCmd = -0.50;
setpointDeadband = 0.05;

% unpack states
setpointReached = altControl.setpointReached;
setpointVal = altControl.setpointVal;
prevAlt = altControl.prevVal;
lastTime = altControl.lastTime;

% time elapsed since last control
dt = curTime - lastTime;

% low-pass filter altitude
alpha_a = dt / ( altFiltTimeConstant + dt);
altFilt = (1-alpha_a)*prevAlt + alpha_a*zcur;

% altitude error
altError = zd - altFilt;

% reset setpoint
if ( abs(setpointVal - zd) > setpointDeadband && setpointReached == 1 )
   setpointReached = 0;   
   disp('New Setpoint');
end

% bang-bang control
if ( abs(altError) <= setpointDeadband && setpointReached == 0) % triggers the setpointReached
   altRateCmd = 0;
   setpointReached = 1;
   setpointVal = altFilt;
   disp('Reached Setpoint')
elseif (altError > setpointDeadband && setpointReached == 0 ) % if it hasn't reached the setpoint and must climb
    altRateCmd = climbRateCmd;
    disp('Climb To Setpoint') 
elseif (altError < -setpointDeadband && setpointReached == 0 ) %  if it hasn't reached the setpoint and must decend
    altRateCmd = descentRateCmd;
    disp('Descend To Setpoint') 
else 
   altRateCmd = 0;
   disp('Holding Setpoint')   
end


%% pack up structure
altControl.lastTime = curTime;
altControl.prevVal = zcur;
altControl.setpointReached = setpointReached;
altControl.setpointVal = setpointVal;

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
    fprintf(pFile,'%6.6f,\n',setpointDeadband);

    fclose(pFile);    
end

end