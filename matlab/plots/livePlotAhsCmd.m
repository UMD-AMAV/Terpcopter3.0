% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author- Team AMAV 2018-2019
% 
% About - Subscribes to ahs command, state estimation topic and displays 
%         the live plots.      
% 
% Input - 'terpcopter_msgs/ahsCmd'
%         'terpcopter_msgs/stateEstimate'
% 
% Output - 4x1 Graphical plot containing Altitude ForwardSpeed CrabSpeed HeadingRad
% 
% Note - 1) If plot display is delayed try running it on a windows machine.
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

clear all; clc;
%addpath('./results');

%  ahsCmd
%  altitudeMeters
%  headingRad
%  forwardSpeedMps
%  crabSpeedMps

global ahsCmdMsg;
ahsCmdMsg = rosmessage('terpcopter_msgs/ahsCmd');
ahsCmdMsg.AltitudeMeters = 0;
ahsCmdMsg.HeadingRad = 0;
ahsCmdMsg.ForwardSpeedMps = 0;
ahsCmdMsg.CrabSpeedMps = 0;

% global stateEstimateMsg;
% stateEstimateMsg = rosmessage('terpcopter_msgs/stateEstimate');
% stateEstimateMsg.Time = 0 ;

plotahsCmdNode = robotics.ros.Node('/liveplotahsCmd');
pahsCmdMsg = robotics.ros.Subscriber(plotahsCmdNode,'ahsCmd','terpcopter_msgs/ahsCmd',{@ahsCmdCallback});
% pStateEstimateSub = robotics.ros.Subscriber(plotahsCmdNode,'stateEstimate','terpcopter_msgs/stateEstimate',{@stateEstimateCallback});


msg = receive(pahsCmdMsg,20);
% msgTime = receive(pStateEstimateSub,20);

% Displaying figure
figure()
subplot(4,1,1)

% Creating animated lines for live plots
Altitude = animatedline('Color','k','LineWidth',3);
xAltitude = gca;
xAltitude.XGrid = 'on';
xAltitude.YGrid = 'on';
xlabel('iteration');
ylabel('Altitude');
set(gca,'FontSize',25)
legend('Altitude in Meters')
set(gca,'FontSize',16)
grid on;

subplot(4,1,1)
ForwardSpeed = animatedline('Color','k','LineWidth',3);
xForwardSpeed = gca;
xForwardSpeed.XGrid = 'on';
xForwardSpeed.YGrid = 'on';
xlabel('iteration');
ylabel('Forward Speed');
set(gca,'FontSize',25)
legend('Forward Speed')
set(gca,'FontSize',16)
grid on;

subplot(4,1,1)
CrabSpeed = animatedline('Color','k','LineWidth',3);
xCrabSpeed = gca;
xCrabSpeed.XGrid = 'on';
xCrabSpeed.YGrid = 'on';
xlabel('iteration');
ylabel('Crab speed');
set(gca,'FontSize',25)
legend('Crab speed')
set(gca,'FontSize',16)
grid on;

subplot(4,1,4)
Heading = animatedline('Color','k','LineWidth',3);
xHeading = gca;
xHeading.XGrid = 'on';
xHeading.YGrid = 'on';
xlabel('iteration');
ylabel('Heading Rad');
set(gca,'FontSize',25)
legend('Heading Rad')
set(gca,'FontSize',16)
grid on;

% Title for subplots
sgt = sgtitle('AHS Cmd'); %raw data
sgt.FontSize = 25;

stop = false;
startTime = datetime('now');
while ~stop
    
    % Read current value from topic
    pAltitudeMeters = ahsCmdMsg.AltitudeMeters;
    pForwardSpeedMps = ahsCmdMsg.ForwardSpeedMps;
    pCrabSpeedMps = ahsCmdMsg.CrabSpeedMps;
    pHeadingRad = ahsCmdMsg.HeadingRad;    
    
    % Get current time
    t =  datetime('now') - startTime;
     
    % Add points to animation
    dAltitudeMeters = double(pAltitudeMeters);
    dForwardSpeedMps = double(pForwardSpeedMps);
    dCrabSpeedMps = double(pCrabSpeedMps);
    dHeadingRad = double(pHeadingRad);
    
    addpoints(Altitude, datenum(t), dAltitudeMeters)
    addpoints(ForwardSpeed, datenum(t), dForwardSpeedMps)
    addpoints(CrabSpeed, datenum(t), dCrabSpeedMps)
    addpoints(Heading, datenum(t), dHeadingRad)
    
    % Update axes
    xAltitude.XLim = datenum([t-seconds(25) t]);
    datetick('x','keeplimits')
    
    xForwardSpeed.XLim = datenum([t-seconds(25) t]);
    datetick('x','keeplimits')
    
    xCrabSpeed.XLim = datenum([t-seconds(25) t]);
    datetick('x','keeplimits')
    
    xHeading.XLim = datenum([t-seconds(25) t]);
    datetick('x','keeplimits')
 
    drawnow %limitrate
    
    % Add stop condition 
end