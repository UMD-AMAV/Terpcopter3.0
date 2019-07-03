function  [xhat,Uhat,dpsihat] = myObserver(pos,euler321,u_stick,dt,paramC)

g= 9.81;
A       = paramC.A;
B       = paramC.B;
C       = paramC.C;
L       = paramC.L_observer;
delTstar= paramC.delTstar;

% sin and cos in 3-2-1 order
c= cos(euler321([3,2,1]));  % psi, theta, phi
s= sin(euler321([3,2,1]));  % psi, theta, phi

persistent xhat_

if isempty(xhat_)
    % initialize with measured states
    xhat_= [pos';0;0;0];
end

% xyz acceleration depends on thrust and attitude
etaT= u_stick(1);
T_hat= (etaT+1)/(2*delTstar)*g;
Uhat= [ T_hat*( s(1)*s(3) + c(1)*c(3)*s(2) );
        T_hat*( c(3)*s(1)*s(2) - c(1)*s(3) );
          -g + T_hat*c(2)*c(3)             ];

% U_observer(ii,:)= U';
Uhat=Uhat*0;

% use continuous filter with Euler 1st order
position= pos(:);
if nnz(position)==3 %&& nnz(ind_missing)==0
    % measurements are complete
    dx    = A*xhat_ + B*Uhat + L*(position-C*xhat_);
    xhat  = xhat_ + dt*dx;
else
    % some states are missing
    dx    = A*xhat_ + B*Uhat; % no Innovation term
    xhat  = xhat_ + dt*dx;
end

% for next time step
xhat_ = xhat;

%_yaw motion_________________________%
persistent psi_prev dpsi_prev
if isempty(psi_prev)
    psi_prev=0;
    dpsi_prev= 0;
end
% 2point differentiation
psi= euler321(3);
dpsi= (psi-psi_prev)/dt;
% low-pass filter
aLP= 0.8;
dpsihat= aLP*dpsi_prev + (1-aLP)*dpsi;

