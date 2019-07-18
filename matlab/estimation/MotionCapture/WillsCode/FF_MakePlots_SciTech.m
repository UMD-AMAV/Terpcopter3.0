%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make plots for free-flight tests
% Will Craig
% 12/06/18
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd '/Users/willcraig/Documents/University of Maryland/CDCL Research/CDCL Research Matlab/Mocap OL'

%2g_1 for all 2 second tests, 5gz_2 for all 5 second tests
test = 2;

if test == 2
    load('Processed_Data/181207_FFon_2g_1.mat') 
elseif test == 5
    load('Processed_Data/181207_FFon_5gz_2.mat') 
end
FFon.time = time;
FFon.attitude = attitude;
FFon.position = [x_obsv_match, y_obsv_match, z_obsv_match];
FFon.inputs = [thrust, roll_in, pitch_in, yaw_in];
FFon.flow = flow;
FFon.rates = gyro;
FFon.velocity = [u_obsv_match, v_obsv_match, w_obsv_match];
clearvars -except FFon test

if test == 2
    load('Processed_Data/181207_FFoff_2g_1.mat')
elseif test == 5
    load('Processed_Data/181207_FFoff_5gz_2.mat')
end
FFoff.time = time;
FFoff.attitude = attitude;
FFoff.position = [x_obsv_match, y_obsv_match, z_obsv_match];
FFoff.inputs = [thrust, roll_in, pitch_in, yaw_in];
FFoff.flow = flow;
FFoff.rates = gyro;
FFoff.velocity = [u_obsv_match, v_obsv_match, w_obsv_match];
clearvars -except FFon FFoff test

if test == 2
    load('Processed_Data/181207_CF_2g_1.mat')
elseif test == 5
    load('Processed_Data/181207_CF_5g_2.mat')
end
CF.time = time;
CF.attitude = attitude;
CF.position = [x_obsv_match, y_obsv_match, z_obsv_match];
CF.inputs = [thrust, roll_in, pitch_in, yaw_in];
CF.flow = flow;
CF.rates = gyro;
CF.velocity = [u_obsv_match, v_obsv_match, w_obsv_match];
clearvars -except FFon FFoff CF test

xoff        = 1;
yoff        = -0.4; % offsets from zero position in motion capture
sample_rate = 250; % Hz
if test == 2
    sample0 = 4*sample_rate; % 4 for 2g, 5 for 5g
elseif test == 5
    sample0 = 5*sample_rate; % 4 for 2g, 5 for 5g
end
sampleend   = 44.6*sample_rate;
plotlength = 38.3;

arwL = 10;
arwA = 25;
fntsz = 14;
axfnt = 17;

plotlims = 0.7;

colors = get(gca,'ColorOrder'); clear c
c(1,:) = colors(1,:);
c(2,:) = colors(2,:);
c(3,:) = colors(3,:);
c(4,:) = colors(5,:);
c(5,:) = colors(6,:);

figure(1), clf, hold on
plot(FFon.flow(:,1)), plot(FFoff.flow(:,1)), plot(CF.flow(:,1))
legend('FFon', 'FFoff', 'CF')

% Time matching effort
FFon.idx  = find(FFon.flow(:,1)<-3000,1);
FFoff.idx = find(FFoff.flow(:,1)<-3000,1);
CF.idx    = find(CF.flow(:,1)<-3000,1);

lowval = min([FFon.idx,FFoff.idx,CF.idx]);

FFon.offset  = FFon.idx - lowval + sample0;
FFoff.offset = FFoff.idx - lowval + sample0;
CF.offset    = CF.idx - lowval + sample0;

% Apply offset
FFon.time       = FFon.time(FFon.offset:sampleend,:) - FFon.time(FFon.offset);
FFon.attitude   = FFon.attitude(FFon.offset:sampleend,:);
FFon.position   = FFon.position(FFon.offset:sampleend,:);
FFon.inputs     = FFon.inputs(FFon.offset:sampleend,:);
FFon.flow       = FFon.flow(FFon.offset:sampleend,:);
FFon.rates      = FFon.rates(FFon.offset:sampleend,:);
FFon.velocity   = FFon.velocity(FFon.offset:sampleend,:);

