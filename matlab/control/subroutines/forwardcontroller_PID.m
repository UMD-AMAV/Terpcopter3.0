% function [u_t_crab, u_t_forward, crabErrorHistory, forwardErrorHistory] = crabforwardcontroller_PID(crabGains,forwardGains , crabErrorHistory, forwardErrorHistory, currTime, crabError, forwardError)
function [u_t_forward, forwardErrorHistory] = forwardcontroller_PID(forwardGains , forwardErrorHistory, currTime, forwardVelocity, forwardVelocitySetpoint)
    
%     fprintf("currTime: %6.2f \n",currTime);
    % dt_crab = currTime - crabErrorHistory.lastTime;
%     global forwardErrorHistory; 
%     forwardErrorHistory = forwardErrorHist;
    forwardError = forwardVelocitySetpoint - forwardVelocity;
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
    u_stick = max(-1,min(1,u_t_forward));

    displayFlag = 1;
if ( displayFlag )    
    pFile = fopen( forwardErrorHistory.log ,'a');
    
    % write csv file
    fprintf(pFile,'%6.6f,',currTime);
    fprintf(pFile,'%6.6f,',dt_forward);    
    fprintf(pFile,'%6.6f,',forwardVelocity);
    fprintf(pFile,'%6.6f,',forwardVelocitySetpoint);    
    
    fprintf(pFile,'%6.6f,',forwardError);
    fprintf(pFile,'%6.6f,',forwardErrorHistory.lastSum);
    fprintf(pFile,'%6.6f,',errorDot_forward);
    
    fprintf(pFile,'%6.6f,',u_t_forward);
    fprintf(pFile,'%6.6f,',u_t_stick);
    
    % constant parameters
    fprintf(pFile,'%6.6f,',forwardGains.Kp);
    fprintf(pFile,'%6.6f,',forwardGains.Ki);
    fprintf(pFile,'%6.6f,',forwardGains.Kd);
        
    fclose(pFile);
end

end
