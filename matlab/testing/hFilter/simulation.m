clear; close all; clc;


% simulation of quad
r = 1.5; % radius
Tp = 20; % period
w = 2*pi/Tp;
px0 = r; % (r,0) default
py0 = 0;
vx0 = -w*r*sin(0);
vy0 = w*r*cos(0);
ax0 = -w^2*r*cos(0);
ay0 = -w^2*r*sin(0);

x0 = [px0 py0 vx0 vy0 ax0 ay0]';
dt = 0.01;
T = 1*Tp;
N = floor(T/dt);
x(:,1) = x0;
t(1) = 0;
f = 2*pi;

heightH = 1;
widthH = 0.5;
th = 25*pi/180;
R = [cos(th) -sin(th); sin(th) cos(th)];
HleftX = [-widthH/2 -widthH/2 -widthH/2]';
HleftY = [-heightH/2 0 heightH/2]';
HrightX = [widthH/2 widthH/2 widthH/2]';
HrightY = [-heightH/2 0 heightH/2]';
HmidX = [-widthH/2 0 widthH/2]';
HmidY = [0 0 0]';
for i = 1:1:3
    hpt = R*[HleftX(i) HleftY(i)]';
    HleftX(i) = hpt(1);
    HleftY(i) = hpt(2);
    hpt = R*[HrightX(i) HrightY(i)]';
    HrightX(i) = hpt(1);
    HrightY(i) = hpt(2);
    hpt = R*[HmidX(i) HmidY(i)]';
    HmidX(i) = hpt(1);
    HmidY(i) = hpt(2);
end
% hPixelX = -360 to 360 (pixels)
% hPixelY = -640 to 640
aspectWidth = 640;
aspectHeight = 640;
kcam = 0.5/100; % meters/pixel

