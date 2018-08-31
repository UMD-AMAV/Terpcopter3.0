function R = rotationMatrixYPR(psi,theta,phi)
% Description: 
%   Computes the 3x3 rotation matrix to convert vectors, with
%   R defined by the "3-2-1" rotation sequence, 
%
%   Note: angle directions defined by the right hand rule.
%       - first rotation around axis 3 (z, yaw)
%       - second rotation around axis 2 (y, pitch)
%       - third rotation around axis 1 (x, roll)
%       - i.e., R = R3(roll)*R2(pitch)*R3(yaw)
%
% Inputs
%   psi : yaw angle around z axis (rad)
%   theta : pitch angle around y axis (rad)
%   phi : roll angle aroud x axis (rad)
%   
% Outputs : 
%   R : 3x3 rotation matrix 

% Note the transpose at the end:
R =  [cos(theta)*cos(psi) sin(phi)*sin(theta)*cos(psi) - cos(phi)*sin(psi) cos(phi)*sin(theta)*cos(psi)+sin(phi)*sin(psi);
     cos(theta)*sin(psi) sin(phi)*sin(theta)*sin(psi)+cos(phi)*cos(psi)   cos(phi)*sin(theta)*sin(psi)-sin(phi)*cos(psi);
     -sin(theta)                          sin(phi)*cos(theta)                           cos(phi)*cos(theta)]';


end