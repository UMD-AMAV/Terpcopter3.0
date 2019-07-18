% INITIALIZATION ==========================================================
close all
clear all

%-------------------------------------------------------------------------%
% Motion Capture Interface
% Add NatNet library and java jar files
Opti = NET.addAssembly('C:\Users\katar\Dropbox\Quad_experiments\mocap_toolbox\NatNetSDK\lib\x64\NatNetML.dll');
% Create client and connect to tracking stream
client = NatNetML.NatNetClientML();
client.Initialize('192.168.1.145','192.168.1.145');


%% Parameters
g       = 9.81;

%% Low-pass filter
alphaLP = 0.8;
euler321prev= zeros(1,3);

%% Observer
A= [zeros(3), eye(3);
    zeros(3), zeros(3)];
C= [eye(3), zeros(3)];
B= [zeros(3); eye(3)];
D= eye(3);       % intensity of process noise (disturbance)
N= diag([1 1 0.01]);   % intensity of measurement noise
[L_observer,~,~]= lqe(A,B,C,D,N);

%initialize observer
xhat = zeros(6,1);
xhat_= zeros(6,1);
delT = 0;

%% Controller gain
Q= diag([100 100 100 1 1 1]);
R= diag([1 1 1]);
[K_lqr,~,~]= lqr(A,B,Q,R);

%% Initialize plot
fig= figure();
htraj= plot3(0,0,0,':');hold on
htail= plot3([0 0],[0 0],[0 0],'-b','linewidth',2);
hmark= plot3(0,0,0,'.k','markersize',15);
grid on
set(gca,'Projection','perspective')
xlim([-.5 2.5])
ylim([-.5 2.5])
zlim([-.5 2])
daspect([1 1 1])
xlabel('x')
ylabel('y')
zlabel('z')
set(gcf,'renderer','painters')
box on

%quad
draw_quad



%% RUN
ii= 1;
while ishandle(fig)
    %_get MoCap information __________________________________________%
    [xs, ys, zs, yaws, pitchs, rolls, ts] = frame_grab(client);
    %[xs ys zs yaws pitchs rolls] = checknan(xs,ys,zs,yaws,pitchs,rolls);
    
    xe(ii) = xs(1);
    ye(ii) = ys(1);
    ze(ii) = zs(1);
    tt(ii) = ts(1);
    %% convert Euler123 to Euler321
    % rotational matrix
    Rmat= Euler2Rmat([rolls(1),pitchs(1),yaws(1)],123);
    % convert to Euler 3-2-1
    euler321raw= Rmat2Euler(Rmat); % phi, theta, psi
    
    %% Lowpass Filter
    ind_missing= find(euler321raw==0);
    % augment missing measurement
    if numel(ind_missing)>0
        euler321raw(ind_missing)= euler321prev(ind_missing);
    end
    % discrete low-pass filter
    euler321= alphaLP*euler321raw + (1-alphaLP)*euler321prev;
    euler321prev= euler321;
    
    % sin and cos in 3-2-1 order
    c= cos(euler321([3,2,1]));  % psi, theta, phi
    s= sin(euler321([3,2,1]));  % psi, theta, phi

    %% Luenberger    
    % xyz acceleration depends on thrust and attitude
    U= g* [(delT+1)*( s(1)*s(3) + c(1)*c(3)*s(2) );
           (delT+1)*( c(3)*s(1)*s(2) - c(1)*s(3) );
             -1 + (delT+1)*c(2)*c(3)             ];
    
    dt= tt(ii)-tprev;
    % use continuous filter with Euler 1st order
    if nnz(y)==6   % measurements are complete
        dx    = A*xhat_ + B*U + L*(position-C*xhat_);
        xhat  = xhat_ + dt*dx;
    else           % some states are missing
        dx    = A*xhat_ + B*U; % no Innovation term
        xhat  = xhat_ + dt*dx;
    end
    
    % for next time step
    xhat_ = xhat;
    tprev = tt(ii);
    angles_prev= angles;
    
    
    %% PLOT
    for hind= 1:numel(handle)
        move_body(handle{hind},hdata(hind,:),xhat(1:3),Euler2Rmat(euler321,321))
    end
    
    drawnow
    
    %% save values
    x_observer(ii,:)= xhat';
    x_mocap(ii,:)= [xs, ys, zs];
    attitude_mocap(ii,:)= euler321raw;
    attitude_filter(ii,:)= euler321;
    U_observer(ii,:)= U';
    
    ii= ii+1;
end

%-------------------------------------------------------------------------%
% Motion Capture Interface
client.Uninitialize();


%% PLOT results
figure()
cc= lines(3);
for dim= 1:3
    h1a(dim)= plot(tt,x_mocap(:,dim),'.','color',cc(dim,:));hold on
    h1b(dim)= plot(tt,x_observer(:,dim),'-','color',cc(dim,:));hold on
end
xlabel('time(s)')
ylabel('position(m)')
set(legend,'location','best')
title('Observer Performance (position)')

figure()
cc= lines(3);
for dim= 1:3
    h2a(dim)= plot(tt,attitude_mocap(:,dim)/pi*180,'.','color',cc(dim,:));hold on
    h2b(dim)= plot(tt,attitude_filter(:,dim)/pi*180,'-','color',cc(dim,:));hold on
end
xlabel('time(s)')
ylabel('angles(degrees)')
set(legend,'location','best')
title('Observer Performance (attitude)')



% %-------------------------------------------------------------------------%
% % Serial communication
% fclose(sTrainerBox);