function [completionFlag, ayprCmd] = bhv_fly_forward_flowprobe(stateEstimateMsg, ayprCmd, fpMsg, completion, bhvTime)

%% output pitchDesiredDeg

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

%% set ayprCmd
ayprCmdMsg.PitchDesiredDegrees = pitchDesiredDeg;

% complete
if bhvTime >= completion.durationSec
    completionFlag = 1;
    return;
end
completionFlag = 0;
end