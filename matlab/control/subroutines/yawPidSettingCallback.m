function yawPidSettingCallback(src,msg)
global controlParams
global yawPidSettingMsg;
yawPidSettingMsg = msg;
controlParams.yawGains.kp = yawPidSettingMsg.Kp;
controlParams.yawGains.ki = yawPidSettingMsg.Ki;
controlParams.yawGains.kd = yawPidSettingMsg.Kd;
end