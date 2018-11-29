keyboardBox = {}
keyboardBox.size = 100
keyboardBox.x = love.graphics.getWidth() / 2 - keyboardBox.size / 2
keyboardBox.y = love.graphics.getHeight() / 2 - keyboardBox.size / 2
keyboardBox.w, keyboardBox.h = keyboardBox.size, keyboardBox.size
keyboardBox.speed = 100

mouseBox = {}
mouseBox.size = 100
mouseBox.x = love.graphics.getWidth() / 2 - mouseBox.size / 2
mouseBox.y = love.graphics.getHeight() / 2 - mouseBox.size / 2
mouseBox.w, mouseBox.h = mouseBox.size, mouseBox.size
mouseBox.speed = 100

function love.load()

end

function love.update(dt)
    local mouseX, mouseY = love.mouse.getPosition()
    mouseBox.x, mouseBox.y = mouseX - mouseBox.size / 2, mouseY - mouseBox.size / 2

    local dx, dy = 0, 0
    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        dx = dx - keyboardBox.speed * dt
    end
    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        dx = dx + keyboardBox.speed * dt
    end
    if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
        dy = dy - keyboardBox.speed * dt
    end
    if love.keyboard.isDown('s') or love.keyboard.isDown('down') then
        dy = dy + keyboardBox.speed * dt
    end

    keyboardBox.x = keyboardBox.x + dx
    keyboardBox.y = keyboardBox.y + dy

    calculateMinkowskiRect(mouseBox, keyboardBox)

    if pointInRect({ x = 0, y = 0}, minkowskiBox) then
        local dx, dy = calculateMinkowskiResolution()
        keyboardBox.x = keyboardBox.x + dx
        keyboardBox.y = keyboardBox.y + dy
    end
end

function love.draw()
    if pointInRect({ x = 0, y = 0}, minkowskiBox) then
        love.graphics.setColor(1, 0, 0, 1)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.rectangle('line', minkowskiBox.x, minkowskiBox.y, minkowskiBox.w, minkowskiBox.h)
    love.graphics.rectangle('line', mouseBox.x, mouseBox.y, mouseBox.size, mouseBox.size)
    love.graphics.rectangle('line', keyboardBox.x, keyboardBox.y, keyboardBox.size, keyboardBox.size)
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