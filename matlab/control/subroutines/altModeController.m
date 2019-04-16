function [altRateCmd, altControl] = altModeController(altControl, curTime, zcur, zd)

% unpack states
timeSetpointSet = altControl.timeSetpointSet;

% unpack tuning parameters (constants)
altFiltTimeConstant = altControl.altFiltTimeConstant;
climbRateCmd = altControl.climbRateCmd;
descentRateCmd = altControl.descentRateCmd;
altErrorDeadband = altControl.altErrorDeadband;
settlingTime = altControl.settlingTime;

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
if (altError >= altErrorDeadband && timeSinceSetpoint >= settlingTime )
    altRateCmd = climbRateCmd;
elseif ( altError <= -altErrorDeadband && timeSinceSetpoint >= settlingTime )
    altRateCmd = descentRateCmd;
else
    altRateCmd = 0;
%   timeSetpointSet = curTime;
end


%% pack up structure
altControl.timeSetpointSet = timeSetpointSet;
altControl.lastTime = curTime;
altControl.prevAlt = zcur;
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
    fprintf(pFile,'%6.6f,',altErrorDeadband);
%    fprintf(pFile,'%6.6f,',altDesTimeConstant);
    fprintf(pFile,'%6.6f,',settlingTime);
    
    fclose(pFile);
    
end

end