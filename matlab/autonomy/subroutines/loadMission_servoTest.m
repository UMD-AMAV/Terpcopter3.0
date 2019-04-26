function mission = loadMission_servoTest()
mission.config.firstLoop = 1;

mission.config.H_detector = 0;
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
mission.bhv{i}.name = 'bhv_hover_drop';
mission.bhv{i}.ayprCmd = default_aypr_msg();
mission.bhv{i}.completion.durationSec = 3;
mission.bhv{i}.completion.status = false;   

end