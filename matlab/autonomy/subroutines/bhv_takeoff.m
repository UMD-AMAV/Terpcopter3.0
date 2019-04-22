function [completionFlag] = bhv_takeoff( stateEstimateMsg , ayprCmd )
   disp('bhv_takeoff_status');
   
   zd = ayprCmd.AltDesiredMeters;
   z = stateEstimateMsg.Up;
   thresholdDist = 0.1;
   maxAltSafety = 5;
   
   % complete if desired altitude is reached within threshold
   if ( abs(z-zd) <= thresholdDist || z >= maxAltSafety ) % 5 m max cieling as safety
       completionFlag = 1;
   else
       completionFlag = 0;
   end

end

