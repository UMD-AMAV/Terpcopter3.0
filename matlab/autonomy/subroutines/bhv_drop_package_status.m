function [completionFlag, servoCmd] = bhv_drop_package_status(completion, t)
    global timestamps 
    
    current_event_time = t;
  
    elapsed_satisfied_time = current_event_time - timestamps.behavior_satisfied_timestamp;
    
    if elapsed_satisfied_time >= completion.durationSec
        completionFlag = 1;
        servoCmd = -1;
        return;
    end
    
    servoCmd = 1;
    completionFlag = 0;
end