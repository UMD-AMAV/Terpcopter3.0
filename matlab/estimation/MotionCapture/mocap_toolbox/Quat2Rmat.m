function Rmat= Quat2Rmat(Q)
% Rmat = Quat2Rmat(Q)
% converts quaternians to rotation matrix
% Rmat: rotation matrix I^R^B that converts body coord. to inertail.
%       columns are Rmat= [b1,b2,b3] unit vectors that describe body frame.
% Q= [q0,qx,qy,qz]

% convert to column vector
Q= Q(:);

% normalize
magnitude= sqrt(Q'*Q);
q0 = Q(1)/magnitude;
qx = Q(2)/magnitude;
qy = Q(3)/magnitude;
qz = Q(4)/magnitude;

% rotation matrix
Rmat(1,1)  = q0*q0  +  qx*qx  -  qy*qy  -  qz*qz;
Rmat(1,2)  = 2 * (qx*qy  -  q0*qz);
Rmat(1,3)  = 2 * (qx*qz  +  q0*qy);

Rmat(2,1)  = 2 * (qx*qy  +  q0*qz);
Rmat(2,2)  = q0*q0  -  qx*qx  +  qy*qy  -  qz*qz;
Rmat(2,3)  = 2 * (qy*qz  -  q0*qx);

Rmat(3,1)  = 2 * (qx*qz  -  q0*qy);
Rmat(3,2)  = 2 * (qy*qz  +  q0*qx);
Rmat(3,3)  = q0*q0  -  qx*qx  -  qy*qy  +  qz*qz;


