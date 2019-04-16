function [completionFlag, stick_thrust_land] = bhv_landing_open_status(stateEstimateMsg, ahs, completion)
   disp('bhv_land_open');
    
   landComplete = stateEstimateMsg.Up < ahs.desiredAltMeters;
   
   if landComplete
       completionFlag = 1;
       stick_thrust_land = -1;
       return;
   end
   
   stick_thrust_land = -0.15;
   completionFlag = 0;
end