ux(1) = 0;
uy(1) = 0;
h(1) = pi/2;
i = 1;
R = [cos(h(i)-pi/2) -sin(h(i)-pi/2); sin(h(i)-pi/2) cos(h(i)-pi/2)];
hpt = R*[HmidX(2) HmidY(2)]';
hpt = 1/kcam*(hpt - [x0(1) x0(2)]');
pixelX(i) = hpt(1);
pixelY(i) = hpt(2);
for i = 2:1:N
    t(i) = (i-1)*dt;
    xi = x(:,i-1);
    xdot(1,1) = xi(3);
    xdot(2,1) = xi(4);
    xdot(3,1) = xi(5);
    xdot(4,1) = xi(6);
    xdot(5,1) = ux(i-1);
    xdot(6,1) = uy(i-1);
    x(:,i) = xi + xdot*dt;
    ux(i) = r*w^3*sin( t(i)*w );
    uy(i) = -r*w^3*cos( t(i)*w );
    delx = x(1,i) - x(1,i-1);
    dely = x(2,i) - x(2,i-1);
    h(i) = atan2( dely , delx );
    
    R = [cos(h(i)-pi/2) -sin(h(i)-pi/2); sin(h(i)-pi/2) cos(h(i)-pi/2)];
    hpt = R*[HmidX(2) HmidY(2)]';
    hpt = 1/kcam*(hpt - [xi(1) xi(2)]');
    pixelX(i) = hpt(1);
    pixelY(i) = hpt(2);
end

xp = x(1,:);
yp = x(2,:);
vx = x(3,:);
vy = x(4,:);
ax = x(5,:);
ay = x(6,:);

for i =1:1:N
    a = [ax(i) ay(i)]';
    R = [cos(h(i)-pi/2) -sin(h(i)-pi/2); sin(h(i)-pi/2) cos(h(i)-pi/2)];
    ab = R*a;
    abx(i) = ab(1);
    aby(i) = ab(2);
end


for i = 1:1:3
    hpt = R*[HleftX(i) HleftY(i)]';
    HleftX(i) = hpt(1);
    HleftY(i) = hpt(2);
    hpt = R*[HrightX(i) HrightY(i)]';
    HrightX(i) = hpt(1);
    HrightY(i) = hpt(2);
    hpt = R*[HmidX(i) HmidY(i)]';
    HmidX(i) = hpt(1);
    HmidY(i) = hpt(2);
end

figure;
plot(xp,yp); hold on;
plot(HleftX, HleftY,'ko-');
plot(HrightX, HrightY,'ko-');
plot(HmidX, HmidY,'ko-');

xlabel('x');
ylabel('y');
grid on;
axis equal;

figure;
plot(t,vx); hold on;
plot(t,vy)
legend('vx','vy');

figure;
plot(t,ax); hold on;
plot(t,ay)
legend('ax','ay');


camw = aspectWidth*kcam;
camh = aspectHeight*kcam;

ang = linspace(0,2*pi);
xc = r*cos(ang);
yc = r*sin(ang);

movie = 1;
if ( movie )
    for i = 1:floor(0.5/dt):N
        figure(3);
        subplot(1,2,2)
        hold off;
        subplot(1,2,1)
        hold off;
        
        figure(3);
        %
        subplot(1,2,1);
        plot(xp(i),yp(i),'ro'); hold on;
        % box
        boxX = [-camw -camw camw camw -camw]/2;
        boxY = [-camh camh camh -camh -camh]/2;
        R = [cos(h(i)) -sin(h(i)); sin(h(i)) cos(h(i))];
        for k = 1:1:5
            hpt = R*[boxX(k) boxY(k)]';
            boxX(k) = hpt(1);
            boxY(k) = hpt(2);
        end
        boxX = xp(i) + boxX;
        boxY = yp(i) + boxY;
        plot(boxX, boxY,'k-');
        % circle
        circX = px0-r + xc;
        circY = py0 + yc;
        plot(circX, circY,'k--');
        % H
        plot(HleftX, HleftY,'ko-');
        plot(HrightX, HrightY,'ko-');
        plot(HmidX, HmidY,'ko-');
        % arrow
        arrow = 1*[cos(h(i)) sin(h(i))];
        plot([xp(i) arrow(1)+xp(i)],[yp(i) arrow(2)+yp(i)],'r-','linewidth',2);
        axis equal;
        set(gca,'FontSize',16)
        xlabel('X');
        ylabel('Y');
        xlim([-4 4]);
        ylim([-4 4]);
        
        %
        subplot(1,2,2);
        set(gca,'FontSize',16)
        R = [cos(h(i)-pi/2) -sin(h(i)-pi/2); sin(h(i)-pi/2) cos(h(i)-pi/2)];
        for k = 1:1:3
            hpt = R*[HleftX(k) HleftY(k)]';
            HleftXp(k) = hpt(1);
            HleftYp(k) = hpt(2);
            hpt = R*[HrightX(k) HrightY(k)]';
            HrightXp(k) = hpt(1);
            HrightYp(k) = hpt(2);
            hpt = R*[HmidX(k) HmidY(k)]';
            HmidXp(k) = hpt(1);
            HmidYp(k) = hpt(2);
            
        end
        HleftXp = 1/kcam*(HleftX - xp(i));
        HleftYp = 1/kcam*(HleftY - yp(i));
        HrightXp = 1/kcam*(HrightX - xp(i));
        HrightYp = 1/kcam*(HrightY - yp(i));
        HmidXp = 1/kcam*(HmidX - xp(i));
        HmidYp = 1/kcam*(HmidY - yp(i));
        % H
        plot(HleftXp, HleftYp,'ko-'); hold on;
        plot(HrightXp, HrightYp,'ko-');
        plot(HmidXp, HmidYp,'ko-');
        plot(HmidXp(2), HmidYp(2),'ro','linewidth',2);
        xlabel('Pixel X');
        ylabel('Pixel Y');
        axis equal;
        xlim([-360 360]);
        ylim([-360 360]);
        grid on;
        drawnow;
    end
end



% add noise
pixelXn = pixelX + 20*randn(1,N);
pixelYn = pixelY + 20*randn(1,N);
abxn = abx + 0.15*randn(1,N);
abyn = aby + 0.15*randn(1,N);
drift = 90;
hn = h + 0.5*randn(1,N) + t/T*drift*pi/180;

% downsample
imuFreq = 15;
imgFreq = 10;
imuVals = [1:floor( (1/imuFreq) / dt ):N];
imgVals = [1:floor( (1/imgFreq) / dt ):N];
t_imu = t(imuVals);
t_img = t(imgVals);
pixelXn = pixelXn(imgVals);
pixelYn = pixelYn(imgVals);
abxn = abxn(imuVals);
abyn = abyn(imuVals);
hn = hn(imuVals);

% dropout
dropout = 0;
j = 1;
notvalid = [];
for i = 1:1:length(imgVals)    
    if ( j > dropout )
        n = rand();
        if ( n < 0.08 )
            dropout = randi(20);
        else
            dropout = 0;
        end
        j = 1;
    else
        j = j + 1;
        notvalid = [notvalid i];
    end
    
end

pixelXn(notvalid) = NaN;
pixelYn(notvalid) = NaN;
%t_img(notvalid) = NaN;

figure;
subplot(3,2,1);
plot(t,pixelX);
hold on;
plot(t,pixelY);
legend('pixel x','pixel y');
ylabel('Pixel');
set(gca,'FontSize',16)

subplot(3,2,3);
plot(t,abx);
hold on;
plot(t,aby);
legend('abx','aby');
ylabel('Body Acceleration (m^2/s)');
set(gca,'FontSize',16)

subplot(3,2,5);
plot(t,h*180/pi);
hold on;
xlabel('Time (sec.)')
ylabel('Heading (deg)');
set(gca,'FontSize',16)

subplot(3,2,2);
plot(t_img,pixelXn,'o');
hold on;
plot(t_img,pixelYn,'o');
legend('pixel x','pixel y');
ylabel('Pixel');
set(gca,'FontSize',16)

subplot(3,2,4);
plot(t_imu,abxn);
hold on;
plot(t_imu,abyn);
legend('abx','aby');
ylabel('Body Acceleration (m^2/s)');
set(gca,'FontSize',16)

subplot(3,2,6);
plot(t_imu,hn*180/pi);
hold on;
xlabel('Time (sec.)')
ylabel('Heading (deg)');
set(gca,'FontSize',16)

