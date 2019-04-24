function [completionFlag, servoCmd] = bhv_hover_drop(completion, bhvTime)

    if bhvTime >= completion.durationSec
        completionFlag = 1;
        servoCmd = -1; % closed 
        return;
    end    
    servoCmd = 1; % open
    completionFlag = 0;     
    
end