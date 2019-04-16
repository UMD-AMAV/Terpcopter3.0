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
zcur = data(:,4);
altFilt = data(:,5);

altRateCmd = data(:,6);
%timeSetpointSet = data(:,7);

altFiltTimeConstant = data(:,7);
climbRateCmd = data(:,8);
descentRateCmd = data(:,9);
altErrorDeadband = data(:,10);
%settlingTime = data(:,12);

%     % write csv file
%     fprintf(pFile,'%6.6f,',curTime); % 1
%     fprintf(pFile,'%6.6f,',dt); % 2
%     fprintf(pFile,'%6.6f,',zd); % 3
%     fprintf(pFile,'%6.6f,',zcur); % 4
%     fprintf(pFile,'%6.6f,',altFilt); % 5
%
%     fprintf(pFile,'%6.6f,',altRateCmd); % 6
%     fprintf(pFile,'%6.6f,',timeSetpointSet); % 7
%
%     % constant parameters
%     fprintf(pFile,'%6.6f,',altFiltTimeConstant); % 8
%     fprintf(pFile,'%6.6f,',climbRateCmd); % 9
%     fprintf(pFile,'%6.6f,',descentRateCmd); % 10
%     fprintf(pFile,'%6.6f,',altErrorDeadband); % 11
%     fprintf(pFile,'%6.6f,',altDesTimeConstant); % 12
%     fprintf(pFile,'%6.6f,',settlingTime); % 13

%
figure(1);
plot(curTime, zd,'mo-','linewidth',2);
hold on;
plot(curTime, zcur,'bo-','linewidth',2);
hold on;
plot(curTime, altFilt,'kx-','linewidth',2);
hold on;
xlabel('Time (sec');
ylabel('Altitude (m)');
ylim([0 1.5]);
set(gca,'FontSize',16);
plot(curTime, ones(size(curTime)).*(zd + altErrorDeadband),'-','linewidth',1);
plot(curTime, ones(size(curTime)).*(zd - altErrorDeadband),'-','linewidth',1);
legend('z-des','z-raw','z-filt','z+db','z-db');

%
figure(2);
plot(curTime, ones(size(curTime)).*climbRateCmd,'--','linewidth',2);
hold on;
plot(curTime, ones(size(curTime)).*descentRateCmd,'--','linewidth',2);
hold on;
plot(curTime, altRateCmd,'kx-','linewidth',2);
hold on;
xlabel('Time (sec');
ylabel('Altitud Rate Cmd [-1,1]');
set(gca,'FontSize',16);
