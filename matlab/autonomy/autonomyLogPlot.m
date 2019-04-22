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
curBhv = data(:,2);

altDes = data(:,3);
yawDes = data(:,4);
pitchDes = data(:,5);
rollDes = data(:,6);

altSwitch = data(:,7);
yawSwitch = data(:,8)-0.05;
pitchSwitch = data(:,9)-0.10;
rollSwitch = data(:,10)-0.15;

est_Range = data(:,11);
est_Time = data(:,12);
est_North = data(:,13);
est_East = data(:,14);
est_Up= data(:,15);
est_Yaw = data(:,16);
est_Pitch = data(:,17);
est_Roll = data(:,18);

%     % write csv file
%  1           fprintf(pFile,'%6.6f,',t);
%  2           fprintf(pFile,'%d,',currentBehavior);
%  3           fprintf(pFile,'%6.6f,',ayprCmdMsg.AltDesiredMeters);   
%  4           fprintf(pFile,'%6.6f,',ayprCmdMsg.YawDesiredDeg);
%  5           fprintf(pFile,'%6.6f,',ayprCmdMsg.PitchDesiredDeg);  
%  6           fprintf(pFile,'%6.6f,',ayprCmdMsg.RollDesiredDeg);  
%  7           fprintf(pFile,'%6.6f,',ayprCmdMsg.AltSwitch);  
%  8           fprintf(pFile,'%6.6f,',ayprCmdMsg.YawSwitch);  
%  9           fprintf(pFile,'%6.6f,',ayprCmdMsg.PitchSwitch);  
%  10           fprintf(pFile,'%6.6f,',ayprCmdMsg.RollSwitch);   
%             
%  11           fprintf(pFile,'%6.6f,',stateEstimateMsg.Range);  
%  12           fprintf(pFile,'%6.6f,',stateEstimateMsg.Time); 
%  13           fprintf(pFile,'%6.6f,',stateEstimateMsg.North); 
%  14           fprintf(pFile,'%6.6f,',stateEstimateMsg.East); 
%  15           fprintf(pFile,'%6.6f,',stateEstimateMsg.Up); 
%  16           fprintf(pFile,'%6.6f,',stateEstimateMsg.Yaw); 
%  17           fprintf(pFile,'%6.6f,',stateEstimateMsg.Pitch);
%  18           fprintf(pFile,'%6.6f,\n',stateEstimateMsg.Roll);  

% plot current behavior
figure(1);
subplot(2,1,1)
plot(t,curBhv,'k-','linewidth',2);
hold on;
grid on;
xlabel('Time (sec)');
ylabel('Current Behavior (index)');
set(gca,'FontSize',16);

% plot switches
subplot(2,1,2)
plot(t,altSwitch,'b-','linewidth',2);
hold on;
plot(t,yawSwitch,'r-','linewidth',2);
plot(t,pitchSwitch,'g-','linewidth',2);
plot(t,rollSwitch,'k-','linewidth',2);
grid on;
xlabel('Time (sec)');
ylabel('Active Channels');
legend('Alt','Yaw','Pitch','Roll');
set(gca,'FontSize',16);

% plot switches
figure(2);
subplot(4,1,1)
plot(t,altDes,'k--','linewidth',2);
hold on;
plot(t,est_Up,'b-','linewidth',2);
grid on;
xlabel('Time (sec)');
ylabel('Altitude (m)');
set(gca,'FontSize',16);

subplot(4,1,2)
plot(t,yawDes,'k--','linewidth',2);
hold on;
plot(t,est_Yaw,'b-','linewidth',2);
grid on;
xlabel('Time (sec)');
ylabel('Yaw (deg)');
set(gca,'FontSize',16);

subplot(4,1,3)
plot(t,pitchDes,'k--','linewidth',2);
hold on;
plot(t,est_Pitch,'b-','linewidth',2);
grid on;
xlabel('Time (sec)');
ylabel('Pitch (deg)');
set(gca,'FontSize',16);

subplot(4,1,4)
plot(t,rollDes,'k--','linewidth',2);
hold on;
plot(t,est_Roll,'b-','linewidth',2);
grid on;
xlabel('Time (sec)');
ylabel('Roll (deg)');
set(gca,'FontSize',16);