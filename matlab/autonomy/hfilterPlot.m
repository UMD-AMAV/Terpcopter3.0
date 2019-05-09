clear all;
close all;

clc;

[file,path] = uigetfile();

file
filepath = [path file ];
data = csvread(filepath);

% parse out
t = data(:,1);

currentYawDeg = data(:,2);
axRaw = data(:,3);
ayRaw = data(:,4);
hDetected = data(:,5);
hAngle = data(:,6);
hPixelX = data(:,7);
hPixelY = data(:,8);

xEst = data(:,9);
yEst= data(:,10);
vxEst= data(:,11);
vyEst = data(:,12);
axEst = data(:,13);
ayEst = data(:,14);
% 
% % filter covariance
% fprintf(pFile,'%6.6f,',Pk_k(1));
% fprintf(pFile,'%6.6f,',Pk_k(2));
% fprintf(pFile,'%6.6f,',Pk_k(3));
% fprintf(pFile,'%6.6f,',Pk_k(4));
% fprintf(pFile,'%6.6f,',Pk_k(5));
% fprintf(pFile,'%6.6f,',Pk_k(6));
% fprintf(pFile,'%6.6f,',Pk_k(7));
% fprintf(pFile,'%6.6f,',Pk_k(8));
% fprintf(pFile,'%6.6f,',Pk_k(9));
% fprintf(pFile,'%6.6f,',Pk_k(10));
% fprintf(pFile,'%6.6f,',Pk_k(11));
% fprintf(pFile,'%6.6f,',Pk_k(12));
% fprintf(pFile,'%6.6f,',Pk_k(13));
% fprintf(pFile,'%6.6f,',Pk_k(14));
% fprintf(pFile,'%6.6f,',Pk_k(15));
% fprintf(pFile,'%6.6f,',Pk_k(16));
%     
% % output    
% fprintf(pFile,'%6.6f,', pFilt(1) );
% fprintf(pFile,'%6.6f,', pFilt(2) );    
% 
% % persistent variables
% fprintf(pFile,'%6.6f,',lastTime);
% fprintf(pFile,'%6.6f,',lastValidTime);
% fprintf(pFile,'%6.6f,',lastHrefYawDeg);
% fprintf(pFile,'%6.6f,',lastPixelX);
% fprintf(pFile,'%6.6f,',lastPixelY);
% fprintf(pFile,'%6.6f,\n',lastHangle);
% 
%     fprintf(pFile,'%6.6f,',th);
%     fprintf(pFile,'%6.6f,',axFilt);
%     fprintf(pFile,'%6.6f,\n',ayFilt);  
    

% plot current behavior
figure(1);
plot(t,axRaw); hold on;
plot(t,ayRaw,'r');
xlabel('Time (sec)');
ylabel('Acceleration (m/s^2)');
legend('ax','ay');
set(gca,'FontSize',16);

figure(2);
subplot(3,1,1)
plot(t,hPixelX,'bo'); hold on;
plot(t,hPixelY,'ro');
xlabel('Time (sec)');
ylabel('H Pixels');
ylim([-640 640]);
legend('hx','hy');
set(gca,'FontSize',16);
subplot(3,1,2)
plot(t,hDetected,'bo');
xlabel('Time (sec)');
ylabel('H detected');
set(gca,'FontSize',16);
subplot(3,1,3)
plot(t,hAngle,'bo');
xlabel('Time (sec)');
ylabel('H angle');
set(gca,'FontSize',16);
ylim([60 80])

figure(3);
plot(xEst,yEst); hold on;
xlabel('X');
ylabel('Y');
legend('ax','ay');
set(gca,'FontSize',16);