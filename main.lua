boxA = {}
boxA.size = 100
boxA.x = love.graphics.getWidth() / 2 - boxA.size / 2
boxA.y = love.graphics.getHeight() / 2 - boxA.size / 2
boxA.w, boxA.h = boxA.size, boxA.size
boxA.speed = 100
boxA.mass = 100

boxB = {}
boxB.size = 100
boxB.x = love.graphics.getWidth() / 2 - boxB.size / 2
boxB.y = love.graphics.getHeight() / 2 - boxB.size / 2
boxB.w, boxB.h = boxB.size, boxB.size
boxB.speed = 100
boxB.mass = 100

function love.load()
    mx, my = 0, 0
end

function love.update(dt)
    local dx, dy = 0, 0
    if love.keyboard.isDown('left') then
        dx = dx - boxA.speed * dt
    end
    if love.keyboard.isDown('right') then
        dx = dx + boxA.speed * dt
    end
    if love.keyboard.isDown('up') then
        dy = dy - boxA.speed * dt
    end
    if love.keyboard.isDown('down') then
        dy = dy + boxA.speed * dt
    end

    boxA.x = boxA.x + dx
    boxA.y = boxA.y + dy

    dx, dy = 0, 0
    if love.keyboard.isDown('a') then
        dx = dx - boxB.speed * dt
    end
    if love.keyboard.isDown('d') then
        dx = dx + boxB.speed * dt
    end
    if love.keyboard.isDown('w') then
        dy = dy - boxB.speed * dt
    end
    if love.keyboard.isDown('s') then
        dy = dy + boxB.speed * dt
    end

    boxB.x = boxB.x + dx
    boxB.y = boxB.y + dy

    calculateMinkowskiRect(boxA, boxB)

    if pointInRect({ x = 0, y = 0}, minkowskiBox) then
        mx, my = calculateMinkowskiResolution()
        resolveCollisions()
    else
        mx, my = 0, 0
    end
end

function love.draw()
    if pointInRect({ x = 0, y = 0}, minkowskiBox) then
        love.graphics.setColor(1, 0, 0, 1)
    else
        love.graphics.setColor(0, 1, 0, 1)
    end
    love.graphics.rectangle('line', minkowskiBox.x, minkowskiBox.y, minkowskiBox.w, minkowskiBox.h)
    love.graphics.rectangle('line', boxB.x, boxB.y, boxB.size, boxB.size)
    love.graphics.rectangle('line', boxA.x, boxA.y, boxA.size, boxA.size)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('Minkowski penetration vector\nx: ' .. string.format("%.2f", mx) .. '\ny: ' .. string.format("%.2f", my), 10, 10)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function calculateMinkowskiRect(boxA, boxB)
    minkowskiBox = {}
    minkowskiBox.x = boxA.x - boxB.x - boxB.w
    minkowskiBox.y = boxA.y - boxB.y - boxB.h
    minkowskiBox.w = boxA.w + boxB.w
    minkowskiBox.h = boxA.h + boxB.h
end

function calculateMinkowskiResolution()
    local x1, x2 = minkowskiBox.x, minkowskiBox.x + minkowskiBox.w
    local y1, y2 = minkowskiBox.y, minkowskiBox.y + minkowskiBox.h

    local minX = smallestAbs{x1, x2}
    local minY = smallestAbs{y1, y2}

    if math.abs(minX) < math.abs(minY) then
        return minX, 0
    else
        return 0, minY
    end
end

function resolveCollisions()
    boxA.x = boxA.x - mx * (boxA.mass / (boxA.mass + boxB.mass))
    boxA.y = boxA.y - my * (boxA.mass / (boxA.mass + boxB.mass))
    boxB.x = boxB.x + mx * (boxB.mass / (boxA.mass + boxB.mass))
    boxB.y = boxB.y + my * (boxB.mass / (boxA.mass + boxB.mass))
end

function pointInRect(point, rect)
    return (
        point.x > rect.x and point.x < rect.x + rect.w and
        point.y > rect.y and point.y < rect.y + rect.h
    )
end

function smallestAbs(values)
    local squaredValues = {}
    for i, v in ipairs(values) do
        table.insert(squaredValues, math.pow(v, 2))
    end

    table.sort(squaredValues, function(a, b)
        return a < b
    end)

    local smallestSquaredVal = squaredValues[1]

    for _, v in pairs(values) do
        if math.pow(v, 2) == smallestSquaredVal then
            return v
        end
    end

    return nil
end