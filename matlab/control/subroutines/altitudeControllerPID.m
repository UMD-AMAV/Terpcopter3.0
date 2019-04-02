function [thrustCmd, altControl] = altitudeControllerPID(gains, altControl, curTime, zcur, zd, altControlDegbugPublisher)


% unpack parameters
prevTime = altControl.time;
prevAlt = altControl.alt;
prevAltDesired = altControl.altDesired;
prevAltIntegralError = altControl.altIntegralError;
fileName = [params.env.matlabRoot altControl.];



% saturation limits
integralTermLimit = gains.integralTermLimit;%
altTimeConstant = gains.altTimeConstant;
altDesTimeConstant = gains.altDesTimeConstatConstant;
ffterm = gains.ffterm;

% time elapsed since last control
dt = curTime - prevTime;

% scale gains
Kp = gains.Kp*dt;
Ki = gains.Ki*dt;

%% Low-pass filters

% low-pass filter desired altitude
alpha_d = dt / ( altDesTimeConstant + dt);
altDesFilt = alpha_d*prevAltDesired + (1-alpha_d)*zd;

% low-pass filter altitude
alpha_a = dt / ( altTimeConstant + dt);
altFilt = alpha_a*prevAlt + (1-alpha_a)*zcur;

%% PID Control + feed forward

% errors
altError = altDesFilt - altFilt;
altIntegralError =  prevAltIntegralError + altError*dt;

% PID terms
propTerm =  Kp * altError;
integralTerm = Ki * altIntegralError;

% saturate integral term
integralTerm =  max(min(integralTerm,integralTermLimit), -integralTermLimit); % 

% PID control, only keep values between 0 and 2
thrustCmdUnsat = propTerm + derivTerm + integralTerm + ffterm;

% output is [-1 (zero thrust), 1 (max thrust)]
% we saturate hear to avoid excessive thrust commands
thrustCmd =  max(min(0.1,thrustCmdUnsat),-1);

%% pack up structure
altControl.time = prevTime;
altControl.alt = prevAlt;
altControl.altDesired = prevAltDesired;
altControl.altIntegralError = prevAltIntegralError;

%% display/debug
fprintf('Controller running at %3.2f Hz\n',1/dt);

displayFlag = 1;
if ( displayFlag )
    
    pFile = fopen(fileName,'a');
    
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
    fprintf(pFile,'%6.6f\n',ffterm);
    
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