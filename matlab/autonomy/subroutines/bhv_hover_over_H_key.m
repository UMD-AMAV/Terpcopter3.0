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
    
    arrowPixelIncrement = 5;
    hPixelX  = arrowPixelIncrement*key_roll;
    hPixelY = arrowPixelIncrement*key_pitch;
    
    pixelStickGainPitch = 0.001;
    pixelStickGainRoll = 0.001;
    
    ayprCmd.PitchDesiredDegrees = hPixelX * pixelStickGainPitch;
    ayprCmd.RollDesiredDegrees = hPixelY * pixelStickGainRoll;
    
    disp('-------');
    fprintf('Roll (Arrow, HPixel, StickCmd) = (%d, %d, %3.3f)\n',key_roll, hPixelX, ayprCmd.PitchDesiredDegrees);
    fprintf('Pitch (Arrow, HPixel, StickCmd) = (%d, %d, %3.3f)\n',key_pitch, hPixelY, ayprCmd.RollDesiredDegrees);
    
    
    % Terminating condition
    if bhvTime >= completion.durationSec
        completionFlag = 1;
        return;
    end
    completionFlag = 0;
end