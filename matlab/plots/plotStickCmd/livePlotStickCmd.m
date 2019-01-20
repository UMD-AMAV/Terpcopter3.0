% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author- Team AMAV 2018-2019
% 
% About -Subscribes to stick commands and state estimation topic and 
%        displays the live plots.
% 
% Input -  'terpcopter_msgs/stickCmd'
%          'terpcopter_msgs/stateEstimate'
% 
% Output - 4x1 Graphical plot containing Thrust Yaw Pitch Roll
% 
% Note - 1) If plot display is delayed try running it on a windows machine.
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

clear all; close all; clc;
% addpath('./results');

% stickCmd
% float32 thrust
% float32 yaw
% float32 pitch
% float32 roll

global stickCmdMsg;
stickCmdMsg = rosmessage('terpcopter_msgs/stickCmd');
stickCmdMsg.Thrust =0;
stickCmdMsg.Yaw= 0;
stickCmdMsg.Pitch= 0;
stickCmdMsg.Roll=0;

global stateEstimateMsg;
stateEstimateMsg = rosmessage('terpcopter_msgs/stateEstimate');
stateEstimateMsg.Time = 0 ;

plotStickCmdNode = robotics.ros.Node('/liveplotStickCmd');
plotStickCmdSub = robotics.ros.Subscriber(plotStickCmdNode,'stickCmd','terpcopter_msgs/stickCmd',{@stickCmdCallback});
pStateEstimateSub = robotics.ros.Subscriber(plotStickCmdNode,'stateEstimate','terpcopter_msgs/stateEstimate',{@stateEstimateCallback});

msg = receive(plotStickCmdSub,20);
msgTime = receive(pStateEstimateSub,20);

% Displaying figure
figure
subplot(4,1,1)

% Creating animated lines for live plots
Thrust = animatedline('Color','k');
xThrust = gca;
xThrust.YGrid = 'on';
xlabel('Time');
ylabel('Thrust');
set(gca,'FontSize',25)
legend('Thrust')
set(gca,'FontSize',16)
grid on;

subplot(4,1,2)
Yaw = animatedline('Color','r');
xYaw = gca;
xYaw.YGrid = 'on';
xlabel('Time');
ylabel('Yaw');
set(gca,'FontSize',25)
legend('Yaw')
set(gca,'FontSize',16)
grid on;

subplot(4,1,3)
Pitch = animatedline('Color','g');
xPitch = gca;
xPitch.YGrid = 'on';
xlabel('Time');
ylabel('Pitch');
set(gca,'FontSize',25)
legend('Pitch')
set(gca,'FontSize',16)
grid on;

subplot(4,1,1)
Roll = animatedline('Color','b');
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
    pThrust = stickCmdMsg.Thrust;
    pYaw = stickCmdMsg.Yaw;
    pPitch = stickCmdMsg.Pitch;
    pRoll = stickCmdMsg.Roll;    
    
    % Get current time
    t =  datetime('now') - startTime;
     
    % Add points to animation
    dThrust = double(pThrust);
    dYaw = double(pYaw);
    dPitch = double(pPitch);
    dRoll = double(pRoll);
    
    addpoints(Thrust, datenum(t), dThrust)
    addpoints(Yaw, datenum(t), dYaw)
    addpoints(Pitch, datenum(t), dPitch)
    addpoints(Roll, datenum(t), dRoll)
    
    % Update axes
    xThrust.XLim = datenum([t-seconds(25) t]);
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