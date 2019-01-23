% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Author - Team AMAV 2018-2019
% 
% About -Subscribes to the pid settings topic and displays the live plots.
% 
% Input - 'terpcopter_msgs/ffpidSettting'
% 
% Output - 4x1 Graphical plot containing Kp Ki Kd Ff
% 
% Note - 1) If plot display is delayed try running it on a windows machine.
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

clear all; close all; clc;
% addpath('./results');

% pidSetting
% float32 kp
% float32 ki
% float32 kd
% float32 ff

global ffpidSettingMsg;
ffpidSettingMsg= rosmessage('terpcopter_msgs/ffpidSetting');
ffpidSettingMsg.Kp = 0 ;
ffpidSettingMsg.Ki = 0 ;
ffpidSettingMsg.Kd = 0 ;
ffpidSettingMsg.Ff = 0 ;

plotpidSettingNode = robotics.ros.Node('/liveplotpidSetting');
pidSettingSub = robotics.ros.Subscriber(plotpidSettingNode,'pidSetting','terpcopter_msgs/ffpidSetting',{@ffpidSettingCallback});

msg = receive(pidSettingSub,20);

% Creating the Plots
figure
subplot(4,1,1)

% Creating animated lines for live plots
Kp = animatedline('Color','g');
xKp = gca;
xKp.YGrid = 'on';
xlabel('Time');
ylabel('Kp');
set(gca,'FontSize',25)
legend('Kp')
set(gca,'FontSize',16)

subplot(4,1,2)
Ki = animatedline('Color','g');
xKi = gca;
xKi.YGrid = 'on';
xlabel('Time');
ylabel('Ki');
set(gca,'FontSize',25)
legend('Ki')
set(gca,'FontSize',16)

subplot(4,1,3)
Kd = animatedline('Color','g');
xKd = gca;
xKd.YGrid = 'on';
xlabel('Time');
ylabel('Kd');
set(gca,'FontSize',25)
legend('Kd')
set(gca,'FontSize',16)

subplot(4,1,4);
Ff = animatedline('Color','g');
xFf = gca;
xFf.YGrid = 'on';
xlabel('Time');
ylabel('Ff');
set(gca,'FontSize',25)
legend('FeedForward')
set(gca,'FontSize',16)

stop = false;
startTime = datetime('now');
while ~stop
    
    % Read current value from topic 
    pKp =  ffpidSettingMsg.Kp;
    pKi =  ffpidSettingMsg.Ki;
    pKd =  ffpidSettingMsg.Kd;
    pFf =  ffpidSettingMsg.Ff;    
    
    % Get current time
    t =  datetime('now') - startTime;
     
    dKp = double(pKp);
    dKi = double(pKi);
    dKd = double(pKd);
    dFf = double(pFf);
    
    % Add points to animation
    addpoints(Kp, datenum(t), dKp)
    addpoints(Ki, datenum(t), dKi)
    addpoints(Kd, datenum(t), dKd)
    addpoints(Ff, datenum(t), dFf)
    
    % Update axes
    xKp.XLim = datenum([t-seconds(25) t]);
    datetick('x','keeplimits')
    
    xKi.XLim = datenum([t-seconds(25) t]);
    datetick('x','keeplimits')
    
    xKd.XLim = datenum([t-seconds(25) t]);
    datetick('x','keeplimits')
    
    xFf.XLim = datenum([t-seconds(25) t]);
    datetick('x','keeplimits')
 
    drawnow %limitrate
   
    % Add stop condition 
end
