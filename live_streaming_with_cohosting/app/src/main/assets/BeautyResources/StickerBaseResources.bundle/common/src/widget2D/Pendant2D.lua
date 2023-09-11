
require "cocos.init"
if not json then
    require "cocos.cocos2d.json"
end

local Pendant2D = class("Pendant2D")

function Pendant2D:ctor()

    self.index = 0
    self.mediaSprite = nil
    self.mediaSegment = nil
    self.mediaFaceSegment = nil
    self.faceData = nil

    self.animations = {}
    self.animationParams = {}
    self.triggers = {}
    self.triggersJson = {}
    self.nodesByFace = {}
    self.nodeFaceJson = {}
    self.medias = {}
    self.mediasJson = {}
    self.faceImages = {}
    self.faceImagesJson = {}
    self.scene = nil
    self.resIndex = 1

    self.supportETC1 = true
    self.state = nil
end

function Pendant2D:layoutChild(v, parent, child)
    local w = parent:getContentSize().width
    local h = parent:getContentSize().height

    local wc = child:getContentSize().width
    local hc = child:getContentSize().height

    if v.positionRate ~= nil then
        child:setPosition(w * v.positionRate.x, h * v.positionRate.y)
    end
    if v.scaleRate ~= nil then
        child:setScale(w / wc * v.scaleRate.x, h / hc * v.scaleRate.y)
    end
    if v.rotate ~=  nil then
        child:setRotation(v.rotate)
    end

    if v.anchor ~= nil then
        child:setAnchorPoint(cc.p(v.anchor.x, v.anchor.y))
    end
end

function Pendant2D:createChildren(params, parent)
    if params ~= nil and parent ~= nil then
        for k,v in pairs(params) do

            local data = {}
            if v.res ~= nil then
                data = self:parseJsonFile(string.format("%s/config.json", v.res))
                --print("config pic", data.pic)
                if data ~= nil and data.animation ~= nil then
                    self:createAnims(data.animation, v.res)
                end
            end

            if v.type == nil or v.type == "sprite" then
                local sp = cc.Sprite:create()
                local pic = string.format("%s/%s", v.res, data.pic)
                local filePath =  cc.FileUtils:getInstance():fullPathForFilename(pic)
                sp:setTexture(filePath)
                --sp:setLocalZOrder(constant.order.face + v.order)
                --sp:setGlobalZOrder(constant.order.face + v.order)
--                if self.supportETC1 == false then
--                    sp:setBlendFunc(cc.blendFunc(ccb.BlendFactor.SRC_ALPHA , ccb.BlendFactor.ONE_MINUS_SRC_ALPHA))
--                end
                if v.blend ~= nil and constant.blend[v.blend] ~= nil and constant.blend[v.blend] ~= 0 then
                    sp:setZegoBlendMode(constant.blend[v.blend])
                end

                self:layoutChild(v, parent, sp)
                parent:addChild(sp, v.order, v.name)
                if v.children ~= nil then
                    self:createChildren(v.children, sp)
                end

                -- filter背景， 与 分割结果
            elseif v.type == "media"  or v.type == "segment" or v.type == "faceSegment" then
                local info = nil
                if v.type == "media" then
                    info = self.mediaSprite
                elseif v.type == "segment" then
                    info = self.mediaSegment
                elseif v.type == "faceSegment" then
                    info = self.mediaFaceSegment
                end

                if info ~= nil then
                    local sp = cc.Sprite:createWithTextureID(info.texID, info.width, info.height)
--                    if self.supportETC1 == false then
--                        sp:setBlendFunc(cc.blendFunc(ccb.BlendFactor.SRC_ALPHA , ccb.BlendFactor.ONE_MINUS_SRC_ALPHA))
--                    end
                    if v.blend ~= nil and constant.blend[v.blend] ~= nil and constant.blend[v.blend] ~= 0 then
                        sp:setZegoBlendMode(constant.blend[v.blend])
                    end
                    if v.type == "media" then
