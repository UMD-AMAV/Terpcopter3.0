function updatePaths()
params = loadParams();
addpath(params.env.terpcopterMatlabMsgs);
addpath('./control')
addpath('./control/subroutines')
addpath('./estimation')
addpath('./estimation/subroutines')
addpath('./autonomy')
addpath('./autonomy/subroutines')
addpath('./virtual_transmitter')
addpath('./virtual_transmitter/subroutines')
addpath('./vision')
addpath('./vision/subroutines')
addpath('./utils')
addpath('./utils/geometry')
savepath;
%savepath([params.env.matlabHome '/pathdef.m']);
end