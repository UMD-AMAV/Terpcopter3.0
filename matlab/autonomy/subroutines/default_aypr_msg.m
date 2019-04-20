function [ayprCmdMsg] = default_aypr_msg(ayprCmdPublisher)
ayprCmdMsg = rosmessage(ayprCmdPublisher);
ayprCmdMsg.AltDesiredMeters = 0;
ayprCmdMsg.YawDesiredDeg = 0;
ayprCmdMsg.PitchDesiredDeg = 0;
ayprCmdMsg.RollDesiredDeg = 0;
ayprCmdMsg.AltSwitch = 0;
ayprCmdMsg.YawSwitch = 0;
ayprCmdMsg.PitchSwitch = 0;
ayprCmdMsg.RollSwitch = 0;

end