--                        sp:setBlendFunc(cc.blendFunc(ccb.BlendFactor.ONE , ccb.BlendFactor.ZERO))
                    end
                    --sp:setLocalZOrder(constant.order.face + v.order)
                    --sp:setGlobalZOrder(constant.order.face + v.order)
                    self:layoutChild(v, parent, sp)
                    parent:addChild(sp, v.order, v.name)
                    if v.children ~= nil then
                        self:createChildren(v.children, sp)
                    end
                else
                    print("create media or segment is null", v.type)
                end

            elseif v.type == "particle" then
                local plist = string.format("%s/%s", v.res, data.plist)
                local filePath =  cc.FileUtils:getInstance():fullPathForFilename(plist)
                local emitter = cc.ParticleSystemQuad:create(filePath)
--                if self.supportETC1 == false then
--                    emitter:setBlendFunc(cc.blendFunc(ccb.BlendFactor.SRC_ALPHA , ccb.BlendFactor.ONE_MINUS_SRC_ALPHA))
--                end
                --emitter:setLocalZOrder(constant.order.face + v.order)
                --emitter:setGlobalZOrder(constant.order.face + v.order)
                self:layoutChild(v, parent, emitter)
                parent:addChild(emitter, v.order)
                if v.children ~= nil then
                    self:createChildren(v.children, emitter)
                end
            end
        end
    end

end

function Pendant2D:createWidget2Ds(params)
    for k,v in pairs(params) do
        local data = {}
        if v.res ~= nil then
            data = self:parseJsonFile(string.format("%s/config.json", v.res))
            --print("config pic", data.pic)
            if data ~= nil and data.animation ~= nil then
                self:createAnims(data.animation, v.res)
            end
        end

        -- sprite
        if v.type == nil or v.type == "sprite" then
            local sp = cc.Sprite:create()
            local pic = string.format("%s/%s", v.res, data.pic)
            local filePath =  cc.FileUtils:getInstance():fullPathForFilename(pic)
            sp:setTexture(filePath)
            sp:setVisible(v.visible )
            sp:setOpacity(v.opacity)

            --sp:setLocalZOrder(constant.order.face + v.order)
            sp:setGlobalZOrder(constant.order.face + v.order)
            --sp:setPositionZ(v.order)
            if v.blend ~= nil and constant.blend[v.blend] ~= nil and constant.blend[v.blend] ~= 0 then
                sp:setZegoBlendMode(constant.blend[v.blend])
            end
            --sp:setScale(v.scale.x, v.scale.y)
            sp:setAnchorPoint(cc.p(v.anchor.x, v.anchor.y))
            --sp:setRotation(v.rotate)
--            if self.supportETC1 == false then
--                sp:setBlendFunc(cc.blendFunc(ccb.BlendFactor.SRC_ALPHA , ccb.BlendFactor.ONE_MINUS_SRC_ALPHA))
--            end
            self.nodeFaceJson[v.name] = v
            self.nodesByFace[v.name] = sp
            --self.scene:addChild(sp, constant.order.face + v.order)
            self.scene:addChild(sp)
--            print("face + v.order ", constant.order.face + v.order)
            if v.children ~= nil then
                self:createChildren(v.children, sp)
            end

        -- filter背景， 与 分割结果
        elseif v.type == "media"  or v.type == "segment" or v.tyep == "faceSegment" then
            local info = nil
            if v.type == "media" then
                info = self.mediaSprite
            elseif v.type == "segment" then
                info = self.mediaSegment
            elseif v.type == "faceSegment" then
                info = self.mediaFaceSegment
            end

            if info ~= nil then
                local sp = cc.Sprite:createWithTextureID(info.texID,
                        info.width, info.height)
                sp:setVisible(v.visible )
                sp:setOpacity(v.opacity)
                --sp:setLocalZOrder(constant.order.face + v.order)
                if v.type == "media" then
