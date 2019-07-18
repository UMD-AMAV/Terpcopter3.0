function [udes,err_int,e_x_prev,e_x,e_x_std,e_z_int_prev] = myTrackingCtrl_wsc_linear(xhat,xref,err_int,tnow,dt,...
                                    paramQuad,paramControl,paramLinear,k_ramp,e_x_prev,e_z_int_prev)

%% Parameters

% Open up the quadrotor parameters (too many to open up one by one)
% v2struct(paramQuad)
mass = paramQuad.mass;
g = paramQuad.g;
u_max = paramQuad.u_max;
T_scale = paramQuad.T_scale;

Z_th0 = paramLinear.Z_th0;
Z_w   = paramLinear.Z_w;

% Pull the control gains
% k1 = paramControl.k1;
% k2 = paramControl.k2;
% k3 = paramControl.k3;

Kx = paramControl.Kx(:);
Kv = paramControl.Kv(:);
K_zi = paramControl.K_zi;

% Eb1d = [0;0;0]; % Desired direction of the body one axis in inertial frame

% ind_var     =  paramControl.ind_var;


%%%%%%%%%%%%%%%%%%%%%%% SOLVE FOR TRANSLATIONAL ERRORS %%%%%%%%%%%%%%%%%%
% k_ramp = 0.8;
% s = tf([1 0],1);
xref(4:6) = (1./k_ramp).*min(k_ramp.*[10;10;10],...
                        max(-k_ramp.*[10;10;10],-(xhat(1:3) - xref(1:3))));
        
e_v = xhat(4:6) - xref(4:6); %xhat(4:6) - (-e_x); %
% disp(e_v')
e_x = e_x_prev + e_v*dt; %xhat(1:3) - xref(1:3);
e_x_std = (xhat(1:3) - xref(1:3))/3;
e_x_std(3) = (xhat(3) - xref(3));
% fprintf('z error is %1.4f\n',e_x(3))
e_x_prev = e_x;

e_z_int = e_z_int_prev + e_x_std(3)*dt;

e_z_int_prev = e_z_int;
% pre_int_e_x = xref(1:3) - xhat(1:3);
% tha_d_1 = (-Kx.*e_x - Kv.*e_v);
% fprintf('e_x is %1.4f, %1.4f, %1.4f\ntha_d_1 is %1.4f, %1.4f, %1.4f \n',...
%     pre_int_e_x(1), pre_int_e_x(2), pre_int_e_x(3), tha_d_1(1), tha_d_1(2), tha_d_1(3))

%%%%%%%%%%%%%%%%%%%%%%%%% SOLVE FOR DESIRED ROTATION %%%%%%%%%%%%%%%%%%%%%%
position_in = (1/g)*(-Kx.*e_x_std - Kv.*e_v);
position_in(3) = ((1/Z_th0)*(g*position_in(3) - K_zi*e_z_int - mass*Z_w*xhat(6)) + mass*g)/T_scale;
% disp(position_in')
if max(abs(position_in(1:3))) < u_max
    udes = [position_in(3); -position_in(2); position_in(1)]/u_max;
else
    max(abs(position_in));
    udes = [position_in(3); -position_in(2); position_in(1)]/max(abs(position_in));
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