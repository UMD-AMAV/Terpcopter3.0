function completionFlag = bhv_landing_status(stateEstimateMsg, ayprCmd, completion, t)

    global timestamps
    toleranceMeters = 0.05;
    
    hoverAltComplete = abs(ayprCmd.AltDesiredMeters - stateEstimateMsg.Up) <= toleranceMeters;
    
    % fprintf('Task: Hover at %f meters for %f seconds\n', ahs.desiredAltMeters, completion.durationSec);
    
    if hoverAltComplete
        disp('landing alt satisfied');
        current_event_time = t; % reset time for which altitude is satisfied
    else
        disp('landing alt not satisfied');
        current_event_time = t;
        timestamps.behavior_satisfied_timestamp = t;
    end
    
    % require vehicle to maintain altitude within envelope for durationSec
    elapsed_satisfied_time = current_event_time - timestamps.behavior_satisfied_timestamp;
    
    fprintf('Desired Altitude: %f meters\tCurrent Altitude %f meters\nDesired Time: %f\tElapsed time: %f\n', ayprCmd.AltDesiredMeters, stateEstimateMsg.Up, completion.durationSec, elapsed_satisfied_time);
    
    if elapsed_satisfied_time >= completion.durationSec
        completionFlag = 1;
        return;
    end
    completionFlag = 0;
end