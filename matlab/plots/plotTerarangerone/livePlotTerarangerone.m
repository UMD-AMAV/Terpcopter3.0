% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About -Subscribes to the /terarangerone topic and displays the live plots.
% 
% Input - 'sensor_msgs/Range'
% 
% Output - Graphical plot containing Range
% 
% Note - 1) If plot display is delayed try running it on a windows machine.
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

clear all; clc;

global terarangeroneMsg;
terarangeroneMsg = rosmessage('sensor_msgs/Range');
terarangeroneMsg.FieldOfView = 0;
terarangeroneMsg.MinRange = 0;
terarangeroneMsg.MaxRange = 0;
terarangeroneMsg.Range_ = 0;

plotTerarangeroneNode = robotics.ros.Node('/plotTerarangerone');
pTerarangeroneSub = robotics.ros.Subscriber(plotTerarangeroneNode,'/terarangerone','sensor_msgs/Range',{@terarangeroneCallback});

msg = receive(pTerarangeroneSub,20);

figure()
% subplot(3,2,1)

% Creating animated lines for live plots
Range = animatedline('Color','g','LineWidth',3);
xRange = gca;
xRange.XGrid = 'on';
xRange.YGrid = 'on';
xlabel('Time');
ylabel('Range');
set(gca,'FontSize',25)
legend('Range Terarangerone')
title('Lidar Raw data')
set(gca,'FontSize',16)

stop = false;
startTime = datetime('now');
while ~stop
    
    % Read current value from topic
    pRange = terarangeroneMsg.Range_;
     
    % Get current time
    t =  datetime('now') - startTime;
     
    % Add points to animation
    dRange = double(pRange);
   
    addpoints(Range, datenum(t), dRange)
    
    % Update axes
    xRange.XLim = datenum([t-seconds(25) t]);
    datetick('x','keeplimits')
 
    drawnow %limitrate
   
    % Add stop condition 
end