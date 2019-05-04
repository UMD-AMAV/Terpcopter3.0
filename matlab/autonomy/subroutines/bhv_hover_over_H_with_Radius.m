function [completionFlag, ayprCmd] = bhv_hover_over_H_with_Radius(stateEstimateMsg, ayprCmd, completion, bhvTime, hDetected, hAngle, hPixelX, hPixelY, t)
    
    % hDetected = 0 (no H detected) , 1 (H detected) 
    % hAngle = -180 to 180 (deg) 
    % hPixelX = -360 to 360 (pixels)
    % hPixelY = -640 to 640

    % unpack state estimate
    % pitch = stateEstimateMsg.PitchDegrees;
    % roll = stateEstimateMsg.RollDegrees;    
    % yaw = stateEstimateMsg.YawDegrees;
    
    
    % TODO: 
    % - add topic with H (x,y) data as input
    % - do some processing 
    
        % Persistent variables for the if H is not detected 
    persistent lastPixelX lastPixelY
    Kx = 0.00333/5;
    Ky = 0.00333/5;
    
    if isempty(lastPixelX)
        lastPixelX = 0;
        lastPixelY = 0;
        pitchDesired = Ky*lastPixelY;
        rollDesired = Kx*lastPixelX;
    else
        if ( hDetected )
            % yawDesired = yaw + hAngle;
            lastPixelX = hPixelX;
            lastPixelY = hPixelY;
            pitchDesired = Ky*hPixelY;
            rollDesired = Kx*hPixelX;
            %         time = bhvTime;
        else
             pitchDesired = Ky*lastPixelY;
             rollDesired = Kx*lastPixelX;
        end
    end
    % set ayprCmd
    % - set ayprCmdMsg.PitchDesiredDegrees = 0;
    % ayprCmd.YawDesiredDegrees = yawDesired;
    ayprCmd.PitchDesiredDegrees = pitchDesired;
    ayprCmd.RollDesiredDegrees = rollDesired;
    
    % Terminating condition
    radiusTolerancePixel = completion.acceptableRadiusPixels;
    radiusPixels = sqrt(hPixelX^2 + hPixelY^2);
    
    withinRadius = radiusPixels <= radiusTolerancePixel;
    
    if withinRadius
        disp('hover over H within radius satisfied');
        current_event_time = t;
    else
        disp('hover over H within radius satisfied');
        current_event_time = t;
        timestamps.behavior_satisfied_timestamp = t;
    end
    
    % require vehicle to maintain within radial distance from the H for durationSec
    elapsed_satisfied_time = current_event_time - timestamps.behavior_satisfied_timestamp;
    
    fprintf('Radius Threshold: %f pixels\t Current Radius %f pixels\nDesired Time: %f\tElapsed time: %f\n', radiusTolerancePixel,radiusPixels, completion.durationSec, elapsed_satisfied_time);
    if elapsed_satisfied_time >= completion.durationSec
        completionFlag = 1;
        return;
    end

    completionFlag = 0;
end 
        