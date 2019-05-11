function [completionFlag, ayprCmd] = bhv_hover_over_H(stateEstimateMsg, ayprCmd, completion, bhvTime, hDetected, hAngle, hPixelX, hPixelY, bhvLog)

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
persistent lastPixelX lastPixelY lastValidUpdateTime filtPixelX filtPixelY;
Kroll = 0.06/100; %
Kpitch = 0.06/100;
Kx_no_det = 0.02;
Ky_no_det = 0.02;
Kx_det = 0.2;
Ky_det = 0.2;

Rlatch = 100;% radius (pixels);
Rdz = 15;
latchOnTime = 4.0; % sec
satLimit = 0.15;                 % over 2m   satLimit = 0.1

pixelWidth = 640;
pixelHeight = 480;

% unpack state
z = stateEstimateMsg.Range;
theta = stateEstimateMsg.Pitch;
phi = stateEstimateMsg.Roll;


if isempty(lastPixelX)
    lastPixelX = 0;
    lastPixelY = 0;
    lastValidUpdateTime = -1E3;
    pitchDesired = 0;
    rollDesired = 0;
    filtPixelX = 0;
    filtPixelY = 0;
else
    if ( hDetected )
        filtPixelX = filtPixelX - Kx_det*(filtPixelX - hPixelX);
        filtPixelY = filtPixelY - Ky_det*(filtPixelY - hPixelY);
        
        % we recently detected the H, use the last value to reject outliers
        if ( bhvTime - lastValidUpdateTime <= latchOnTime )
            vLast = [lastPixelX lastPixelY];
            vNew = [hPixelX hPixelY];
            if ( norm(vLast-vNew) <= Rlatch ) % accept
                disp('H detected: Within radius, updated H pixels');
                lastPixelX = hPixelX;
                lastPixelY = hPixelY;
                lastValidUpdateTime = bhvTime;
                %pitchDesired = Kpitch*hPixelY;
                %rollDesired = Kroll*hPixelX;
                pitchDesired = Kpitch*filtPixelY;
                rollDesired = Kroll*filtPixelX;
            else % reject outlier
                disp('H detected: Outside radius, rejecting outlier');
                %                pitchDesired = Kpitch*lastPixelY;
                %                 rollDesired = Kroll*lastPixelX;
                pitchDesired = Kpitch*filtPixelY;
                rollDesired = Kroll*filtPixelX;
            end
        else
            % first time h is detected, accept value as valid, or
            disp('H detected: first time / or reset , Updated H pixels');
            lastPixelX = hPixelX;
            lastPixelY = hPixelY;
            lastValidUpdateTime = bhvTime;
            
            %             pitchDesired = Kpitch*hPixelY;
            %             rollDesired = Kroll*hPixelX;
            pitchDesired = Kpitch*filtPixelY;
            rollDesired = Kroll*filtPixelX;
        end
    else
        % no H detected, but we recently detected, so use the last value:
        filtPixelX = filtPixelX - Kx_no_det*(filtPixelX);
        filtPixelY = filtPixelY - Ky_no_det*(filtPixelY);
        
        if ( bhvTime - lastValidUpdateTime <= latchOnTime )
            disp('No H: Using last value');
            %             pitchDesired = Kpitch*lastPixelY;
            %             rollDesired = Kroll*lastPixelX;
            pitchDesired = Kpitch*filtPixelY;
            rollDesired = Kroll*filtPixelX;
        else  % no H detected in long time (or ever)
            disp('No H: Setting zeros');
            %             pitchDesired = 0;
            %             rollDesired = 0;
            pitchDesired = Kpitch*filtPixelY;
            rollDesired = Kroll*filtPixelX;
        end
    end
end
% set ayprCmd
% - set ayprCmdMsg.PitchDesiredDegrees = 0;
% ayprCmd.YawDesiredDegrees = yawDesired;

pitchDesiredRaw = pitchDesired;
rollDesiredRaw = rollDesired;

% correct for pitch/roll
%TODO : rename from desired to cmds 
pitchDesired = -pitchDesired;% - pixelHeight/2*Kpitch*z*tand(theta);
rollDesired = -rollDesired;% + pixelWidth/2*Kroll*z*tand(phi);


% saturate
% TODO: Pitch cmd (+) = negative pitch (nose down)
% Roll cmd (-) = positivie roll (right wing down)

ayprCmd.PitchDesiredDegrees = max(-satLimit, min(satLimit, pitchDesired));
ayprCmd.RollDesiredDegrees = max(-satLimit, min(satLimit, rollDesired));

% if ( hDetected )
%     errorR = sqrt(hPixelX*hPixelX + hPixelY*hPixelY);
%     if ( errorR <= Rdz )
%         disp('In deadzone');
%         ayprCmd.PitchDesiredDegrees = 0;
%         ayprCmd.RollDesiredDegrees = 0;
%     end
% end

% Terminating condition
if bhvTime >= completion.durationSec
    completionFlag = 1;
    return;
end
completionFlag = 0;


displayFlag = 1;
if ( displayFlag )
    
    pFile = fopen( bhvLog  ,'a');
    
    % write csv file
    fprintf(pFile,'%6.6f,',bhvTime);
    fprintf(pFile,'%6.6f,',hPixelX);
    fprintf(pFile,'%6.6f,',hPixelY);
    fprintf(pFile,'%6.6f,',filtPixelX);
    fprintf(pFile,'%6.6f,',filtPixelY);
    fprintf(pFile,'%6.6f,',hDetected);
    fprintf(pFile,'%6.6f,',pitchDesiredRaw);
    fprintf(pFile,'%6.6f,',pitchDesired);
    
    fprintf(pFile,'%6.6f,',rollDesiredRaw);    
    fprintf(pFile,'%6.6f,\n',rollDesired);    
    
    fclose(pFile);
end

end