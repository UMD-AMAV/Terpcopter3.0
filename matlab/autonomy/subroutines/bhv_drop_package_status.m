function [completionFlag, servoCmd] = bhv_drop_package_status(completion, t)
    global timestamps 
    
    current_event_time = t;
  
    elapsed_satisfied_time = current_event_time - timestamps.behavior_satisfied_timestamp;
    fprintf('Desired Yaw: %f Degrees\tCurrent Yaw %f Degrees\nDesired Time: %f\tElapsed time: %f\n', ahs.desiredYawDegrees, yaw_current, completion.durationSec, elapsed_satisfied_time);
    
    if elapsed_satisfied_time >= completion.durationSec
        completionFlag = 1;
        servoCmd = -1;
        return;
    end
    
    servoCmd = 1;
    completionFlag = 0;
end