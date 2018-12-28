function [completionFlag] = bhv_hover_status(stateEstimateMsg, ahs, completion, timestamp, t)
    disp('bhv_hover_status');
    
    toleranceMeters = 0.1;
    
    hoverAltComplete = abs(ahs.desiredAltMeters - stateEstimateMsg.Up) < toleranceMeters;
    if hoverAltComplete
        disp('hover alt satisfied');
        current_event_time = t;
    else
        disp('hover alt not satisfied');
        current_event_time = t;
        timestamp.behavior_satisfied_timestamp = t; 
    end
    elapsed_satisfied_time = seconds(current_event_time - timestamp.behavior_satisfied_timestamp);
    
    if elapsed_satisfied_time >= completion.durationSec
        disp('hover is complete')
        completionFlag = 1;
        return;
    end
    completionFlag = 0;
end
