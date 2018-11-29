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
end

function love.draw()
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle('line', minkowskiBox.x, minkowskiBox.y, minkowskiBox.w, minkowskiBox.h)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.rectangle('line', mouseBox.x, mouseBox.y, mouseBox.size, mouseBox.size)
    love.graphics.setColor(0, 0, 1, 1)
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