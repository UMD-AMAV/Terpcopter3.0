function [val] = arrowToInt(src,event)
disp(event.Key);
global key_roll  key_pitch;
switch event.Key
    case 'leftarrow'
        key_roll = key_roll + 1;
    case 'uparrow'
        key_pitch = key_pitch + 1;
    case 'rightarrow'
        key_roll = key_roll - 1;
    case 'downarrow'
        key_pitch = key_pitch - 1;
end
plot([0 key_roll],[0 0],'bo-','Linewidth',2);
hold on;
plot([0 0],[0 key_pitch],'ro-','Linewidth',2);
lim = 15;
xlim([-lim lim]);
xticks([-lim:1:lim])
ylim([-lim lim]);
yticks([-lim:1:lim])
grid on;
hold off;
end