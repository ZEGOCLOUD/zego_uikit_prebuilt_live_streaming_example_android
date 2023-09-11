util = {}

function util.distance(x1, y1, x2, y2)
    return math.pow(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2), 0.5);
end

return util
