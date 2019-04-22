function completionFlag = bhv_fly_forward_flowprobe(stateEstimateMsg, ayprCmd, completion, t)



forwardErrorHistory = struct;
forwardErrorHistory.lastTime = 0; %stateEstimateMsg.Time;
forwardErrorHistory.lastVal = ahsCmdMsg.ForwardSpeedMps;
forwardErrorHistory.lastSum = 0;
forwardErrorHistory.log=[params.env.matlabRoot '/forwardSpeedControl_' datestr(now,'mmmm_dd_yyyy_HH_MM_SS_FFF') '.log'];

u_t_forward = 0;
[u_t_forward, forwardErrorHistory] = forwardcontroller_PID(controlParams.forwardGains , forwardErrorHistory, t, u, u_d)

u_t_alt = 2*max(min(1,u_t_alt),0)-1;
u_d = 0.5; %ahsCmdMsg.ForwardSpeedMps;
% update errors
forwardError = u_d - u;

flowProbeHeight = 0.1;
u = stateEstimateMsg.ForwardVelocity;
if(velCorrect)
    omega = (pitch - lastPitch)/dt;            % not sure of the sign/direction
    u = (u + (omega*flowProbeHeight))/cos(pitch);
end






%     global timestamps
%     toleranceRadians = 0.35;
%
%     disp(stateEstimateMsg.Yaw);
%
%     yawDesiredRadians = deg2rad(ayprCmd.YawDesiredDeg);
%
%     pointToDirectionComplete = abs(yawDesiredRadians - stateEstimateMsg.Yaw) < toleranceRadians;
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
%     fprintf('Desired Yaw: %f Degrees\tCurrent Yaw %f Degrees\nDesired Time: %f\tElapsed time: %f\n', ayprCmd.desiredYawDegrees, yaw_current, completion.durationSec, elapsed_satisfied_time);
%
%     if elapsed_satisfied_time >= completion.durationSec
%         completionFlag = 1;
%         return;
%     end
%     completionFlag = 0;
end