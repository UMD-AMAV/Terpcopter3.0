function plotYaw

disp('')
disp('Welcome to plot VIO data')
disp('press q on the figure to quit and save variables');
disp('')

% initialize ROS
if(~robotics.ros.internal.Global.isNodeActive)
    rosinit('192.168.0.29'); %change to master IP 
end

VIOYaw = rossubscriber('/mavros/vision_pose/pose');
StateYaw = rossubscriber('/stateEstimate');

ax = 5; %m
tlag = 10; %sec

try
    msgVIO = receive(VIOYaw,10);
    msgstateYaw = receive(StateYaw,10);
catch e
    fprintf(1,'The identifier was:\n%s',e.identifier);
    fprintf(1,'There was an error! The message was:\n%s',e.message);
end

% subplot xy, xyz , and z lidar 
figure(gcf), clf
axis image, hold on
axis(ax*[-1 1 -1 1]),
box on, grid on
yaw_quiver1 = quiver(0,0,0,1);
set(yaw_quiver1,'linewidth',2,'Color','red');

yaw_quiver2 = quiver(0,0,0,1);
set(yaw_quiver2,'linewidth',2,'Color','blue');

xlabel('x (m)'), ylabel('y (m)')
title('VIO 2D position');

t0 = [];
ii = 1;
set(gcf,'CurrentCharacter','@');

while(1)
    try
        msgVIO = VIOYaw.LatestMessage;
        msgstateYaw = StateYaw.LatestMessage;

    catch e
        fprintf(1,'The identifier was:\n%s',e.identifier);
        fprintf(1,'There was an error! The message was:\n%s',e.message);
        continue;
    end
    
    posX(ii) = msgstateYaw.North;
    posY(ii) = msgstateYaw.East;
    
    %plot the Magnatometer yaw 
    yawMag(ii) = msgstateYaw.Yaw;
     
    % plot the VIO yaw  
    quat=([msgVIO.Pose.Orientation.W, msgVIO.Pose.Orientation.X,...
        msgVIO.Pose.Orientation.Y,msgVIO.Pose.Orientation.Z]);
    
    Eangles = rad2deg(quat2eul(quat));
    yawVIO(ii) = Eangles(1);
    pitch(ii) = Eangles(2);
    roll(ii) = Eangles(3);
    
%     abs_t = eval([int2str(msgPose.Header.Stamp.Sec) '.' ...
%         int2str(msgPose.Header.Stamp.Nsec)]);
    abs_t = msgstateYaw.Time;
    if isempty(t0), t0 = abs_t; end
    t = abs_t-t0;
    
    %subplot(5,2,[1 3 5])
    plot(posX(ii),posY(ii),'m.');
    
    set(yaw_quiver1,'xdata',posX(ii),'ydata',posY(ii),'udata', ...
        cos(yawVIO(ii)/180*pi), 'vdata',sin(yawVIO(ii)/180*pi));
    
    set(yaw_quiver2,'xdata',posX(ii),'ydata',posY(ii),'udata', ...
        cos(yawMag(ii)/180*pi), 'vdata',sin(yawMag(ii)/180*pi));
     
    legend('VIO','Mag');
    
     k=get(gcf,'CurrentCharacter');
    if k~='@' % has it changed from the dummy character?
        set(gcf,'CurrentCharacter','@'); % reset the character
        % now process the key as required
        if k=='q', break;
        end
    end
    
    drawnow
    ii = ii + 1;
end
% save all variables 
save('VIOYaw');
end