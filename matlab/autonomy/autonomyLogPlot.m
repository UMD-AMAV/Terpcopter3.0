% clear all;
% close all;
% 
% clc;

[file,path] = uigetfile('*.log');

file
filepath = [path file ];
data = csvread(filepath);

h_detection = 0;

% parse out
t = data(:,1);
t = t - t(1);
curBhv = data(:,2);

waypointXDes = data(:,3);
waypointYDes = data(:,4);
altDes = data(:,5);
yawDes = mod(data(:,6),360);
pitchDes = data(:,7);
rollDes = data(:,8);

altSwitch = data(:,9);
yawSwitch = data(:,10)-0.05;
pitchSwitch = data(:,11)-0.10;
rollSwitch = data(:,12)-0.15;

est_Range = data(:,13);
est_Time = data(:,14);
est_North = data(:,15);
est_East = data(:,16);
est_Up= data(:,17);
est_Yaw = mod(data(:,18),360);
est_Pitch = data(:,19);
est_Roll = data(:,20);

if (h_detection == 1)
    hDetected = data(:,21);
    hPixelX = data(:,22);
    hPixelY = data(:,23);
    hAngle = data(:,24);
    
    figure(4)
    subplot(2,1,1)
    plot(t,hDetected,'ko-','linewidth',2);
    hold on;
    grid on;
    xlabel('Time (sec)');
    ylabel('H Detected');
    set(gca,'FontSize',16);
    
    % plot switches
    subplot(2,1,2)
    plot(t,hPixelX,'bo-','linewidth',2);
    hold on;
    plot(t,hPixelY,'ro-','linewidth',2);
    grid on;
    xlabel('Time (sec)');
    ylabel('H Pixel');
    legend('Hx','Hy');
    set(gca,'FontSize',16);
end
%     % write csv file
%  1           fprintf(pFile,'%6.6f,',t);
%  2           fprintf(pFile,'%d,',currentBehavior);
%  3             fprintf(pFile,'%6.6f,',ayprCmdMsg.WaypointXDesiredMeters);
%  4            fprintf(pFile,'%6.6f,',ayprCmdMsg.WaypointYDesiredMeters);
%  5           fprintf(pFile,'%6.6f,',ayprCmdMsg.AltDesiredMeters);   
%  6           fprintf(pFile,'%6.6f,',ayprCmdMsg.YawDesiredDeg);
%  7           fprintf(pFile,'%6.6f,',ayprCmdMsg.PitchDesiredDeg);  
%  8           fprintf(pFile,'%6.6f,',ayprCmdMsg.RollDesiredDeg);  
%  9           fprintf(pFile,'%6.6f,',ayprCmdMsg.AltSwitch);  
%  10           fprintf(pFile,'%6.6f,',ayprCmdMsg.YawSwitch);  
%  11           fprintf(pFile,'%6.6f,',ayprCmdMsg.PitchSwitch);  
%  12           fprintf(pFile,'%6.6f,',ayprCmdMsg.RollSwitch);   
%             
%  13           fprintf(pFile,'%6.6f,',stateEstimateMsg.Range);  
%  14           fprintf(pFile,'%6.6f,',stateEstimateMsg.Time); 
%  15           fprintf(pFile,'%6.6f,',stateEstimateMsg.North); 
%  16           fprintf(pFile,'%6.6f,',stateEstimateMsg.East); 
%  17           fprintf(pFile,'%6.6f,',stateEstimateMsg.Up); 
%  18           fprintf(pFile,'%6.6f,',stateEstimateMsg.Yaw); 
%  19           fprintf(pFile,'%6.6f,',stateEstimateMsg.Pitch);
%  20           fprintf(pFile,'%6.6f,\n',stateEstimateMsg.Roll);  

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
plot(t,est_Up,'b-','linewidth',2);
grid on;
xlabel('Time (sec)');
ylabel('Altitude (m)');
set(gca,'FontSize',16);

subplot(4,1,2)
plot(t,est_Yaw,'b-','linewidth',2);
grid on;
xlabel('Time (sec)');
ylabel('Yaw (deg)');
set(gca,'FontSize',16);

subplot(4,1,3)
plot(t,est_Pitch,'b-','linewidth',2);
hold on;
plot(t,pitchDes*100,'k--','linewidth',2);
grid on;
xlabel('Time (sec)');
ylabel('Pitch (deg)');
set(gca,'FontSize',16);

subplot(4,1,4)
plot(t,est_Roll,'b-','linewidth',2);
hold on;
plot(t,rollDes*100,'k--','linewidth',2);
grid on;
xlabel('Time (sec)');
ylabel('Roll (deg)');
set(gca,'FontSize',16);


% plot switches
figure(3);
subplot(4,1,1)
plot(t,altDes,'k--','linewidth',2);
grid on;
xlabel('Time (sec)');
ylabel('Altitude (m)');
set(gca,'FontSize',16);

subplot(4,1,2)
plot(t,yawDes,'k--','linewidth',2);
grid on;
xlabel('Time (sec)');
ylabel('Yaw');
set(gca,'FontSize',16);

subplot(4,1,3)
plot(t,pitchDes*100,'k--','linewidth',2);
grid on;
xlabel('Time (sec)');
ylabel('Pitch');
set(gca,'FontSize',16);

subplot(4,1,4)
plot(t,rollDes*100,'k--','linewidth',2);
grid on;
xlabel('Time (sec)');
ylabel('Roll');
set(gca,'FontSize',16);