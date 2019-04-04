function [predictX, predictY, state,param, previous_t] = kalmanFilter(t, x, y, state, param, previous_t)
% State =[px py vx vy]'

sigmaQ = diag([1.317848e-07,2.118806e-07,3.582132e-04,1.823729e-04]); % setting this value large and sigmaR samller the output should be roughly the measurement values 
sigmaR = diag([1.5299e-07,9.3897e-08]); %1.5299e-07 9.3897e-08

% If first time running this funciton 
if previous_t < 0
    state = [x;y;0;0];
    param.P = 0.3*eye(4); % measure of estimated accuracy of the state estimate
    predictX = x;
    predictY = y;
    previous_t = t;
    return;
end

dt = t - previous_t

A = [1 0 dt 0;
    0 1 0 dt;
    0 0 1 0;
    0 0 0 1];

B = [0.5*dt*dt 0;
    0 0.5*dt*dt;
    dt 0;
    0 dt];

%param.u = [ax; ay];

% observable matrix -> which one velocity or pos?
C = [1 0 0 0;
    0 1 0 0];

%measurement 
%Z = [x;y;vx;vy];
Z = [x;y];

disp('u');
param.u

% prediction step
X = A * state + B * param.u;
P = A * param.P * A' + sigmaQ;

%Update

%kalman Gain 
K = P * C'* inv(sigmaR + C * P * C');

%state estimate
state = X + K * (Z - C * X)
 
% below is valid only for the optimal gain that minimizes the residual error
param.P = P - K* C * P;

predictX = state(1);
predictY = state(2);

previous_t = t;

% [dt K predictX predictY velX velY]
% fileID = fopen('kalmanlog.csv','a');
% fprintf(fileID,'%5f %5f %5f %5f\n',dt, K, round(predictX,3), round(predictY,3));
% fclose(fileID);
end

