function mission = loadMission_PitchRollTestJerrar()
mission.config.firstLoop = 1;

mission.config.H_detector = 0;
mission.config.target_detector = 0;
mission.config.flowProbe = 0;

i = 1;
% Behavior 3: Hover with a Fixed Orientation
mission.bhv{i}.name = 'bhv_fly_forward';
mission.bhv{i}.ayprCmd = default_aypr_msg();
mission.bhv{i}.ayprCmd.AltSwitch = 0; 
mission.bhv{i}.ayprCmd.AltDesiredMeters = 1; 
% mission.bhv{i}.ayprCmd.YawSwitch = 1; 
% mission.bhv{i}.ayprCmd.YawDesiredDegrees = 0; 
% % roll and pitch are actively controlled but we initialize values here
mission.bhv{i}.ayprCmd.RollSwitch = 1; 
mission.bhv{i}.ayprCmd.RollDesiredDegrees = 0.2; 
mission.bhv{i}.ayprCmd.PitchSwitch = 1; 
mission.bhv{i}.ayprCmd.PitchDesiredDegrees = 0.2; 
mission.bhv{i}.completion.durationSec = 60*10; % 10 seconds
mission.bhv{i}.completion.status = false;     % completion flag

end