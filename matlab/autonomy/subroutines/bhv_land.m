function completionFlag = bhv_land(completion, bhvTime)

    if bhvTime >= completion.durationSec
        completionFlag = 1;
        return;
    end
    completionFlag = 0;
end