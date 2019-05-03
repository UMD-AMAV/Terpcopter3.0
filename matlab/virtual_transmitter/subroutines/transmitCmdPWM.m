function transmitCmdPWM( trainerBox, pwm )

% conver u_stick_net to PWM 
channel1Command = pwm(1);  % throttle (up)
channel2Command = pwm(2);  % roll     (right)
channel3Command = pwm(3);  % pitch    (forward)
channel4Command = pwm(4);  % yaw
channel5Command = pwm(5);  % paylaod

% transmit to trainer box 
% change sign to reverse
fprintf(trainerBox,'a');
fprintf(trainerBox,int2str(channel1Command)); %channel1Command
fprintf(trainerBox,int2str(channel2Command));
fprintf(trainerBox,int2str(channel3Command));
fprintf(trainerBox,int2str(channel4Command));
fprintf(trainerBox,int2str(channel5Command));
fprintf(trainerBox,'z');
end

