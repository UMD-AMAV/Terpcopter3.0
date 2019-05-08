function [pxFilt, pyFilt] = Hfilter(stateEstimateMsg, imuMsg, bhvTime, hDetected, hAngle, hPixelX, hPixelY, logname)


% hDetected = 0 (no H detected) , 1 (H detected)
% hAngle = -180 to 180 (deg)
% hPixelX = -360 to 360 (pixels)
% hPixelY = -640 to 640

% process noise
stdev_pos = 1;% m
stdev_vel = 0.1;% m/s
stdev_accel = 0.1;% m/s^2

% measurement noise
stdev_pm = 2;% pixels
stdev_am = 0.1;% accel

% camera model
kcam = 1/100; % meters/pixel (at a fixed altitude)

% outlier rejection
Raccept = 150; % pixels
accelFiltTimeConstant = 1; % sec

% initial filter conditions
Pinit = diag([stdev_pos^2 stdev_pos^2 stdev_vel^2 stdev_vel^2 stdev_accel^2 stdev_accel^2]); % 6 x 6
xinit = [0 0 0 0 0 0]';

% initialize
persistent lastTime lastAx lastAy xkm1_km1 Pkm1_km1 lastValidTime lastHrefYawDeg lastPixelX lastPixelY lastHangle;

if isempty(xkm1_km1)
    xkm1_km1 = xinit;
    Pkm1_km1 = Pinit;
    lastTime = 0;
    lastAx = 0;
    lastAy = 0;
    lastValidTime = 0;
    lastHrefYawDeg  = 0;
    lastPixelX  = 0;
    lastPixelY  = 0;
    lastHangle  = 0;
end

% compute time step
T = bhvTime - lastTime;

% derived parameter
% z = [x y vx vy ax ay];
Q = diag([stdev_pos^2 stdev_pos^2 stdev_vel^2 stdev_vel^2 stdev_accel^2 stdev_accel^2]); % 6 x 6
R_det = diag([stdev_pm^2 stdev_pm^2 stdev_am^2 stdev_am^2]); % 4 x 4
R_no_det = diag([stdev_am^2 stdev_am^2]);% 2 x 2


% unpack state estimate
% pitch = stateEstimateMsg.PitchDegrees;
% roll = stateEstimateMsg.RollDegrees;
currentYawDeg = stateEstimateMsg.Yaw;
axRaw = imuMsg.LinearAcceleration.X;
ayRaw = imuMsg.LinearAcceleration.Y;

% low-pass filter altitude
alpha = T / ( accelFiltTimeConstant + T);
axFilt = (1-alpha)*lastAx + alpha*axRaw;
ayFilt = (1-alpha)*lastAy + alpha*ayRaw;





% z = [x y vx vy ax ay bx by];
S = T^2/2;
F = [1 0 T 0 S 0;
     0 1 0 T 0 S;
     0 0 1 0 T 0;
     0 0 0 1 0 T;
     0 0 0 0 0 0;
     0 0 0 0 0 0];
G = 0;
ukm1 = 0;
H_det = [1 0 0 0 0 0;
    0 1 0 0 0 0;
    0 0 0 0 1 0;
    0 0 0 0 0 1];
H_no_det = [ 0 0 0 0 1 0;
             0 0 0 0 0 1];

% check if measurement passes through gate
gateSatisfied = 0;
if ( hDetected )
    % get H-relative heading, th
    th =  currentYawDeg + hAngle;
    vLast = [lastPixelX lastPixelY];
    vNew = [hPixelX hPixelY];
    % check if measurement is not outlier
    if ( norm(vLast-vNew) <= Raccept )
        % check if measurement is unique
        if ( any([lastPixelX lastPixelY lastHangle]~=[hPixelX hPixelY hAngle]) )
            gateSatisfied = 1;
        end
    end
end

% compute rotation matrix
if ( gateSatisfied )
    th = hAngle;
else
    th = signedAngularDist(currentYawDeg*pi/180, lastHrefYawDeg*pi/180)*180/pi + 90;
end
R = [cosd(th) -sind(th); sind(th) cosd(th)];

% rotate accelerations
a = R*[axFilt ayFilt]';
ax = a(1);
ay = a(2);

