function disp_dependency(filename,n_ignore)
% DISP_DEPENDENCY(filename,num_ignore)
% Displays all the functions that 'filename' uses.
% Omits the first N characters specified by 'num_ignore'. (Default is 0)

if nargin<2
    n_ignore=1;
end

% check if 'filename' exists
if exist(filename)==0
    disp('The file name')
    disp(filename)
    disp('does not exist.')
else
    
    fprintf('\n List of functions used by %s \n\n',filename)
    files = matlab.codetools.requiredFilesAndProducts(filename);
    for ii= 1:numel(files)
        str = files{ii};
        disp(['...',str(n_ignore:end)])
    end
    fprintf('\n')
    
end