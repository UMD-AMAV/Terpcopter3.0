function [u, error] = PID(gains, error, newTime, newVal)
dt = newTime - error.lastTime;
edot = (newVal - error.lastVal) / dt;
error.lastSum = error.lastSum + newVal*dt;
u = - gains.kp * newVal - gains.kd * edot - gains.ki * error.lastSum;
error.lastTime = newTime;
error.lastVal = newVal;
end
