function [completionFlag, ayprCmd] = bhv_hover_over_H_impulse_bound(stateEstimateMsg, ayprCmd, completion, bhvTime, hDetected, hAngle, hPixelX, hPixelY)

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
persistent lastPixelX lastPixelY lastValidUpdateTime lastImpulseInitialTime initiated validCounts pitchImpulse rollImpulse;
Kx = 0.05/100; % was /5          % over 2m   Kx = 0.02/100
Ky = 0.05/100;                   % over 2m   Ky = 0.02/100

boundRadius = 0;  
start_impulse = 0;
impulsePitch = 0.075;
impulseRoll = 0.075;
Rlatch = 100;% radius (pixels);
impulseDuration = 0.3;
latchOnTime = 4.0; % sec
satLimit = 0.1;                 % over 2m   satLimit = 0.1
validThreshold = 2; % No. of Valid frames in vicinty to trust H location
            pitchDesired = 0;
            rollDesired = 0;

if isempty(lastPixelX)
    lastPixelX = 0;
    lastPixelY = 0;
    lastValidUpdateTime = -1E3;
    lastImpulseInitialTime = -1E3; % elapsed time since last impulse initiated
    initiated = 0;
else
    if ( hDetected )
        if ( bhvTime - lastValidUpdateTime <= latchOnTime  && validCounts > validThreshold) % if H detected within last 'latchOnTime' seconds
            vLast = [lastPixelX lastPixelY];
            vNew = [hPixelX hPixelY];
            if ( norm(vLast-vNew) <= Rlatch) % accept
                disp('H detected: Within radius, updated H pixels');
                lastPixelX = hPixelX;
                lastPixelY = hPixelY;
                lastValidUpdateTime = bhvTime;
                radiusPixels = sqrt(hPixelX^2 + hPixelY^2);
                if radiusPixels > boundRadius
                    start_impulse = 1;
                end
            else % reject outlier
                disp('H detected: Outside radius, rejecting outlier');
            end
        else
            % first time h is detected, accept value as valid only after 3
            % frames in vicinity
            disp('H detected: first time / or reset , Updated H pixels');
            if (validCounts == 0)
                lastPixelX = hPixelX;
                lastPixelY = hPixelY;
            end
            vLast = [lastPixelX lastPixelY];
            vNew = [hPixelX hPixelY];
            if ( norm(vLast-vNew) <= Rlatch) % accept
                disp('H detected: Within radius, updated H pixels');
                validCounts = validCounts + 1;
                lastPixelX = hPixelX;
                lastPixelY = hPixelY;
                if (validCounts > validThreshold)
                    lastValidUpdateTime = bhvTime;
                end
                
            else
                validCounts = 0;
            end
        end
    else
        % no H detected, but we recently detected, so use the last value:
        if ( bhvTime - lastValidUpdateTime <= latchOnTime )
            disp('No H: Using last value');
            pitchDesired = 0;
            rollDesired = 0;
        else  % no H detected in long time (or ever)
            disp('No H: Setting zeros');
            pitchDesired = 0;
            rollDesired = 0;
        end
    end
end

if (start_impulse && ~initiated)
    radiusPixels = sqrt(hPixelX^2 + hPixelY^2);
    if radiusPixels > boundRadius
        lastImpulseInitialTime = bhvTime ;
        initiated = 1;
        pitchImpulse = (hPixelY/radiusPixels)*impulsePitch;
        rollImpulse = (hPixelX/radiusPixels)*impulseRoll;
    end
end
if (initiated)
    if((bhvTime - lastImpulseInitialTime) > impulseDuration)
        pitchDesired = 0;
        rollDesired = 0;
        initiated = 0;
    else
        pitchDesired = pitchImpulse;
        rollDesired = rollImpulse;
    end
end
ayprCmd.PitchDesiredDegrees = max(-satLimit, min(satLimit, pitchDesired));
ayprCmd.RollDesiredDegrees = max(-satLimit, min(satLimit, rollDesired));




% Terminating condition
if bhvTime >= completion.durationSec
    completionFlag = 1;
    return;
end
completionFlag = 0;
end