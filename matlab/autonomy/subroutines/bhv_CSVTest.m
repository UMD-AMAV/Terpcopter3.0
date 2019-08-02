function [completionFlag, ayprCmd] = bhv_CSVTest(stateEstimateMsg, ayprCmd, completion, t)
    global timestamps
    global waypoint
    persistent k
    
    % Initialize Incrementing Variable k
    if isempty(k)
    k = 1;
    end
    
    % Initialize Current Waypoint
    ayprCmd.WaypointXDesiredMeters = waypoint.waypoint_x(k);
    ayprCmd.WaypointYDesiredMeters = waypoint.waypoint_y(k);
    ayprCmd.AltDesiredMeters = waypoint.waypoint_z(k);
    toleranceMeters = 0.25;
    
    % Completion Conditions
    waypointXComplete = abs(ayprCmd.WaypointXDesiredMeters - stateEstimateMsg.East) <= toleranceMeters;
    waypointYComplete = abs(ayprCmd.WaypointYDesiredMeters - stateEstimateMsg.North) <= toleranceMeters;
    hoverAltComplete = abs(ayprCmd.AltDesiredMeters - stateEstimateMsg.Up) <= toleranceMeters;
    % fprintf('Task: Hover at %f meters for %f seconds\n', ahs.desiredAltMeters, completion.durationSec);
    
    if hoverAltComplete && waypointXComplete && waypointYComplete
        disp('position hold satisfied');
        current_event_time = t; % reset time for which altitude is satisfied
    else
        disp('position hold not satisfied');
        current_event_time = t;
        timestamps.behavior_satisfied_timestamp = t;
    end
    
    % require vehicle to maintain altitude within envelope for durationSec
    elapsed_satisfied_time = current_event_time - timestamps.behavior_satisfied_timestamp;
    
    fprintf('Desired Altitude: %f meters\tCurrent Altitude %f meters\nDesired Time: %f\tElapsed time: %f\nDesired Position X: %f meters\tCurrent Position X: %f meters\nDesired Position Y: %f meters\tCurrent Position Y: %f meters\n', ayprCmd.AltDesiredMeters, stateEstimateMsg.Up, completion.durationSec, elapsed_satisfied_time,ayprCmd.WaypointXDesiredMeters, stateEstimateMsg.East,ayprCmd.WaypointYDesiredMeters, stateEstimateMsg.North);
    
    if elapsed_satisfied_time >= completion.durationSec
        k=k+1;
        if k == (waypoint.FinalWaypoint)
            completionFlag = 1;
            return;
        end
    end
    completionFlag = 0;
end