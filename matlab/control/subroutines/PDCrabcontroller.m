function [u, crabErrorHistory] = PDCrabcontroller(gains, crabErrorHistory, currTime, Error)


dt = currTime - crabErrorHistory.lastTime;
%fprintf("e: %6.2f \n",e);

eDot = (Error - crabErrorHistory.lastVal) / dt;

%fprintf("eVel: %6.2f",eVel);

u = gains.kP * Error + gains.kD * eDot;

%fprintf("u: %6.3f",u);

crabErrorHistory.lastTime = currTime;
crabErrorHistory.lastVal = Error;


end