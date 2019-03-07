% function [u_t_crab, u_t_forward, crabErrorHistory, forwardErrorHistory] = crabforwardcontroller_PID(crabGains,forwardGains , crabErrorHistory, forwardErrorHistory, currTime, crabError, forwardError)
function [u_t_forward, forwardErrorHistory] = forwardcontroller_PID(forwardGains , forwardErrorHistory, currTime, forwardError)
    
%     fprintf("currTime: %6.2f \n",currTime);
    % dt_crab = currTime - crabErrorHistory.lastTime;
%     global forwardErrorHistory; 
%     forwardErrorHistory = forwardErrorHist;
    dt_forward = currTime - forwardErrorHistory.lastTime;
    
%     fprintf("dt: %6.2f \n",dt_forward);

   % crabErrorHistory.lastSum = crabErrorHistory.lastSum + crabError * dt_crab;
    forwardErrorHistory.lastSum = forwardErrorHistory.lastSum + forwardError * dt_forward;
    
    % disp(crabErrorHistory);
%     disp(forwardErrorHistory);

    %errorDot_crab = (crabError - crabErrorHistory.lastVal) / dt_crab;
    errorDot_forward = (forwardError - forwardErrorHistory.lastVal) / dt_forward;
    % fprintf("errorDot_crab: %6.2f",errorDot_crab);
%     fprintf("errorDot_forward: %6.2f",errorDot_forward);
    
    % u_t_crab = crabGains.kp *crabError + crabGains.kd * errorDot_crab + crabGains.ffterm + ...
        %  crabGains.ki * crabErrorHistory.lastSum;
    u_t_forward = (-1)*(forwardGains.kp *forwardError + forwardGains.kd * errorDot_forward + ...
        forwardGains.ki * forwardErrorHistory.lastSum);
    % fprintf("u_crab: %6.2f",u_t_crab);
%     fprintf("u_forward: %f", u_t_forward);
    
    % crabErrorHistory.lastTime = currTime;
    forwardErrorHistory.lastTime = currTime;
    forwardErrorHistory.lastVal = forwardError;
    % crabErrorHistory.lastVal = crabError;


end
