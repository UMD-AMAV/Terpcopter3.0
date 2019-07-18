function [position, angle, t, Rmat, Quat] = get_PosAngDummy_data(pos_data,ang_data,t_data,tt)

Np= numel(pos_data(1,:))/3;

if tt > numel(t_data)
    tt= numel(t_data);
end

pos_tt = pos_data(tt,:);
ang_tt = ang_data(tt,:);
t = t_data(tt);

% in PosAng2 style
position= reshape(pos_tt,3,Np);
angle= reshape(ang_tt,3,Np);

% % in PosAng1 style
% position= reshape(pos_tt,3,Np)';
% angle= reshape(ang_tt,3,Np)';

Rmat= {eye(3), eye(3)};
Quat= [0 1 0 0; 0 1 0 0];
