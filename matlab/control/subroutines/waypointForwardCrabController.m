function [yawStickCmd, uStickCmd, vStickCmd] = waypointForwardCrabController(curTime, yawDeg, x_d, x, y_d, y)

% gains/parameters
Kp_u = 0.10;
Kp_v = 0.10;
attitudeDeadbandMeters = 0.25;
relativeYawDeg = yawDeg - 90;  % This yaw is relative to the initial yaw when quad is turned on (90 Degrees)

% calculate attitude error in inertial frame
x_error = x_d - x;
y_error = y_d - y;

% Rotation from inertial frame to quad body frame
x_error_body = x_error*cosd(relativeYawDeg) + y_error*sind(relativeYawDeg);
y_error_body = -x_error*sind(relativeYawDeg) + y_error*cosd(relativeYawDeg);

distanceErrorMeters = sqrt(x_error_body^2 + y_error_body^2);

% proportional control scaled to unit vector
uStickCmd = Kp_u*(y_error_body/distanceErrorMeters);
vStickCmd = -Kp_v*(x_error_body/distanceErrorMeters);

yawStickCmd = 0;

if (abs(distanceErrorMeters) <= attitudeDeadbandMeters)
    uStickCmd = 0;
    vStickCmd = 0;
    yawStickCmd = 0;
end
end