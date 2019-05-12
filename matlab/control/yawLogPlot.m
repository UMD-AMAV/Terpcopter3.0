clear all;
close all;

clc;

[file,path] = uigetfile('*.log');

file
filepath = [path file ];
data = csvread(filepath);

% parse out
t = data(:,1);
dt = data(:,2);
desVal = mod(data(:,3),360);
actualVal = mod(data(:,4),360);
filtVal = mod(data(:,5),360);
errorVal = data(:,6);
stickCmd = data(:,7);

%     % write csv file
%     1 fprintf(pFile,'%6.6f,',curTime);
%    2  fprintf(pFile,'%6.6f,',dt);
%    3  fprintf(pFile,'%6.6f,',yawDesDeg);
%    4  fprintf(pFile,'%6.6f,',yawDeg);
%    5  fprintf(pFile,'%6.6f,',yawFiltDeg);
%    6  fprintf(pFile,'%6.6f,',yawErrorDeg);
%    7  fprintf(pFile,'%6.6f,',yawStickCmd);

filtTimeConstant = data(:,5);
kp = data(:,6);
stickLimit = data(:,7);


%     % write csv file
% 1    fprintf(pFile,'%6.6f,',curTime);
% 2    fprintf(pFile,'%6.6f,',dt);
% 3    fprintf(pFile,'%6.6f,',yawDesDeg);
% 4    fprintf(pFile,'%6.6f,',yawDeg);
% 5    fprintf(pFile,'%6.6f,',yawFiltDeg);
% 6    fprintf(pFile,'%6.6f,',yawErrorDeg);
% 7    fprintf(pFile,'%6.6f,',yawStickCmd);
%     
%     
%     % constant parameters
% 8   fprintf(pFile,'%6.6f,',yawFiltTimeConstant);
% 9    fprintf(pFile,'%6.6f,',kp);
% 10    fprintf(pFile,'%6.6f\n,',yawStickLimit);

figure(1);
subplot(2,1,1)
plot(t,desVal,'r-','linewidth',2);
hold on;
plot(t,actualVal,'b-','linewidth',2);
plot(t,filtVal,'k-','linewidth',2);
grid on;
xlabel('Time (sec');
ylabel('Yaw (deg)');
legend('Desired','Actual','Fitlered')
set(gca,'FontSize',16);

figure(2);
subplot(2,1,1)
plot(t,stickCmd,'r-','linewidth',2);
hold on;
plot(t,ones(size(t))*stickLimit(1),'k--','linewidth',2);
plot(t,-ones(size(t))*stickLimit(1),'k--','linewidth',2);
hold on;
xlabel('Time (sec');
ylabel('Stick Command)');
set(gca,'FontSize',16);

subplot(2,1,2)
plot(t,errorVal,'k-','linewidth',2);
hold on
grid on;
xlabel('Time (sec');
ylabel('Yaw Error (deg)');
set(gca,'FontSize',16);