% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About -Subscribes to the state estimation topic and displays the live plots.
% 
% Input - 'terpcopter_msgs/stateEstimate'
% 
% Output - 3x2 Graphical plot containing North East Up Yaw Pitch Roll
% 
% Note - 1) If plot display is delayed try running it on a windows machine.
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

clear all; close all; clc;

global stateEstimateMsg;
stateEstimateMsg = rosmessage('terpcopter_msgs/stateEstimate');
stateEstimateMsg.Range = 0 ;
stateEstimateMsg.Time = 0 ;
stateEstimateMsg.North = 0 ;
stateEstimateMsg.East = 0 ;
stateEstimateMsg.Up = 0 ;
stateEstimateMsg.Yaw = 0 ;
stateEstimateMsg.Pitch = 0 ;
stateEstimateMsg.Roll = 0 ;

plotStateEstimateNode = robotics.ros.Node('/livePlotStateEstimate');
pStateEstimateSub = robotics.ros.Subscriber(plotStateEstimateNode,'stateEstimate','terpcopter_msgs/stateEstimate',{@stateEstimateCallback});

msg = receive(pStateEstimateSub,20);

% Acquire and display live data
figure
subplot(3,2,1)

% Creating animated lines for live plots
NorthDri = animatedline('Color','g');
xNorthDri = gca;
xNorthDri.YGrid = 'on';
xlabel('Time');
ylabel('North direction');
set(gca,'FontSize',25)
legend('North direction')
set(gca,'FontSize',16)

subplot(3,2,3)
EastDri = animatedline('Color','c');
xEastDri = gca;
xEastDri.YGrid = 'on';
xlabel('Time');
ylabel('East direction');
set(gca,'FontSize',25)
legend('East direction')
set(gca,'FontSize',16)

subplot(3,2,5)
Range = animatedline('Color','b');
xRange = gca;
xRange.YGrid = 'on';
xlabel('Time');
ylabel('Range');
set(gca,'FontSize',25)
legend('Range')
set(gca,'FontSize',16)

subplot(3,2,2)
Yaw = animatedline('Color','m');
xYaw = gca;
xYaw.YGrid = 'on';
xlabel('Time');
ylabel('Yaw');
set(gca,'FontSize',25)
legend('Yaw')
set(gca,'FontSize',16)

subplot(3,2,4)
Pitch = animatedline('Color','r');
xPitch = gca;
xPitch.YGrid = 'on';
xlabel('Time');
ylabel('Pitch');
set(gca,'FontSize',25)
legend('Pitch')
set(gca,'FontSize',16)

subplot(3,2,6)
Roll = animatedline('Color','k');
xRoll = gca;
xRoll.YGrid = 'on';
xlabel('Time');
ylabel('Roll');
set(gca,'FontSize',25)
legend('Roll')
set(gca,'FontSize',16)

stop = false;
startTime = datetime('now');
while ~stop
    
    % Read current value from topic
    pRange = stateEstimateMsg.Range;
    pTime = stateEstimateMsg.Time;
    pNorth = stateEstimateMsg.North;
    pEast = stateEstimateMsg.East;
    pUp = stateEstimateMsg.Up;
    pYaw = stateEstimateMsg.Yaw;
    pPitch = stateEstimateMsg.Pitch;
    pRoll = stateEstimateMsg.Roll;    
    
    % Get current time
    t =  datetime('now') - startTime;
     
    % Add points to animation
    dTime = double(pTime);
    dNorth = double(pNorth);
    dEast = double(pEast);
    dRange = double(pRange);
    dYaw = double(pYaw);
    dPitch = double(pPitch);
    dRoll = double(pRoll);
    
    addpoints(NorthDri, datenum(t), dNorth)
    addpoints(EastDri, datenum(t), dEast)
    addpoints(Range, datenum(t), dRange)
    addpoints(Yaw, datenum(t), dYaw)
    addpoints(Pitch, datenum(t), dPitch)
    addpoints(Roll, datenum(t), dRoll)
    
    % Update axes
    xNorthDri.XLim = datenum([t-seconds(25) t]);
    datetick('x','keeplimits')
    
    xEastDri.XLim = datenum([t-seconds(25) t]);
    datetick('x','keeplimits')
    
    xRange.XLim = datenum([t-seconds(25) t]);
    datetick('x','keeplimits')
    
    xYaw.XLim = datenum([t-seconds(25) t]);
    datetick('x','keeplimits')
    
    xPitch.XLim = datenum([t-seconds(25) t]);
    datetick('x','keeplimits')
    
    xRoll.XLim = datenum([t-seconds(25) t]);
    datetick('x','keeplimits')
 
    drawnow %limitrate
   
    % Add stop condition 
end

% % Plot the recorded data
% 
% [timeLogs,tempLogs] = getpoints(h);
% timeSecs = (timeLogs-timeLogs(1))*24*3600;
% figure
% plot(timeSecs,tempLogs)
% xlabel('Elapsed time (sec)')
% ylabel('Y')
