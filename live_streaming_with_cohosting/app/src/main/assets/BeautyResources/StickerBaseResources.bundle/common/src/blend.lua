local blendUtil = {}

local ZegoBlendMode = {
    blend_UseCocos = 0,
    blend_Darken = 1, -- 变暗 Darken
    blend_Multiply = 2, -- 正片叠底 Multiply
    blend_ColorBurn = 3, -- 颜色加深 Color Burn
    blend_LinearBurn = 4, -- 线性加深 Linear Burn
    blend_Lighten = 5, -- 变亮 Lighten
    blend_Screen = 6, -- 滤色 Screen
    blend_ColorDodge = 7, -- 颜色减淡 Color Dodge
    blend_LinearDodage = 8, -- 线性减淡 Linear Dodage
    blend_Overlay = 9, -- 叠加 Overlay
    blend_SoftLight = 10, -- 柔光 Soft Light
    blend_HardLight = 11, -- 强光 Hard Light
    blend_VividLight = 12, -- 亮光 Vivid Light
    blend_LinearLight = 13, -- 线性光 Linear Light
    blend_PinLight = 14 -- 点光 Pin Light
}

-- 示例 sprite:setZegoBlendMode(ZegoBlendMode.blend_Darken)
