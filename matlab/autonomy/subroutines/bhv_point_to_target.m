function [completionFlag, ayprCmd] = bhv_point_to_target(stateEstimateMsg, yawErrorCameraMsg, ayprCmd, completion, t)
    global timestamps
    toleranceRadians = 5*pi/180;
    fprintf('Point To Target Active\n');
    
    % compute desired yaw angle by adding error to current yaw
    yawCurDeg = stateEstimateMsg.yaw*180/pi;
    yawErrorCameraDegrees = rad2deg(yawErrorCameraMsg.Data);
    ayprCmd.YawDesiredDeg = yawCurDeg + yawErrorCameraDegrees;
    
    % check if complete
    pointToTargetComplete = abs(yawErrorCameraMsg.Data) < toleranceRadians;   
    if pointToTargetComplete
        disp('point to target satisfied')
        current_event_time = t;
    else 
        disp('point to target not satisfied')
        current_event_time = t;
        timestamps.behavior_satisfied_timestamp = t;
    end    
    elapsed_satisfied_time = current_event_time - timestamps.behavior_satisfied_timestamp;
    fprintf('Current Yaw Error: %f Degrees\t Desired Time: %f\tElapsed time: %f\n', yawErrorCameraDegrees, completion.durationSec, elapsed_satisfied_time);
    if elapsed_satisfied_time >= completion.durationSec
        completionFlag = 1;
        return;
    end
    completionFlag = 0;
end   