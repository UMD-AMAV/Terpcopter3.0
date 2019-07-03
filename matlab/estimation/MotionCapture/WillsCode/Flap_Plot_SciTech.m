%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Flap image generator
% Will Craig
% 6/28/15
% This function is designed to produce an image of helicopter flapping
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{k
arwL = 12;
arwA = 17;
figure(21); clf, hold on
xlim([-1.1, 1.1])
axis equal
h = gca;
colors = parula;
h.ColorOrder = colors;
% pcol = get(gca,'ColorOrder');
B1col = colors(10,:);
B2col = colors(20,:);
x = linspace(-1,1,1000);

% Plot hub plane
hp = plot(x, zeros(size(x)), '--');

% Plot blades
B1 = 5*pi/180; % Flap angle for blade one
B2 = 3*pi/180; % Flap angle for blade two
blade1 = plot(x(x>=0)*cos(B1), x(x>=0)*sin(B1), 'color', B1col,'linewidth',2);
blade2 = plot(x(x<=0)*cos(B2), -x(x<=0)*sin(B2), 'color', B2col,'linewidth',2);

% Label B1
[B1x, B1y] = pol2cart(linspace(0, B1), 0.7);
plot(B1x, B1y, 'color', B1col)
xB1 = 0.72;
yB1 = 0.03;
strB1 = ['\beta_1 = ',num2str(B1*180/pi), '^o'];
text(xB1,yB1,strB1,'HorizontalAlignment','left', 'color', B1col, 'fontsize', 14)

% Label B2
[B2x, B2y] = pol2cart(linspace(pi-B2, pi), 0.7);
plot(B2x, B2y, 'color', B2col)
xB2 = -0.6;
yB2 = 0.11;
strB2 = ['\beta_2 = ',num2str(B2*180/pi), '^o'];
text(xB2,yB2,strB2,'HorizontalAlignment','right', 'color', B2col, 'fontsize', 14)


[circx, circy] = pol2cart(linspace(0, 2*pi, 360), 0.25);
fuselage = plot(circx, circy-0.35, 'k','linewidth',2);
plot([0, 0], [-0.1, 0], 'k','linewidth',2)
h_leg = legend([hp, blade1, blade2, fuselage],...
    'Hub Plane', 'Blade 1', 'Blade 2','Fuselage', 'Location', 'SouthEast');
set(h_leg, 'FontSize', 15)

% Plot axes
plot([0, 0.4], [0, 0], 'k--')
arrow([0.39,0],[0.4, 0], 'Length',arwL,'TipAngle',arwA);
xy = 0.3;
yy = -0.04;
text(xy,yy,'\bf{e}_y','HorizontalAlignment','right', 'color', 'k', 'fontsize', 14)

plot([0, 00], [0, -0.4], 'k--')
arrow([0,-0.39],[0, -0.4], 'Length',arwL,'TipAngle',arwA);
xz = 0.02;
yz = -0.3;
text(xz,yz,'\bf{e}_z','HorizontalAlignment','left', 'color', 'k', 'fontsize', 14)

xlim([-1.1, 1.1])
axis equal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot rotor in wind
arwL = 12;
arwA = 17;
figure(22), clf, hold on
bladeclr = [.45 .45 .45];

ylim([-0.7, 0.8]), axis equal
R = 0.5;
[rotorx, rotory] = pol2cart(linspace(0, 2*pi, 360), R);
Rotor = plot(rotorx, rotory, 'k:');

[hubx, huby] = pol2cart(linspace(0, 2*pi, 360), R/10/2);
Hub = plot(hubx, huby, 'k');

c = 0.03; % Chord
% adv = plot([R/10, R, R, R/10, R/10],...
%     [-c/2, -c/2, c/2, c/2, -c/2], 'color', bladeclr);
% plot([R/10/2, R/10], [0, 0], 'color', bladeclr)
% 
% retr = plot(-[R/10, R, R, R/10, R/10],...
%     [-c/2, -c/2, c/2, c/2, -c/2], 'color', bladeclr);
% plot(-[R/10/2, R/10], [0, 0], 'color', bladeclr)

bldvec = [-c/2, -c/2, c/2, c/2, -c/2; -R/10, -R, -R, -R/10, -R/10];
% yaw = pi/2.5;
yaw = pi/2-pi/8;
Rb = [cos(yaw), -sin(yaw); sin(yaw), cos(yaw)];
advbld = Rb*bldvec;
adv = plot(advbld(1,:), advbld(2,:), 'color', B1col,'linewidth',2);
hingeoff = [0, 0; -R/10/2, -R/10];
hingeoff = Rb*hingeoff;
plot(hingeoff(1,:), hingeoff(2,:), 'color', B1col,'linewidth',2)
retr = plot(-advbld(1,:), -advbld(2,:), 'color', B1col,'linewidth',2);
plot(-hingeoff(1,:), -hingeoff(2,:), 'color', B1col,'linewidth',2)


% Plot body
ang = 0:.01:2*pi;
x = 0.1*cos(ang);
y = 0.2*sin(ang);
plot(x,y, 'k')

ang = pi:.01:2*pi;
x = 0.02*cos(ang);
y = -0.195 + 0.4*sin(ang);
plot(x,y, 'k')

ang = 0:.01:2*pi;
x = 0.05 + 0.001*cos(ang);
y = -0.53 + 0.1*sin(ang);
plot(x,y, 'k')

% plot([0.013, 0.049], [-0.495, -0.495], 'k')
% plot([0.0125, 0.049], [-0.505, -0.505], 'k')
plot([0.013, 0.049], [-0.525, -0.525], 'k')
plot([0.0125, 0.049], [-0.535, -0.535], 'k')

% % plot omegas
[omgax, omgay] = pol2cart(linspace(-pi/4, -pi/8), 0.9*R);
plot(omgax, omgay, 'k--');
arrow([omgax(end-1), omgay(end-1)], [omgax(end), omgay(end)])
% text(0.75*R, -R/5, '\psi t', 'FontSize', 16)
[omgax, omgay] = pol2cart(linspace(pi-pi/4, pi-pi/8), 0.9*R);
plot(omgax, omgay, 'k--');
arrow([omgax(end-1), omgay(end-1)], [omgax(end), omgay(end)])
% text(-0.75*R, R/5, '$\psi t$', 'FontSize', 16,'HorizontalAlignment','right',...
%     'interpreter','latex')
% 
plot([0, 0], [1.5*R, 1.1*R], 'k')
arrow([0, 1.5*R], [0, 1.1*R], 'Length',arwL,'TipAngle',arwA)
text(R/10, 1.3*R, '$\textbf{V}_\infty$', 'FontSize', 16,'interpreter','latex')
ylim([-1.4*R, 1.6*R])
axis equal

% Plot phase delay angle
pcol = get(gca,'ColorOrder');
Ccol = pcol(7,:);
phid = 90;
[phidx, phidy] = pol2cart(linspace(0, phid*pi/180), 0.6*R);
plot(phidx, phidy, '--','color', Ccol);
h_ar = arrow([phidx(end-1), phidy(end-1)], [phidx(end), phidy(end)]);
set(h_ar, 'facecolor', Ccol, 'edgecolor', Ccol)
text(0.5*R, 0.5*R, ['$\delta = ' num2str(phid) '^\circ$'], 'FontSize', 16,'color',Ccol,...
    'interpreter','latex')


% plot([1.5*R, 1.1*R], [0, 0], 'k')
% arrow([1.5*R, 0], [1.1*R, 0], 'Length',arwL,'TipAngle',arwA)
% text(1.3*R, R/10, 'V', 'FontSize', 16)

% Plot Axes
plot([0, 0.4], [0, 0], 'k--')
text(0.42, 0.0, '$F_{max}$', 'FontSize', 16,'color','k', 'interpreter', 'latex')
% arrow([0.39,0],[0.4, 0], 'Length',arwL,'TipAngle',arwA);
xy = 0.3;
yy = 0.09;
% text(xy,yy,'\bf{e}\rm_{y}','HorizontalAlignment','right', 'color', 'k', 'FontSize', 16)

plot([0, 0.4*cos(phid*pi/180)], [0, 0.4*sin(phid*pi/180)], 'k--')
text(0.4*cos(phid*pi/180)+0.01,0.4*sin(phid*pi/180), '$\beta_{max}$',...
    'FontSize', 16,'color','k','interpreter','latex')
% arrow([0,0.39],[0, 0.4], 'Length',arwL,'TipAngle',arwA);
xx = 0.04;
yx = 0.3;
% text(xx,yx,'\bf{e}\rm_{x}','HorizontalAlignment','left', 'color', 'k', 'FontSize', 16)


% % Plot Axes
% plot([0, 0.4], [0, 0], 'k--')
% arrow([0.39,0],[0.4, 0], 'Length',arwL,'TipAngle',arwA);
% xy = 0.3;
% yy = 0.09;
% text(xy,yy,'\bf{e}\rm_{x}','HorizontalAlignment','right', 'color', 'k', 'FontSize', 16)
% 
% plot([0, 00], [0, -0.4], 'k--')
% arrow([0,-0.39],[0, -0.4], 'Length',arwL,'TipAngle',arwA);
% xx = 0.04;
% yx = -0.3;
% text(xx,yx,'\bf{e}\rm_{y}','HorizontalAlignment','left', 'color', 'k', 'FontSize', 16)

% % % %plot psi
% % [psix, psiy] = pol2cart(linspace(3*pi/2, 3*pi/2 + yaw), 0.5*R);
% % plot(psix, psiy, 'k--');
% % plot([0,0], [-0.225, -0.275], 'k')
% % arrow([psix(end-10), psiy(end-10)],...
% %     [psix(end), psiy(end)], 'Length',arwL,'TipAngle',arwA)
% % text(0.16*R, -R/1.8, '\psi', 'FontSize', 16)
%}

