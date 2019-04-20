function [rollStickCmd, rollControl] = rollController(rollControl, curTime, rollDeg, rollDesDeg)

% gains/parameters
rollFiltTimeConstant = 0.2; sec
kp = 0.1/10; % estimate : 10 deg error gives 0.1 stick cmd with kp = 0.1/10;
rollStickLimit = 0.2;

% unpack states
prevRollDeg = rollControl.prevVal;
lastTime = rollControl.lastTime;

% time elapsed since last control
dt = curTime - lastTime;

% low-pass filter
alpha = dt / ( rollFiltTimeConstant + dt);
rollFiltDeg = (1-alpha)*prevRollDeg + alpha*rollDeg;

% altitude error
rollErrorDeg = rollDesDeg - rollFiltDeg;

% proportional control
rollStickCmd = kp*rollErrorDeg; 

% saturate
rollStickCmd = max(-rollStickLimit,min(1,rollStickLimit));

% pack up structure
rollControl.lastTime = curTime;
rollControl.prevAlt = prevRollDeg;

%
displayFlag = 1;
if ( displayFlag )
    
    pFile = fopen( rollControl.log ,'a');
    
    % write csv file
    fprintf(pFile,'%6.6f,',curTime);
    fprintf(pFile,'%6.6f,',dt);
    fprintf(pFile,'%6.6f,',rollDesDeg);
    fprintf(pFile,'%6.6f,',rollDeg);
    fprintf(pFile,'%6.6f,',rollFiltDeg);
    fprintf(pFile,'%6.6f,',rollErrorDeg);
    fprintf(pFile,'%6.6f,',rollStickCmd);
       
    % constant parameters
    fprintf(pFile,'%6.6f,',rollFiltTimeConstant);
    fprintf(pFile,'%6.6f,',kp);
    fprintf(pFile,'%6.6f\n,',rollStickLimit);


    fclose(pFile);
    
end
end