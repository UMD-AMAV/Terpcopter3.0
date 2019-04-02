function callBackAhsCmd(subscriber,ahsCmdMsg)

global directory
global date

pAltitudeMeters = ahsCmdMsg.AltitudeMeters;
pForwardSpeedMps = ahsCmdMsg.ForwardSpeedMps;
pCrabSpeedMps = ahsCmdMsg.CrabSpeedMps;
pHeadingRad = ahsCmdMsg.HeadingRad; 

pTime = 0;

data = [pAltitudeMeters pForwardSpeedMps pCrabSpeedMps pHeadingRad pTime];

fname = sprintf('plotahsCmd_%s.csv', date);
fileDest  = fullfile(directory,fname);
fid=fopen(fileDest,'a');
fprintf(fid,'%6.6f,%6.6f,%6.6f,%6.6f,%6.6f\n',data(1),data(2),data(3),data(4),data(5));
pause(0.1);

fclose(fid);
end