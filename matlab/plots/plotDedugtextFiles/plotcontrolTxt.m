function [] = plotcontrolTxt
fileID = 'control.txt';

% [time y u_crab crabError stickCmdMsg.Roll x u_fwd]
A = load(fileID, '-ascii');

t = A(:,1);
y = A(:,2);
u_crab = A(:,3);
crabError = A(:,4);
stickRoll = A(:,5);

figure(1);
plot(t, crabError,'r'); hold on;
plot(t, u_crab,'g'); hold on;
plot(t, stickRoll,'b');

legend('crabError','ucrab','stickroll');
end
