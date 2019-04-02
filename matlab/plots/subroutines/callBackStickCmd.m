function callBackStickCmd(subscriber,stickCmdMsg)

global directory
global date

pthrust = stickCmdMsg.Thrust;
pyaw = stickCmdMsg.Yaw;
ppitch = stickCmdMsg.Pitch;
proll = stickCmdMsg.Roll;

ptime = 0; 

data = [pthrust pyaw ppitch proll ptime];

fname = sprintf('plotStickCmd_%s.csv', date);
fileDest  = fullfile(directory,fname);
fid=fopen(fileDest,'a');
fprintf(fid,'%6.6f,%6.6f,%6.6f,%6.6f,%6.6f\n',data(1),data(2),data(3),data(4),data(5));
pause(0.1);

fclose(fid);
end