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

persistent filtPixelX filtPixelY;


% gains/params
Kroll = 0.06/100; %
Kdr = 0.01; % this term will multiply ~ 1 pixel change per timestep (~0.04 sec)
Kpitch = 0.06/100;
Kdp = 0.01;
Kx_no_det = 0.02;
Ky_no_det = 0.02;
Kx_det = 0.2;
Ky_det = 0.2;
satLimit = 0.15; 
% pixelWidth = 640;
% pixelHeight = 480;

% unpack state
% z = stateEstimateMsg.Range;
% theta = stateEstimateMsg.Pitch;
% phi = stateEstimateMsg.Roll;

% save pixelX from previous step for computing derivative
filtPixelXprev = filtPixelX;
filtPixelYprev = filtPixelY;

if isempty(filtPixelX)
    filtPixelX = 0;
    filtPixelY = 0;
else
    if ( hDetected )
        filtPixelX = filtPixelX - Kx_det*(filtPixelX - hPixelX);
        filtPixelY = filtPixelY - Ky_det*(filtPixelY - hPixelY);
        
    else
        filtPixelX = filtPixelX - Kx_no_det*(filtPixelX);
        filtPixelY = filtPixelY - Ky_no_det*(filtPixelY);
    end
end

% control (P)
% pitchCmd = -Kpitch*filtPixelY;
% rollCmd = -Kroll*filtPixelX;

% control (PD)
pitchCmd = -Kpitch*filtPixelY + Kdp*(filtPixelY - filtPixelYprev);
rollCmd = -Kroll*filtPixelX  + Kdr*(filtPixelX - filtPixelXprev);


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

% write log
pFile = fopen( bhvLog  ,'a');
fprintf(pFile,'%6.6f,',bhvTime);
fprintf(pFile,'%6.6f,',hPixelX);
fprintf(pFile,'%6.6f,',hPixelY);
fprintf(pFile,'%6.6f,',filtPixelX);
fprintf(pFile,'%6.6f,',filtPixelY);
fprintf(pFile,'%6.6f,',hDetected);<O
fprintf(pFile,'%6.6f,',pitchCmd);
fprintf(pFile,'%6.6f,\n',rollCmd);
fclose(pFile);

end