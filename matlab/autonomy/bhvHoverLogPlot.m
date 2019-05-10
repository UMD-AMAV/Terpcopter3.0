% clear all;
% close all;
% 
% clc;

[file,path] = uigetfile('../*.log');

file
filepath = [path file ];
data = csvread(filepath);

% parse out
t = data(:,1);
t = t - t(1);
% TODO : fix time

hPixelX = data(:,2);
hPixelY = data(:,3);
filtPixelX = data(:,4);
filtPixelY = data(:,5);
hDetected = data(:,6);

pitchDesRaw = data(:,7);
pitchDes = data(:,8);

rollDesRaw = data(:,9);
rollDes = data(:,10);

figure;
subplot(2,1,1)
plot(pitchDesRaw,'ko','linewidth',2);
hold on;
plot(pitchDes,'r-','linewidth',2);
grid on;
legend('old','new');
%xlabel('Time (sec)');
ylabel('Pitch Cmd');
set(gca,'FontSize',16);

subplot(2,1,2)
plot(rollDesRaw,'ko','linewidth',2);
hold on;
plot(rollDes,'r-','linewidth',2);
grid on;
legend('old','new');
%xlabel('Time (sec)');
ylabel('Roll Cmd');
set(gca,'FontSize',16);



figure;
subplot(3,1,2)
plot(hPixelX,'ko','linewidth',2);
hold on;
plot(filtPixelX,'r-','linewidth',2);
hold on;
grid on;
legend('raw','filt');
%xlabel('Time (sec)');
ylabel('Pixel X');
ylim([-320 320])
set(gca,'FontSize',16);


subplot(3,1,1)
plot(hPixelY,'ko','linewidth',2);
hold on;
plot(filtPixelY,'r-','linewidth',2);
hold on;
grid on;
legend('raw','filt');
%xlabel('Time (sec)');
ylabel('Pixel Y');
ylim([-320 320])

subplot(3,1,3)
plot(hDetected)
set(gca,'FontSize',16);