require "widget2D.PendantSceneManager"


function main()
    print("start PendantSceneManager")
    local startTime = os.time()
    local PendantSceneManager = require("widget2D.PendantSceneManager"):create()
    local endTime = os.time()
    print ("main startcost :" , endTime - startTime)
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end