function sendStickCmd(src,stateEstimateMsg,controlParams,stickCmdPublisher)

% unpack statestimate
t = stateEstimateMsg.Time;
z = stateEstimateMsg.Up;
fprintf('Received Msg, Quad Alttiude is : %3.3f m\n', z );

% get setpoint
global ahsCmdMsg;
z_d = ahsCmdMsg.AltitudeMeters;
disp('desired altitude');
disp(z_d)
% DEBUG
%z_d =1;
% update errors
global altitudeError;
altError = z - z_d;

% initialize error on first instance
if ( altitudeError.lastTime == 0 )
    altitudeError.lastTime = t;
    altitudeError.lastVal = z_d;
    altitudeError.lastSum = 0;
    u_t = controlParams.altitudeGains.ffterm;
    disp('initialize loop');
else
    % compute controls
    [u_t, altitudeError] = FF_PID(controlParams.altitudeGains, altitudeError, t, altError);
    disp('pid loop');
end

% publish
stickCmdMsg = rosmessage('terpcopter_msgs/stickCmd');
stickCmdMsg.Thrust = u_t;%max(min(1,u_t),-1);
stickCmdMsg.Yaw = 0*pi/180;
send(stickCmdPublisher, stickCmdMsg);
fprintf('Published Stick Cmd., Thrust : %3.3f, Error : %3.3f \n', stickCmdMsg.Thrust , ( z - z_d ) );

% plot
% figure(1);
% plot(t, z,'bo');
% hold on;
% plot(t, z_d,'r*');
% set(gca,'FontSize',16)
% xlabel('Ros Time Sec.');
% ylabel('Altitude (m)')
% grid on;

end