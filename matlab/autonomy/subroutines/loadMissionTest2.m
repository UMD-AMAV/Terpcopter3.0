function mission = loadMissionTest2()
% This test is for Altitude Hover and Point to Target
mission.config.firstLoop = 1;


i = 1;
% Behavior 1: Takeoff
mission.bhv{i}.name = 'bhv_takeoff';
mission.bhv{i}.ahs.desiredAltMeters = 0.5;    %
% mission.bhv{i}.ahs.forwardSpeed = 0;
% mission.bhv{i}.ahs.crabSpeed = 0;
mission.bhv{i}.completion.status = false;

i = i + 1;
mission.bhv{i}.name = 'bhv_hover';
mission.bhv{i}.initialize.firstLoop = 1;
mission.bhv{i}.ahs.desiredAltMeters = 1;
mission.bhv{i}.ahs.desiredYawDegrees = 0;
mission.bhv{i}.completion.durationSec = 5;       % 60 seconds
mission.bhv{i}.completion.status = false;           % completion flag
% mission.bhv{i}.pid.alt.Kp = 0.1;
% mission.bhv{i}.pid.alt.Ki = 0.2;
% mission.bhv{i}.pid.alt.Kd = 0.01;
% mission.bhv{i}.pid.alt.Ff = 0.4;


i = i + 1;
mission.bhv{i}.name = 'bhv_hover';
mission.bhv{i}.initialize.firstLoop = 1;
mission.bhv{i}.ahs.desiredAltMeters = .6;
mission.bhv{i}.ahs.desiredYawDegrees = 0;
mission.bhv{i}.completion.durationSec = 5;       % 60 seconds
mission.bhv{i}.completion.status = false;           % completion flag

i = i + 1;
mission.bhv{i}.name = 'bhv_hover';
mission.bhv{i}.initialize.firstLoop = 1;
mission.bhv{i}.ahs.desiredAltMeters = 1.25;
mission.bhv{i}.ahs.desiredYawDegrees = 0;
mission.bhv{i}.completion.durationSec = 5;       % 60 seconds
mission.bhv{i}.completion.status = false;           % completion flag

i = i + 1;
%Behavior 3: Land
mission.bhv{i}.name = 'bhv_land';
mission.bhv{i}.initialize.firstLoop = 1;
mission.bhv{i}.ahs.desiredAltMeters = 0; % default is zero
mission.bhv{i}.completion.altitudeIncrementMeters = 0.01;
mission.bhv{i}.completion.landingAltMeters = 0.20;
mission.bhv{i}.completion.threshold = 0.1;
mission.bhv{i}.completion.durationSec = 0.1;
mission.bhv{i}.completion.status = false;
end
