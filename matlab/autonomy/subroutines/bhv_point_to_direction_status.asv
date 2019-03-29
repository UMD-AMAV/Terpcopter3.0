function completionFlag = bhv_point_to_direction_status(stateEstimateMsg, ahs, completion)
    toleranceRadians = 0.35; 
    yawDesiredRadians = deg2rad(ahs.desiredYawDegrees);
    
    pointToDirectionComplete = abs(yawDesiredRadians - stateEstimateMsg.Yaw) < tolerance;
    
    if pointToDirectionComplete
        completionFlag = 1;
        return;
    end
    completionFlag = 0;
end