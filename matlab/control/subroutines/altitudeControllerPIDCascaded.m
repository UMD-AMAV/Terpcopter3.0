function [thrustCmd, altControl] = altitudeControllerPIDCascaded(gains, altControl, curTime, zcur, zd, altControlDegbugPublisher)


% unpack parameters
prevTime = altControl.time;
prevAlt = altControl.alt;
prevAltRate = altControl.altRate;
prevAltDesired = altControl.altDesired;
prevAltIntegralError = altControl.altIntegralError;
fileName = altControl.log;

% saturation limits
integralTermLimit = gains.integralTermLimit;%
altRateSatLimit = gains.saturationLimit;
altTimeConstant = gains.altTimeConstant;
altRateTimeConstant = gains.altRateTimeConstant;
altDesTimeConstant = gains.altDesTimeConstant;
ffterm = gains.ffterm;

% time elapsed since last control
dt = curTime - prevTime;
zdot = (zcur - prevAlt) /dt;

% scale gains
Kp = gains.Kp; %*dt;
Ki = gains.Ki; %*dt;
Kd = gains.Kd;
Kv = gains.Kv;

%% Low-pass filters
% low-pass filter desired altitude

alpha_d = dt / ( altDesTimeConstant + dt);
altDesFilt = (1-alpha_d)*prevAltDesired + alpha_d*zd;

% low-pass filter altitude
alpha_a = dt / ( altTimeConstant + dt);
altFilt = (1-alpha_a)*prevAlt + alpha_a*zcur;

% low-pass filter altitude-rate
alpha_r = dt / ( altRateTimeConstant + dt);
altRateFilt = (1-alpha_r)*prevAltRate + alpha_r*zdot;
%% PID Control + feed forward

% P error
altError = altDesFilt - altFilt
altRateDes = Kv*altError % positive altError (below target) => increase thrust
%altRateDes = max(min(altRateDes,altRateSatLimit),-altRateSatLimit) % saturate
altRateFilt
altRateError = altRateDes - altRateFilt % positive (going up to slow) => increase thrust

% I error
altRateErrorIntegral = altControl.altRateErrorIntegral + (altRateError * dt);
altIntegralError =  prevAltIntegralError + altError*dt;

% D error
prevAltRateError = altControl.altRateError; %
altRateErrorRate = ( altRateError  - prevAltRateError ) / dt;


% PID terms
propTerm =  Kp * altRateError
integralTerm = Ki * altRateErrorIntegral
derivTerm = Kd * altRateErrorRate


% saturate integral term
integralTerm =  max(min(integralTerm,integralTermLimit), -integralTermLimit); % 

% PID control, only keep values between 0 and 2
thrustCmdUnsat = propTerm + integralTerm + derivTerm + ffterm;

% output is [-1 (zero thrust), 1 (max thrust)]
% we saturate hear to avoid excessive thrust commands
thrustCmd =  max(min(0.1,thrustCmdUnsat),-1);

%% pack up structure
altControl.time = curTime;
altControl.alt = altFilt;
altControl.altDesired = altDesFilt;
altControl.altRate = altRateFilt;
altControl.altRateError = altRateError;
altControl.altRateErrorIntegral = altRateErrorIntegral;
altControl.altIntegralError = altIntegralError;

%% display/debug
fprintf('Controller running at %3.2f Hz\n',1/dt);

displayFlag = 1;
if ( displayFlag )
    
    pFile = fopen(fileName,'a');
    fileName
    
    % write csv file
    fprintf(pFile,'%6.6f,',curTime);
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
    fprintf(pFile, '%6.6f',altRateFilt);
    fprintf(pFile, '%6.6f',altRateError);
    fprintf(pFile, '%6.6f\n',altRateErrorIntegral);
    
    
    fclose(pFile);
    
%     % initialize message to publish
%     altControlDebugMsg = rosmessage(altControlDegbugPublisher);
%     altControlDebugMsg.T = curTime;
%     altControlDebugMsg.Zd = zd;
%     altControlDebugMsg.Zcur = zcur;
%     altControlDebugMsg.AltRateDes = altRateDes;
%     altControlDebugMsg.AltRateActual = altRateActual;
%     
%     altControlDebugMsg.AltRateError = altRateError;
%     altControlDebugMsg.AltRateErrorIntegral = altRateErrorIntegral;
%     altControlDebugMsg.AltRateErrorRate = altRateErrorRate;
%     
%     
%     altControlDebugMsg.Proportional = propTerm;
%     altControlDebugMsg.Integral = integralTerm;
%     altControlDebugMsg.Derivative = derivTerm;
% 
%     altControlDebugMsg.ThrustCmdUnsat = thrustCmdUnsat;
%     altControlDebugMsg.ThrustCmd = thrustCmd;
%     
%     send(altControlDegbugPublisher, altControlDebugMsg);
end

end