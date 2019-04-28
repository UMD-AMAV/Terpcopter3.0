function completionFlag = bhv_fly_forward_until_target(completion, bhvTime, targetDet)

    if ( targetDet ) 
        completionFlag = 1;
        return;
    else
        completionFlag = 0;
    end
end