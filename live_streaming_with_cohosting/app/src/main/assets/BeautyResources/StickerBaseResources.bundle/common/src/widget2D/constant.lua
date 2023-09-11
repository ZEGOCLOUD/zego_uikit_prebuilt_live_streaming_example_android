
constant = {
    json = {},
    event = {},
    action = {},
    mesh = {},
    layout = {},
    particle = {},
    blend = {},
    order = {},
}

-- json key / node
constant.json.file = "../pendantConfig.json"
constant.json.animation  = "animation"
constant.json.minEngineVersion  = "minEngineVersion"
constant.json.version  = "version"
constant.json.debug  = "debug"
constant.json.type  = "type"
constant.json.background = "background"
constant.json.foreground = "foreground"
constant.json.element = "element"
constant.json.face = "face"
constant.json.face_order = "default_face_order"
constant.json.state = "state"
constant.json.ground_animation = "ground_animation"
constant.json.aiSegment = "aiSegment"
constant.json.supportETC1 = "supportETC1"
constant.json.music = "music"
constant.json.faceFilm = "faceFilm"

constant.json.spriteByFace  = "spriteByFace"
constant.json.sprite  = "sprite"
constant.json.media  = "media"
constant.json.trigger  = "trigger"
constant.json.faceImage  = "faceImage"
constant.json.particle  = "particle"

-- event
constant.event.faceEnter= "EVENT_FACE_ENTER"
constant.event.faceExit= "EVENT_FACE_EXIT"
constant.event.sceneBegin = "EVENT_SCENE_BEGIN"
constant.event.sceneEND = "EVENT_SCENE_END"

constant.event.eyeClose = "EVENT_EYE_CLOSE"
constant.event.eyeOpen = "EVENT_EYE_OPEN"
constant.event.mouseClose = "EVENT_MOUSE_CLOSE"
constant.event.mouseOpen = "EVENT_MOUSE_OPEN"
constant.event.mouseEat = "EVENT_MOUSE_EAT"
constant.event.headShake = "EVENT_HEAD_SHAKE"
constant.event.headNod = "EVENT_HEAD_NOD"

--action type
constant.action.typeAnimation = "animation"
constant.action.typeStopAnimation= "stopAnimation"
constant.action.typeAnimationFrame = "frameAnimation"
constant.action.typeVisible = "visible"
constant.action.changeForeground = "changeForeground"
constant.action.changeBackground = "changeBackground"
constant.action.changeFace = "changeFace"
constant.action.playMusic = "playMusic"
constant.action.stopMusic = "stopMusic"
constant.action.startReplaceFace = "startFaceFilm"
constant.action.endReplaceFace = "endFaceFilm"

--mesh point index
constant.mesh.indexLeftEyeUpper = 73
constant.mesh.indexLeftEyeLower = 35
constant.mesh.indexRightEyeUpper = 103
constant.mesh.indexRightEyeLower = 115

constant.mesh.indexMouseUpper = 188
constant.mesh.indexMouseLower = 201
constant.mesh.indexMouseLeft = 180
constant.mesh.indexMouseRight = 196

--order
constant.order.foreground = 0
constant.order.face = 0
constant.order.background = 0

-- layout
constant.layout.left = "left"
constant.layout.right = "right"
constant.layout.top = "top"
constant.layout.bottom = "bottom"
constant.layout.center = "center"
constant.layout.full = "full"
constant.layout.custom = "custom"

--particle
constant.particle.snow = "snow"
constant.particle.rain = "rain"
constant.particle.meteor = "meteor"
constant.particle.fire = "fire"
constant.particle.explosion = "explosion"


constant.MAX_FACE_INDEX = 2
constant.EYE_CLOSE_DISTANCE = 0.024
constant.MOUSE_CLOSE_DISTANCE = 0.08
constant.HEAD_SHAKE_DETECT_COUNT = 30
constant.HEAD_SHAKE_ANGLE_LIMIT = 0.37
constant.HEAD_NOD_DETECT_COUNT = 30
constant.HEAD_NOD_ANGLE_LIMIT = 0.8

constant.blend["blend_UseCocos"] = 0 -- 关闭blend
constant.blend["blend_Darken"] = 1 -- 变暗 Darken
constant.blend["blend_Multiply"] = 2-- 正片叠底 Multiply
constant.blend["blend_ColorBurn"] = 3 -- 颜色加深 Color Burn
constant.blend["blend_LinearBurn"] = 4 -- 线性加深 Linear Burn
constant.blend["blend_Lighten"] = 5 -- 变亮 Lighten
constant.blend["blend_Screen"] = 6 -- 滤色 Screen
constant.blend["blend_ColorDodge"] = 7 -- 颜色减淡 Color Dodge
constant.blend["blend_LinearDodage"] = 8 -- 线性减淡 Linear Dodage
constant.blend["blend_Overlay"] = 9 -- 叠加 Overlay
constant.blend["blend_SoftLight"] = 10 -- 柔光 Soft Light
constant.blend["blend_HardLight"] = 11 -- 强光 Hard Light
constant.blend["blend_VividLight"] = 12 -- 亮光 Vivid Light
constant.blend["blend_LinearLight"] = 13 -- 线性光 Linear Light
constant.blend["blend_PinLight"] = 14 -- 点光 Pin Light

constant.blend["blend_Segment"] = 15 -- 分割专用
constant.blend["blend_Opacity"] = 16 -- 透明度模式（如果是cocos内部元素，建议使用blend_UseCocos，性能更好）

constant.blend["blend_Multiply_Alpha"] = 200-- 正片叠底 Multiply, alpha也相乘

return constant