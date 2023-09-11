local util3d = {}

function util3d.distance(point1, point2)
    return math.sqrt(math.pow(point2.x - point1.x, 2) + math.pow(point2.y - point1.y, 2) +
                         math.pow(point2.z - point1.z, 2));
end

-- 设置一个3D摄像机
function util3d.createCamera(layer)
    local size = cc.Director:getInstance():getWinSize()
    -- local camera = cc.Camera:createPerspective(60, size.width / size.height, 1, 1000)
    local camera = cc.Camera:createOrthographic(display.width, display.height, 1, 10000)
    camera:setCameraFlag(cc.CameraFlag.USER1)
    camera:setPosition3D(cc.vec3(0, 0, 5001))
    camera:lookAt(cc.vec3(0, 0, 0), cc.vec3(0, 1, 0))
    camera:setDepth(1)

    layer:addChild(camera)
    layer:setCameraMask(cc.CameraFlag.USER1)

    util3d.camera = camera

    return camera
end

-- 通过屏幕坐标计算3D空间中，z=0所在平面上的3D坐标
function util3d.count3DPoint(screenPoint)
    -- 只有计算near和far才是准确的
    local nearPos = util3d.camera:unProjectGL(cc.vec3(screenPoint.x, screenPoint.y, 0))
    local farPos = util3d.camera:unProjectGL(cc.vec3(screenPoint.x, screenPoint.y, 1))
    return cc.vec3((nearPos.x + farPos.x) / 2, (nearPos.y + farPos.y) / 2, 0);
end

-- 通过3D坐标，计算在屏幕上的坐标
function util3d.countScreenPoint(point3d)
    -- local vpMatrix = util3d.camera:getViewProjectionMatrix()
    -- -- vpMatrix:mat4_transformVector(point3d, res)
    -- return mat4_transformVector(vpMatrix, point3d)

    -- -- 只有计算near和far才是准确的
    return util3d.camera:projectGL(point3d)
end