--                    sp:setBlendFunc(cc.blendFunc(ccb.BlendFactor.ONE , ccb.BlendFactor.ZERO))
                end
                sp:setGlobalZOrder(constant.order.face + v.order)
                --sp:setPositionZ(v.order)
                if v.blend ~= nil and constant.blend[v.blend] ~= nil and constant.blend[v.blend] ~= 0 then
                    sp:setZegoBlendMode(constant.blend[v.blend])
                end
--                if self.supportETC1 == false then
--                    sp:setBlendFunc(cc.blendFunc(ccb.BlendFactor.SRC_ALPHA , ccb.BlendFactor.ONE_MINUS_SRC_ALPHA))
--                end
                sp:setAnchorPoint(cc.p(v.anchor.x, v.anchor.y))
                self.nodeFaceJson[v.name] = v
                self.nodesByFace[v.name] = sp
                --self.scene:addChild(sp, constant.order.face + v.order)
                self.scene:addChild(sp)
                if v.children ~= nil then
                    self:createChildren(v.children, sp)
                end
            else
                print("create media or segment is null", v.type)
            end

        elseif v.type == "particle" then

            local plist = string.format("%s/%s", v.res, data.plist)
            local filePath =  cc.FileUtils:getInstance():fullPathForFilename(plist)
            local emitter = cc.ParticleSystemQuad:create(filePath)

            emitter:setVisible(v.visible)
            --emitter:setLocalZOrder(constant.order.face + v.order)
            emitter:setGlobalZOrder(constant.order.face + v.order)
            --emitter:setPositionZ(v.order)
--            if self.supportETC1 == false then
--                emitter:setBlendFunc(cc.blendFunc(ccb.BlendFactor.SRC_ALPHA , ccb.BlendFactor.ONE_MINUS_SRC_ALPHA))
--            end
            emitter:setAnchorPoint(cc.p(v.anchor.x, v.anchor.y))

            self.nodeFaceJson[v.name] = v
            self.nodesByFace[v.name] = emitter
            --self.scene:addChild(emitter, constant.order.face + v.order)
            self.scene:addChild(emitter)
            if v.children ~= nil then
                self:createChildren(v.children, emitter)
            end
        elseif v.type == "video" then
            local videoplayer = cc.VideoPlayer:create()
            local video = string.format("%s/%s", v.res, data.video.file)
            local filePath =  cc.FileUtils:getInstance():fullPathForFilename(video)
            --local filePathTexture =  cc.FileUtils:getInstance():fullPathForFilename(v.texture)
            videoplayer:initPlayer(0, v.video_width, v.video_height)

            if data.video.loop ~= nil then
                videoplayer:setLooping(data.video.loop)
            end
            --videoplayer:setTexture(filePathTexture)
            videoplayer:setFileName(filePath)
            videoplayer:setAlphaMode(v.alpha_mode)
--            if self.supportETC1 == false then
--                videoplayer:setBlendFunc(cc.blendFunc(ccb.BlendFactor.SRC_ALPHA , ccb.BlendFactor.ONE_MINUS_SRC_ALPHA))
--            end

            if v.blend ~= nil and constant.blend[v.blend] ~= nil and constant.blend[v.blend] ~= 0 then
                videoplayer:setZegoBlendMode(constant.blend[v.blend])
            end

            videoplayer:play()

            videoplayer:setVisible(v.visible)
            videoplayer:setOpacity(v.opacity)
            --videoplayer:setLocalZOrder(constant.order.face + v.order)
            videoplayer:setGlobalZOrder(constant.order.face + v.order)

            videoplayer:setAnchorPoint(cc.p(v.anchor.x, v.anchor.y))
            self.nodeFaceJson[v.name] = v
            self.nodesByFace[v.name] = videoplayer
            --self.scene:addChild(videoplayer, constant.order.face + v.order)
            self.scene:addChild(videoplayer)
            if v.children ~= nil then
                self:createChildren(v.children, videoplayer)
            end

        end

    print("pendant createWidget2Ds", v.name, self.nodesByFace[v.name])
    end
