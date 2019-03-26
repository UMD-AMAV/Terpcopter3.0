function [u, errorHistory] = Cascade_PID(gains, errorHistory, curTime, error)
% Note on sign convention: 
% The inner-loop PID controller is of the form
% u = Kp *error +Kd * error-dot +  Ki * error-integral;
%   with Kp, Kd, Ki non-negative
% Thus we assume positive error requires increase in control
% e.g., if error = desiredAlt - curAlt, then if curAlt < desiredAlt we need
% to increase thrust. 

% unpack variables for convenience
outerLoopKp = gains.Ff;
saturationLimit = gains.saturationLimit;

% time elapsed since last control
dt = curTime - errorHistory.lastTime;


%% Outer Loop:
% desired error rate (v)
vDes = outerLoopKp*error;

% saturate
vDes = max(min(vDes,saturationLimit),-saturationLimit);

%% Inner Loop:

% actual error rate 
eDot = (error - errorHistory.lastVal) / dt;
v = -eDot;

% actual error rate derivative
eDotDot = (eDot - errorHistory.lastError) / dt;
vDot = -eDotDot;

% specify setpoint for inner-loop as 
% vDesDot = outerLoopPgain*eDot;

% error in desired error-rate
eVel = vDes - v;
%fprintf("eVel: %6.2f",eVel);

% error in desired error-accel 
eVelDot = vDesDot - vDot;
%fprintf("eDotVel: %6.2f",eDotVel);

% This error is for eVel, NOT e (last sum of velocity errors)
errorHistory.lastSum = errorHistory.lastSum + (eVel * dt);

% compute PID control (inner loop)
u = gains.Kp *eVel + gains.Kd * eVelDot +  gains.Ki * errorHistory.lastSum;

%fprintf("u: %6.3f",u);

% update error history
errorHistory.lastError = eDot;
errorHistory.lastTime = curTime;
errorHistory.lastVal = error;

%% Debug/plot

%figure(100);
%subplot(2,2,1);



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