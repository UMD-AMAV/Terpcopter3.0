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

global flowProbeMsg;
flowProbeMsg = rosmessage('std_msgs/Float32');

plotTerarangeroneNode = robotics.ros.Node('/plotFlowProbe');
flowProbeDataSubscriber = robotics.ros.Subscriber(estimationNode,'/terpcopter_flow_probe_node/flowProbe','std_msgs/Float32',@flowProbeCallback,"BufferSize",1);

msg = receive(flowProbeDataSubscriber,20);

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
    v = flowProbeMsg.Data;
     
    % Get current time
    t =  datetime('now') - startTime;
     
    % Add points to animation
    dv= double(v);
   
    addpoints(Range, datenum(t), dv)
    
    % Update axes
    xRange.XLim = datenum([t-seconds(25) t]);
    datetick('x','keeplimits')
 
    drawnow %limitrate
   
    % Add stop condition 
end