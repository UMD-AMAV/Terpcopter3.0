function [completionFlag, stick_thrust] = bhv_takeoff_status(stateEstimateMsg, ahs, stick_thrust)
   disp('bhv_takeoff_status');
   maxTakeoffThrust = 0.1;
   
   %if takeOffComplete, switch on altitude control and return
   takeOffComplete = stateEstimateMsg.Up > ahs.desiredAltMeters;
   
   if takeOffComplete
      completionFlag = 1;
      return;
   end
   completionFlag = 0;
   
   if stick_thrust <= maxTakeoffThrust
        stick_thrust = stick_thrust + 0.01
   else 
      stick_thrust = maxTakeoffThrust
end

