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
    u_stick_cmd(1) = input('u_stick_cmd(1): ');
    u_stick_cmd(2) = input('u_stick_cmd(2): ');
    u_stick_cmd(3) = input('u_stick_cmd(3): ');
    u_stick_cmd(4) = input('u_stick_cmd(4): ');
    u_stick_cmd(5) = input('u_stick_cmd(5): ');
    trim_val(1) = input('trim_val(1): ');
    trim_val(2) = input('trim_val(2): ');
    trim_val(3) = input('trim_val(3): ');
    trim_val(4) = input('trim_val(4): ');
    trim_val(5) = input('trim_val(5): ');
    disp('Sending Command...');
    transmitCmd( trainerBox, u_stick_cmd, trim_val, params.vtx.stick_lim, params.vtx.trim_lim );
end

0