%%%%%%%%%%%%%%%%%%%%%%
% Make the blade FBD, Paper version
%{k
% Plot axes
R = 1;
arwL = 12;
arwA = 17;
figure(23), clf, hold on
pcol = get(gca,'ColorOrder');
Ccol = pcol(7,:);
dcol = pcol(5,:);
xlim([-0.15*R, 1.2*R]), ylim([-0.2, 0.5])
% % xlim([-.25, 1.1]), ylim([-0.9, 0.5])
plot([0, 0.975*R], [0, 0], '--', 'color', Ccol)
% C1 = arrow([1.09*R,0],[1.1*R, 0], 'Length',arwL,'TipAngle',arwA);
% set(C1, 'facecolor', Ccol, 'edgecolor', Ccol)
% text(1.03*R,-0.04,'\bf c_{\rm1}','HorizontalAlignment','right', 'color', Ccol,...
%     'fontsize', 14)
% 
plot([0, 0], [0, 0.225*R], '--', 'color', Ccol)
% C2 = arrow([0, 0.39*R],[0, 0.4*R], 'Length',arwL,'TipAngle',arwA);
% set(C2, 'facecolor', Ccol, 'edgecolor', Ccol)
% text(-0.06,0.33*R,'\bf c_{\rm3}','HorizontalAlignment','left', 'color', Ccol,...
%     'fontsize', 14)
% text(-0.03,0.4*R,'$\mathcal{C}$','HorizontalAlignment',...
%     'left', 'color', Ccol,'fontsize', 16, 'interpreter', 'latex')


% Draw Hub
[hcapx, hcapy] = pol2cart(linspace(pi/2-pi/12, pi/2+pi/12), 0.3*R);
plot(hcapx, hcapy-0.25*R, 'k');
[hcapx, hcapy] = pol2cart(linspace(0, pi), 0.08*R);
theta = pi/1.95;%pi/2.3;
R_x = [1, 0, 0; 0,  cos(theta), sin(theta);
                0, -sin(theta), cos(theta)];
hcap = R_x*[hcapx; hcapy; zeros(size(hcapx))];
plot(hcap(1,:), hcap(2,:)+0.04*R, 'k');

% Draw Blade
% offset
bladeclr = [.3 .3 .3];
e = 0.15;
plot([0.02, 0.02], [-.05, 0.035], 'color', bladeclr)
plot([-0.02, -0.02], [-.05, 0.035], 'color', bladeclr)
plot([0.02, e], [0.01, 0.01], 'color', bladeclr)
plot([0.02, e], [-0.01, -0.01], 'color', bladeclr)
% hinge
[hingex, hingey] = pol2cart(linspace(0, 2*pi), 0.01);
plot(hingex + e, hingey, 'color', bladeclr)
% blade
beta = 15*pi/180;
Rbeta = [cos(beta), -sin(beta); sin(beta), cos(beta)];
flap = Rbeta*[R-e, R-e; 0.01, -0.01];
plot([0, flap(1,1)]+e, [0.01, flap(2,1)],'color', bladeclr)
plot([0, flap(1,2)]+e, [-0.01, flap(2,2)],'color', bladeclr)
plot([flap(1,1), flap(1,2)]+e, [flap(2,1), flap(2,2)],'color', bladeclr)
% flap spring
[kx, ky] = pol2cart(linspace(-pi/2, 3*pi), linspace(0.01, 0.05));
plot(kx+e, ky, 'k')
% element
% r = 0.65;
% dx = 0.01;
% b_e = Rbeta*[r-e-dx, r-e+dx, r-e+dx, r-e-dx; -0.01, -0.01, 0.01, 0.01];
% patch(b_e(1,:)+e, b_e(2,:), 'k')


% % Draw D^(n) axes
% dax = Rbeta*[1.1*(R-e); 0];
% plot([0, dax(1)]+e, [0, dax(2)], '--', 'color', dcol)
% D1 = arrow([.99*dax(1)+e,0.99*dax(2)],[dax(1)+e, dax(2)], 'Length',arwL,'TipAngle',arwA);
% set(D1, 'facecolor', dcol, 'edgecolor', dcol)
% text(0.97*dax(1)+e,dax(2)-0.06,'\bfd\rm_{1}','HorizontalAlignment',...
%     'right', 'color', dcol,'fontsize', 14)
% 
% day = Rbeta*[0; 0.4*R];
% plot([0, day(1)]+e, [0, day(2)], '--', 'color', dcol)
% D2 = arrow([.99*day(1)+e,0.99*day(2)],[day(1)+e, day(2)], 'Length',arwL,'TipAngle',arwA);
% set(D2, 'facecolor', dcol, 'edgecolor', dcol)
% text(day(1)+e+0.02,day(2)-0.05,'\bfd\rm_{3}','HorizontalAlignment',...
%     'left', 'color', dcol,'fontsize', 14)
% text(day(1)+e+0.02,day(2),'$\mathcal{D}$','HorizontalAlignment',...
%     'left', 'color', dcol,'fontsize', 16, 'interpreter', 'latex')
% 


%%%%%%%%%%%%%%%%%%%%%
% Label Diagram
% Flap angle
[betax, betay] = pol2cart(linspace(0, beta), 0.3);
plot(betax+e, betay, 'k')
arrow([betax(end-1)+e, betay(end-1)],...
    [betax(end)+e, betay(end)], 'Length',arwL,'TipAngle',arwA)
text(0.46, 0.04, '$\beta_j$', 'FontSize', 18,'interpreter', 'latex')

% Spring
text(e, 0.07, '$k_{\beta}$', 'FontSize', 18,'interpreter', 'latex')

% Hinge Offset
e_y = -0.1;
plot([0, e], [e_y, e_y], 'k')
plot([0, 0], [e_y-0.01, e_y+0.01], 'k')
plot([e, e], [e_y-0.01, e_y+0.01], 'k')
text(0.065, e_y+0.03, '$e$', 'fontsize', 18,'interpreter', 'latex')

% % Blade Element
% be_y = 0.14;
% % plot([0, r], [0.2, 0.2], 'k')
% % plot([0, 0], [0.19, 0.21], 'k'), plot([r, r], [0.19, 0.21], 'k')
% % text(r/2, 0.23, 'r', 'fontsize', 14)
% r_less_e = Rbeta*[0, r-e; 0, 0];
% rx = r_less_e(1,:)+e-be_y*sin(beta);
% ry = r_less_e(2,:)+be_y*cos(beta);
% plot(rx, ry, 'k')
% r_sides = Rbeta*[0, 0;-0.01, 0.01];
% plot(r_sides(1,:)+rx(1), r_sides(2,:)+ry(1), 'k')
% plot(r_sides(1,:)+rx(2), r_sides(2,:)+ry(2), 'k')
% h_r = text(r/2, 0.21, 'r - e', 'fontsize', 14);
% set(h_r, 'Rotation', beta*180/pi)
% 
% % Blade
% % [diamx, diamy] = pol2cart(linspace(0, beta), R-e);
% % plot(diamx+e, diamy, 'k--')
% % plot([0, R], [0.27, 0.27], 'k')
% % plot([0, 0], [0.26, 0.28], 'k'), plot([R, R], [0.26, 0.28], 'k')
% % text(R/2, 0.3, 'R', 'fontsize', 14)
% 
% bld_y = 0.2;
% R_less_e = Rbeta*[0, R-e; 0, 0];
% Rx = R_less_e(1,:)+e-bld_y*sin(beta);
% Ry = R_less_e(2,:)+bld_y*cos(beta);
% plot(Rx, Ry, 'k')
% r_sides = Rbeta*[0, 0;-0.01, 0.01];
% plot(r_sides(1,:)+Rx(1), r_sides(2,:)+Ry(1), 'k')
% plot(r_sides(1,:)+Rx(2), r_sides(2,:)+Ry(2), 'k')
% h_R = text(0.45, 0.31, '$\bar{\textrm{r}}$ - e', 'fontsize', 14, 'interpreter','latex');
% set(h_R, 'Rotation', beta*180/pi)
% 

% Show direction of rotation
[omegax, omegay] = pol2cart(linspace(2*pi/3, 2*pi+pi/3), 0.06*R);
theta = pi/2.3;%pi/2.3;
R_x = [1, 0, 0; 0,  cos(theta), sin(theta);
                0, -sin(theta), cos(theta)];
omegadir = R_x*[omegax; omegay; zeros(size(omegax))];
h_off = 0.07*R;
plot(omegadir(1,:), omegadir(2,:)+h_off, 'k', 'linewidth', 1);
arrow([omegadir(1,end-1), omegadir(2, end-1)+h_off],...
    [omegadir(1,end)-0.02, omegadir(2,end)+h_off], 'Length',arwL,'TipAngle',arwA)
text(-0.08, 0.115, '${\omega}_j$', 'fontsize', 18,'interpreter', 'latex')

% % Plot lift force
% lift = Rbeta*[0, 0; 0, 0.12];
% liftx = [lift(1,1),lift(1,2)]+(r-e)*cos(beta)+e;
% lifty = [lift(2,1), lift(2,2)]+(r-e)*sin(beta);
% arrow([liftx(1), lifty(1)],[liftx(2), lifty(2)], 'Length',arwL,'TipAngle',arwA)
% text(0.6, 0.27, 'dF_{3}\bf{d}\rm_3', 'fontsize', 14)
% % text(0.62, 0.23, 'dF_{3}\bf{d}\rm_3', 'fontsize', 14)
% 
% % Plot Tension force on element
% tens = Rbeta*[-0.16, 0; 0, 0];
% tensx = [tens(1,1),tens(1,2)]+(r-e)*cos(beta)+e;
% tensy = [tens(2,1), tens(2,2)]+(r-e)*sin(beta);
% arrow([tensx(2), tensy(2)],[tensx(1), tensy(1)], 'Length',arwL,'TipAngle',arwA)
% text(0.41, 0.15, '-dF_{1}\bf{d}\rm_1', 'fontsize', 14)
% % text(0.45, 0.13, '-dF_{1}\bf{d}\rm_1', 'fontsize', 14)
% 
% 
% % Plot weight force
% mg = [0, 0; 0, -0.08];
% mgx = [mg(1,1),mg(1,2)]+(r-e)*cos(beta)+e;
% mgy = [mg(2,1), mg(2,2)]+(r-e)*sin(beta);
% arrow([mgx(1), mgy(1)],[mgx(2), mgy(2)], 'Length',arwL,'TipAngle',arwA)
% text(0.58, 0.025, '-gdm\bf{e}\rm_3', 'fontsize', 14)
% 
% text(0.65, 0.21, '-dF_2\bf{d}\rm_2', 'fontsize', 14)
% % text(0.53, 0.15, '-dF_2\bf{d}\rm_2', 'fontsize', 14)
% % 

% % Plot torque from hub to rotate the blade
% [taux, tauy] = pol2cart(linspace(2*pi/3, 2*pi+pi/3), 0.08*R);
% theta = pi/2.3;%pi/2.3;
% R_x = [1, 0, 0; 0,  cos(theta), sin(theta);
%                 0, -sin(theta), cos(theta)];
% taudir = R_x*[taux; tauy; zeros(size(taux))];
% tau_off = 0.11*R;
% plot(taudir(1,:), taudir(2,:)+tau_off, 'k', 'linewidth', 1);
% arrow([taudir(1,end-1), taudir(2, end-1)+tau_off],...
%     [taudir(1,end)-0.01, taudir(2,end)+tau_off], 'Length',arwL,'TipAngle',arwA)
% text(-0.1, 0.075, '\tau\bf{c}\rm_3', 'fontsize', 14)


% % Plot aerodynamic moment on blade in -d2 direction
% [AMx, AMy] = pol2cart(linspace(2*pi+5*pi/12, 7*pi/12), 0.07*R);
% theta = pi/2.3;%pi/2.3;
% R_z = [cos(theta), sin(theta), 0; -sin(theta), cos(theta), 0; 0, 0, 1];
% Rbeta3 = [cos(beta+pi/2), -sin(beta+pi/2), 0;sin(beta+pi/2), cos(beta+pi/2), 0; 0, 0, 1];
% AMdir = Rbeta3*R_x*[AMx; AMy; zeros(size(AMx))];
% m_r = 0.995*r;
% offst = R/32;
% plot(AMdir(1,:)+(m_r-e+offst)*cos(beta)+e, AMdir(2,:)+(m_r-e+offst)*sin(beta),...
%     'k', 'linewidth', 1);
% arrow([AMdir(1,end-1)+(m_r-e+offst)*cos(beta)+e, AMdir(2, end-1)+(m_r-e+offst)*sin(beta)],...
%     [AMdir(1,end)+(m_r-e+offst)*cos(beta)+e, AMdir(2,end)+(m_r-e+offst)*sin(beta)]...
%     , 'Length',arwL,'TipAngle',arwA)
% text(0.69, 0.11, 'dM_1\bf{d}\rm_1', 'fontsize', 14)

% % Plot torque from hub to rotate the blade
% [M_Hx, M_Hy] = pol2cart(linspace(-pi/6, -2*pi+pi/6), 0.035*R);
% M_Hdir = [M_Hx; M_Hy];
% plot(M_Hdir(1,:), M_Hdir(2,:), 'k', 'linewidth', 1);
% arrow([M_Hdir(1,end-10), M_Hdir(2, end-10)],...
%     [M_Hdir(1,end), M_Hdir(2,end)])
% text(-0.05, -0.04, '\bfM_{\rmH}', 'fontsize', 14)
% 
% % Plot constraint force on hub
% arrow([0, 0],[0, 0.06])
% text(-0.023, 0.015, '\bfF_{\rm\tau}', 'fontsize', 14)

% Label point P and point O
text(-0.09, -0.025, '$O_j''$', 'fontsize', 18,'interpreter', 'latex')
% text(e, -0.06, 'H', 'fontsize', 14)
% text(b_e(1,1)+e-0.03, b_e(2,1)-0.025, 'P', 'fontsize', 14)
% text(Rx(2)*cos(beta)*0.9+e, Rx(2)*sin(beta)+0.01, 'Q', 'fontsize', 14)


axis equal
%}

