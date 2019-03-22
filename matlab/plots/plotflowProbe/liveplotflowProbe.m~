% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About -Subscribes to the /terarangerone topic and displays the live plots.
% 
% Input - 'std_msgs/Float32'
% 
% Output - Graphical plot containing Velocity
% 
% Note - 1) If plot display is delayed try running it on a windows machine.
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
clear all; clc;

global flowProbeMsg;
flowProbeMsg = rosmessage('std_msgs/Float32');
flowProbeMsg.Data = 0;

plotflowProbeNode = robotics.ros.Node('/plotflowProbe');
plotflowProbeSub = robotics.ros.Subscriber(plotflowProbeNode,'terpcopter_flow_probe_node/flowProbe','std_msgs/Float32',{@flowProbeCallback});

msg = receive(plotflowProbeSub,20);

figure()
% subplot(3,2,1)

% Creating animated lines for live plots
Velocity = animatedline('Color','g','LineWidth',3);
xVelocity = gca;
xVelocity.XGrid = 'on';
xVelocity.YGrid = 'on';
xlabel('Time');
ylabel('Range');
set(gca,'FontSize',25)
legend('Velocity')
title('Flow Probe data')
set(gca,'FontSize',16)

stop = false;
startTime = datetime('now');
while ~stop
    
    % Read current value from topic
    pVelocity = flowProbeMsg.Data;
     
    % Get current time
    t =  datetime('now') - startTime;
     
    % Add points to animation
    dRange = double(pVelocity);
   
    addpoints(Velocity, datenum(t), dRange)
    
    % Update axes
    xVelocity.XLim = datenum([t-seconds(25) t]);
    datetick('x','keeplimits')
 
    drawnow %limitrate
   
    % Add stop condition 
end