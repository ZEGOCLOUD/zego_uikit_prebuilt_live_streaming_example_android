time = {}

function time.setTimeout(callback, time)
    local handle
    handle = cc.Director:getInstance():getScheduler():scheduleScriptFunc(
                 function()
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(handle)
            callback()
        end, time, false)

    return handle
end

function time.schedule(callback, time)
    local handle
    handle = cc.Director:getInstance():getScheduler():scheduleScriptFunc(
                 function()
            callback()
        end, time, false)

    return handle
end

function time.stopSchedul(handle)
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(handle)
end

return time