%%%%%%%%%%%%%%%%%%%%%%
% Make the blade FBD, Presentation version
%{
% Plot axes
R = 1;
arwL = 12;
arwA = 17;
figure(23), clf, hold on
pcol = get(gca,'ColorOrder');
Ccol = pcol(7,:);
dcol = pcol(5,:);
xlim([-0.15*R, 1.2*R]), ylim([-0.2, 0.5])
% xlim([-.25, 1.1]), ylim([-0.9, 0.5])
plot([0, 1.1*R], [0, 0], 'k--')
% C1 = arrow([1.09*R,0],[1.1*R, 0], 'Length',arwL,'TipAngle',arwA);
% set(C1, 'facecolor', Ccol, 'edgecolor', Ccol)
% text(1.03*R,-0.04,'\bf c_{\rm1}','HorizontalAlignment','right', 'color', Ccol,...
%     'fontsize', 14)
% 
% plot([0, 0], [0, 0.4*R], '--', 'color', Ccol)
% C2 = arrow([0, 0.39*R],[0, 0.4*R], 'Length',arwL,'TipAngle',arwA);
% set(C2, 'facecolor', Ccol, 'edgecolor', Ccol)
% text(-0.06,0.33*R,'\bf c_{\rm3}','HorizontalAlignment','left', 'color', Ccol,...
%     'fontsize', 14)
% text(-0.03,0.4*R,'$\mathcal{C}$','HorizontalAlignment',...
%     'left', 'color', Ccol,'fontsize', 16, 'interpreter', 'latex')


% Draw Hub
[hcapx, hcapy] = pol2cart(linspace(pi/2-pi/12, pi/2+pi/12), 0.3*R);
plot(hcapx, hcapy-0.25*R, 'k');
[hcapx, hcapy] = pol2cart(linspace(0, pi), 0.08*R);
theta = pi/1.95;%pi/2.3;
R_x = [1, 0, 0; 0,  cos(theta), sin(theta);
                0, -sin(theta), cos(theta)];
hcap = R_x*[hcapx; hcapy; zeros(size(hcapx))];
plot(hcap(1,:), hcap(2,:)+0.04*R, 'k');

% Draw Blade
% offset
bladeclr = [.3 .3 .3];
e = 0.15;
plot([0.02, 0.02], [-.05, 0.035], 'color', bladeclr)
plot([-0.02, -0.02], [-.05, 0.035], 'color', bladeclr)
plot([0.02, e], [0.01, 0.01], 'color', bladeclr)
plot([0.02, e], [-0.01, -0.01], 'color', bladeclr)
% hinge
[hingex, hingey] = pol2cart(linspace(0, 2*pi), 0.01);
plot(hingex + e, hingey, 'color', bladeclr)
% blade
beta = 15*pi/180;
Rbeta = [cos(beta), -sin(beta); sin(beta), cos(beta)];
flap = Rbeta*[R-e, R-e; 0.01, -0.01];
plot([0, flap(1,1)]+e, [0.01, flap(2,1)],'color', bladeclr)
plot([0, flap(1,2)]+e, [-0.01, flap(2,2)],'color', bladeclr)
plot([flap(1,1), flap(1,2)]+e, [flap(2,1), flap(2,2)],'color', bladeclr)
% flap spring
[kx, ky] = pol2cart(linspace(-pi/2, 3*pi), linspace(0.01, 0.05));
plot(kx+e, ky, 'k')
% element
r = 0.65;
dx = 0.01;
b_e = Rbeta*[r-e-dx, r-e+dx, r-e+dx, r-e-dx; -0.01, -0.01, 0.01, 0.01];
patch(b_e(1,:)+e, b_e(2,:), 'k')


% Draw D^(n) axes
% dax = Rbeta*[1.1*(R-e); 0];
% plot([0, dax(1)]+e, [0, dax(2)], '--', 'color', dcol)
% D1 = arrow([.99*dax(1)+e,0.99*dax(2)],[dax(1)+e, dax(2)], 'Length',arwL,'TipAngle',arwA);
% set(D1, 'facecolor', dcol, 'edgecolor', dcol)
% text(0.97*dax(1)+e,dax(2)-0.06,'\bfd\rm_{1}','HorizontalAlignment',...
%     'right', 'color', dcol,'fontsize', 14)
% 
% day = Rbeta*[0; 0.4*R];
% plot([0, day(1)]+e, [0, day(2)], '--', 'color', dcol)
% D2 = arrow([.99*day(1)+e,0.99*day(2)],[day(1)+e, day(2)], 'Length',arwL,'TipAngle',arwA);
% set(D2, 'facecolor', dcol, 'edgecolor', dcol)
% text(day(1)+e+0.02,day(2)-0.05,'\bfd\rm_{3}','HorizontalAlignment',...
%     'left', 'color', dcol,'fontsize', 14)
% text(day(1)+e+0.02,day(2),'$\mathcal{D}$','HorizontalAlignment',...
%     'left', 'color', dcol,'fontsize', 16, 'interpreter', 'latex')



%%%%%%%%%%%%%%%%%%%%%
% Label Diagram
% Flap angle
[betax, betay] = pol2cart(linspace(0, beta), 0.3);
plot(betax+e, betay, 'k')
arrow([betax(end-1)+e, betay(end-1)],...
    [betax(end)+e, betay(end)], 'Length',arwL,'TipAngle',arwA)
text(0.46, 0.04, '\beta', 'FontSize', 20)

% Spring
text(e-0.06, 0.07, 'Spring', 'FontSize', 14)

% Hinge Offset
e_y = -0.1;
plot([0, e], [e_y, e_y], 'k')
plot([0, 0], [e_y-0.01, e_y+0.01], 'k')
plot([e, e], [e_y-0.01, e_y+0.01], 'k')
text(-0.05, e_y-0.04, 'Hinge Offset', 'fontsize', 14)

% Blade Element
be_y = 0.14;
% plot([0, r], [0.2, 0.2], 'k')
% plot([0, 0], [0.19, 0.21], 'k'), plot([r, r], [0.19, 0.21], 'k')
% text(r/2, 0.23, 'r', 'fontsize', 14)
% r_less_e = Rbeta*[0, r-e; 0, 0];
% rx = r_less_e(1,:)+e-be_y*sin(beta);
% ry = r_less_e(2,:)+be_y*cos(beta);
% plot(rx, ry, 'k')
% r_sides = Rbeta*[0, 0;-0.01, 0.01];
% plot(r_sides(1,:)+rx(1), r_sides(2,:)+ry(1), 'k')
% plot(r_sides(1,:)+rx(2), r_sides(2,:)+ry(2), 'k')
% h_r = text(r/2, 0.21, 'r - e', 'fontsize', 14);
% set(h_r, 'Rotation', beta*180/pi)

% Blade
% [diamx, diamy] = pol2cart(linspace(0, beta), R-e);
% plot(diamx+e, diamy, 'k--')
% plot([0, R], [0.27, 0.27], 'k')
% plot([0, 0], [0.26, 0.28], 'k'), plot([R, R], [0.26, 0.28], 'k')
% text(R/2, 0.3, 'R', 'fontsize', 14)

% bld_y = 0.2;
% R_less_e = Rbeta*[0, R-e; 0, 0];
% Rx = R_less_e(1,:)+e-bld_y*sin(beta);
% Ry = R_less_e(2,:)+bld_y*cos(beta);
% plot(Rx, Ry, 'k')
% r_sides = Rbeta*[0, 0;-0.01, 0.01];
% plot(r_sides(1,:)+Rx(1), r_sides(2,:)+Ry(1), 'k')
% plot(r_sides(1,:)+Rx(2), r_sides(2,:)+Ry(2), 'k')
% h_R = text(0.45, 0.31, 'R - e', 'fontsize', 14);
% set(h_R, 'Rotation', beta*180/pi)


% Show direction of rotation
% [omegax, omegay] = pol2cart(linspace(2*pi/3, 2*pi+pi/3), 0.06*R);
% theta = pi/2.3;%pi/2.3;
% R_x = [1, 0, 0; 0,  cos(theta), sin(theta);
%                 0, -sin(theta), cos(theta)];
% omegadir = R_x*[omegax; omegay; zeros(size(omegax))];
% h_off = 0.16*R;
% plot(omegadir(1,:), omegadir(2,:)+h_off, 'k', 'linewidth', 1);
% arrow([omegadir(1,end-1), omegadir(2, end-1)+h_off],...
%     [omegadir(1,end)-0.02, omegadir(2,end)+h_off], 'Length',arwL,'TipAngle',arwA)
% text(-0.08, 0.18, '\Omega\bf{c}\rm_3', 'fontsize', 14)

% Plot lift force
lift = Rbeta*[0, 0; 0, 0.12];
liftx = [lift(1,1),lift(1,2)]+(r-e)*cos(beta)+e;
lifty = [lift(2,1), lift(2,2)]+(r-e)*sin(beta);
arrow([liftx(1), lifty(1)],[liftx(2), lifty(2)], 'Length',arwL,'TipAngle',arwA)
text(0.6, 0.27, 'Lift', 'fontsize', 14)
% text(0.62, 0.23, 'dF_{3}\bf{d}\rm_3', 'fontsize', 14)

% Plot Tension force on element
tens = Rbeta*[-0.16, 0; 0, 0];
tensx = [tens(1,1),tens(1,2)]+(r-e)*cos(beta)+e;
tensy = [tens(2,1), tens(2,2)]+(r-e)*sin(beta);
arrow([tensx(2), tensy(2)],[tensx(1), tensy(1)], 'Length',arwL,'TipAngle',arwA)
text(0.41, 0.15, 'Tension', 'fontsize', 14)
% text(0.45, 0.13, '-dF_{1}\bf{d}\rm_1', 'fontsize', 14)


% Plot weight force
mg = [0, 0; 0, -0.08];
mgx = [mg(1,1),mg(1,2)]+(r-e)*cos(beta)+e;
mgy = [mg(2,1), mg(2,2)]+(r-e)*sin(beta);
arrow([mgx(1), mgy(1)],[mgx(2), mgy(2)], 'Length',arwL,'TipAngle',arwA)
text(0.54, 0.032, 'Weight', 'fontsize', 14)

text(0.65, 0.1, 'Drag', 'fontsize', 14)
% text(0.53, 0.15, '-dF_2\bf{d}\rm_2', 'fontsize', 14)

% % Plot torque from hub to rotate the blade
% [taux, tauy] = pol2cart(linspace(2*pi/3, 2*pi+pi/3), 0.08*R);
% theta = pi/2.3;%pi/2.3;
% R_x = [1, 0, 0; 0,  cos(theta), sin(theta);
%                 0, -sin(theta), cos(theta)];
% taudir = R_x*[taux; tauy; zeros(size(taux))];
% tau_off = 0.11*R;
% plot(taudir(1,:), taudir(2,:)+tau_off, 'k', 'linewidth', 1);
% arrow([taudir(1,end-1), taudir(2, end-1)+tau_off],...
%     [taudir(1,end)-0.01, taudir(2,end)+tau_off], 'Length',arwL,'TipAngle',arwA)
% text(-0.1, 0.075, '\tau\bf{c}\rm_3', 'fontsize', 14)


% Plot aerodynamic moment on blade in d1 direction
[AMx, AMy] = pol2cart(linspace(2*pi+5*pi/12, 7*pi/12), 0.07*R);
theta = pi/2.3;%pi/2.3;
R_z = [cos(theta), sin(theta), 0; -sin(theta), cos(theta), 0; 0, 0, 1];
R_xpitch = [1, 0, 0; 0,  cos(theta), sin(theta);
                0, -sin(theta), cos(theta)];
Rbeta3 = [cos(beta+pi/2), -sin(beta+pi/2), 0;sin(beta+pi/2), cos(beta+pi/2), 0; 0, 0, 1];
AMdir = Rbeta3*R_xpitch*[AMx; AMy; zeros(size(AMx))];
m_r = 0.995*r;
offst = 4*R/32;
plot(AMdir(1,:)+(m_r-e+offst)*cos(beta)+e, AMdir(2,:)+(m_r-e+offst)*sin(beta),...
    'k', 'linewidth', 1);
arrow([AMdir(1,end-1)+(m_r-e+offst)*cos(beta)+e, AMdir(2, end-1)+(m_r-e+offst)*sin(beta)],...
    [AMdir(1,end)+(m_r-e+offst)*cos(beta)+e, AMdir(2,end)+(m_r-e+offst)*sin(beta)]...
    , 'Length',arwL,'TipAngle',arwA)
text(0.79, 0.13, 'Pitching', 'fontsize', 14)

% % Plot torque from hub to rotate the blade
% [M_Hx, M_Hy] = pol2cart(linspace(-pi/6, -2*pi+pi/6), 0.035*R);
% M_Hdir = [M_Hx; M_Hy];
% plot(M_Hdir(1,:), M_Hdir(2,:), 'k', 'linewidth', 1);
% arrow([M_Hdir(1,end-10), M_Hdir(2, end-10)],...
%     [M_Hdir(1,end), M_Hdir(2,end)])
% text(-0.05, -0.04, '\bfM_{\rmH}', 'fontsize', 14)
% 
% % Plot constraint force on hub
% arrow([0, 0],[0, 0.06])
% text(-0.023, 0.015, '\bfF_{\rm\tau}', 'fontsize', 14)

% Label point P and point O
text(-0.11, 0.0, 'Hub', 'fontsize', 14)
text(e, -0.06, 'Hinge', 'fontsize', 14)
% text(b_e(1,1)+e-0.03, b_e(2,1)-0.025, 'P', 'fontsize', 14)
% text(Rx(2)*cos(beta)*0.9+e, Rx(2)*sin(beta)+0.01, 'Q', 'fontsize', 14)


axis equal
%}

%%%%%%%%%%%%%%%%
% Verify Eqns
% Angular momentum body derivatives (Omega_x_h is simple)
% pretty(diff(m*dr*(-(r-e)*e*sin(B)*W - (r-e)^2*0.5*sin(2*B)*W),t))
% pretty(diff(m*dr*(-(r-e)^2*diff(B,t) - (r-e)*e*cos(B)*diff(B,t)),t))
% pretty(diff(m*dr*((e+(r-e)*cos(B))^2*W),t))
