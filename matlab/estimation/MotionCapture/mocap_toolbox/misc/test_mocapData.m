% INITIALIZATION ==========================================================
close all
clear all

%-------------------------------------------------------------------------%

% Motion Capture Interface
% Add NatNet library and java jar files
Opti = NET.addAssembly('C:\Users\Daigo\Dropbox\NatNetSDK\lib\x64\NatNetML.dll');

% Create client and connect to tracking stream
client = NatNetML.NatNetClientML();
client.Initialize('192.168.1.145','192.168.1.145');

%-------------------------------------------------------------------------%
% Initialize plot
fig= figure();
hmark= plot3(0,0,0,'.b','markersize',15);hold on
htail= plot3([0,0],[0,0],[0,0],'-k','linewidth',2);
htraj= plot3([0,0],[0,0],[0,0],':k','linewidth',1);

xlim([-.5 1]),xlabel('x')
ylim([-.5 1]),ylabel('y')
zlim([0 1]),zlabel('z')
set(gca,'Projection','perspective')
view([-.1 -1 .3])
daspect([1 1 1])
grid on
box on
drawnow


ii= 1;
while ishandle(fig)
    %_get MoCap information __________________________________________%
    [position,angle,t,Rmat] = get_PosAng(client);
    % Position
    x(ii) = position(1);
    y(ii) = position(2);
    z(ii) = position(3);
    % Euler angle
    phi(ii)  = angle(1);
    theta(ii)= angle(2);
    psi(ii)  = angle(3);
    
    %_update plot ____________________________________________________%
    set(hmark,'xdata',x(ii),'ydata',y(ii),'zdata',z(ii))
    ttail= max(1,ii-100):ii;
    set(htail,'xdata',x(ttail),'ydata',y(ttail),'zdata',z(ttail))
    set(htraj,'xdata',x(:),'ydata',y(:),'zdata',z(:))
    drawnow
    
    ii= ii+1;
end


%%
figure(1)
plot(x);hold on
plot(y)
plot(z)
legend('x','y','z')

figure(2)
plot(phi/pi*180);hold on
plot(theta/pi*180)
plot(psi/pi*180)
legend('phi','theta','psi')
grid on
ylim([-180 180])
%-------------------------------------------------------------------------%

% Motion Capture Interface
client.Uninitialize();

