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
v = data(:,3);
v_d = data(:,4);
ferr = data(:,5);
ferrSum = data(:,6);
ferrDot = data(:,7);

u_f = data(:,8);
u_stick = data(:,9);
kp = data(:,10);
ki = data(:,11);
kd = data(:,12);



%
fprintf('(Kp,Ki,kd) = (%3.3f,%3.3f,%3.3f) \n',kp(1), ki(1), kd(1));
% fprintf('integralTermLimit = %3.3f \n',integralTermLimit(1) );
fprintf('Time constants (velocity, desired velocity) = (%3.3f, %3.3f) \n',v, v_d);

%
figure(1);
title(file);

subplot(2,4,1);
plot(curTime, v,'mo-','linewidth',2);
hold on;
plot(curTime, v_d,'rx-','linewidth',2);
xlabel('Time (sec');
ylabel('velocity (m/s)');
ylim([0 1.5]);
set(gca,'FontSize',16);
legend('v','v-des','v-error','v-errorsum');

subplot(2,4,5);
plot(curTime, ki,'bo-','linewidth',2);
hold on;
plot(curTime, kd,'ro-','linewidth',2);
plot(curTime, ffterm,'k--');
xlabel('Time (sec');
ylabel('Thrust Command');
set(gca,'FontSize',16);
ylim([-0.4 0.2]);

subplot(2,4,2);
plot(curTime, ferr,'bo-','linewidth',2);
xlabel('Time (sec)');
ylabel('Velocity Error (m/s)');
set(gca,'FontSize',16);

subplot(2,4,3);
plot(curTime, ferrSum,'kx-','linewidth',2);
xlabel('Time (sec');
ylabel('Velocity Error Sum (m/s)');
set(gca,'FontSize',16);

subplot(2,4,4);
plot(curTime, ferrDot,'ko-','linewidth',2);
xlabel('Time (sec');
ylabel('Velocity Error Dot (m/s^2)');
set(gca,'FontSize',16);

subplot(2,4,5);
plot(curTime, u_f,'ko-','linewidth',2);
xlabel('Time (sec');
ylabel('Control');
set(gca,'FontSize',16);

subplot(2,4,6);
plot(curTime, u_stick,'ko-','linewidth',2);
xlabel('Time (sec)');
ylabel('Stick Command Pitch');
set(gca,'FontSize',16);



% subplot(2,4,7);
% plot(curTime, kp,'ko-','linewidth',2);
% xlabel('Time (sec');
% ylabel('Integral Term');
% set(gca,'FontSize',16);
% 
% subplot(2,4,4);
% plot(curTime,vel,'o-','linewidth',2);
% hold on
% plot(curTime,velFilt,'b-','linewidth',2);
% grid on;
% xlabel('Time (sec.)')
% ylabel('Alt Rate (m/s)');
% set(gca,'FontSize',16);
% legend('vel','vel-filter');
% 
% subplot(2,4,8);
% plot(curTime,derivTerm,'o-','linewidth',2);
% hold on
% grid on;
% xlabel('Time (sec.)')
% ylabel('Derivative Term');
% set(gca,'FontSize',16);

% figure(2);
% title(file);
% plot(curTime, 1./dt,'ko-','linewidth',2);
% xlabel('Time (sec');
% ylabel('Frequency (Hz)');
% set(gca,'FontSize',16);