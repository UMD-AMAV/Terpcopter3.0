function updatePaths()
%try 
%    cd  '/home/amav/amav/Terpcopter3.0/matlab'
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
addpath('./GUI')
addpath('./GUI/scripts')
addpath('./plots')
addpath('./plots/plotpidSetting')
addpath('./plots/plotpidSetting/subroutines')
addpath('./plots/plotStateEstimate')
addpath('./plots/plotStateEstimate/subroutines')
addpath('./plots/plotStickCmd')
addpath('./plots/plotStickCmd/subroutines')
savepath;
%savepath([params.env.matlabHome '/pathdef.m']);
end