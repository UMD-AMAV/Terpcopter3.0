function [u, error] = FF_PID(gains, error, newTime, newErrVal)

% compute PID error terms
dt = newTime - error.lastTime; % time since last command issued 
edot = (newErrVal - error.lastVal) / dt; % approximate derivative

u_intermediate = -gains.kp*newErrVal - gains.kd*edot + gains.ffterm;
k_intermediate = -gains.ki*error.lastSum;
ki_next = -gains.ki*(newErrVal);
disp('u_intermediate')
disp(u_intermediate)
if ((u_intermediate + k_intermediate) > -1) && ((u_intermediate + k_intermediate) < 1)
    error.lastSum = error.lastSum + newErrVal*dt; % approximat inetgral
    disp('new error value')
    disp(newErrVal*dt)
elseif ((u_intermediate + k_intermediate) < -1) && (ki_next > 0 )
    error.lastSum = error.lastSum + newErrVal*dt; % approximat inetgral
elseif ((u_intermediate + k_intermediate) > 1) && (ki_next < 0 )
    error.lastSum = error.lastSum + newErrVal*dt; % approximat inetgral
else
    error.lastSum = error.lastSum;
end
%error.lastSum = max(min(10,error.lastSum),-10); % prevent error saturation
disp('accumulated error')
disp(error.lastSum);
% pid control + feed-forward term
u = -gains.kp*newErrVal - gains.kd*edot -gains.ki*error.lastSum + gains.ffterm;
% update error variables (for use in next iteration)
error.lastTime = newTime;
error.lastVal = newErrVal;
end