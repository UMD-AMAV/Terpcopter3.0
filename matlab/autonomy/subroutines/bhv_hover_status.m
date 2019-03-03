function completionFlag = bhv_hover_status(stateEstimateMsg, ahs, completion, t)
    global timestamps
    toleranceMeters = 0.1;
    
    hoverAltComplete = abs(ahs.desiredAltMeters - stateEstimateMsg.Up) < toleranceMeters;
    
    % fprintf('Task: Hover at %f meters for %f seconds\n', ahs.desiredAltMeters, completion.durationSec);
    
    if hoverAltComplete
        disp('hover alt satisfied');
        current_event_time = t;
    else
        disp('hover alt not satisfied');
        current_event_time = t;
        timestamps.behavior_satisfied_timestamp = t;
    end
    elapsed_satisfied_time = current_event_time - timestamps.behavior_satisfied_timestamp;
    fprintf('Desired Altitude: %f meters\tCurrent Altitude %f meters\nDesired Time: %f\tElapsed time: %f\n', ahs.desiredAltMeters, stateEstimateMsg.Up, completion.durationSec,elapsed_satisfied_time);
    
    if elapsed_satisfied_time >= completion.durationSec
        completionFlag = 1;
        return;
    end
    completionFlag = 0;
end
