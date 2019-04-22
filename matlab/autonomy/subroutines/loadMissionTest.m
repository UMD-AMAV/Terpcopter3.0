function mission = loadMissionTest()
mission.config.firstLoop = 1;

mission.config.H_detector = 0;
mission.config.target_detector = 0;
mission.config.flowProbe = 0;

i = 1;
mission.bhv{i}.name = 'bhv_hover';
mission.bhv{i}.initialize.firstLoop = 1;
mission.bhv{i}.ahs.desiredAltMeters = 1;
mission.bhv{i}.ahs.desiredYawDegrees = 0;
mission.bhv{i}.completion.durationSec = 5;       % 60 seconds
mission.bhv{i}.completion.status = false;           % completion flag
mission.bhv{i}.pid.alt.Kp = 0.1;
mission.bhv{i}.pid.alt.Ki = 0.2;
mission.bhv{i}.pid.alt.Kd = 0.01;
mission.bhv{i}.pid.alt.Ff = 0.4;

i = i + 1;

% Behavior 3: Point to Direction 
mission.bhv{i}.name = 'bhv_point_to_direction';
mission.bhv{i}.initialize.firstLoop = 1;
mission.bhv{i}.ahs.desiredAltMeters = 1;
mission.bhv{i}.ahs.desiredYawDegrees = 30;
mission.bhv{i}.completion.status = false; 
mission.bhv{i}.completion.durationSec = 5; 

i = i + 1;

% Behavior 3: Point to Direction 
mission.bhv{i}.name = 'bhv_point_to_direction';
mission.bhv{i}.initialize.firstLoop = 1;
mission.bhv{i}.ahs.desiredAltMeters = 1;
mission.bhv{i}.ahs.desiredYawDegrees = 60;
mission.bhv{i}.completion.status = false; 
mission.bhv{i}.completion.durationSec = 5; 

i = i + 1;

% Behavior 3: Point to Direction 
mission.bhv{i}.name = 'bhv_point_to_direction';
mission.bhv{i}.initialize.firstLoop = 1;
mission.bhv{i}.ahs.desiredAltMeters = 1;
mission.bhv{i}.ahs.desiredYawDegrees = 30;
mission.bhv{i}.completion.status = false; 
mission.bhv{i}.completion.durationSec = 5; 

i = i + 1;

% Behavior 3: Point to Direction 
mission.bhv{i}.name = 'bhv_point_to_direction';
mission.bhv{i}.initialize.firstLoop = 1;
mission.bhv{i}.ahs.desiredAltMeters = 1;
mission.bhv{i}.ahs.desiredYawDegrees = 0;
mission.bhv{i}.completion.status = false; 
mission.bhv{i}.completion.durationSec = 5; 

i = i + 1;

% Behavior 3: Point to Direction 
mission.bhv{i}.name = 'bhv_point_to_direction';
mission.bhv{i}.initialize.firstLoop = 1;
mission.bhv{i}.ahs.desiredAltMeters = 1;
mission.bhv{i}.ahs.desiredYawDegrees = -30;
mission.bhv{i}.completion.status = false; 
mission.bhv{i}.completion.durationSec = 5; 

i = i + 1;

% Behavior 3: Point to Direction 
mission.bhv{i}.name = 'bhv_point_to_direction';
mission.bhv{i}.initialize.firstLoop = 1;
mission.bhv{i}.ahs.desiredAltMeters = 1;
mission.bhv{i}.ahs.desiredYawDegrees = -60;
mission.bhv{i}.completion.status = false; 
mission.bhv{i}.completion.durationSec = 5; 

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