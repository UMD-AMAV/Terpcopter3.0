function plotQuad(x,y,z,yaw,pitch,roll)
% package angles
angles = [yaw pitch roll]';
% origin of frame
or = [x y z]';
lx = 1.0;
ly = 1.0;
xVert = [-lx -lx lx lx -lx];
yVert = [-ly ly ly -ly -ly];
% rotors
th = linspace(0,2*pi*6);
R = 0.5;
xc = R*cos(th);
yc = R*sin(th);
xr1 = xc - lx;
yr1 = yc - ly;
xr2 = xc - lx;
yr2 = yc + ly;
xr3 = xc + lx;
yr3 = yc - ly;
xr4 = xc + lx;
yr4 = yc + ly;

% convert rectangle vertices
for i = 1:1:length(xVert)
    v = [xVert(i) yVert(i) 0];
    vi = vectorConversions(v, 'imu2ned', angles) + or;
    xi(i) = vi(1);
    yi(i) = vi(2);
    zi(i) = vi(3);
end

% convert rotors
for i = 1:1:length(xc)
    vr1 = [xr1(i) yr1(i) 0];
    vr1i = vectorConversions(vr1, 'imu2ned', angles) + or;
    xr1i(i) = vr1i(1);
    yr1i(i) = vr1i(2);
    zr1i(i) = vr1i(3);
    
    vr2 = [xr2(i) yr2(i) 0];
    vr2i = vectorConversions(vr2, 'imu2ned', angles) + or;
    xr2i(i) = vr2i(1);
    yr2i(i) = vr2i(2);
    zr2i(i) = vr2i(3);
    
    vr3 = [xr3(i) yr3(i) 0];
    vr3i = vectorConversions(vr3, 'imu2ned', angles) + or;
    xr3i(i) = vr3i(1);
    yr3i(i) = vr3i(2);
    zr3i(i) = vr3i(3);
    
    vr4 = [xr4(i) yr4(i) 0];
    vr4i = vectorConversions(vr4, 'imu2ned', angles) + or;
    xr4i(i) = vr4i(1);
    yr4i(i) = vr4i(2);
    zr4i(i) = vr4i(3);
end

% plot
plot3(xi,yi,zi,'Color','k','linewidth',2);
hold on;
plot3(xr1i,yr1i,zr1i,'Color','k','linewidth',2);
plot3(xr2i,yr2i,zr2i,'Color','k','linewidth',2);
plot3(xr3i,yr3i,zr3i,'Color','k','linewidth',2);
plot3(xr4i,yr4i,zr4i,'Color','k','linewidth',2);
end