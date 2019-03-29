function stickCmdCallback(src,msg)
global stickCmdMsg;
global lastStickCmd_time;
stickCmdMsg = msg;
lastStickCmd_time = rostime('now');
end
