function [xk_k, Pk_k, K, xk_km1, Pk_km1] = discreteKalmanFilter(xkm1_km1, ukm1, Pkm1_km1, yk, F, G, H, Q, R)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Artur Wolek                                  Last Modified: 13-March-2018           
%
% Description: discreteKalmanFilter.m
%   Perform one iteration of the discrete time Kalman filter
%
%  Consider the discrete time system given by:	
%  		x(k+1) 	= F(k)x(k) + G(k)u(k) + w(k)		(motion model)
%  		y(k)   	= H(k)x(k) + v(k)		        (measurement model)
%  		w(k) 	~ (0, Q(k))  				(zero mean process noise)
% 		v(k) 	~ (0, R(k))				(zero mean measurement noise)
% 
%  Note:  it is assumed that the noise terms (w, and v) enter linearly into
%  		  the system 
%
% Inputs:       xkm1_km1    : estimate of x at time-step (k-1) given data
%                             at (k-1) (i.e., prior)
%               ukm1        : control applied at time-step (k-1)
%               Pkm1_km1    : covariance of state x at time-step (k-1)
%                             given data at (k-1)
%               ykp1        : measurement at time-step (k)
%
%               F           : F state-transition matrix
%               G           : G control input matrix
%               Q           : process noise covariance matrix
%
%               H           : H deterministic measurement model
%               R           : measurement noise covariance matrix
%
% Outputs:      xk_k        : estimate of x at time-step (k) given data at 
%                             (k) (i.e., posterior)
%               Pk_k        : covariance of state x at time-step (k) given 
%                             data at (k)
%               xk_km1      : estimate of x at time-step (k) given data
%                             at (k-1) (i.e., posterior)
%               Pk_km1      : covariance of state x at time-step (k) given 
%                             data at (k-1)
%
% Ref. 
% 1. https://en.wikipedia.org/wiki/Kalman_filter
% 2. "Optimal State Estimation" Dan Simon (Cleveland State University)
%    John Wiley & Sons, Inc. Hoboken, New Jersey, 2006.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize
n = size(xkm1_km1,1); % state vector size

% compute time update 
xk_km1 = F*xkm1_km1 + G*ukm1; % predicted state 
yk_km1 = H*xk_km1; % predicted measurement
Pk_km1 = F*Pkm1_km1*F' + Q; % predicted covariance

% compute measurement update
S = H*Pk_km1*H' + R; % innovation
K = Pk_km1*H'/S; % Kalman gain 
xk_k = xk_km1  + K*(yk - yk_km1); % posterior state stimation
%Pk_k = (eye(n,n)-K*H)*P_prior*(eye(n,n)-K*H)' + K*R*K'; % Joseph stabilized version
Pk_k = (eye(n,n)-K*H)*Pk_km1; % posterior covariance

end
