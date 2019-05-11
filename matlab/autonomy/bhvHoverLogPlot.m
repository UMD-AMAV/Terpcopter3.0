clear all;
close all;

clc;

[file,path] = uigetfile('../*.log');

file
filepath = [path file ];
data = csvread(filepath);

% parse out
t = data(:,1);
t = t - t(1);
% TODO : fix time

% % write log
% pFile = fopen( bhvLog  ,'a');
% fprintf(pFile,'%6.6f,',bhvTime);
% fprintf(pFile,'%6.6f,',hPixelX);
% fprintf(pFile,'%6.6f,',hPixelY);
% fprintf(pFile,'%6.6f,',filtPixelX);
% fprintf(pFile,'%6.6f,',filtPixelY);
% fprintf(pFile,'%6.6f,',hDetected);
% fprintf(pFile,'%6.6f,',pitchCmdProp);
% fprintf(pFile,'%6.6f,',pitchCmd);
% fprintf(pFile,'%6.6f,',ayprCmd.PitchDesiredDegrees);
% fprintf(pFile,'%6.6f,',theta);
% fprintf(pFile,'%6.6f,',rollCmdProp);
% fprintf(pFile,'%6.6f,',rollCmd);
% fprintf(pFile,'%6.6f,',ayprCmd.RollDesiredDegrees);
% fprintf(pFile,'%6.6f,\n',phi);
% fclose(pFile);

hPixelX = data(:,2);
hPixelY = data(:,3);
filtPixelX = data(:,4);
filtPixelY = data(:,5);
hDetected = data(:,6);

pitchCmdProp = data(:,7);
pitchCmd = data(:,8);
pitchCmdSat = data(:,9);
pitch = data(:,10);

rollCmdProp = data(:,11);
rollCmd = data(:,12);
rollCmdSat = data(:,13);
roll = data(:,14);

figure;
subplot(2,1,1)
hold on;
plot(t,pitch,'k-','linewidth',2); hold on;
plot(t,pitchCmdSat*100,'r-','linewidth',2);
grid on;
legend('degree','command');
ylabel('Pitch');
set(gca,'FontSize',16);

subplot(2,1,2)
plot(t,roll,'k-','linewidth',2); hold on;
plot(t,rollCmdSat*100,'r-','linewidth',2);
grid on;
legend('degree','command');
ylabel('Roll');
set(gca,'FontSize',16);




figure;
subplot(2,1,1)
hold on;
plot(t,pitchCmdProp,'k-','linewidth',2); hold on;
plot(t,pitchCmd,'r-','linewidth',2);
plot(t,pitchCmdSat,'b-','linewidth',2);
grid on;
legend('prop. term','cmd','sat');
ylabel('Pitch Cmd');
set(gca,'FontSize',16);

subplot(2,1,2)
plot(t,rollCmdProp,'k-','linewidth',2); hold on;
plot(t,rollCmd,'r-','linewidth',2);
plot(t,rollCmdSat,'b-','linewidth',2);
grid on;
legend('prop','cmd','sat');
ylabel('Roll Cmd');
set(gca,'FontSize',16);

figure;
subplot(3,1,2)
plot(t,hPixelX,'ko','linewidth',2);
hold on;
plot(t,filtPixelX,'r-','linewidth',2);
hold on;
grid on;
legend('raw','filt');
%xlabel('Time (sec)');
ylabel('Pixel X');
ylim([-320 320])
set(gca,'FontSize',16);


subplot(3,1,1)
plot(t,hPixelY,'ko','linewidth',2);
hold on;
plot(t,filtPixelY,'r-','linewidth',2);
hold on;
grid on;
legend('raw','filt');
%xlabel('Time (sec)');
ylabel('Pixel Y');
ylim([-320 320])

subplot(3,1,3)
plot(hDetected)
set(gca,'FontSize',16);