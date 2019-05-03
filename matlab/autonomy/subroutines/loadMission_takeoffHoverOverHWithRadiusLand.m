function mission = loadMission_takeoffHoverOverHWithRadiusLand()
mission.config.firstLoop = 1;

mission.config.H_detector = 1;
mission.config.target_detector = 0;
mission.config.flowProbe = 0;

% for reference:
%
% ayprCmdMsg = rosmessage(ayprCmdPublisher);
% ayprCmdMsg.AltDesiredMeters = 0;
% ayprCmdMsg.YawDesiredDeg = 0;
% ayprCmdMsg.PitchDesiredDeg = 0;
% ayprCmdMsg.RollDesiredDeg = 0;
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
mission.bhv{i}.name = 'bhv_hover';
mission.bhv{i}.ayprCmd = default_aypr_msg();
mission.bhv{i}.ayprCmd.AltSwitch = 1; 
mission.bhv{i}.ayprCmd.AltDesiredMeters = 1; 
mission.bhv{i}.completion.durationSec = 1; % 1seconds
mission.bhv{i}.completion.status = false;     % completion flag

i = i + 1;
% Behavior 3: Hover over the H
mission.bhv{i}.name = 'bhv_hover_over_H';
mission.bhv{i}.ayprCmd = default_aypr_msg();
mission.bhv{i}.ayprCmd.AltSwitch = 1; 
mission.bhv{i}.ayprCmd.AltDesiredMeters = 1; 
% mission.bhv{i}.ayprCmd.YawSwitch = 1; 
% mission.bhv{i}.ayprCmd.YawDesiredDegrees = 0; 
% % roll and pitch are actively controlled but we initialize values here
mission.bhv{i}.ayprCmd.RollSwitch = 1; 
mission.bhv{i}.ayprCmd.RollDesiredDegrees = 0; 
mission.bhv{i}.ayprCmd.PitchSwitch = 1; 
mission.bhv{i}.ayprCmd.PitchDesiredDegrees = 0; 
mission.bhv{i}.completion.durationSec = 10; % 10 seconds
mission.bhv{i}.completion.acceptableRadiusPixels = 70;
mission.bhv{i}.completion.status = false;     % completion flag

i = i + 1;
% Behavior 4: Land
mission.bhv{i}.name = 'bhv_land';
mission.bhv{i}.ayprCmd = default_aypr_msg();
mission.bhv{i}.ayprCmd.AltSwitch = 1; 
mission.bhv{i}.ayprCmd.AltDesiredMeters = 0.2; 
mission.bhv{i}.completion.durationSec = 10*60; % make this very long so vehicle hovers above ground before manual takeover
mission.bhv{i}.completion.status = false;     % completion flag

end