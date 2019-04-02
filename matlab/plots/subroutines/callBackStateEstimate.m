function callBackStateEstimate(subscriber,stateEstimateMsg)

global directory
global date

pRange = stateEstimateMsg.Range;
pTime = stateEstimateMsg.Time;
pNorth = stateEstimateMsg.North;
pEast = stateEstimateMsg.East;
pUp = stateEstimateMsg.Up;
pYaw = stateEstimateMsg.Yaw;
pPitch = stateEstimateMsg.Pitch;
pRoll = stateEstimateMsg.Roll;

data = [pRange pTime pNorth pEast pUp pYaw pPitch pRoll];

fname = sprintf('plotStateEstimate_%s.csv',date);
fileDest  = fullfile(directory,fname);
fid=fopen(fileDest,'a');

fprintf(fid,'%6.6f,%6.6f,%6.6f,%6.6f,%6.6f,%6.6f, %6.6f,%6.6f\n',data(1),data(2),data(3),data(4), data(5), data(6), data(7), data(8));
pause(0.1);

fclose(fid);
end