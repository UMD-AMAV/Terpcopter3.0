clear all;
close all;

clc;

[file,path] = uigetfile();

file
filepath = [path file ];
data = csvread(filepath);

% parse out
t = data(:,1);
t = t - t(1);
    
hPixelX = data(:,2);
hPixelY = data(:,3);
filtPixelX = data(:,4);
filtPixelY = data(:,5);

figure;
subplot(2,1,1)
plot(t,hPixelX,'ko','linewidth',2);
hold on;
plot(t,filtPixelX,'r-','linewidth',2);
hold on;
grid on;
legend('raw','filt');
xlabel('Time (sec)');
ylabel('Pixel X');
set(gca,'FontSize',16);


subplot(2,1,2)
plot(t,hPixelY,'ko','linewidth',2);
hold on;
plot(t,filtPixelY,'r-','linewidth',2);
hold on;
grid on;
legend('raw','filt');
xlabel('Time (sec)');
ylabel('Pixel X');
set(gca,'FontSize',16);