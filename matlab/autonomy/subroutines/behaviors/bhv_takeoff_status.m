function [completionFlag] = bhv_takeoff_status(stateEstimateMsg, ahs)
   disp('bhv_takeoff_status');
   
   %if takeOffComplete, switch on altitude control and return
   takeOffComplete = stateEstimateMsg.Up > ahs.desiredAltMeters;
   if takeOffComplete
      completionFlag = 1;
      return;
   end
   completionFlag = 0;
end

