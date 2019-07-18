%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make plots for free-flight tests
% Will Craig
% 12/06/18
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd '/Users/willcraig/Documents/University of Maryland/CDCL Research/CDCL Research Matlab/Mocap OL'

load('Processed_Data/181205_FFon_5g_2.mat')
FFon.time = time;
FFon.attitude = attitude;
FFon.position = [x_obsv_match, y_obsv_match, z_obsv_match];
FFon.inputs = [thrust, roll_in, pitch_in, yaw_in];
FFon.flow = flow;
FFon.rates = gyro;
FFon.velocity = [u_obsv_match, v_obsv_match, w_obsv_match];
clearvars -except FFon

load('Processed_Data/181205_FFoff_5g.mat')
FFoff.time = time;
FFoff.attitude = attitude;
FFoff.position = [x_obsv_match, y_obsv_match, z_obsv_match];
FFoff.inputs = [thrust, roll_in, pitch_in, yaw_in];
FFoff.flow = flow;
FFoff.rates = gyro;
FFoff.velocity = [u_obsv_match, v_obsv_match, w_obsv_match];
clearvars -except FFon FFoff

load('Processed_Data/181205_CF_5g.mat')
CF.time = time;
CF.attitude = attitude;
CF.position = [x_obsv_match, y_obsv_match, z_obsv_match];
CF.inputs = [thrust, roll_in, pitch_in, yaw_in];
CF.flow = flow;
CF.rates = gyro;
CF.velocity = [u_obsv_match, v_obsv_match, w_obsv_match];
clearvars -except FFon FFoff CF


figure(1), clf, hold on
plot(FFon.flow(:,1)), plot(FFoff.flow(:,1)), plot(CF.flow(:,1))
legend('FFon', 'FFoff', 'CF')

% Time matching effort
FFon.idx  = find(FFon.flow(:,1)<-2000,1);
FFoff.idx = find(FFoff.flow(:,1)<-2000,1);
CF.idx    = find(CF.flow(:,1)<-2000,1);

lowval = min([FFon.idx,FFoff.idx,CF.idx]);

FFon.offset  = FFon.idx - lowval + 10;
FFoff.offset = FFoff.idx - lowval + 10;
CF.offset    = CF.idx - lowval + 10;

% Apply offset
FFon.time       = FFon.time(FFon.offset:end,:) - FFon.time(FFon.offset);
FFon.attitude   = FFon.attitude(FFon.offset:end,:);
FFon.position   = FFon.position(FFon.offset:end,:);
FFon.inputs     = FFon.inputs(FFon.offset:end,:);
FFon.flow       = FFon.flow(FFon.offset:end,:);
FFon.rates      = FFon.rates(FFon.offset:end,:);
FFon.velocity   = FFon.velocity(FFon.offset:end,:);

FFoff.time      = FFoff.time(FFoff.offset:end,:) - FFoff.time(FFoff.offset);
FFoff.attitude  = FFoff.attitude(FFoff.offset:end,:);
FFoff.position  = FFoff.position(FFoff.offset:end,:);
FFoff.inputs    = FFoff.inputs(FFoff.offset:end,:);
FFoff.flow      = FFoff.flow(FFoff.offset:end,:);
FFoff.rates     = FFoff.rates(FFoff.offset:end,:);
FFoff.velocity  = FFoff.velocity(FFoff.offset:end,:);

CF.time         = CF.time(CF.offset:end,:) - CF.time(CF.offset);
CF.attitude     = CF.attitude(CF.offset:end,:);
CF.position     = CF.position(CF.offset:end,:);
CF.inputs       = CF.inputs(CF.offset:end,:);
CF.flow         = CF.flow(CF.offset:end,:);
CF.rates        = CF.rates(CF.offset:end,:);
CF.velocity     = CF.velocity(CF.offset:end,:);

figure(2), clf, hold on
plot(FFon.flow(:,1)), plot(FFoff.flow(:,1)), plot(CF.flow(:,1))
legend('FFon', 'FFoff', 'CF')

