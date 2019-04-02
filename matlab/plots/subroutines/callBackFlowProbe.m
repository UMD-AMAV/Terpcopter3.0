function  callBackFlowProbe(subscriber,flowProbeMsg)

global directory
global date

pvelocity = flowProbeMsg.Data; 
ptime = 0;

data = [pvelocity ptime];

fname = sprintf('plotflowProbe_%s.csv', date);
fileDest  = fullfile(directory,fname);
fid=fopen(fileDest,'a');
fprintf(fid,'%6.6f,%6.6f\n',data(1),data(2));
pause(0.1);

fclose(fid);

end