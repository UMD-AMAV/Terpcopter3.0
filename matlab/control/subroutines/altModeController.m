function [altRateCmd, altControl] = altModeController(altControl, curTime, zcur, zd)

% unpack states
timeSetpointSet = altControl.timeSetpointSet;

% unpack tuning parameters (constants)
altFiltTimeConstant = altControl.altFiltTimeConstant;
climbRateCmd = altControl.climbRateCmd;
descentRateCmd = altControl.descentRateCmd;
setpointDeadband = altControl.altErrorDeadband;
overshootDeadband = 0.5;
%^settlingTime = altControl.settlingTime;
setpointReached = altControl.setpointReached;

%%
% time elapsed since last control
dt = curTime - altControl.lastTime;
timeSinceSetpoint = curTime - timeSetpointSet;

% low-pass filter altitude
alpha_a = dt / ( altFiltTimeConstant + dt);
prevAlt = altControl.prevAlt;
altFilt = (1-alpha_a)*prevAlt + alpha_a*zcur;

% altitude error
altError = zd - altFilt;

% bang-bang control
if (altError >= setpointDeadband && setpointReached == 0 )
    altRateCmd = climbRateCmd;
    disp('Climb To Setpoint')    
elseif (altError >= overshootDeadband  && setpointReached == 1 )
    altRateCmd = climbRateCmd;
    disp('Climb To Overcome Overshoot')
elseif (altError <= -setpointDeadband && setpointReached == 0 )
    altRateCmd = descentRateCmd;
    disp('Descend To Setpoint')    
elseif (altError <= -overshootDeadband  && setpointReached == 1 )
    altRateCmd = descentRateCmd;
    disp('Descend To Overcome Overshoot')
elseif ( abs(altError) <= setpointDeadband )
   altRateCmd = 0;
   setpointReached = 1;
   disp('Hold')
else
   altRateCmd = 0;
   setpointReached = 0;
   disp('Reset Setpoint')   
end


%% pack up structure
altControl.timeSetpointSet = timeSetpointSet;
altControl.lastTime = curTime;
altControl.prevAlt = zcur;
altControl.setpointReached = setpointReached;
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
    fprintf(pFile,'%6.6f,',timeSetpointSet);
    
    % constant parameters
    fprintf(pFile,'%6.6f,',altFiltTimeConstant);
    fprintf(pFile,'%6.6f,',climbRateCmd);
    fprintf(pFile,'%6.6f,',descentRateCmd);
    fprintf(pFile,'%6.6f,',setpointDeadband);
    %fprintf(pFile,'%6.6f,\n',settlingTime);
    
    fclose(pFile);
    
end

end