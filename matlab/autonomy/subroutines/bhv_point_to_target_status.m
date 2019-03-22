function [completionFlag] = bhv_point_to_target_status(stateEstimateMsg, yawErrorCameraMsg, ahs, completion, t)
    global timestamps
    toleranceRadians = 0.15;
    fprintf('Point To Target Active\n');
    
    pointToTargetComplete = abs(yawErrorCameraMsg.Data) < toleranceRadians;
    
    if pointToTargetComplete
        disp('point to target satisfied')
        current_event_time = t;
    else 
        disp('point to target not satisfied')
        current_event_time = t;
        timestamps.behavior_satisfied_timestamp = t;
    end
    yawErrorCameraDegrees = rad2deg(yawErrorCameraMsg.Data);
    elapsed_satisfied_time = current_event_time - timestamps.behavior_satisfied_timestamp;
    fprintf('Current Yaw Error: %f Degrees\t Desired Time: %f\tElapsed time: %f\n', yawErrorCameraDegrees, completion.durationSec, elapsed_satisfied_time);
    if elapsed_satisfied_time >= completion.durationSec
        completionFlag = 1;
        return;
    end
    completionFlag = 0;
end   