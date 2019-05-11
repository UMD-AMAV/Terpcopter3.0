function [completionFlag, ayprCmd] = bhv_hover_over_Artag(stateEstimateMsg, ayprCmd, completion, bhvTime, tagDetected, tagAngle, tagPixelX, tagPixelY)
    
    % convert to x pixels: 640/2.842 * m 
    % convert to y pixels: 480/2.032 * m 
    
    % topic name: arPose :geomentry msg 
    
    global key_roll key_pitch;
        
    % set ayprCmd
    % - set ayprCmdMsg.PitchDesiredDegrees = 0;
    % ayprCmd.YawDesiredDegrees = yawDesired;
    
    arrowPixelIncrement = 10;
    tagPixelX  = arrowPixelIncrement*key_roll;
    tagPixelY = arrowPixelIncrement*key_pitch;
    
    pixelStickGainPitch = 0.005;
    pixelStickGainRoll = 0.005;
    
    rawPitchCmd = tagPixelX * pixelStickGainPitch;
    rawRollCmd = tagPixelY * pixelStickGainRoll;
    
    satLimit = 0.4;
    ayprCmd.PitchDesiredDegrees = max(-satLimit, min(satLimit, rawPitchCmd));
    ayprCmd.RollDesiredDegrees = max(-satLimit, min(satLimit, rawRollCmd));
    
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