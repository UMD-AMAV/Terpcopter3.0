function plotRefFrame(x,y,z,yaw,pitch,roll)
    % package angles
    angles = [yaw pitch roll]';
    % origin of frame
    or = [x y z]';    
    % define axes
    xAxis = [1 0 0]';
    yAxis = [0 1 0]';
    zAxis = [0 0 1]';
    % convert axes to inertial 
    xi = vectorConversions(xAxis, 'imu2ned', angles) + or;
    yi = vectorConversions(yAxis, 'imu2ned', angles) + or;
    zi = vectorConversions(zAxis, 'imu2ned', angles) + or;
    % plot 
    plot3([or(1) xi(1)],[or(2) xi(2)],[or(3) xi(3)],'Color','r','linewidth',2);
    hold on;
    plot3([or(1) yi(1)],[or(2) yi(2)],[or(3) yi(3)],'Color','g','linewidth',2);
    plot3([or(1) zi(1)],[or(2) zi(2)],[or(3) zi(3)],'Color','b','linewidth',2);
end