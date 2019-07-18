function  [zhat,Uhat] = myObserverAng(zhat_,euler321,u_des,u_stick,dt,paramC)
%
% This observer does not have a persistent variable, which means that this
% function can be used for multiple agents.

g= 9.81;
A       = paramC.A;
B       = paramC.B;
C       = paramC.C;
L       = paramC.L_obsAngle;

% command
Uhat= [0;0;0];

% use continuous filter with Euler 1st order
angles= euler321(:);
if nnz(angles)==3 %&& nnz(ind_missing)==0
    % measurements are complete
    dx    = A*zhat_ + B*Uhat + L*(angles-C*zhat_);
    zhat  = zhat_ + dt*dx;
else
    % some states are missing
    dx    = A*zhat_ + B*Uhat; % no Innovation term
    zhat  = zhat_ + dt*dx;
end


