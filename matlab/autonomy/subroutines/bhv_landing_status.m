function [completionFlag, initialize, ahsUpdate] = bhv_landing_status(stateEstimateMsg, ahs, completion, t, init)
   disp('bhv_landing_status');
   global timestamps
   toleranceMeters = 0.05;
   
   %if landComplete, return
   landComplete = stateEstimateMsg.Up <= completion.landingAltMeters;
   if landComplete
      completionFlag = 1;
      return;
   end

   if init.firstLoop == 1
       ahsUpdate = stateEstimateMsg.Up - completion.altitudeIncrementMeters;
       initialize = 0;
       display(ahsUpdate);
   else 
       initialize = 0;
       
       ahsUpdate = ahs.desiredAltMeters;
       landingAltHoverComplete = abs(ahs.desiredAltMeters - stateEstimateMsg.Up) < toleranceMeters;
       
       if landingAltHoverComplete
           current_event_time = t;
       else
           current_event_time = t;
           timestamps.behavior_satisfied_timestamp = t;
       end
       elapsed_satisfied_time = current_event_time - timestamps.behavior_satisfied_timestamp;

       fprintf('Desired Altitude: %f meters\tCurrent Altitude %f meters\nDesired Time: %f\tElapsed time: %f\n', ahs.desiredAltMeters, stateEstimateMsg.Up, completion.durationSec,elapsed_satisfied_time);
       if elapsed_satisfied_time >= completion.durationSec
            ahsUpdate = stateEstimateMsg.Up - completion.altitudeIncrementMeters;
       end  
   end
   completionFlag = 0;
end
