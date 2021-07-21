--Project 5 [7/20/2021] version 0.1
game = {}

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
game.menu = require 'game/menu'

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
    background.draw(dt)
  end

  DEBUG()

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
