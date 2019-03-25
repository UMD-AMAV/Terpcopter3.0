function [thrustCmd, altErrorHistory] = altitudeController(gains, altErrorHistory, curTime, zcur, zd)

% Note thrustCmd valid range : []

% unpack variables for convenience
outerLoopKp = gains.outerLoopKp;
saturationLimit = gains.saturationLimit;

% time elapsed since last control
dt = curTime - altErrorHistory.lastTime;

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
altRateErrorIntegral = altRateErrorHistory.altRateErrorIntegral + (altRateError * dt);

% D error
prevAltRateError = altErrorHistory.altRateError; %
altRateErrorRate = ( altRateError  - prevAltRateError ) / dt; 

% PID control
thrustCmd =  gains.Kp * altRateError + ... 
             gains.Kd * altRateErrorRate +  ...
             gains.Ki * altRateErrorIntegral;
         
% saturate so it is between -1 and 1
thrustCmd =  max(min(2,thrustCmd),0)-1;

%% pack up structure
altErrorHistory.lastTime = curTime;
altErrorHistory.altDes = zd;
altErrorHistory.alt = zcur;
altErrorHistory.altRateError = altRateError;
altErrorHistory.altRateErrorIntegral = altRateErrorIntegral;

%% display/debug
figure(100);
scrollTime = 30; %s
tmin = t - scrollTime;

subplot(1,2,1)
ms = 4;
lw = 2;
plot(t,zd,'r+','Linewidth',lw,'MarkerSize',ms);
hold on;
plot(t,zcur,'bo','Linewidth',lw,'MarkerSize',ms);
xlim([tmin,t]);
xlabel('Time (sec)');
ylabel('Altitude (m)');

subplot(1,2,2)
plot(t,altRateDes,'r+','Linewidth',lw,'MarkerSize',ms);
hold on;
plot(t,altRateActual,'bo','Linewidth',lw,'MarkerSize',ms);
xlim([tmin,t]);
xlabel('Time (sec)');
ylabel('Altitude-Rate (m/s)');


%%
figure(101);

subplot(2,3,1)
plot(t,altRateError,'bo','Linewidth',lw,'MarkerSize',ms);
hold on;
xlim([tmin,t]);
xlabel('Time (sec)');
ylabel('Altitude-Rate Error (m/s)');

subplot(2,3,1)
hold on;
plot(t,altRateErrorRate,'bo','Linewidth',lw,'MarkerSize',ms);
hold on;
xlim([tmin,t]);
xlabel('Time (sec)');
ylabel('Altitude-Rate Error Rate (m/s)');

subplot(2,3,2)
plot(t,altRateErrorIntegral,'bo','Linewidth',lw,'MarkerSize',ms);
hold on;
xlim([tmin,t]);
xlabel('Time (sec)');
ylabel('Altitude-Rate Error Integral (m/s)');


subplot(2,3,3)
plot(t, gains.Kp * altRateError ,'bo','Linewidth',lw,'MarkerSize',ms);
hold on;
plot(t, thrustCmd ,'k*','Linewidth',lw,'MarkerSize',ms);
hold on;
xlim([tmin,t]);
xlabel('Time (sec)');
ylabel('Inner Loop P (cmd) / Total (cmd)');

subplot(2,3,4)
plot(t, gains.Ki * altRateErrorIntegral ,'bo','Linewidth',lw,'MarkerSize',ms);
hold on;
xlim([tmin,t]);
xlabel('Time (sec)');
ylabel('Inner Loop I (cmd)');

subplot(2,3,5)
hold on;
plot(t, gains.Kd * altRateErrorRate ,'bo','Linewidth',lw,'MarkerSize',ms);
hold on;
xlim([tmin,t]);
xlabel('Time (sec)');
ylabel('Inner Loop D (cmd)');





end