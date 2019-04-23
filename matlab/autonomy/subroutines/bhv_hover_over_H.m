function [completionFlag, ayprCmd] = bhv_hover_over_H(stateEstimateMsg, ayprCmd, completion, bhvTime)

    % unpack state estimate
    pitchDeg = stateEstimateMsg.Pitch;
    rollDeg = stateEstimateMsg.Deg;

    % TODO: 
    % - add topic with H (x,y) data as input
    % - do some processing    
    
    % - set ayprCmdMsg.PitchDesiredDegrees = 0;
    % - set ayprCmdMsg.RollDesiredDegrees = 0;
    
    % Terminating condition
    if bhvTime >= completion.durationSec
        completionFlag = 1;
        return;
    end
    completionFlag = 0;
end