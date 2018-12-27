function [u, error] = FF_PID(gains, error, newTime, newErrVal)

% compute PID error terms
dt = newTime - error.lastTime; % time since last command issued 
edot = (newErrVal - error.lastVal) / dt; % approximate derivative
error.lastSum = error.lastSum + newErrVal*dt; % approximat inetgral

% pid control + feed-forward term
u = -gains.kp*newErrVal - gains.kd*edot -gains.ki*error.lastSum + gains.ffterm;

% update error variables (for use in next iteration)
error.lastTime = newTime;
error.lastVal = newErrVal;
end