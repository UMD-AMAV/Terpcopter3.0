function completionFlag = bhv_point_to_direction(stateEstimateMsg, ayprCmd, completion, t, bhvTime)
%     global timestamps
%     toleranceDegrees = 5; 
%     
%     disp(stateEstimateMsg.Yaw);
%     
%     % TODO: modify this to account for 360 deg wraparounds
%     pointToDirectionComplete = abs(ayprCmd.YawDesiredDegrees - stateEstimateMsg.Yaw) < toleranceDegrees;
%     
%     if pointToDirectionComplete
%         disp('point to direction satisfied')
%         current_event_time = t;
%     else
%         disp('point to direction not satisfied')
%         current_event_time = t;
%         timestamps.behavior_satisfied_timestamp = t;
%     end
%     yaw_current = rad2deg(stateEstimateMsg.Yaw);
%     elapsed_satisfied_time = current_event_time - timestamps.behavior_satisfied_timestamp;
%     fprintf('Desired Yaw: %f Degrees\tCurrent Yaw %f Degrees\nDesired Time: %f\tElapsed time: %f\n', ayprCmd.YawDesiredDegrees, stateEstimateMsg.Yaw, completion.durationSec, elapsed_satisfied_time);
%     
    if bhvTime >= completion.durationSec
        completionFlag = 1;
        return;
    end
    completionFlag = 0;
end