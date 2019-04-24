function completionFlag = bhv_fly_forward(completion, bhvTime )

    if bhvTime >= completion.durationSec
        completionFlag = 1;
        return;
    end
    completionFlag = 0;
end