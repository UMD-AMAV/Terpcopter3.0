function [udes,err_int] = myTrackingCtrl_wsc(xhat,xref,err_int,tnow,dt,paramQuad,paramControl)

%% Parameters

% Open up the quadrotor parameters (too many to open up one by one)
% v2struct(paramQuad)
mass = paramQuad.mass;
g = paramQuad.g;
u_max = paramQuad.u_max;
T_scale = paramQuad.T_scale;

% Pull the control gains
% k1 = paramControl.k1;
% k2 = paramControl.k2;
% k3 = paramControl.k3;

Kx = paramControl.Kx;
Kx = [Kx;Kx;Kx];
Kv = paramControl.Kv;
Kv = [Kv;Kv;Kv];

% Eb1d = [0;0;0]; % Desired direction of the body one axis in inertial frame

% ind_var     =  paramControl.ind_var;


%%%%%%%%%%%%%%%%%%%%%%% SOLVE FOR TRANSLATIONAL ERRORS %%%%%%%%%%%%%%%%%%

e_x = xhat(1:3) - xref(1:3);
e_v = xhat(4:6) - xref(4:6);

%%%%%%%%%%%%%%%%%%%%%%%%% SOLVE FOR DESIRED ROTATION %%%%%%%%%%%%%%%%%%%%%%
Ee3 = [0;0;1];
X_d_ddot = [0;0;0];
Eb3_in = (-Kx.*e_x - Kv.*e_v + mass*g*Ee3 + mass*X_d_ddot);
% fprintf('b3_in_ctrl = %2.3f, %2.3f, %2.3f\n', Eb3_in(1), Eb3_in(2), Eb3_in(3))
% Eb3_in roughly corresponds to [pitch; roll; thrust];
% We want to reverse that for our stick input

% K_thrust = norm(Eb3_in);
% theta_des = Eb3_in(1)/K_thrust;
% phi_des = Eb3_in(2)/K_thrust;
% udes= [K_thrust; phi_des; theta_des];
Eb3_in(1) = Eb3_in(1)/T_scale;
if max(abs(Eb3_in)) < u_max
    udes = [Eb3_in(3); -Eb3_in(2); Eb3_in(1)]/u_max;
else
    udes = [Eb3_in(3); -Eb3_in(2); Eb3_in(1)]/max(abs(Eb3_in));
end

err_int = 0; %set to zero for now

%% For reference tracking
% % Use LQR + Integral for position
% err_xdx= xhat - xref;
% if tnow > 2
%     err_int= err_int + dt*err_xdx(ind_var);
% end
% % LQR + Integral
% udes= -K_lqr*err_xdx -K_int*err_int;