function [thrustCmd, altErrorHistory] = altitudeController(gains, altErrorHistory, curTime, zcur, zd, altControlDegbugPublisher)


% Note thrustCmd valid range : []

% time elapsed since last control
dt = curTime - altErrorHistory.lastTime;

% unpack variables for convenience
outerLoopKp = gains.outerLoopKp*dt;
saturationLimit = gains.saturationLimit;
Kp = gains.Kp*dt;
Kd = gains.Kd*dt;
Ki = gains.Ki*dt;


%% Outer Loop Proportional Control on Altitude (Output Desired Alt Rate)

% control variable, current error in altitude (m)
altError = zd - zcur;

% P error
altRateDes = outerLoopKp*altError; % positive altError (below target) => increase thrust
altRateDes = max(min(altRateDes,saturationLimit),-saturationLimit); % saturate

%% Inner Loop PID Control on Altitude Rate (Output Thrust Command)

% control variable
altRateActual =  (zcur - altErrorHistory.alt) / dt;

% P error
altRateError = altRateDes - altRateActual; % positive (going up to slow) => increase thrust

% I error
altRateErrorIntegral = altErrorHistory.altRateErrorIntegral + (altRateError * dt);

% D error
prevAltRateError = altErrorHistory.altRateError; %
altRateErrorRate = ( altRateError  - prevAltRateError ) / dt;

% Integral term
integralTerm = Ki * altRateErrorIntegral;
minIntegralLimit = -0.2; % TODO: add as parameter
maxIntegralLimit = 0.2;

% Saturate integral term
integralTerm =  max(min(integralTerm,maxIntegralLimit), minIntegralLimit); % 

% small feedforward term to make nominal value (zero error) close to hover
ffterm = -0.30;

% PID control, only keep values between 0 and 2
thrustCmdUnsat =  Kp * altRateError + ...
                  Kd * altRateErrorRate +  ...
                  integralTerm + ffterm;

% saturate so it is between 0 and 2, then shift down by 1 
% output is [-1 (zero thrust), 1 (max thrust)]
thrustCmd =  max(min(1,thrustCmdUnsat),-1);

%% pack up structure
altErrorHistory.lastTime = curTime;
altErrorHistory.altDes = zd;
altErrorHistory.alt = zcur;
altErrorHistory.altRateError = altRateError;
altErrorHistory.altRateErrorIntegral = altRateErrorIntegral;

%% display/debug


fprintf('Controller running at %3.2f Hz\n',1/dt);

displayFlag = 1;
if ( displayFlag )
    
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
    
    
    altControlDebugMsg.Proportional = gains.Kp * altRateError;
    altControlDebugMsg.Integral = integralTerm;
    altControlDebugMsg.Derivative = gains.Kd * altRateErrorRate;

    altControlDebugMsg.ThrustCmdUnsat = thrustCmdUnsat;
    altControlDebugMsg.ThrustCmd = thrustCmd;
    
    send(altControlDegbugPublisher, altControlDebugMsg);
end

end