%filter
if ( gateSatisfied )
    
    % rotate pixels
    p = R*[hPixelX hPixelY]';
    px = p(1);
    py = p(2);
    
    % convert pixels to x,y (measured)
    xm = kcam*px;
    ym = kcam*py;
    
    % package measurement
    yk = [xm ym ax ay]';
    
    % filter with pixel measurement
    [xk_k, Pk_k, K, xk_km1, Pk_km1] = discreteKalmanFilter(xkm1_km1, ukm1, Pkm1_km1, yk, F, G, H_det, Q, R_det);
    
    % update last valid
    lastValidTime = bhvTime;
    lastPixelX = hPixelX;
    lastPixelY = hPixelY;
    lastHangle = hAngle;
    lastHrefYawDeg = currentYawDeg - (hAngle - 90);
else
    % package measurement
    yk = [ax ay]';
    
    % filter without pixel measurement
    [xk_k, Pk_k, K, xk_km1, Pk_km1] = discreteKalmanFilter(xkm1_km1, ukm1, Pkm1_km1, yk, F, G, H_no_det, Q, R_no_det);
end

% update persistent
xkm1_km1 = xk_k;
Pkm1_km1 = Pk_k;
lastTime = bhvTime;

% rotate back body frame
pFilt = R'*[xk_k(1) xk_k(2)]'./kcam;

% output pixels
pxFilt = pFilt(1);
pyFilt = pFilt(2);

% logging
logFlag = 1;
if ( logFlag )
    
    pFile = fopen( logname ,'a');
    
    % write csv file
    fprintf(pFile,'%6.6f,',bhvTime);
    
    % measurements
    fprintf(pFile,'%6.6f,',currentYawDeg);
    fprintf(pFile,'%6.6f,',axRaw);
    fprintf(pFile,'%6.6f,',ayRaw);
    fprintf(pFile,'%6.6f,',hDetected);
    fprintf(pFile,'%6.6f,',hAngle);
    fprintf(pFile,'%6.6f,',hPixelX);
    fprintf(pFile,'%6.6f,',hPixelY);
    
    % filter states
    fprintf(pFile,'%6.6f,',xk_k(1));
    fprintf(pFile,'%6.6f,',xk_k(2));
    fprintf(pFile,'%6.6f,',xk_k(3));
    fprintf(pFile,'%6.6f,',xk_k(4));
    fprintf(pFile,'%6.6f,',xk_k(5));
    fprintf(pFile,'%6.6f,',xk_k(6));
    
    % filter covariance
    fprintf(pFile,'%6.6f,',Pk_k(1));
    fprintf(pFile,'%6.6f,',Pk_k(2));
    fprintf(pFile,'%6.6f,',Pk_k(3));
    fprintf(pFile,'%6.6f,',Pk_k(4));
    fprintf(pFile,'%6.6f,',Pk_k(5));
    fprintf(pFile,'%6.6f,',Pk_k(6));
    fprintf(pFile,'%6.6f,',Pk_k(7));
    fprintf(pFile,'%6.6f,',Pk_k(8));
    fprintf(pFile,'%6.6f,',Pk_k(9));
    fprintf(pFile,'%6.6f,',Pk_k(10));
    fprintf(pFile,'%6.6f,',Pk_k(11));
    fprintf(pFile,'%6.6f,',Pk_k(12));
    fprintf(pFile,'%6.6f,',Pk_k(13));
    fprintf(pFile,'%6.6f,',Pk_k(14));
    fprintf(pFile,'%6.6f,',Pk_k(15));
    fprintf(pFile,'%6.6f,',Pk_k(16));
    
    % output    
    fprintf(pFile,'%6.6f,', pFilt(1) );
    fprintf(pFile,'%6.6f,', pFilt(2) );    
    
    % persistent variables
    fprintf(pFile,'%6.6f,',lastTime);
    fprintf(pFile,'%6.6f,',lastValidTime);
    fprintf(pFile,'%6.6f,',lastHrefYawDeg);
    fprintf(pFile,'%6.6f,',lastPixelX);
    fprintf(pFile,'%6.6f,',lastPixelY);
    fprintf(pFile,'%6.6f,',lastHangle);
    
    fprintf(pFile,'%6.6f,',th);
    fprintf(pFile,'%6.6f,',axFilt);
    fprintf(pFile,'%6.6f,\n',ayFilt);    
    fclose(pFile);
end

end


