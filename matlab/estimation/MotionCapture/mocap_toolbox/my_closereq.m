function my_closereq(src,callbackdata)
% Close request function 
% to display a question dialog box 
%    selection = questdlg('Close This Figure?',...
%       'Close Request Function',...
%       'Yes','No','Yes'); 
%    switch selection, 
%       case 'Yes',
%          delete(gcf)
%       case 'No'
%       return 
%    end

% Serial communication
sii = instrfind;
if isempty(sii)==0
fclose(sii);
delete(sii);
end

% Motion Capture Interface
if exist('client')
    client.Uninitialize();
    delete(client);
    disp('mocap client uninitialized!')
end

delete(gcf)

