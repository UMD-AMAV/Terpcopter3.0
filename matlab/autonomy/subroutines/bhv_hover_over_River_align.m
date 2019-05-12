function [completionFlag, ayprCmd] = bhv_hover_over_River_align(stateEstimateMsg, ayprCmd, completion, bhvTime, rDetected, yLeft, yRight, riverLog)

% rDetected
% rPixelX = 0 to 640 (pixels)
% rPixelY = 0 to 480


% Note: Pitch cmd (+) = negative pitch (nose down)
%       Roll cmd (-) = positivie roll (right wing down)

persistent filtPixelY errorSumY diffY desiredYaw;

% pitch gains
Kpitch = 0.03/100;
Kdp = 0.005;
Kip = 1.5e-6;
Ky_no_det = 0.02;
Ky_det = 0.2;
satLimit = 0.15;

% yaw gains 
ySetpoint = 120; % Setpoint of River Line Midpoint
filtTimeConstant = 1;
dt = 1/25;
alpha = dt / ( filtTimeConstant + dt);

% unpack state
yaw = stateEstimateMsg.Yaw;

if isempty(filtPixelY)
    filtPixelY = 0;
    errorSumY = 0;
    diffY = 0;
    desiredYaw = yaw;
end

filtPixelYprev = filtPixelY;

if ( rDetected )
    % pitch to hold river distance
    yMid = (yRight + yLeft)/2;
    yError = yMid - ySetpoint;
    filtPixelY = filtPixelY - Ky_det*(filtPixelY - yError);
    
    % yaw to align with river 
    delY = yRight - yLeft;    
    rAngle = atand(delY,720);      
    desiredYawCurrent = yaw + rAngle;
    desiredYaw = (1-alpha)*desiredYaw + alpha*desiredYawCurrent;    
else
    % converge to zero
    filtPixelY = filtPixelY - Ky_no_det*(filtPixelY);    
end

% leaky integrator (y pixel)
errorSumY = errorSumY + filtPixelY;
errorSumY = 0.95*errorSumY ;

% low pass filter (y pixel)
diffY = (1-alpha)*diffY + alpha*(filtPixelY - filtPixelYprev);

% command
pitchCmd = -Kpitch*filtPixelY - Kdp*diffY - Kip*errorSumX;

% saturate, set pitch command
ayprCmd.PitchDesiredDegrees = max(-satLimit, min(satLimit, pitchCmd));

% set yaw comand
ayprCmd.YawDesiredDegrees = desiredYaw;

% behavior completes after time elapsed
if bhvTime >= completion.durationSec
    completionFlag = 1;
    return;
end
completionFlag = 0;

% write log
pFile = fopen( riverLog  ,'a');
fprintf(pFile,'%6.6f,',bhvTime);
fprintf(pFile,'%6.6f,',rDetected);
fprintf(pFile,'%6.6f,',yLeft);
fprintf(pFile,'%6.6f,',yRight);
fprintf(pFile,'%6.6f,',yMid);
fprintf(pFile,'%6.6f,',yError);
fprintf(pFile,'%6.6f,',filtPixelY);
fprintf(pFile,'%6.6f,',delY);
fprintf(pFile,'%6.6f,',rAngle);
fprintf(pFile,'%6.6f,',desiredYaw);
fprintf(pFile,'%6.6f,',errorSumY);
fprintf(pFile,'%6.6f,',diffY);
fprintf(pFile,'%6.6f,',pitchCmd);
fprintf(pFile,'%6.6f,',ayprCmd.PitchDesiredDegrees);
fprintf(pFile,'%6.6f,',ayprCmd.YawDesiredDegrees);
fprintf(pFile,'%6.6f,',theta);
fprintf(pFile,'%6.6f,\n',yaw);
fclose(pFile);

end