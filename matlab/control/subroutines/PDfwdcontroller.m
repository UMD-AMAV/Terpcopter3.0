function [u, fwdErrorHistory] = PDfwdcontroller(gains, fwdErrorHistory, currTime, Error)


dt = currTime - fwdErrorHistory.lastTime;
%fprintf("e: %6.2f \n",e);

eDot = (Error - fwdErrorHistory.lastVal) / dt;

%fprintf("eVel: %6.2f",eVel);

u = gains.kP * Error + gains.kD * eDot;

%fprintf("u: %6.3f",u);

fwdErrorHistory.lastTime = currTime;
fwdErrorHistory.lastVal = Error;

end