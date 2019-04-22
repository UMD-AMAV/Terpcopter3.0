function mission = loadMission_takeoffHoverOverHLand()
mission.config.firstLoop = 1;

mission.config.H_detector = 1;
mission.config.target_detector = 1;
mission.config.flowProbe = 0;

% for reference:
%
% ayprCmdMsg = rosmessage(ayprCmdPublisher);
% ayprCmdMsg.AltDesiredMeters = 0;
% ayprCmdMsg.YawDesiredDegrees = 0;
% ayprCmdMsg.PitchDesiredDegrees = 0;
% ayprCmdMsg.RollDesiredDegrees = 0;
% ayprCmdMsg.AltSwitch = 0;
% ayprCmdMsg.YawSwitch = 0;
% ayprCmdMsg.PitchSwitch = 0;
% ayprCmdMsg.RollSwitch = 0;

i = 1;
% Behavior 1: Takeoff
mission.bhv{i}.name = 'bhv_takeoff';
mission.bhv{i}.ayprCmd = default_aypr_msg();
mission.bhv{i}.ayprCmd.AltSwitch = 1; 
mission.bhv{i}.ayprCmd.AltDesiredMeters = 1; 
mission.bhv{i}.completion.status = false;

i = i + 1;
% Behavior 2: Hover
mission.bhv{i}.name = 'bhv_hover_over_H';
mission.bhv{i}.ayprCmd = default_aypr_msg();
mission.bhv{i}.ayprCmd.AltSwitch = 1; 
mission.bhv{i}.ayprCmd.AltDesiredMeters = 1; 
mission.bhv{i}.completion.durationSec = 1; % 1seconds
mission.bhv{i}.completion.status = false;     % completion flag

i = i + 1;
% Behavior 3: Land
mission.bhv{i}.name = 'bhv_land';
mission.bhv{i}.ayprCmd = default_aypr_msg();
mission.bhv{i}.ayprCmd.AltSwitch = 1; 
mission.bhv{i}.ayprCmd.AltDesiredMeters = 0.2; 
mission.bhv{i}.completion.durationSec = 10*60; % make this very long so vehicle hovers above ground before manual takeover
mission.bhv{i}.completion.status = false;     % completion flag

end