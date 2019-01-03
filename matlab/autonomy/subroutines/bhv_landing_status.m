function [completionFlag] = bhv_landing_status(stateEstimateMsg, ahs)
   disp('bhv_landing_status');
   
   %if landComplete, return
   landComplete = stateEstimateMsg.Up <= ahs.desiredAltMeters;
   if landComplete
      completionFlag = 1;
      return;
   end
   completionFlag = 0;
end