end

function Pendant2D:createTrigger(params)
    for k, v in pairs(params) do
        self.triggers[v.event] = v.actions
        print("pendant trigger ", v.event, v)
    end
end

function Pendant2D:createAnims(params, dir)
    for k, v in pairs(params) do
        if self.supportETC1 == true then
            local plist = string.format("%s/%s.plist", dir, v.res)
            --local pkm = string.format("%s.pkm", v.res)

            cc.SpriteFrameCache:getInstance():addSpriteFrames(plist)
            local animFrames = { }

            for i = 0, v.num do
                local str = string.format("%s%02d.png", v.res, i)
                if cc.SpriteFrameCache:getInstance():getSpriteFrame(str) ~= nil then
                    animFrames[i] = cc.SpriteFrameCache:getInstance():getSpriteFrame(str);
                end

                if animFrames[i] == nil then
                    str = string.format("%s%03d.png", v.res, i)
                    if cc.SpriteFrameCache:getInstance():getSpriteFrame(str) ~= nil then
                        animFrames[i] = cc.SpriteFrameCache:getInstance():getSpriteFrame(str);
                    end
                end
            end

            local animation = cc.Animation:createWithSpriteFrames(animFrames, v.interval)

            --创建Animation (帧table，播放间隔 )
            if v.loop ~= nil and v.loop < 0 then
                animation:setLoops(999999)
            else
                animation:setLoops(v.loop)
            end
            animation:setDelayPerUnit(v.interval)
            --创建Animate
            local animate = cc.Animate:create(animation)
            animate:retain()
            self.animations[v.name] = animate
            v.tmpFrame = 0
            self.animationParams[v.name] = v
        else
            local animation = cc.Animation:create()
            local p = string.format("%s/%s", dir, v.res)
            local path =  cc.FileUtils:getInstance():fullPathForDirectory(dir)
            local files =  cc.FileUtils:getInstance():listFiles(path)
            table.sort(files)
            for k,v in pairs(files) do
                if k ~= 1 and k ~= 2 and cc.FileUtils:getInstance():getFileExtension(v) == ".png" then  --去掉 . 和 ..
                    animation:addSpriteFrameWithFile(v);
                end
            end

            --创建Animation (帧table，播放间隔 )
            if v.loop ~= nil and  v.loop < 0 then
                animation:setLoops(999999)
            else
                animation:setLoops(v.loop)
            end
            animation:setDelayPerUnit(v.interval)
            --创建Animate
            local animate = cc.Animate:create(animation)
            animate:retain()
            self.animations[v.name] = animate
            v.tmpFrame = 0
            self.animationParams[v.name] = v
        end
        print("pendant animate ", v.name, self. animations[v.name])
    end
end

function Pendant2D:parseJsonFile(file)
    local filePath =  cc.FileUtils:getInstance():fullPathForFilename(file)

    print("Pendant2D parseJsonFile start ", filePath)
    local f = io.open(filePath, "r" )
    if f ~= nil then
        local t = f:read( "*all" )
        f:close()
        if nil ~= t and "" ~= t then
            local jsonData = json.decode(t, 1)
            if jsonData == nil then
                print("pendant Json error")
            end

            return jsonData
        else
            print("pendant data was empty")
        end
    else
        print("parseJsonFile open file error ", file)
    end
    return nil
end

function Pendant2D:onCreate()

end

function Pendant2D:onFinish()

end

function Pendant2D:finish()
    for k, v in pairs(self.animations) do
        v:release()
    end

    for k, v in pairs(self.nodesByFace) do
        self.scene:removeChild(v, true)
    end
end

return Pendant2D