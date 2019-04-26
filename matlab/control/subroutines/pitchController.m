function [pitchStickCmd, pitchControl] = pitchController(pitchControl, curTime, pitchDeg, pitchDesDeg)

% gains/parameters
pitchFiltTimeConstant = 0.2; % seconds
kp = 0.15/5; % estimate : 10 deg error gives 0.1 stick cmd with kp = 0.1/10;
pitchStickLimit = 0.2;

% unpack states
prevPitchDeg = pitchControl.prevVal;
lastTime = pitchControl.lastTime;

% time elapsed since last control
dt = curTime - lastTime;

% low-pass filter
alpha = dt / ( pitchFiltTimeConstant + dt);
pitchFiltDeg = (1-alpha)*prevPitchDeg + alpha*pitchDeg;

% altitude error
pitchErrorDeg = pitchDesDeg - pitchFiltDeg;

% proportional control
pitchStickCmd = kp*pitchErrorDeg; 

% saturate
pitchStickCmd = max(-pitchStickLimit,min(1,pitchStickLimit));

%% pack up structure
pitchControl.lastTime = curTime;
pitchControl.prevVal = prevPitchDeg;

% display/debug
displayFlag = 1;
if ( displayFlag )
    
    pFile = fopen( pitchControl.log ,'a');
    
    % write csv file
    fprintf(pFile,'%6.6f,',curTime);
    fprintf(pFile,'%6.6f,',dt);
    fprintf(pFile,'%6.6f,',pitchDesDeg);
    fprintf(pFile,'%6.6f,',pitchDeg);
    fprintf(pFile,'%6.6f,',pitchFiltDeg);
    fprintf(pFile,'%6.6f,',pitchErrorDeg);
    fprintf(pFile,'%6.6f,',pitchStickCmd);
       
    % constant parameters
    fprintf(pFile,'%6.6f,',pitchFiltTimeConstant);
    fprintf(pFile,'%6.6f,',kp);
    fprintf(pFile,'%6.6f\n,',pitchStickLimit);


    fclose(pFile);
    
end
end