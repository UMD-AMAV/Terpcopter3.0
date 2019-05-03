clear all;
close all;
clc;

h_fig = figure;
global key_roll key_pitch;
% initialize
key_roll = 0;
key_pitch = 0;
set(h_fig,'KeyPressFcn',@arrowToInt);
set(gcf, 'Position',  [100, 100, 300, 50])
text(0.1,0.4,'Keystroke Capture','FontSize',16);
while(1)
    key_roll
    key_pitch
    pause(0.2);
end