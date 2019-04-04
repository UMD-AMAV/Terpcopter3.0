function [] = plotestimationTxt
fileID = 'estimation.txt';
 %  1    2  3  4   5        6       7      8   9    10    11   12 13
% [time ax ay az imuaccx imuaccY imuaccZ VIox VIoY predX predY vx vy]
A = load(fileID, '-ascii');

figure(1);
plot(A(:,1), A(:,2),'r'); hold on;
plot(A(:,1), A(:,3),'g'); hold on;
plot(A(:,1), A(:,4),'b');
title('NWU Inertial Frame');
legend('ax','ay','az');
xlabel('Time(s)');
ylabel('acceleration (m/s^2)');

figure(2)
plot(A(:,1), A(:,5),'r'); hold on;
plot(A(:,1), A(:,6),'g'); hold on;
plot(A(:,1), A(:,7),'b'); 

title('IMU (body) Frame');
legend('imuaX','imuaY','imuaZ');
xlabel('Time(s)');
ylabel('acceleration (m/s^2)');

%Gaussian fit 
Ax = fitdist(A(:,2),'Normal')
Ay = fitdist(A(:,3),'Normal')
Az = fitdist(A(:,4),'Normal')

pxCov =  cov(A(:,8));
pyCov =  cov(A(:,9));

predXCov = cov(A(:,10));
predYCov = cov(A(:,11));

predVXCov = cov(A(:,12));
predVYCov = cov(A(:,13));

fprintf('VIO px covariance is: %5d\n', pxCov);
fprintf('VIO py covariance is: %5d\n', pyCov);

fprintf('prediction px covariance is: %5d\n', predXCov);
fprintf('prediction py covariance is: %5d\n', predYCov);

fprintf('prediction vx covariance is: %5d\n', predVXCov);
fprintf('prediction vy covariance is: %5d\n', predVYCov);

figure(3); 
plot(A(:,8), A(:,9),'sr','MarkerSize',10); hold on;
plot(A(:,10), A(:,11),'*b','MarkerSize',10); hold on;

title('Results from VIO and Kalman');
legend('VIO','kalmanPos');
xlabel('X (m)');
ylabel('Y (m)');

figure(4);
plot(A(:,1),A(:,12),'*r','MarkerSize',10); hold on;
plot(A(:,1),A(:,13),'sb','MarkerSize',10); 

title('Kalman velocity predictions');
legend('vx','vy');
xlabel('Time(s)');
ylabel('Y (m/s)');
end
