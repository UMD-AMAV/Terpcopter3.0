function completionFlag = bhv_point_to_direction(stateEstimateMsg, ayprCmd, completion, t)
    global timestamps
    toleranceYawDegrees = 5;

    pointToDirectionComplete = abs(rad2deg(signedAngularDist(deg2rad(ayprCmd.YawDesiredDegrees), deg2rad(stateEstimateMsg.Yaw)))) <= toleranceYawDegrees;
    
    if pointToDirectionComplete
        disp('hover alt satisfied');
        current_event_time = t; % reset time for which altitude is satisfied
    else
        disp('hover alt not satisfied');
        current_event_time = t;
        timestamps.behavior_satisfied_timestamp = t;
    end
    
    % require vehicle to maintain altitude within envelope for durationSec
    elapsed_satisfied_time = current_event_time - timestamps.behavior_satisfied_timestamp;
    
    fprintf('Desired Altitude: %f meters\tCurrent Altitude %f meters\nDesired Yaw: %f degrees\tCurrent Yaw %f degrees\nDesired Time: %f\tElapsed time: %f\n', ayprCmd.AltDesiredMeters, stateEstimateMsg.Up, ayprCmd.YawDesiredDegrees, stateEstimateMsg.Yaw,completion.durationSec, elapsed_satisfied_time);
    
    if elapsed_satisfied_time >= completion.durationSec
        completionFlag = 1;
        return;
    end
    completionFlag = 0;
end