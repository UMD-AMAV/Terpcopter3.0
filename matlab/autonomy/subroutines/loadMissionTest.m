function mission = loadMissionTest()
mission.config.firstLoop = 1;

i = 1;
mission.bhv{i}.name = 'bhv_hover';
mission.bhv{i}.initialize.firstLoop = 1;
mission.bhv{i}.ahs.desiredAltMeters = 1;
mission.bhv{i}.completion.durationSec = 5;       % 60 seconds
mission.bhv{i}.completion.status = false;           % completion flag

i = i + 1;
%Behavior 3: Land
mission.bhv{i}.name = 'bhv_land';
mission.bhv{i}.initialize.firstLoop = 1;
mission.bhv{i}.ahs.desiredAltMeters = 0; % default is zero
mission.bhv{i}.completion.altitudeIncrementMeters = 0.1;
mission.bhv{i}.completion.landingAltMeters = 0.20;
mission.bhv{i}.completion.threshold = 0.1;
mission.bhv{i}.completion.durationSec = 5;
mission.bhv{i}.completion.status = false;

end