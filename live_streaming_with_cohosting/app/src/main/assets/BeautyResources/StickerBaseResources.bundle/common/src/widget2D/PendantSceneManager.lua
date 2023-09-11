require "widget2D.PendantScene"

local PendantSceneManager = class("PendantSceneManager")

function PendantSceneManager:ctor()

    local start = os.time()

    self.curScene = nil
    self.director = cc.Director:getInstance()
    self.eventDispatcher = self.director:getEventDispatcher()

    local s = self
--    print("self.director", self.director)

    __onPendantStart = function(kiwiEngine)
        local startTime = os.time()
        if s.curScene ~= nil then
            s.curScene:finish()
        end
        s.curScene = require("widget2D.PendantScene"):create(kiwiEngine)
        local endTime = os.time()
        print ("__onPendantStart startcost :" , endTime - startTime)
    end

    __onPendantStop = function()
        print("__onPendantStop")
        if s.curScene ~= nil then
            s.curScene:finish()
            s.curScene = nil
        end
    end

    __onDestroy = function()
        print("__onDestroy")
        if s.curScene ~= nil then
            s:finish()
            s.curScene = nil
        end
    end

    local end1 = os.time()

    print ("PendantSceneManager startcost  :" , end1 - start)
end

function PendantSceneManager:finish()
    self.curScene:finish()
    self.eventDispatcher:removeAllEventListeners()
    self.Director:getInstance():End()

    self.curScene = nil
    self.eventDispatcher = nil
    self.director = nil
end

return PendantSceneManager
