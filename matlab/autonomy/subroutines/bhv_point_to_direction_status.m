function completionFlag = bhv_point_to_direction_status(stateEstimateMsg, ayprCmd, completion, t)
    global timestamps
    toleranceRadians = 0.35; 
    
    disp(stateEstimateMsg.Yaw);
    
    yawDesiredRadians = deg2rad(ayprCmd.YawDesiredDeg);
    
    pointToDirectionComplete = abs(yawDesiredRadians - stateEstimateMsg.Yaw) < toleranceRadians;
    
    if pointToDirectionComplete
        disp('point to direction satisfied')
        current_event_time = t;
    else
        disp('point to direction not satisfied')
        current_event_time = t;
        timestamps.behavior_satisfied_timestamp = t;
    end
    yaw_current = rad2deg(stateEstimateMsg.Yaw);
    elapsed_satisfied_time = current_event_time - timestamps.behavior_satisfied_timestamp;
    fprintf('Desired Yaw: %f Degrees\tCurrent Yaw %f Degrees\nDesired Time: %f\tElapsed time: %f\n', ayprCmd.desiredYawDegrees, yaw_current, completion.durationSec, elapsed_satisfied_time);
    
    if elapsed_satisfied_time >= completion.durationSec
        completionFlag = 1;
        return;
    end
    completionFlag = 0;
end