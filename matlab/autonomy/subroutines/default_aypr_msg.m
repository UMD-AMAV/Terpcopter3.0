function [ayprCmdMsg] = default_aypr_msg()
ayprCmdMsg = rosmessage('terpcopter_msgs/ayprCmd');
ayprCmdMsg.WaypointXDesiredMeters = 0;
ayprCmdMsg.WaypointXDesiredMeters = 0;
ayprCmdMsg.AltDesiredMeters = 0;
ayprCmdMsg.YawDesiredDegrees = 0;
ayprCmdMsg.PitchDesiredDegrees = 0;
ayprCmdMsg.RollDesiredDegrees = 0;
ayprCmdMsg.WaypointSwitch = 0;
ayprCmdMsg.AltSwitch = 0;
ayprCmdMsg.YawSwitch = 0;
ayprCmdMsg.PitchSwitch = 0;
ayprCmdMsg.RollSwitch = 0;

end