function [position, angle, t, Rmat, Quat] = get_PosAng(client)
% [position, angle, t, Rmat, Q] = frame_grab2(client)
% position: nx3 ( position [x,y,z] in (m) )
% angle: nx3 ( Euler 321 angles [phi,theta,psi] in (rad) )
% t
% Rmat: n-dimensional cell. Rmat{ii}= 3x3. 
%       rotation matrix I^R^B that converts body coords to inertial.
%       columns are Rmat= [b1,b2,b3] unit vectors that describe body frame.
% Quat: nx4 (quaternions [q0,qx,qy,qz])
%
% Daigo 3/11/2016
% daigo.shishika@gmail.com

frame = client.GetLastFrameOfData;
n = frame.nRigidBodies;

% Loop over bodies
x     = zeros(n,1);
y     = zeros(n,1);
z     = zeros(n,1);
phi   = zeros(n,1);
theta = zeros(n,1);
psi   = zeros(n,1);
Quat  = zeros(n,4);
Rmat  = cell(n,1);

for ii = 1:n
    % set mocap so right is X and back is Z. 
    % [ex,ey,ez]= [mx,-mz,my].
    % Here, we use -z in mocap for Y in world frame, 
    %          and  y in mocap for Z in world frame.
    x(ii) =  frame.RigidBodies(ii).x;
    y(ii) = -frame.RigidBodies(ii).z;
    z(ii) =  frame.RigidBodies(ii).y;
    % Quaternions
    q0 = frame.RigidBodies(ii).qw;
    qx =  frame.RigidBodies(ii).qx; 
    qy = -frame.RigidBodies(ii).qz; 
    qz =  frame.RigidBodies(ii).qy; 
    Q= [q0,qx,qy,qz];
    Quat(ii,:)= Q;
    
    % ** one of the following two steps can be omitted to enhance the speed
    % Convert to rotation matrix
    Rmat{ii} = Quat2Rmat(Q);
    % Convert to Euler-321 angles
    ang = Rmat2Euler(Rmat{ii},321);
    % ang is sometimes complex (might have some bug in Rmat2Euler)
    ang = real(ang);
    
    phi(ii)  = ang(1);
    theta(ii)= ang(2);
    psi(ii)  = ang(3);   
end

t = frame.fLatency;
position= [x,y,z];
angle   = [phi,theta,psi];