FFoff.time      = FFoff.time(FFoff.offset:sampleend,:) - FFoff.time(FFoff.offset);
FFoff.attitude  = FFoff.attitude(FFoff.offset:sampleend,:);
FFoff.position  = FFoff.position(FFoff.offset:sampleend,:);
FFoff.inputs    = FFoff.inputs(FFoff.offset:sampleend,:);
FFoff.flow      = FFoff.flow(FFoff.offset:sampleend,:);
FFoff.rates     = FFoff.rates(FFoff.offset:sampleend,:);
FFoff.velocity  = FFoff.velocity(FFoff.offset:sampleend,:);

CF.time         = CF.time(CF.offset:sampleend,:) - CF.time(CF.offset);
CF.attitude     = CF.attitude(CF.offset:sampleend,:);
CF.position     = CF.position(CF.offset:sampleend,:);
CF.inputs       = CF.inputs(CF.offset:sampleend,:);
CF.flow         = CF.flow(CF.offset:sampleend,:);
CF.rates        = CF.rates(CF.offset:sampleend,:);
CF.velocity     = CF.velocity(CF.offset:sampleend,:);

figure(2), clf, hold on
plot(FFon.flow(:,1)), plot(FFoff.flow(:,1)), plot(CF.flow(:,1))
legend('FFon', 'FFoff', 'CF')

minlength = min([length(FFon.time), length(FFoff.time), length(CF.time)]);

meanflow = mean([FFon.flow(1:minlength,1), FFoff.flow(1:minlength,1), CF.flow(1:minlength,1)],2);
plot(meanflow,'linewidth',2)

% get x-y total position error
FFon.pos_err    = sqrt((FFon.position(1:minlength,1)-xoff).^2 + (FFon.position(1:minlength,2)-yoff).^2);
FFoff.pos_err   = sqrt((FFoff.position(1:minlength,1)-xoff).^2 + (FFoff.position(1:minlength,2)-yoff).^2);
CF.pos_err      = sqrt((CF.position(1:minlength,1)-xoff).^2 + (CF.position(1:minlength,2)-yoff).^2);

% Getting the actual plots together
TSfig = figure(3); clf, hold on
subplot(2,1,1), hold on, 
cffig = plot(CF.time(1:minlength), CF.position(1:minlength,1)-xoff,'linewidth',2, 'color', c(3,:));
offfig = plot(FFoff.time(1:minlength), FFoff.position(1:minlength,1)-xoff,'linewidth',2, 'color', c(2,:));
onfig = plot(FFon.time(1:minlength), FFon.position(1:minlength,1)-xoff,'linewidth',2, 'color', c(1,:));
xlabel('Time, s', 'interpreter','latex')
ylabel('$\textbf{e}_1$ Position, m', 'interpreter','latex')
set(gca, 'FontSize',16); box on, grid on
lgd = legend([onfig, offfig, cffig], 'Flow Feedback On: SO(3) Control', 'Flow Feedback Off: SO(3) Control', 'Flow Feedback Off: PID Control');
xlim([0 plotlength]), ylim(plotlims*[-1 1])
rect = [0.195, 0.87, 0.1, 0.1];
set(lgd, 'Position', rect)
set(TSfig,'Position',[1 285 1158 420])

subplot(2,1,2), plot(FFon.time(1:minlength), meanflow/1000, 'linewidth', 2)
xlabel('Time, s', 'interpreter','latex')
ylabel('Flow Velocity, m/s', 'interpreter','latex')
xlim([0 plotlength]), ylim([-5 1])
set(gca, 'FontSize',16); box on, grid on

figure(4), clf, hold on
subplot(2,1,1), hold on, plot(FFon.time(1:minlength), FFon.pos_err(1:minlength,1),'linewidth',2)
plot(FFoff.time(1:minlength), FFoff.pos_err(1:minlength,1),'linewidth',2)
plot(CF.time(1:minlength), CF.pos_err(1:minlength,1),'linewidth',2)
xlabel('Time, s', 'interpreter','latex')
ylabel('Pos. Error Norm, m', 'interpreter','latex')
set(gca, 'FontSize',18); box on, grid on
legend('Flow Feedback On', 'Flow Feedback Off', 'PID')
subplot(2,1,2), plot(FFon.time(1:minlength), -meanflow/1000, 'linewidth', 2)
xlabel('Time, s', 'interpreter','latex')
ylabel('Flow Speed, m/s', 'interpreter','latex')
set(gca, 'FontSize',18); box on, grid on


