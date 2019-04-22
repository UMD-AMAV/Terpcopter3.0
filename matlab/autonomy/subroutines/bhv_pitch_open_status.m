function [completionFlag, open_stick_cmd] = bhv_pitch_open_status(stateEstimateMsg, ahs, completion,t)
   global timestamps
   disp('bhv_pitch_open');
   current_event_time = t;
    
   elapsed_satisfied_time = current_event_time - timestamps.behavior_satisfied_timestamp;
   
   if elapsed_satisfied_time >= completion.durationSec
       open_stick_cmd.thrust = 0;
       open_stick_cmd.yaw = 0;
       open_stick_cmd.pitch = 0;
       open_stick_cmd.roll = 0;
       completionFlag = 1;
       return;
   end
   open_stick_cmd.thrust = 0;
   open_stick_cmd.yaw = 0;
   open_stick_cmd.pitch = 0.3;
   open_stick_cmd.roll = 0;
   completionFlag = 0;
end