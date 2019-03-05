function completionFlag = bhv_point_to_target_status(stateEstimateMsg, ahs, completion, t)
    global timestamps
    toleranceRadians = 0.35; 
    
    yawDesiredRadians = deg2rad(ahs.desiredYawDegrees);
    
    pointToDirectionComplete = abs(yawDesiredRadians - stateEstimateMsg.Yaw) < tolerance;
    
    if pointToDirectionComplete
        disp('point to direction satisfied')
        current_event_time = t;
    else
        disp('point to direction satisfied')
        current_event_time = t;
        timestamps.behavior_satisfied_timestamp = t;
    end
    elapsed_satisfied_time = current_event_time - timestamps.behavior_satisfied_timestamp;
    fprintf('Desired Yaw: %f Degrees\tCurrent Yaw %f Degrees\nDesired Time: %f\tElapsed time: %f\n', ahs.desiredYawDegrees, rad2deg(stateEstimateMsg.Yaw), completion.durationSec,elapsed_satisfied_time);
    
    if elapsed_satisfied_time >= completion.durationSec
        completionFlag = 1;
        return;
    end
    completionFlag = 0;
end