function  [xhat,zhat] = myObserverAll_wsc(xhat_,zhat_,pos,ang,dt,paramObs,R_B,Thrust,paramQuad,linear,T_scale)
% Estimates the states of all agents.
% ** The yaw rate psi_dot (i.e., zhat(6)) blows up when psi crosses over
% pi. This has part has to be rewritten.**
%
% Gain matrices and A~C matrices do NOT have to be block diagonilized;
% i.e., estimation for single agent is repeated N times.
% (This observer does not have a persistent variable, which means that this
%  function can be used for multiple agents.)

A        = paramObs.A;
C        = paramObs.C;
L1       = paramObs.L_observer;
L2       = paramObs.L_obsAngle;
mass     = paramQuad.mass;
g        = paramQuad.g;

N        = numel(xhat_)/6; % number of agents

%% Continous Luenburger with Euler 1st order
% Ignoring the input (since it's not exactly known)
ang = ang(:);
pos = pos(:);
xhat = zeros(N*6,1);
zhat = zeros(N*6,1);
% Loop over N agents
for ii= 1:N
    ind1= [1:3]+(ii-1)*3;
    ind2= [1:6]+(ii-1)*6;
    % Angle
    angles     = ang(ind1);
    zprev      = zhat_(ind2);
    dz         = A*zprev + L2*(angles-C*zprev);
    zhat(ind2) = zprev + dt*dz;
    
    % Position
    position   = pos(ind1);
    xprev      = xhat_(ind2);
%     dx         = A*xprev + L1*(position-C*xprev);
%     if linear
%         dx     = A*xprev + [0;0;0;(1/mass*((-mass*g + Thrust)*[0;0;1]))]...
%                          + L1*(position-C*xprev);
% %                      disp(Thrust*R_B*[0;0;1])
%     else
        dx     = A*xprev + [0;0;0;(1/mass*(-mass*g*[0;0;1]...
                    + Thrust*R_B*[0;0;1].*[1/T_scale; 1/T_scale; 1]))]...
                    + L1*(position-C*xprev);
%     end
    xhat(ind2) = xprev + dt*dx;
end

