function [completionFlag, ayprCmd] = bhv_hover_over_H_key(stateEstimateMsg, ayprCmd, completion, bhvTime, hDetected, hAngle, hPixelX, hPixelY)
    
    % hDetected = 0 (no H detected) , 1 (H detected) 
    % hAngle = -180 to 180 (deg) 
    % hPixelX = -360 to 360 (pixels)
    % hPixelY = -640 to 640

    % unpack state estimate
    % pitch = stateEstimateMsg.PitchDegrees;
    % roll = stateEstimateMsg.RollDegrees;    
    % yaw = stateEstimateMsg.YawDegrees;
    
    global key_roll key_pitch;
        
    % set ayprCmd
    % - set ayprCmdMsg.PitchDesiredDegrees = 0;
    % ayprCmd.YawDesiredDegrees = yawDesired;
    
    arrowPixelIncrement = 10;
    hPixelX  = arrowPixelIncrement*key_roll;
    hPixelY = arrowPixelIncrement*key_pitch;
    
    pixelStickGainPitch = 0.005;
    pixelStickGainRoll = 0.005;
    
    rawPitchCmd = hPixelX * pixelStickGainPitch;
    rawRollCmd = hPixelY * pixelStickGainRoll;
    
    satLimit = 0.4;
    ayprCmd.PitchDesiredDegrees = max(-satLimit, min(satLimit, rawPitchCmd));
    ayprCmd.RollDesiredDegrees = min(-satLimit, min(satLimit, rawRollCmd));
    
    % saturate
    
    disp('-------');
    fprintf('Roll (Arrow, HPixel, RawVal, StickCmd) = (%d, %d, %3.3f, %3.3f)\n',key_roll, hPixelX, rawPitchCmd, ayprCmd.PitchDesiredDegrees);
    fprintf('Pitch (Arrow, HPixel, RawVal, StickCmd) = (%d, %d, %3.3f, %3.3f)\n',key_pitch, hPixelY, rawRollCmd, ayprCmd.RollDesiredDegrees);
    
    
    % Terminating condition
    if bhvTime >= completion.durationSec
        completionFlag = 1;
        return;
    end
    completionFlag = 0;
end