function save_workspace(folder, header,dummy)
%  save_workspace(folder, header,dummy)

if nargin < 3
    % ask if one wants to save
    choice = menu('save workspace?','Yes','No');
    if choice==2 || choice==0
        return
    end
end

% make folder if nonexistent
if exist(folder,'dir')==0
    mkdir(folder)
    % create dummy file
    new_file_name= [folder,'/',header,num2str(0),'.mat'];
    save(new_file_name)
end

% list of files
files= dir(folder);
n_data= numel(files);
n_head= numel(header);

% find largest number
t_max= 0;
for ii= 1:n_data
    filename= files(ii).name;
    % if header matches and controller matches
    if numel(filename)>n_head && strcmp(filename(1:n_head),header) 
        k1= n_head+1;  % start of trial number
        k2= strfind(filename,'.mat') -1; % end of trial number
        n_trial= str2double(filename(k1:k2));
        t_max= max(t_max,n_trial);
    end
end

% save new file
new_file_name= [folder,'/',header,num2str(t_max+1),'.mat'];
% save(new_file_name)
close all
evalin('base', sprintf('save(''%s'')',new_file_name));
fprintf('\n Saved %s\n\n',new_file_name)