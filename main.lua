--Resolution array
_G.resolution = {}
resolution.game = {1280, 960}
resolution.monitor = {love.window.getDesktopDimensions()}

resolution.scale = math.min(resolution.monitor[1]/resolution.game[1], resolution.monitor[2]/resolution.game[2])

resolution.offset = {}
resolution.offset.x = (resolution.monitor[1]-resolution.game[1]*resolution.scale)/2
resolution.offset.y = (resolution.monitor[2]-resolution.game[2]*resolution.scale)/2

--Time array
_G.time = {}
time.current = love.timer.getTime()
time.next = love.timer.getTime()
time.ticks = 0
time.frames = 0

--Game array
_G.game = {}
game.current = nil
game.current_states = {}

--Debugger array
_G.debugger = {}
debugger.debug = false
debugger.show = function()
  love.graphics.print(
    'DEBUG' ..
    '\nFPS: ' .. love.timer.getFPS() ..
    '\nFrame: '.. time.frames ..
    '\nTicks: ' .. time.ticks ..
    '\nCurrent Time: ' .. time.current ..
    '\nNext Time: ' .. time.next
  )
end

function love.load()
  introduction = require 'game/introduction'

  table.insert(game.current_states, introduction)
end

function love.update(dt)
  --Update the variables from time array
  time.next = time.next + 1/60
  time.ticks = time.ticks + dt
  time.frames = time.frames + 1

  for _, state in pairs(game.current_states) do
    if not state.paused then
      state.updt(dt)
    end
  end
end

function love.draw()
  time.current = love.timer.getTime()
  if time.next <= time.current then time.next = time.current end

  love.timer.sleep(time.next - time.current)

  --Offsetting and Scaling the Game Resolution
  love.graphics.translate(resolution.offset.x, resolution.offset.y)
  love.graphics.scale(resolution.scale, resolution.scale)

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

  debugger.show()
end
