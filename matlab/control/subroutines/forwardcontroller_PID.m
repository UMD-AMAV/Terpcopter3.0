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

displayFlag = 1;
if ( displayFlag )    
    pFile = fopen( forwardErrorHistory.log ,'a');
    
    % write csv file
    fprintf(pFile,'%6.6f,',currTime);
    fprintf(pFile,'%6.6f,',dt);    
    fprintf(pFile,'%6.6f,',zd);
    fprintf(pFile,'%6.6f,',altDesFilt);    
    fprintf(pFile,'%6.6f,',zcur);
    fprintf(pFile,'%6.6f,',altFilt);
    
    fprintf(pFile,'%6.6f,',altError);
    fprintf(pFile,'%6.6f,',altIntegralError); 
    
    fprintf(pFile,'%6.6f,',propTerm);
    fprintf(pFile,'%6.6f,',integralTerm);

    fprintf(pFile,'%6.6f,',thrustCmdUnsat);
    fprintf(pFile,'%6.6f,',thrustCmd);
    
    % constant parameters
    fprintf(pFile,'%6.6f,',gains.Kp);
    fprintf(pFile,'%6.6f,',gains.Ki);
    fprintf(pFile,'%6.6f,',integralTermLimit);
    fprintf(pFile,'%6.6f,',altTimeConstant);
    fprintf(pFile,'%6.6f,',altDesTimeConstant);
    fprintf(pFile,'%6.6f,',ffterm);
    
    
    fprintf(pFile, '%6.6f,',zdot);
    fprintf(pFile, '%6.6f\n',altRateFilt);
    fprintf(pFile, '%6.6f\n',derivTerm);
        
    fclose(pFile);
end

end
