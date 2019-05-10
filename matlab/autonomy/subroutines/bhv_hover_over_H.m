function [completionFlag, ayprCmd] = bhv_hover_over_H(stateEstimateMsg, ayprCmd, completion, bhvTime, hDetected, hAngle, hPixelX, hPixelY, bhvLog)

% hDetected = 0 (no H detected) , 1 (H detected)
% hAngle = -180 to 180 (deg)
% hPixelX = -360 to 360 (pixels)
% hPixelY = -640 to 640

% unpack state estimate
% pitch = stateEstimateMsg.PitchDegrees;
% roll = stateEstimateMsg.RollDegrees;
% yaw = stateEstimateMsg.YawDegrees;

% Note: Pitch cmd (+) = negative pitch (nose down)
%       Roll cmd (-) = positivie roll (right wing down)

persistent filtPixelX filtPixelY errorSumX errorSumY diffX diffY;

% gains/params
Kroll = 0.03/100; %
Kdr = 0.005; %0.005; % this term will multiply ~ 1 pixel change per timestep (~0.04 sec)
Kir = 1e-6;

Kpitch = 0.03/100;
Kdp = 0.005; %0.005;
Kip = 1e-6;

Kx_no_det = 0.02;
Ky_no_det = 0.02;
Kx_det = 0.2;
Ky_det = 0.2;
satLimit = 0.15;

filtTimeConstant = 1;
dt = 1/25;

% pixelWidth = 640;
% pixelHeight = 480;

% unpack state
% z = stateEstimateMsg.Range;
theta = stateEstimateMsg.Pitch;
phi = stateEstimateMsg.Roll;

if isempty(filtPixelX)
    filtPixelX = 0;
    filtPixelY = 0;
    errorSumX = 0;
    errorSumY = 0;
    diffX = 0;
    diffY = 0;
end

% save pixelX from previous step for computing derivative
filtPixelXprev = filtPixelX;
filtPixelYprev = filtPixelY;

if ( hDetected )
    filtPixelX = filtPixelX - Kx_det*(filtPixelX - hPixelX);
    filtPixelY = filtPixelY - Ky_det*(filtPixelY - hPixelY);
    
else
    % converge to zero
    filtPixelX = filtPixelX - Kx_no_det*(filtPixelX);
    filtPixelY = filtPixelY - Ky_no_det*(filtPixelY);
    %         % diverge
    %         filtPixelX = filtPixelX + Kx_no_det*(filtPixelX);
    %         filtPixelY = filtPixelY + Ky_no_det*(filtPixelY);
end

% integrator
errorSumX = errorSumX + filtPixelX;
errorSumY = errorSumY + filtPixelY;

% leaky integrator
errorSumX = 0.95*errorSumX ;
errorSumY = 0.95*errorSumY ;


% control (P)
% pitchCmd = -Kpitch*filtPixelY;
% rollCmd = -Kroll*filtPixelX;

% low-pass filter
alpha = dt / ( filtTimeConstant + dt);
diffY = (1-alpha)*diffY + alpha*(filtPixelY - filtPixelYprev);
diffX = (1-alpha)*diffX + alpha*(filtPixelX - filtPixelXprev);

% % control (PD)
% % pitchCmd = -Kpitch*filtPixelY + Kdp*(filtPixelY - filtPixelYprev);
% % rollCmd = -Kroll*filtPixelX  + Kdr*(filtPixelX - filtPixelXprev);
% pitchCmd = -Kpitch*filtPixelY - Kdp*diffY;
% rollCmd = -Kroll*filtPixelX  - Kdr*diffX;

% % control (PI)
% pitchCmd = -Kpitch*filtPixelY - Kip*errorSumX;
% rollCmd = -Kroll*filtPixelX  - Kir*errorSumY;

% control (PID)
pitchCmd = -Kpitch*filtPixelY - Kdp*diffY - Kip*errorSumX;
rollCmd = -Kroll*filtPixelX  - Kdr*diffX - Kir*errorSumY;

% correct for pitch/roll
% pitchDesired = pitchDesired;% - pixelHeight/2*Kpitch*z*tand(theta);
% rollDesired = rollDesired;% + pixelWidth/2*Kroll*z*tand(phi);

% saturate
ayprCmd.PitchDesiredDegrees = max(-satLimit, min(satLimit, pitchCmd));
ayprCmd.RollDesiredDegrees = max(-satLimit, min(satLimit, rollCmd));

% behavior completes after time elapsed
if bhvTime >= completion.durationSec
    completionFlag = 1;
    return;
end
completionFlag = 0;

% for logging only:
pitchCmdProp = -Kpitch*filtPixelY;
rollCmdProp =  -Kroll*filtPixelX;

% write log
pFile = fopen( bhvLog  ,'a');
fprintf(pFile,'%6.6f,',bhvTime);
fprintf(pFile,'%6.6f,',hPixelX);
fprintf(pFile,'%6.6f,',hPixelY);
fprintf(pFile,'%6.6f,',filtPixelX);
fprintf(pFile,'%6.6f,',filtPixelY);
fprintf(pFile,'%6.6f,',hDetected);

fprintf(pFile,'%6.6f,',pitchCmdProp);
fprintf(pFile,'%6.6f,',pitchCmd);
fprintf(pFile,'%6.6f,',ayprCmd.PitchDesiredDegrees);
fprintf(pFile,'%6.6f,',theta);

fprintf(pFile,'%6.6f,',rollCmdProp);
fprintf(pFile,'%6.6f,',rollCmd);
fprintf(pFile,'%6.6f,',ayprCmd.RollDesiredDegrees);
fprintf(pFile,'%6.6f,\n',phi);

fclose(pFile);

end