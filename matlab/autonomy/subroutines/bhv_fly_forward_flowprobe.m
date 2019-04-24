function [completionFlag, ayprCmd, fVelErrorHistory] = bhv_fly_forward_flowprobe(stateEstimateMsg, ayprCmd, fpMsg, completion, bhvTime, fVelErrorHistory)

%% output pitchDesiredDeg

fVelSetpoint = 0.2;
fVelGains.kp = 0.1;
fVelGains.ki = 0.0;
fVelGains.kd = 0.1;
fVelCorrect = false;
flowProbeHeight = 0.1;

pitch = stateEstimateMsg.Pitch
t = stateEstimateMsg.Time
dt = t - fVelErrorHistory.lastTime;

if(fVelCorrect)
    omega = (pitch - fVelErrorHistory.lastPitch)/dt;            % not sure of the sign/direction
    fVel = (fpMsg + (omega*flowProbeHeight))/cos(pitch);
else
    fVel = fpMsg
end

fVelError = fVelSetpoint - fVel;
fVelErrorHistory.lastSum = fVelErrorHistory.lastSum + fVelError * dt;
fVelErrorDot = (fVelError - fVelErrorHistory.lastVal) / dt;

pitchDesiredDeg = (-1)*(fVelGains.kp * fVelError + fVelGains.kd * fVelErrorDot + fVelGains.ki * fVelErrorHistory.lastSum);

fVelErrorHistory.lastTime = currTime;
fVelErrorHistory.lastVal = fVelError;
fVelErrorHistory.lastPitch = pitch;

% displayFlag = 1;
% if ( displayFlag )    
%     pFile = fopen( fVelErrorHistory.log ,'a');
% 
%     % write csv file
%     fprintf(pFile,'%6.6f,',currTime);
%     fprintf(pFile,'%6.6f,',dt);    
%     fprintf(pFile,'%6.6f,',forwardVelocity);
%     fprintf(pFile,'%6.6f,',forwardVelocitySetpoint);    
% 
%     fprintf(pFile,'%6.6f,',fVelError);
%     fprintf(pFile,'%6.6f,',fVelErrorHistory.lastSum);
%     fprintf(pFile,'%6.6f,',fVelErrorDot);
% 
%     fprintf(pFile,'%6.6f,',uPitch);
%     fprintf(pFile,'%6.6f,',u_t_stick);
% 
%     % constant parameters
%     fprintf(pFile,'%6.6f,',forwardGains.Kp);
%     fprintf(pFile,'%6.6f,',forwardGains.Ki);
%     fprintf(pFile,'%6.6f,',forwardGains.Kd);
% 
%     fclose(pFile);
% end

%% set ayprCmd
ayprCmdMsg.PitchDesiredDegrees = pitchDesiredDeg;

% complete
if bhvTime >= completion.durationSec
    completionFlag = 1;
    return;
end
completionFlag = 0;
end