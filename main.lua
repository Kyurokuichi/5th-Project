---[[
--Project 5 [7/20/2021] version 0.1
ame = {}

game.resolution = {
  game = {1280,960},
  desktop = {love.window.getDesktopDimensions()}
}

game.resolution.scale = math.min(

game.resolution.desktop[1] / game.resolution.game[1],
game.resolution.desktop[2] / game.resolution.game[2]

)

game.resolution.offset = {
  (game.resolution.desktop[1] - game.resolution.game[1] * game.resolution.scale)/2,
  (game.resolution.desktop[2] - game.resolution.game[2] * game.resolution.scale)/2
}

game.time = {current = 0, next = 0, ticks = 0, frames= 0,}

game.current = 'loading'

love.graphics.setDefaultFilter('nearest','nearest')

game.font = love.graphics.newFont('res/font.ttf', 24, 'light',4)
love.graphics.setFont(game.font)

game.loading = require 'game/introduction'
game.menu = require 'game/menu1'

game.background = {game.menu}

require 'game/debug'

function love.load()
end

function love.update(dt)
  game.time.next = game.time.next + 1/60 -- cap to 60 fps

  game.time.ticks = game.time.ticks + dt
  game.time.frames = game.time.frames + 1

  for index, background in ipairs(game.background) do
    background.updt(dt)
  end
end

function love.draw()
  game.time.current = love.timer.getTime()
  game.time.next = game.time.next <= game.time.current and game.time.current or game.time.next
  love.timer.sleep(game.time.next - game.time.current)

  love.graphics.translate(game.resolution.offset[1], game.resolution.offset[2])
  love.graphics.scale(game.resolution.scale)

  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('fill',0,0,1280,960)

  love.graphics.setColor(1,1,1)

  for index, background in ipairs(game.background) do
    background.draw()
  end

  DEBUG()

  love.graphics.setFont(game.font)

  love.graphics.setColor(0.03529411764,0.01176470588,0.03529411764)
  love.graphics.rectangle('fill',0,-960,1280,960)
  love.graphics.rectangle('fill',0,960,1280,960)
end

function love.keypressed(k)
  for index, background in ipairs(game.background) do
    pcall(background.keypressed)
  end

	DEBUG.print('Key pressed: ' .. tostring(k))
end

--]]


--[[
_G.game = {}
--Resolution
--game desired resolution ; game.resolution[1]
--current monitor resolution ; game.resolution[2]
game.resolution = {
  {1280,960},
  {love.window.getDesktopDimensions()}
}

game.resolution.scale = math.min(game.resolution[2][1] / game.resolution[1][1], game.resolution[2][2] / game.resolution[1][2])

game.resolution.offset = {
  x = (game.resolution[2][1] - game.resolution[1][1] * game.resolution.scale)/2,
  y = (game.resolution[2][2] - game.resolution[1][2] * game.resolution.scale)/2
}

--Time
game.time = {current = 0, next = 0, ticks = 0, frames = 0}

game.current = nil
game.current_states = {}

--Debug
--Kept as table for metamethods
game.debug = {false}
love.keyboard.setKeyRepeat(true)
--Debug metamethods
setmetatable(game.debug, {
  __call = function(s)
    if game.debug[1] then
      love.graphics.print(
        'DEBUG' ..
        '\nFPS: ' .. love.timer.getFPS() ..
        '\nFrame: '.. game.time.frames ..
        '\nTicks: ' .. game.time.ticks ..
        '\nCurrent Time: ' .. game.time.current ..
        '\nNext Time: ' .. game.time.next
      )
    end
  end
})

love.graphics.setDefaultFilter('nearest','nearest')
--game.font = love.graphics.setNewFont('res/font.ttf', 24)
game.font = love.graphics.newFont('res/font.ttf', 24, 'light',4)
love.graphics.setFont(game.font)

print(game.font:getWidth("Version 0.1"))

print(love.window.getDPIScale())

function love.load()
  game.introduction = require 'game/introduction'
  game.menu = require 'game/menu'

  table.insert(game.current_states, game.menu)
end

function love.update(dt)
  --Update the variables from time array
  game.time.next = game.time.next + 1/60 -- frames per second
  game.time.ticks = game.time.ticks + dt
  game.time.frames = game.time.frames + 1

  for k, state in pairs(game.current_states) do
    if not state.paused then
      state.updt(dt)
    end
  end
end

function love.draw()
  game.time.current = love.timer.getTime()
  game.time.next = game.time.next <= game.time.current and game.time.current or game.time.next

  love.timer.sleep(game.time.next - game.time.current)

  --Offsetting and Scaling the Game Resolution
  love.graphics.translate(game.resolution.offset.x, game.resolution.offset.y)
  love.graphics.scale(game.resolution.scale, game.resolution.scale)

  --Default background color [to indicate the extra pixels of the game resolution(1280x960)]
  love.graphics.setBackgroundColor(0.03529411764,0.01176470588,0.03529411764)

  --We fill in black background and draw a humongous rectangle to see the actual game resolution
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('fill',0,0,1280,960)

  --We set back to normal default color
  love.graphics.setColor(1,1,1)

  for i, state in ipairs(game.current_states) do
    state.draw()
  end

  love.graphics.setColor(1,1,1,1)
  love.graphics.setBlendMode("alpha")
  game.debug()

  --Hide extra pixels
  love.graphics.setColor(0.03529411764,0.01176470588,0.03529411764)
  love.graphics.rectangle('fill',0,-960,1280,960)
  love.graphics.rectangle('fill',0,960,1280,960)
end

function love.keypressed()
  if love.keyboard.isDown('lctrl') then
    game.debug[1] = not game.debug[1] and true or false
  end

  for i, state in ipairs(game.current_states) do
    if not state.paused then
      pcall(state.keypressed)
    end
  end
end
--]]
