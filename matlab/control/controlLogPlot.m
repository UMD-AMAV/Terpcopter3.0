clear all;

close all;

clc;

[file,path] = uigetfile();

file
filepath = [path file ];
data = csvread(filepath);

% parse out
curTime = data(:,1);
dt = data(:,2);
zd = data(:,3);
altDesFilt = data(:,4);
zcur = data(:,5);
altFilt = data(:,6);

altError = data(:,7);
altIntegralError = data(:,8);
propTerm = data(:,9);
integralTerm = data(:,10);
thrustCmdUnsat = data(:,11);
thrustCmd = data(:,12);

%
Kp = data(:,13);
Ki = data(:,14);
integralTermLimit = data(:,15);
altTimeConstant = data(:,16);
altDesTimeConstant = data(:,17);
ffterm = data(:,18);
    
vel = data(:,19);
velFilt = data(:,20);
derivTerm = data(:,21);






%
fprintf('(Kp,Ki,ffterm) = (%3.3f,%3.3f,%3.3f) \n',Kp(1), Ki(1), ffterm(1));
fprintf('integralTermLimit = %3.3f \n',integralTermLimit(1) );
fprintf('Time constants (alt,alt-des) = (%3.3f, %3.3f) \n',altTimeConstant(1), altDesTimeConstant(1));

%
figure(1);
title(file);

subplot(2,4,1);
plot(curTime, zd,'mo-','linewidth',2);
hold on;
plot(curTime, altDesFilt,'rx-','linewidth',2);
plot(curTime, zcur,'ko-','linewidth',2);
hold on;
plot(curTime, altFilt,'bx-','linewidth',2);
hold on;
xlabel('Time (sec');
ylabel('Altitude (m)');
ylim([0 1.5]);
set(gca,'FontSize',16);
legend('z-des','z-des-filter','z-raw','z-filt');

subplot(2,4,5);
plot(curTime, thrustCmdUnsat,'bo-','linewidth',2);
hold on;
plot(curTime, thrustCmd,'ro-','linewidth',2);
plot(curTime, ffterm,'k--');
xlabel('Time (sec');
ylabel('Thrust Command');
set(gca,'FontSize',16);
%ylim([-0.4 0.2]);

subplot(2,4,2);
plot(curTime, altError,'ko-','linewidth',2);
xlabel('Time (sec');
ylabel('Altitude Error (m)');
set(gca,'FontSize',16);

subplot(2,4,6);
plot(curTime, propTerm,'ko-','linewidth',2);
xlabel('Time (sec');
ylabel('Proportional Term');
set(gca,'FontSize',16);

subplot(2,4,3);
plot(curTime, altIntegralError,'ko-','linewidth',2);
xlabel('Time (sec');
ylabel('Altitude Error Integral (m)');
set(gca,'FontSize',16);

subplot(2,4,7);
plot(curTime, integralTerm,'ko-','linewidth',2);
xlabel('Time (sec');
ylabel('Integral Term');
set(gca,'FontSize',16);

subplot(2,4,4);
plot(curTime,vel,'ko-','linewidth',2);
hold on
plot(curTime,velFilt,'bx-','linewidth',2);
grid on;
xlabel('Time (sec.)')
ylabel('Alt Rate (m/s)');
set(gca,'FontSize',16);
legend('vel','vel-filter');

subplot(2,4,8);
plot(curTime,derivTerm,'ko-','linewidth',2);
hold on
grid on;
xlabel('Time (sec.)')
ylabel('Derivative Term');
set(gca,'FontSize',16);

% figure(2);
% title(file);
% plot(curTime, 1./dt,'ko-','linewidth',2);
% xlabel('Time (sec');
% ylabel('Frequency (Hz)');
% set(gca,'FontSize',16);