XYZfig = figure(5); clf, hold on
subplot(1,2,1), hold on
cffig2 = plot(CF.position(1:minlength,1)-xoff, CF.position(1:minlength,2)-yoff, 'linewidth',2, 'color', c(3,:));
offfig2 = plot(FFoff.position(1:minlength,1)-xoff, FFoff.position(1:minlength,2)-yoff, 'linewidth',2, 'color', c(2,:));
onfig2 = plot(FFon.position(1:minlength,1)-xoff, FFon.position(1:minlength,2)-yoff, 'linewidth',2, 'color', c(1,:));
xlabel('$\textbf{e}_1$ Position, m', 'interpreter','latex')
ylabel('$\textbf{e}_2$ Position, m', 'interpreter','latex')
xlim(plotlims*[-1 1]), ylim(plotlims*[-1 1]), axis equal
set(gca, 'FontSize',18); box on, grid on
xlim(plotlims*[-1 1]), ylim(plotlims*[-1 1])%, axis equal
arrow([0.6, 0.000, 0], [0.4,0.000,0], 'Length',arwL,'TipAngle',arwA, 'width', 2);
text(0.55, 0.04, 0,'$\bf{V}_\infty$',...
    'HorizontalAlignment','right', 'fontsize', fntsz,'interpreter','latex')
legend([onfig2, offfig2, cffig2], 'Flow Feedback On: SO(3) Control', 'Flow Feedback Off: SO(3) Control', 'Flow Feedback Off: PID Control');

subplot(1,2,2), hold on
plot(CF.position(1:minlength,1)-xoff,CF.position(1:minlength,3),'linewidth',2, 'color', c(3,:))
plot(FFoff.position(1:minlength,1)-xoff,FFoff.position(1:minlength,3),'linewidth',2, 'color', c(2,:))
plot(FFon.position(1:minlength,1)-xoff,FFon.position(1:minlength,3),'linewidth',2, 'color', c(1,:))
xlabel('$\textbf{e}_1$ Position, m', 'interpreter','latex')
ylabel('$\textbf{e}_3$ Position, m', 'interpreter','latex')
xlim(0.7*[-1 1]), ylim(0.7*[0 2]), axis equal
set(gca, 'FontSize',18); box on, grid on
xlim(plotlims*[-1 1]), ylim(plotlims*[0 2])%, axis equal
set(XYZfig,'Position',[41 114 1117 459])
arrow([0.6, 1, 0], [0.4,1,0], 'Length',arwL,'TipAngle',arwA, 'width', 2);
text(0.55, 1.04, 0,'$\bf{V}_\infty$',...
    'HorizontalAlignment','right', 'fontsize', fntsz, 'interpreter','latex')


figure(6), clf, hold on
plot3(FFon.position(1:minlength,1)-xoff, FFon.position(1:minlength,2)-yoff, FFon.position(1:minlength,3),'linewidth',2)
plot3(FFoff.position(1:minlength,1)-xoff, FFoff.position(1:minlength,2)-yoff, FFoff.position(1:minlength,3),'linewidth',2)
plot3(CF.position(1:minlength,1)-xoff, CF.position(1:minlength,2)-yoff, CF.position(1:minlength,3),'linewidth',2);hold on

zlim([-.02,1.5])
daspect([1,1,1])
angc= linspace(0,2*pi,50); angc(end+1)= angc(1); 
plot3(cos(angc),sin(angc),ones(size(angc))*rref(3),'--','color',[.5,.5,.5],'linewidth',1)
% plot(cos(angc),sin(angc),'--','color',[.5,.5,.5],'linewidth',1)
grid on
xlabel('x')
ylabel('y')
axis equal

FFon.rms    = sqrt((1/minlength)*sum((FFon.pos_err).^2));
FFoff.rms   = sqrt((1/minlength)*sum((FFoff.pos_err).^2));
CF.rms      = sqrt((1/minlength)*sum((CF.pos_err).^2));

