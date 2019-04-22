function mission = loadMissionTest2()
% This test is for Altitude Hover and Point to Target
mission.config.firstLoop = 1;

mission.config.H_detector = 0;
mission.config.target_detector = 0;
mission.config.flowProbe = 0;

% i = 1;
% % Behavior 1: Takeoff
% mission.bhv{i}.name = 'bhv_takeoff';
% mission.bhv{i}.ahs.desiredAltMeters = 0.5;    %
% % mission.bhv{i}.ahs.forwardSpeed = 0;
% % mission.bhv{i}.ahs.crabSpeed = 0;
% mission.bhv{i}.completion.status = false;

i = 1;
mission.bhv{i}.name = 'bhv_hover';
mission.bhv{i}.initialize.firstLoop = 1;
mission.bhv{i}.ahs.desiredAltMeters = 1;
mission.bhv{i}.ahs.desiredYawDegrees = 0;
mission.bhv{i}.completion.durationSec = 3;       % 60 seconds
mission.bhv{i}.completion.status = false;           % completion flag
% mission.bhv{i}.pid.alt.Kp = 0.1;
% mission.bhv{i}.pid.alt.Ki = 0.2;
% mission.bhv{i}.pid.alt.Kd = 0.01;
% mission.bhv{i}.pid.alt.Ff = 0.4;

i = i + 1
mission.bhv{i}.name = 'bhv_land_open';
mission.bhv{i}.ahs.desiredAltMeters = 0.4;
mission.bhv{i}.completion.status = false;

% i = i + 1;
% %Behavior 3: Land
% mission.bhv{i}.name = 'bhv_land';
% mission.bhv{i}.initialize.firstLoop = 1;
% mission.bhv{i}.ahs.desiredAltMeters = 0.3; % default is zero
% mission.bhv{i}.completion.altitudeIncrementMeters = 0.01;
% mission.bhv{i}.completion.landingAltMeters = 0.20;
% mission.bhv{i}.completion.threshold = 0.1;
% mission.bhv{i}.completion.durationSec = 0.1;
% mission.bhv{i}.completion.status = false;
end
