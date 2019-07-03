function [position, angle, t, Rmat, Quat, IDs] = get_PosAng_ID_wsc(client)
% [position, angle, t, Rmat, Q, IDs] = get_PosAng2(client)
%  
% =========================================================================
% This is for multivehicle experiments.
% Rigid bodies are reorder according to the "Rigid Body ID" defined in
% Motive. (See 'Rigid Bodies' pane in Motive. The ID defined in Motive
% should match the vehicle number written on the propeller. This is
% necessary since the order that the vehicles appear in the signal from
% Motive is determined by the time the body is defined, but not the ID. So,
% when a vehicle with, say ID=1, is redefined, and there are N vehicles, it 
% is pushed all the way back to the last (Nth entry) in frame.nRigidBodies.
% ) In the output 'position' and 'angle', the data of vehicle with ID=i
% appears in the i-th column.
% =========================================================================
% 
% * data is a transpose from the original get_PosAng.
% position: 3xn ( position [x';y';z'] in (m) )
% angle: nx3 ( Euler 321 angles [phi,theta,psi] in (rad) )
% t
% Rmat: n-dimensional cell. Rmat{ii}= 3x3. 
%       rotation matrix I^R^B that converts body coords to inertial.
%       columns are Rmat= [b1,b2,b3] unit vectors that describe body frame.
% Quat: nx4 (quaternions [q0,qx,qy,qz])
%
% *missing measurement is set to 0.
%
% daigo.shishika@gmail.com

frame = client.GetLastFrameOfData;
n     = frame.nRigidBodies;

assignin('base','frame',frame)

% Loop over bodies
IDs   = zeros(n,1);
x     = zeros(n,1);
y     = zeros(n,1);
z     = zeros(n,1);
phi   = zeros(n,1);
theta = zeros(n,1);
psi   = zeros(n,1);
Quat  = zeros(n,4);
Rmat  = cell(n,1);

for ii = 1:n
    % Set ground plane in mocap so that (looking into the mocap area from 
    % the desk) X is to the right and Z is towards the desk. 
    %
    % Our inertial frame     mocap frame
    %     [ex,ey,ez]     =  [-mz,-mx,my]
    %
    % i.e, we use -z in mocap for X in world frame (towards the back screen),
    %         and -x in mocap for Y in world frame (towards the shelving on
    %         the left),
    %         and  y in mocap for Z in world frame (towards the ceiling).
    x(ii)  = - frame.RigidBodies(ii).z;
    y(ii)  = - frame.RigidBodies(ii).x; % negative sign
    z(ii)  =   frame.RigidBodies(ii).y;
    IDs(ii)=   frame.RigidBodies(ii).ID;
    
    % Quaternions
    q0 = frame.RigidBodies(ii).qw;
    qx =  frame.RigidBodies(ii).qx; 
    qy = -frame.RigidBodies(ii).qz; 
    qz =  frame.RigidBodies(ii).qy; 
    Q= [q0,qx,qy,qz];
    Q=Q/norm(Q);
    Quat(ii,:)= Q;
    
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

%% Reorder
t = frame.fTimestamp;
nmax = max(IDs);
position = zeros(3,nmax);
angle    = zeros(3,nmax);

% Determine the column based on vehicle ID
position(:,IDs)     = [x'  ;y'    ;z'];   
angle(:,IDs)        = [phi';theta';psi'];
angle(isnan(angle)) = 0; % convert NaN to 0
