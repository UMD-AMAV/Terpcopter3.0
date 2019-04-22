function mission = loadMissionAltWithOpenPitch()
% This mission is for testing the takeoff and hover over the H using altitude mode
mission.config.firstLoop = 1;

i = 1;
mission.bhv{i}.name = 'bhv_hover';
mission.bhv{i}.ahs.desiredAltMeters = 1.25;
mission.bhv{i}.ahs.desiredYawDegrees = 0;
mission.bhv{i}.completion.durationSec = 1.5;       
mission.bhv{i}.completion.status = false;           % completion flag

i = i + 1;
mission.bhv{i}.name = 'bhv_pitch_open';
mission.bhv{i}.ahs.desiredYawDegrees = 0;
mission.bhv{i}.completion.durationSec = 1;       % 60 seconds
mission.bhv{i}.completion.status = false;           % completion flag

i = i + 1
mission.bhv{i}.name = 'bhv_land_open';
mission.bhv{i}.ahs.desiredAltMeters = 0.4;
mission.bhv{i}.completion.status = false;
end