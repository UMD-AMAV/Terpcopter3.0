function plotVIO

disp('')
disp('Welcome to plot VIO data')
disp('press q on the figure to quit and save variables');
disp('')

% initialize ROS
if(~robotics.ros.internal.Global.isNodeActive)
    rosinit('192.168.0.29'); %change to master IP 
end

pose = rossubscriber('/mavros/vision_pose/pose');
lidar = rossubscriber('/mavros/distance_sensor/hrlv_ez4_pub');

ax = 5; %m
tlag = 10; %sec

try
    msgPose = receive(pose,10);
    msgLidar = receive(lidar,10);
catch e
    fprintf(1,'The identifier was:\n%s',e.identifier);
    fprintf(1,'There was an error! The message was:\n%s',e.message);
end

% subplot xy, xyz , and z lidar 
figure(gcf), clf
%subplot(1,2,[1 3 5])
axis image, hold on
axis(ax*[-1 1 -1 1]),
box on, grid on
yaw_quiver1 = quiver(0,0,0,1);
set(yaw_quiver1,'linewidth',2);
xlabel('x (m)'), ylabel('y (m)')
title('VIO 2D position');

% subplot(6,2,[1 4 6])
% axis image, hold on
% axis([0 10 0 2]),
% box on, grid on
% xlabel('t(s)'), zlabel('z(m)');
% title('Z position');

t0 = [];
ii = 1;
set(gcf,'CurrentCharacter','@');

while(1)
    try
        msgPose = receive(pose,10);
        msgLidar = receive(lidar,10);

    catch e
        fprintf(1,'The identifier was:\n%s',e.identifier);
        fprintf(1,'There was an error! The message was:\n%s',e.message);
        continue;
    end
    
    posX(ii) = msgPose.Pose.Position.X;
    posY(ii) = msgPose.Pose.Position.Y;
    posZ(ii) = msgPose.Pose.Position.Z;
 
    posZLidar(ii) = msgLidar.Range_;
    
    quat=([msgPose.Pose.Orientation.W, msgPose.Pose.Orientation.X,...
        msgPose.Pose.Orientation.Y,msgPose.Pose.Orientation.Z]);
    
    Eangles = rad2deg(quat2eul(quat));
    yaw(ii) = Eangles(1);
    pitch(ii) = Eangles(2);
    roll(ii) = Eangles(3);
    
    abs_t = eval([int2str(msgPose.Header.Stamp.Sec) '.' ...
        int2str(msgPose.Header.Stamp.Nsec)]);
    if isempty(t0), t0 = abs_t; end
    t = abs_t-t0;
    
    %subplot(5,2,[1 3 5])
    plot(posX(ii),posY(ii),'r.');
    set(yaw_quiver1,'xdata',posX(ii),'ydata',posY(ii),'udata', ...
        cos(yaw(ii)/180*pi), 'vdata',sin(yaw(ii)/180*pi));
    
    % plot lidar data and vio z pos
%     subplot(6,2,[2 4 6])
%     plot(t,posZ(ii),'b.',t,posZLidar(ii),'g.');
%     legend('vio','lidar');
%     %plot(t,posZLidar(ii),'g-'); legend('vio','lidar');
%     set(gca,'xlim',[max(t-tlag,0) max(t,1)])
   
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
save('VIO');
end