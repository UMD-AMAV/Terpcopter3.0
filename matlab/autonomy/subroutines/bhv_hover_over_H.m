function [completionFlag, ayprCmd] = bhv_hover_over_H(stateEstimateMsg, ayprCmd, completion, bhvTime, hDetected, hAngle, hPixelX, hPixelY)

    % unpack state estimate
    pitch = stateEstimateMsg.PitchDegrees;
    roll = stateEstimateMsg.RollDegrees;
    yaw = stateEstimateMsg.YawDegrees;
    
    % TODO: 
    % - add topic with H (x,y) data as input
    % - do some processing    
    
    % set ayprCmd
    % - set ayprCmdMsg.PitchDesiredDegrees = 0;    
    ayprCmdMsg.yawDesiredDegrees = hAngle;
    
    % Terminating condition
    if bhvTime >= completion.durationSec
        completionFlag = 1;
        return;
    end
    completionFlag = 0;
end