function [completionFlag] = bhv_takeoff_status( stateEstimateMsg , ayprCmd , thresholdDist )
   disp('bhv_takeoff_status');
   
   zd = ayprCmd.AltDesiredMeters;
   z = stateEstimateMsg.Up;
   thresholdDist = 0.1;
   maxAltSafety = 5;
   
   if ( abs(z-zd) <= thresholdDist || z >= maxAltSafety ) % 5 m max cieling as safety
       completionFlag = 1;
   else
       completionFlag = 0;
   end

end

