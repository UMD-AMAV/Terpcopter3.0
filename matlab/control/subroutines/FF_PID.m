function [u, error] = FF_PID(gains, error, newTime, newVal)

% compute PID error terms
dt = newTime - error.lastTime; % time since last command issued 
edot = (newVal - error.lastVal) / dt; % approximate derivative
error.lastSum = error.lastSum + newVal*dt; % approximat inetgral

% pid control + feed-forward term
u = -gains.kp*newVal - gains.kd*edot -gains.ki*error.lastSum + gains.ffterm;

% update error variables (for use in next iteration)
error.lastTime = newTime;
error.lastVal = newVal;
end