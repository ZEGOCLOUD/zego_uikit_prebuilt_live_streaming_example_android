if not json then
    require "cocos.cocos2d.json"
end

require "config"
require "cocos.init"
require "util"
local util3d = require "util3d"

-- zego = {
--     mediaInfo = nil,
--     segmentInfo = nil,
--     faceInfos = nil, -- {1:{xAngle=xx, yAngle=xx, zAngle=xx, width=xx,height=xx, faceMesh={1={x=1, y=1, z=1}}}, 2:{...}}
--     faceNum = 0,
--     mouthOpen = false,
--     mouthCenter = {
--         x = 0,
--         y = 0
--     }
-- }

-- function zego.countMouthState()
--     if (zego.faceNum > 0) then
--         local upperLip = zego.faceInfos[1].faceMesh[13 + 1] -- lua index从1开始
--         local lowerLip = zego.faceInfos[1].faceMesh[14 + 1]

--         -- local dis = math.pow(math.pow(upperLip.x - lowerLip.x, 2) + math.pow(upperLip.y - lowerLip.y, 2), 0.5);
--         local dis = util.distance(upperLip.x, upperLip.y, lowerLip.x, lowerLip.y)
--         zego.mouthOpen = dis > 50

--         zego.mouthCenter.x = (upperLip.x + lowerLip.x) / 2
--         zego.mouthCenter.y = (upperLip.y + lowerLip.y) / 2
--     end
-- end

-- local mediaBackgroundCallback, segmentMediaCallback;
-- local haveMediaInfo = false
-- local haveSegmentInfo = false
-- local function generateBackgroundMedia()

--     return zego.mediaInfo
--     --printf("media info textureID:%d", zego.mediaInfo.originTexID)
--     --local mediaSprite = cc.Sprite:createWithTextureID(zego.mediaInfo.originTexID, zego.mediaInfo.width,
--     --                        zego.mediaInfo.height)
--     --mediaSprite:setAnchorPoint(cc.vec3(0.5, 0.5, 0.5));

--     --local mediaSprite = cc.Sprite:createWithTextureID(zego.mediaInfo.originTexID, 100,
--     --        100)
--     --mediaSprite:setAnchorPoint(cc.vec3(0.5, 0.5, 0.5));

--     --return mediaSprite
-- end

-- local function generateSegmentMedia()

--     return zego.segmentInfo
--     --printf("segment info textureID:%d", zego.segmentInfo.segmentTexID)
--     --local mediaSprite = cc.Sprite:createWithTextureID(zego.segmentInfo.segmentTexID, zego.segmentInfo.width,
--     --                        zego.segmentInfo.height)
--     --mediaSprite:setAnchorPoint(cc.vec3(0.5, 0.5, 0.5));
--     --return mediaSprite

--     -- local mediaNode = cc.BillBoard:createWithTextureID(zego.mediaInfo.segmentTexID, zego.mediaInfo.width,
--     --                       zego.mediaInfo.height)
--     -- local mediaNode = cc.BillBoard:create("ball.png")
--     -- mediaNode:setScale(0.2)
--     -- mediaNode:setAnchorPoint(cc.vec3(0.5, 0.5, 0.5));
--     -- mediaNode:setPosition3D(util3d.count3DPoint({
--     --     x = display.cx,
--     --     y = display.cy
--     -- }))
--     -- mediaNode:setScale(0.5)
--     -- -- billboard:setPosition3D(cc.vec3(rightTop.x, rightTop.y, 600));

--     -- local centerIn3D = util3d.count3DPoint({
--     --     x = display.cx,
--     --     y = display.cy
--     -- });

--     -- local sprite = cc.Sprite3D:create("media3D.obj")
--     -- sprite:setScale(400.0)
--     -- -- -- sprite:setTexture("Sprite3DTest/boss.png")

--     -- local position = cc.vec3(centerIn3D.x, centerIn3D.y, 0)
--     -- sprite:setPosition3D(position);

--     -- printf("media position x:%f y:%f z:%f", position.x, position.y, position.z)

--     -- 这里必须指定camera之后才有意义
--     -- mediaNode:setCameraMask(cc.CameraFlag.USER1)

--     -- return mediaNode
-- end

-- -- originTexID
-- function zego.setupMedia(nodeCallback)
--     mediaBackgroundCallback = nodeCallback
--     if (haveMediaInfo) then
--         nodeCallback(generateBackgroundMedia())
--     end
-- end

-- -- segmentTexID
-- function zego.setupSegment(nodeCallback)
--     segmentMediaCallback = nodeCallback
--     if (haveSegmentInfo) then
--         nodeCallback(generateSegmentMedia())
--     end
-- end

-- zego.__onZegoMediaInfo = function()
--     printf("__onZegoMediaInfo called")
--     haveMediaInfo = true
--     if (mediaBackgroundCallback) then
--         mediaBackgroundCallback(generateBackgroundMedia())
--     end
-- end

-- zego.__onZegoSegmentInfo = function()
--     printf("__onZegoSegmentInfo called")
--     haveSegmentInfo = true
--     if (segmentMediaCallback) then
--         segmentMediaCallback(generateSegmentMedia())
--     end
-- end

-- function zego.setOnFaceListener(faceCallback)
--     printf("setOnFaceListener")
--     zego.__onZegoFace = function()
--         zego.countMouthState()
--         if faceCallback then
--             faceCallback(zego.faceInfos, zego.faceNum)
--         end
--     end
-- end

-- zego.__onZegoJson = function(jsonStr)
--     -- printf(jsonStr)
--     local jsonValue = json.decode(jsonStr, 1)

-- end

return zego
