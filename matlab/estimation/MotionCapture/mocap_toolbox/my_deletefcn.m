function my_deletefcn(src,callbackdata)

% Motion capture interface
client.Uninitialize(); 
clear('client');

% Serial communication
sii = instrfind;
if isempty(sii)==0
    fclose(sii);
    delete(sii);
end