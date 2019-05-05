function [completionFlag, ayprCmd] = bhv_hover_over_H(stateEstimateMsg, ayprCmd, completion, bhvTime, hDetected, hAngle, hPixelX, hPixelY)

% hDetected = 0 (no H detected) , 1 (H detected)
% hAngle = -180 to 180 (deg)
% hPixelX = -360 to 360 (pixels)
% hPixelY = -640 to 640

% unpack state estimate
% pitch = stateEstimateMsg.PitchDegrees;
% roll = stateEstimateMsg.RollDegrees;
% yaw = stateEstimateMsg.YawDegrees;

% TODO:
% - add topic with H (x,y) data as input
% - do some processing
persistent lastPixelX lastPixelY lastValidUpdateTime;
Kx = 0.05/100; % was /5          % over 2m   Kx = 0.02/100
Ky = 0.05/100;                   % over 2m   Ky = 0.02/100
Rlatch = 100;% radius (pixels);
Rdz = 15;
latchOnTime = 4.0; % sec
satLimit = 0.1;                 % over 2m   satLimit = 0.1

if isempty(lastPixelX)
    lastPixelX = 0;
    lastPixelY = 0;
    lastValidUpdateTime = -1E3;
    pitchDesired = 0;
    rollDesired = 0;
else
    if ( hDetected )
        % yawDesired = yaw + hAngle;
        
        % we recently detected the H, use the last value to reject outliers
        if ( bhvTime - lastValidUpdateTime <= latchOnTime )
            vLast = [lastPixelX lastPixelY];
            vNew = [hPixelX hPixelY];
            if ( norm(vLast-vNew) <= Rlatch ) % accept
                disp('H detected: Within radius, updated H pixels');
                lastPixelX = hPixelX;
                lastPixelY = hPixelY;
                lastValidUpdateTime = bhvTime;
                pitchDesired = Ky*hPixelY;
                rollDesired = Kx*hPixelX;
            else % reject outlier
                disp('H detected: Outside radius, rejecting outlier');
                pitchDesired = Ky*lastPixelY;
                rollDesired = Kx*lastPixelX;
            end
        else
            % first time h is detected, accept value as valid, or
            disp('H detected: first time / or reset , Updated H pixels');
            lastPixelX = hPixelX;
            lastPixelY = hPixelY;
            lastValidUpdateTime = bhvTime;
            pitchDesired = Ky*hPixelY;
            rollDesired = Kx*hPixelX;
        end
    else
        % no H detected, but we recently detected, so use the last value:
        if ( bhvTime - lastValidUpdateTime <= latchOnTime )
            disp('No H: Using last value');
            pitchDesired = Ky*lastPixelY;
            rollDesired = Kx*lastPixelX;
        else  % no H detected in long time (or ever)
            disp('No H: Setting zeros');
            pitchDesired = 0;
            rollDesired = 0;
        end
    end
end
% set ayprCmd
% - set ayprCmdMsg.PitchDesiredDegrees = 0;
% ayprCmd.YawDesiredDegrees = yawDesired;

ayprCmd.PitchDesiredDegrees = max(-satLimit, min(satLimit, pitchDesired));
ayprCmd.RollDesiredDegrees = max(-satLimit, min(satLimit, rollDesired));

if ( hDetected )
    errorR = sqrt(hPixelX*hPixelX + hPixelY*hPixelY);
    if ( errorR <= Rdz )
        disp('In deadzone');
        ayprCmd.PitchDesiredDegrees = 0;
        ayprCmd.RollDesiredDegrees = 0;
    end
end

% Terminating condition
if bhvTime >= completion.durationSec
    completionFlag = 1;
    return;
end
completionFlag = 0;
end