function mission = loadMission()
mission.config.firstLoop = 1;

i = 1;

% Behavior 1: Takeoff
mission.bhv{i}.name = 'bhv_takeoff';
mission.bhv{i}.ahs.desiredAltMeters = 0.5;    %
% mission.bhv{i}.ahs.forwardSpeed = 0;
% mission.bhv{i}.ahs.crabSpeed = 0;
mission.bhv{i}.completion.status = false;

i = i + 1;

% Behavior 2: Hover in Place
mission.bhv{i}.name = 'bhv_hover';
mission.bhv{i}.ahs.desiredAltMeters = 1;
mission.bhv{i}.completion.durationSec = 9.95; % 10 seconds
mission.bhv{i}.completion.status = false;     % completion flag

i = i + 1;

% Behavior 3: Point to Direction 
mission.bhv{i}.name = 'bhv_point_to_direction';
mission.bhv{i}.ahs.desiredAltMeters = 1;
mission.bhv{i}.ahs.desiredYawDegrees = 0;
mission.bhv{i}.completion.status = false;     

i = i + 1;

% Behavior 4: Land
mission.bhv{i}.name = 'bhv_land';
%mission.bhv{i}.params.maxDescentRateMps = 0.2;
mission.bhv{i}.ahs.desiredAltMeters = 0.20; % .25 previously shub
mission.bhv{i}.completion.threshold = 0.1;
mission.bhv{i}.completion.status = false;

end