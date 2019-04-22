function completionFlag = bhv_hover_fixed_orient(stateEstimateMsg, ayprCmd, completion, t)
    % uses same status function as bhv_hover, only difference is that 
    % this behavior is initialzied with yaw,pitch,roll switches on and 
    % desired values (see mission script);
    completionFlag = bhv_hover(stateEstimateMsg, ayprCmd, completion, t);

end