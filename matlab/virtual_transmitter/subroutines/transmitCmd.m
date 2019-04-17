function transmitCmd( trainerBox, u_stick_cmd, trim, stick_lim, trim_lim )

% default command is all zeros
u_stick_net = zeros(4,1);

% if u_stick_cmd element is Inf then we use the default zero command 
for i = 1:4
    if (u_stick_cmd(i) ~=inf)
        u_stick(i,1) = u_stick_cmd(i);
    end
end

for i = 1:4    
    if (trim(i) ~=inf)
        trim1(i,1) = trim(i);
    end 
    % u_stick is a value from -1 to +1
    % stick_lim = 100
    % trim_lim = 29
    % after multiplying by stick_lim, trim_lim the value ranges from
    % [-129,129]
    u_stick_net(i) = u_stick(i)*stick_lim(i) + trim1(i)*trim_lim(i);
    
    % divide each value by 129, to give result in -1, +1
    u_stick_net(i) = u_stick_net(i)/(stick_lim(i) + trim_lim(i));
    
    % saturate from -1 to +1, (AW: this step seems rendundant)
    % u_stick_net(i)= max(-1,min(1,u_stick_net(i)));
end

% conver u_stick_net to PWM 
channel1Command = 5000+ 4000*u_stick_net(1);  % throttle (up)
channel2Command = 5000+ 4000*u_stick_net(2);  % roll     (right)
channel3Command = 5000+ 4000*u_stick_net(3);  % pitch    (forward)
channel4Command = 5000+ 4000*u_stick_net(4);  % yaw

% transmit to trainer box 
% change sign to reverse
fprintf(trainerBox,'a');
fprintf(trainerBox,int2str(channel1Command)); %channel1Command
fprintf(trainerBox,int2str(channel2Command));
fprintf(trainerBox,int2str(channel3Command));
fprintf(trainerBox,int2str(channel4Command));
fprintf(trainerBox,'z');
end

