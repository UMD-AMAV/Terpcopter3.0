% INITIALIZATION ==========================================================
close all
clear all

%-------------------------------------------------------------------------%
% Motion Capture Interface
% Add NatNet library and java jar files
% Opti = NET.addAssembly('C:\Users\William\Downloads\NatNetSDK2.2\NatNetSDK\Samples\bin\NatNetML.dll');
Opti = NET.addAssembly('C:\Users\katar\Dropbox\Quad_experiments\mocap_toolbox\NatNetSDK\lib\x64\NatNetML.dll');
% Create client and connect to tracking stream
client = NatNetML.NatNetClientML();
client.Initialize('192.168.1.145','192.168.1.145');


%% Parameters
g       = 9.81;
% Throttle for hover in [0 1] scale. (Accuracy of this parameter may be
% very important for tracking performance. Maybe include adaptive control
% technique in future version)
delTstar= 0.6; 

% Assumed inner-loop performance. (Larger values will lead to attenuated
% control input)
theta_max= 30/180*pi;
phi_max  = 30/180*pi;
dpsi_max= 4*pi;

% For position control
rref= [.2;-.2;.8];
xref= [rref;0;0;0];

%% Low-pass filter
alphaLP = 0.8;
euler321prev= zeros(1,3);

%% Observer
A= [zeros(3), eye(3);
    zeros(3), zeros(3)];
C= [eye(3), zeros(3)];
B= [zeros(3); eye(3)];
D= eye(3);       % intensity of process noise (disturbance)
N= diag([1 1 0.5]*1e-6);   % intensity of measurement noise
[L_observer,~,~]= lqe(A,B,C,D,N);

%% Controller gain
Q= diag([2 2 0.1 1 1 0.1]);
R= diag([1 1 1]*2);
[K_lqr,~,~]= lqr(A,B,Q,R);

u_stick=zeros(4,1);

%% Initialize plot
fig= figure();
set(fig,'closereq',@my_closereq)
htraj= plot3(0,0,0,':');hold on
htail= plot3([0 0],[0 0],[0 0],'-b','linewidth',2);
hmark= plot3(0,0,0,'.k','markersize',15);
grid on
set(gca,'Projection','perspective')
xlim([-1 2.5])
ylim([-1 2.5])
zlim([0 2])
daspect([1 1 1])
xlabel('x')
ylabel('y')
zlabel('z')
set(gcf,'renderer','painters')
box on
%quad
[hquad,hdata]=draw_quad;


%%
paramC= v2struct(delTstar,A,B,C,K_lqr,L_observer,theta_max,phi_max,dpsi_max);

tmax= 30;

time             = zeros(tmax*50,1);
x_observer       = zeros(tmax*50,6);
x_mocap          = zeros(tmax*50,3);
attitude_mocap   = zeros(tmax*50,3);
attitude_filter  = zeros(tmax*50,3);
attitude_desired = zeros(tmax*50,3);
thrust_desired   = zeros(tmax*50,3);
stick_input      = zeros(tmax*50,4);
accel_desired    = zeros(tmax*50,3);

%% RUN
ii= 1;
while ii< tmax*300
    %_get MoCap information __________________________________________%
    [position,angle,t,Rmat] = get_PosAng(client);
%     [position,angle,t,Rmat] = get_PosAngDummy;
    
    pos= position(1,:);
    ang= angle(1,:);
    Rot= Rmat{1};
    % time
    if ii==1
        disp('running')
        tstart= t;
        tprev= tstart;
    end
    tnow= t-tstart;
    dt= tnow-tprev;
    tprev = tnow;
    
    %% Lowpass Filter
    euler321            = myLowPass(ang,alphaLP);
        
    %% Luenberger    
    [xhat,Uhat,dpsihat] = myObserver(pos,euler321,u_stick,dt,paramC);
  
    
    %% save values
    time(ii)              = tnow;
    x_observer(ii,:)      = xhat';
    x_mocap(ii,:)         = pos;
    attitude_mocap(ii,:)  = ang;
    attitude_filter(ii,:) = euler321;
    
    %% PLOT
    for hind= 1:numel(hquad)
       move_body(hquad{hind},hdata(hind,:),xhat(1:3),Euler2Rmat(euler321,321))
    end
    
    drawnow
    ii= ii+1;
end

disp('stopped')

% Motion Capture Interface
client.Uninitialize();
delete(client);

%% PLOT results
inde= find(time>0,1,'last');

for dim= 1:3
    dx_diff(:,dim)= gradient(x_mocap(:,dim))./gradient(time);
end


time= time(1:inde);
x_mocap= x_mocap(1:inde,:);
x_observer= x_observer(1:inde,:);
dx_diff= dx_diff(1:inde,:);

figure()
cc= lines(3);
for dim= 1:3
    h1a(dim)= plot(time,x_mocap(:,dim),'.','color',cc(dim,:));hold on
    h1b(dim)= plot(time,x_observer(:,dim),'-','color',cc(dim,:));hold on
end
ylim([-1 2])
xlabel('time(s)')
ylabel('position(m)')
legend([h1b],'x','y','z')
set(legend,'location','best')
title('Observer Performance (position)')


figure()
cc= lines(3);
for dim= 1:3
    h1a(dim)= plot(time,dx_diff(:,dim),'.','color',cc(dim,:));hold on
    h1b(dim)= plot(time,x_observer(:,3+dim),'-','color',cc(dim,:));hold on
end
ylim([-1 2])
xlabel('time(s)')
ylabel('velocity(m/s)')
legend([h1b],'x','y','z')
set(legend,'location','best')
title('Observer Performance (velocity)')

figure()
plot(diff(time),'x')

% %% Save workspace
% folder = 'exp_Observer';
% header = 'testObs_';
% save_workspace(folder,header)
