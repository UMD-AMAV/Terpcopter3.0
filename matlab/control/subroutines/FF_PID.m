function [u, errorHistory] = FF_PID(gains, errorHistory, curTime, error)

% unpack variables for convenience
feedForwardValue = gains.Ff;
saturationLimit = gains.saturationLimit;

%% Outer Loop:
% desired error rate
vDes = feedForwardValue*error;

% saturate
vDes = max(min(vDes,saturationLimit),-saturationLimit);

% time elapsed since last control
dt = curTime - errorHistory.lastTime;
%fprintf("e: %6.2f \n",e);

% derivative of error
eDot = (error - errorHistory.lastVal) / dt;
%fprintf("eDot: %6.2f",eDot);

% actual error rate 
v = -eDot;

% 
eDotDot = (eDot - errorHistory.lastError) / dt;
vDot = -eDotDot;

% 
vDesDot = feedForwardValue*eDot;


%% Inner Loop:
eVel = vDes - v;
%fprintf("eVel: %6.2f",eVel);

eDotVel = vDesDot - vDot;
%fprintf("eDotVel: %6.2f",eDotVel);

% This error is for eVel, NOT e (last sum of velocity errors)
errorHistory.lastSum = errorHistory.lastSum + (eVel * dt);

% compute PID control
u = gains.Kp *eVel + gains.Kd * eDotVel + ...
    gains.Ki * errorHistory.lastSum;

%fprintf("u: %6.3f",u);

% update persistent variable
errorHistory.lastError = eDot;
errorHistory.lastTime = curTime;
errorHistory.lastVal = error;




% %2018 code controller 
% fprintf("currTime: %6.2f \n",currTime);
% dt = currTime - altitudeErrorHistory.lastTime;
% 
% fprintf("dt: %6.2f \n",dt);
% 
% altitudeErrorHistory.lastSum = altitudeErrorHistory.lastSum + altError * dt;
% 
% disp(altitudeErrorHistory);
% 
% errorDot = (altError - altitudeErrorHistory.lastVal) / dt;
% 
% fprintf("errorDot: %6.2f",errorDot);
% 
% u = gains.Kp *altError + gains.Kd * errorDot + gains.Ff + ...
%     gains.Ki * altitudeErrorHistory.lastSum;
% 
% fprintf("u: %6.2f",u);
% 
% %anti-windup
% % stop_e_int = (u>=1 && altError>=0 )||(u<=-1 && altError<=0);
% % if ~stop_e_int
% %     altitudeErrorHistory.lastSum = altitudeErrorHistory.lastSum + altError * dt; 
% % end
%     
% % update error variables (for use in next iteration)
% altitudeErrorHistory.lastTime = currTime;
% altitudeErrorHistory.lastVal = altError;
%     
% % ENU frame 
% % ref: http://brettbeauregard.com/blog/2011/04/improving-the-beginners-pid-introduction/
% % kp *e + ki*integral(e)*dt + kd*edot + FF_const
% 
% % error = z_desired - z_current;
% % errorSum += (error) * dt
% % errorDot = (currentError - lastError) / dt
% % kp *(error) + ki* (errorSum) + kd * errorDot
% 
% 
% % compute PID error terms
% % dt = newTime - error.lastTime; % time since last command issued 
% % edot = (newErrVal - error.lastVal) / dt; % approximate derivative
% % 
% % u_intermediate = -gains.kp*newErrVal - gains.kd*edot + gains.ffterm;
% % k_intermediate = -gains.ki*error.lastSum;
% % ki_next = -gains.ki*(newErrVal);
% % disp('u_intermediate')
% % disp(u_intermediate)
% % if ((u_intermediate + k_intermediate) > -1) && ((u_intermediate + k_intermediate) < 1)
% %     error.lastSum = error.lastSum + newErrVal*dt; % approximat inetgral
% %     disp('new error value')
% %     disp(newErrVal*dt)
% % elseif ((u_intermediate + k_intermediate) < -1) && (ki_next > 0 )
% %     error.lastSum = error.lastSum + newErrVal*dt; % approximat inetgral
% % elseif ((u_intermediate + k_intermediate) > 1) && (ki_next < 0 )
% %     error.lastSum = error.lastSum + newErrVal*dt; % approximat inetgral
% % else
% %     error.lastSum = error.lastSum;
% % end
% % %error.lastSum = max(min(10,error.lastSum),-10); % prevent error saturation
% % disp('accumulated error')
% % disp(error.lastSum);
% % % pid control + feed-forward term
% % u = -gains.kp*newErrVal - gains.kd*edot -gains.ki*error.lastSum + gains.ffterm;
% % % update error variables (for use in next iteration)
% % error.lastTime = newTime;
% % error.lastVal = newErrVal;
end