-- head box也要旋转
-- 以鼻子为进平面的中心点
-- 以脸部最顶上的点与最底部的点的2倍作为正方体的边长
function util3d.countHeadBox3D(faceInfo)
    local top = faceInfo.faceMesh[10 + 1]
    local top3D = util3d.count3DPoint(top)

    local bottom = faceInfo.faceMesh[152 + 1]
    local bottom3D = util3d.count3DPoint(bottom)

    -- TODO 目前以这种方式计算HeadBox3D，boxsize可能有变化
    local dis = util3d.distance(top3D, bottom3D)
    local headBoxSize = dis * 1.5 --/ math.cos(faceInfo.xAngle)

    local nose = faceInfo.faceMesh[1 + 1]
    local nose3D = util3d.count3DPoint(nose)

    -- 没旋转前的正方体
    local originBox = {
        frontLeftTop = {
            x = nose3D.x - headBoxSize / 2,
            y = nose3D.y + headBoxSize / 2,
            z = 0,
            w = 1
        },
        frontRightTop = {
            x = nose3D.x + headBoxSize / 2,
            y = nose3D.y + headBoxSize / 2,
            z = 0,
            w = 1
        },
        frontLeftBottom = {
            x = nose3D.x - headBoxSize / 2,
            y = nose3D.y - headBoxSize / 2,
            z = 0,
            w = 1
        },
        frontRightBottom = {
            x = nose3D.x + headBoxSize / 2,
            y = nose3D.y - headBoxSize / 2,
            z = 0,
            w = 1
        },

        backLeftTop = {
            x = nose3D.x - headBoxSize / 2,
            y = nose3D.y + headBoxSize / 2,
            z = -headBoxSize * 2 / 3,
            w = 1
        },
        backRightTop = {
            x = nose3D.x + headBoxSize / 2,
            y = nose3D.y + headBoxSize / 2,
            z = -headBoxSize * 2 / 3,
            w = 1
        },
        backLeftBottom = {
            x = nose3D.x - headBoxSize / 2,
            y = nose3D.y - headBoxSize / 2,
            z = -headBoxSize * 2 / 3,
            w = 1
        },
        backRightBottom = {
            x = nose3D.x + headBoxSize / 2,
            y = nose3D.y - headBoxSize / 2,
            z = -headBoxSize * 2 / 3,
            w = 1
        }
    }

    local center = {
        x = 0,
        y = 0,
        z = 0
    }
    for key, value in pairs(originBox) do
        center.x = center.x + value.x
        center.y = center.y + value.y
        center.z = center.z + value.z
    end
    center.x = center.x / 8
    center.y = center.y / 8
    center.z = center.z / 8

    -- 以鼻子中心点旋转
    local translateMatYZ = cc.mat4.createTranslation(nose3D.x, nose3D.y, nose3D.z)
    local translateRevertMatYZ = cc.mat4.getInversed(translateMatYZ)
    -- y\z按照鼻子旋转
    local quatYZ = cc.quaternion(faceInfo.xAngle / 2, faceInfo.yAngle, -faceInfo.zAngle / 2, 1)
    local rotateMatYZ = cc.mat4.createRotation(quatYZ)
    local tempYZ = cc.mat4.multiply(translateMatYZ, rotateMatYZ)
    local rotateYZ = cc.mat4.multiply(tempYZ, translateRevertMatYZ)

    -- faceInfo.xAngle x需要按照box center旋转
    -- local translateMatX = cc.mat4.createTranslation(nose3D.x, nose3D.y, nose3D.z)
    -- local translateRevertMatX = cc.mat4.getInversed(translateMatX)
    -- local quatX = cc.quaternion(faceInfo.xAngle / 2, 0, 0, 1)
    -- printf("faceInfo.xAngle %4.2f", faceInfo.xAngle)
    -- local rotateMatX = cc.mat4.createRotation(quatX)
    -- local tempX = cc.mat4.multiply(translateMatX, rotateMatX)
    -- local rotateX = cc.mat4.multiply(tempX, translateRevertMatX)

    local combine = rotateYZ -- cc.mat4.multiply(rotateYZ, rotateX)
    
    -- local combine = translateMat

    local resultBox = {
        frontLeftTop = cc.mat4.transformVector(combine, originBox.frontLeftTop),
        frontRightTop = cc.mat4.transformVector(combine, originBox.frontRightTop),
        frontLeftBottom = cc.mat4.transformVector(combine, originBox.frontLeftBottom),
        frontRightBottom = cc.mat4.transformVector(combine, originBox.frontRightBottom),

        backLeftTop = cc.mat4.transformVector(combine, originBox.backLeftTop),
        backRightTop = cc.mat4.transformVector(combine, originBox.backRightTop),
        backLeftBottom = cc.mat4.transformVector(combine, originBox.backLeftBottom),
        backRightBottom = cc.mat4.transformVector(combine, originBox.backRightBottom)

    }
    -- printf("frontLeftTop w:%4.2f", resultBox.frontLeftTop.w)

    -- printf("frontLeftTop origin(x:%4.2f y:%4.2f z:%4.2f) now(x:%4.2f y:%4.2f z:%4.2f)", originBox.frontLeftTop.x,
    --     originBox.frontLeftTop.y, originBox.frontLeftTop.z, resultBox.frontLeftTop.x, resultBox.frontLeftTop.y,
    --     resultBox.frontLeftTop.z)

    resultBox.size = headBoxSize

    return resultBox

end

-- 以front面的左下角（frontLeftBottom）作为基准
function util3d.getPointOnHeadBox(headBox, xRate, yRate, zRate)
    local xOff = cc.vec3mul(cc.vec3sub(headBox.frontRightBottom, headBox.frontLeftBottom), xRate)
    local yOff = cc.vec3mul(cc.vec3sub(headBox.frontLeftTop, headBox.frontLeftBottom), yRate)
    local zOff = cc.vec3mul(cc.vec3sub(headBox.backLeftBottom, headBox.frontLeftBottom), zRate)
    return cc.vec3add(cc.vec3add(cc.vec3add(headBox.frontLeftBottom, xOff), yOff), zOff)
end

return util3d
