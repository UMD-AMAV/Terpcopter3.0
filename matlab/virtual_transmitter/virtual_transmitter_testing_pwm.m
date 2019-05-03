% prepare workspace
clear; close all; clc; format compact; clear all;

params = loadParams();
% Clear COM ports -----------------------
if ~isempty(instrfind())
    fclose(instrfind());
    delete(instrfind);
end

% if we are running in flight mode the connection to the transmitter
% through the trainer cable is initialized as follows:
foundComPort = false;
if ( strcmp(params.vtx.mode,'flight') )
    % avialable serial ports
    comlist = seriallist();
    for i = 1:size(comlist,2)
        if contains(comlist(i),'USB0')
            params.env.com_port = comlist(i);
            foundComPort = true;
            disp('Found USB COM port')
            break;
        end
    end
    if foundComPort == false
        disp('No USB COM Port found')
    elseif foundComPort == true
        trainerBox = serial(params.env.com_port);
        trainerBox.BaudRate = params.env.baud_rate;
        trainerBox.terminator = '';
        fopen(trainerBox);
        disp('com port initialised');
        disp(params.env.com_port)
    end
end

while(1)
    disp('---- Specify Command ----');
    pwm(1) = input('pwm(1): ');
    pwm(2) = input('pwm(2): ');
    pwm(3) = input('pwm(3): ');
    pwm(4) = input('pwm(4): ');
    pwm(5) = input('pwm(5): ');
    disp('Sending Command...');
    transmitCmdPWM( trainerBox, pwm )
end

0
