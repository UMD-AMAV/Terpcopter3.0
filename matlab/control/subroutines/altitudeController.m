function [thrustCmd, altErrorHistory] = altitudeController(gains, altErrorHistory, curTime, zcur, zd, altControlDegbugPublisher)


% Note thrustCmd valid range : []

% time elapsed since last control
dt = curTime - altErrorHistory.lastTime;

% unpack variables for convenience
outerLoopKp = gains.outerLoopKp*dt;
altRateSatLimit = gains.saturationLimit;
Kp = gains.Kp*dt;
Kd = gains.Kd*dt;
Ki = gains.Ki*dt;


%% Outer Loop Proportional Control on Altitude (Output Desired Alt Rate)

% control variable, current error in altitude (m)
altError = zd - zcur;

% P error
altRateDes = outerLoopKp*altError; % positive altError (below target) => increase thrust
altRateDes = max(min(altRateDes,altRateSatLimit),-altRateSatLimit); % saturate

%% Inner Loop PID Control on Altitude Rate (Output Thrust Command)

% control variable
altRateActualRaw =  (zcur - altErrorHistory.alt) / dt;

% low-pass filter
RCtimeConstant = 0.5; % sec
alpha = dt / ( RCtimeConstant + dt);
altRatePrevious = altErrorHistory.altRate;
altRateActual = alpha*altRateActualRaw + (1-alpha)*altRatePrevious;

% P error
altRateError = altRateDes - altRateActual; % positive (going up to slow) => increase thrust
propTerm =  Kp * altRateError;

% I error
altRateErrorIntegral = altErrorHistory.altRateErrorIntegral + (altRateError * dt);

% D error
prevAltRateError = altErrorHistory.altRateError; %
altRateErrorRate = ( altRateError  - prevAltRateError ) / dt;
derivTerm = Kd * altRateErrorRate;

% Integral term
integralTerm = Ki * altRateErrorIntegral;
minIntegralLimit = -0.2; % TODO: add as parameter
maxIntegralLimit = 0.2;

% Saturate integral term
integralTerm =  max(min(integralTerm,maxIntegralLimit), minIntegralLimit); % 

% small feedforward term to make nominal value (zero error) close to hover
ffterm = -0.30;

% PID control, only keep values between 0 and 2
thrustCmdUnsat = propTerm + ...
                 derivTerm +  ...
                 integralTerm + ffterm;

% saturate so it is between 0 and 2, then shift down by 1 
% output is [-1 (zero thrust), 1 (max thrust)]
thrustCmd =  max(min(1,thrustCmdUnsat),-1);

%% pack up structure
altErrorHistory.lastTime = curTime;
altErrorHistory.altDes = zd;
altErrorHistory.alt = zcur;
altErrorHistory.altRate = altRateActual;
altErrorHistory.altRateError = altRateError;
altErrorHistory.altRateErrorIntegral = altRateErrorIntegral;

%% display/debug


fprintf('Controller running at %3.2f Hz\n',1/dt);

displayFlag = 1;
if ( displayFlag )
    
    pFile = fopen('altitudeControl.log','a');
    % write csv file
    fprintf(pFile,'%3.3f,',curTime);
    fprintf(pFile,'%3.3f,',zd);
    fprintf(pFile,'%3.3f,',zcur);
    fprintf(pFile,'%3.3f,',altRateDes);
    fprintf(pFile,'%3.3f,',altRateActual);
    fprintf(pFile,'%3.3f,',altRatePrevious);
    fprintf(pFile,'%3.3f,',altRateError);
    fprintf(pFile,'%3.3f,',altRateErrorIntegral);
    fprintf(pFile,'%3.3f,',altRateErrorRate);
    fprintf(pFile,'%3.3f,',propTerm);
    fprintf(pFile,'%3.3f,',derivTerm);
    fprintf(pFile,'%3.3f,',integralTerm);
    fprintf(pFile,'%3.3f,',ffterm);
    fprintf(pFile,'%3.3f,',thrustCmdUnsat);
    fprintf(pFile,'%3.3f,',thrustCmd);
    fprintf(pFile,'%3.3f,',gains.outerLoopKp);
    fprintf(pFile,'%3.3f,',gains.Kp);
    fprintf(pFile,'%3.3f,',gains.Ki);
    fprintf(pFile,'%3.3f,',gains.Kd);
    fprintf(pFile,'%3.3f,',dt);
    fprintf(pFile,'%3.3f,',altRateSatLimit);
    fprintf(pFile,'%3.3f,',minIntegralLimit);
    fprintf(pFile,'%3.3f,',maxIntegralLimit);
    fprintf(pFile,'%3.3f\n',RCtimeConstant);
    fclose(pFile);
    
    
    
    % initialize message to publish
    altControlDebugMsg = rosmessage(altControlDegbugPublisher);
    altControlDebugMsg.T = curTime;
    altControlDebugMsg.Zd = zd;
    altControlDebugMsg.Zcur = zcur;
    altControlDebugMsg.AltRateDes = altRateDes;
    altControlDebugMsg.AltRateActual = altRateActual;
    
    altControlDebugMsg.AltRateError = altRateError;
    altControlDebugMsg.AltRateErrorIntegral = altRateErrorIntegral;
    altControlDebugMsg.AltRateErrorRate = altRateErrorRate;
    
    
    altControlDebugMsg.Proportional = propTerm;
    altControlDebugMsg.Integral = integralTerm;
    altControlDebugMsg.Derivative = derivTerm;

    altControlDebugMsg.ThrustCmdUnsat = thrustCmdUnsat;
    altControlDebugMsg.ThrustCmd = thrustCmd;
    
    send(altControlDegbugPublisher, altControlDebugMsg);
end

end