minlength = min([length(FFon.time), length(FFoff.time), length(CF.time)]);

meanflow = mean([FFon.flow(1:minlength,1), FFoff.flow(1:minlength,1), CF.flow(1:minlength,1)],2);
plot(meanflow,'linewidth',2)

% get x-y total position error
FFon.pos_err    = sqrt((FFon.position(1:minlength,1)-1).^2 + (FFon.position(1:minlength,2)-(-0.5)).^2);
FFoff.pos_err   = sqrt((FFoff.position(1:minlength,1)-1).^2 + (FFoff.position(1:minlength,2)-(-0.5)).^2);
CF.pos_err      = sqrt((CF.position(1:minlength,1)-1).^2 + (CF.position(1:minlength,2)-(-0.5)).^2);

% Getting the actual plots together
figure(3), clf, hold on
subplot(2,1,1), hold on, plot(FFon.time(1:minlength), FFon.position(1:minlength,1)-1,'linewidth',2)
plot(FFoff.time(1:minlength), FFoff.position(1:minlength,1)-1,'linewidth',2)
plot(CF.time(1:minlength), CF.position(1:minlength,1)-1,'linewidth',2)
xlabel('Time, s', 'interpreter','latex')
ylabel('$\textbf{e}_1$ Position, m', 'interpreter','latex')
set(gca, 'FontSize',18); box on, grid on
legend('Flow Feedback On', 'Flow Feedback Off', 'PID')
subplot(2,1,2), plot(FFon.time(1:minlength), meanflow/1000, 'linewidth', 2)
xlabel('Time, s', 'interpreter','latex')
ylabel('Flow Speed, m/s', 'interpreter','latex')
set(gca, 'FontSize',18); box on, grid on

figure(5), clf, hold on
subplot(2,1,1), hold on, plot(FFon.time(1:minlength), FFon.pos_err(1:minlength,1),'linewidth',2)
plot(FFoff.time(1:minlength), FFoff.pos_err(1:minlength,1),'linewidth',2)
plot(CF.time(1:minlength), CF.pos_err(1:minlength,1),'linewidth',2)
xlabel('Time, s', 'interpreter','latex')
ylabel('Pos. Error Norm, m', 'interpreter','latex')
set(gca, 'FontSize',18); box on, grid on
legend('Flow Feedback On', 'Flow Feedback Off', 'PID')
subplot(2,1,2), plot(FFon.time(1:minlength), meanflow/1000, 'linewidth', 2)
xlabel('Time, s', 'interpreter','latex')
ylabel('Flow Speed, m/s', 'interpreter','latex')
set(gca, 'FontSize',18); box on, grid on

arwL = 10;
arwA = 25;
fntsz = 14;
axfnt = 17;

figure(4), clf, hold on
plot(FFon.position(1:minlength,1)-1, FFon.position(1:minlength,2)-(-0.5), 'linewidth',2)
plot(FFoff.position(1:minlength,1)-1, FFoff.position(1:minlength,2)-(-0.5), 'linewidth',2)
plot(CF.position(1:minlength,1)-1, CF.position(1:minlength,2)-(-0.5), 'linewidth',2)
arrow([0.45, 0, 0], [0.25,0,0], 'Length',arwL,'TipAngle',arwA, 'width', 2);
text(0.4, 0.08, 0,'^{B}\bf{V}{_{O}}',...
    'HorizontalAlignment','right', 'fontsize', fntsz)
xlabel('$\textbf{e}_1$ Position, m', 'interpreter','latex')
ylabel('$\textbf{e}_2$ Position, m', 'interpreter','latex')
xlim(0.85*[-1 1]), ylim(0.85*[-1 1]), axis square
legend('Flow Feedback On', 'Flow Feedback Off', 'PID')
set(gca, 'FontSize',18); box on, grid on

FFon.rms    = sqrt((1/minlength)*sum((FFon.pos_err).^2));
FFoff.rms   = sqrt((1/minlength)*sum((FFoff.pos_err).^2));
CF.rms      = sqrt((1/minlength)*sum((CF.pos_err).^2));

