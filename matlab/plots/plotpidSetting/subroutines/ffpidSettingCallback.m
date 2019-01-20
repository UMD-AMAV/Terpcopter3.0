function ffpidSettingCallback(src,msg)
global controlParams
global ffpidSettingMsg;
ffpidSettingMsg = msg;
controlParams.altitudeGains.kp = ffpidSettingMsg.Kp;
controlParams.altitudeGains.ki = ffpidSettingMsg.Ki;
controlParams.altitudeGains.kd = ffpidSettingMsg.Kd;
controlParams.altitudeGains.ffterm = ffpidSettingMsg.Ff;
end