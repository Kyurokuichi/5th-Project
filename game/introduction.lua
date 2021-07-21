local Introduction = {}

Introduction.paused = false

Introduction.title = love.graphics.newImage('res/Title.png')
Introduction.fade = 0

Introduction.thread = [[ nil ]]

Introduction.updt = function(dt)
  Introduction.fade = game.time.frames < 280 and math.clamp(0,255,Introduction.fade + 4) or math.clamp(0,255,Introduction.fade - 4)
  if game.time.frames > 350 then game.current_states[1] = nil ; table.insert(game.current_states, menu) end
end

Introduction.draw = function()
  love.graphics.setColor(1,1,1,Introduction.fade/255)
  love.graphics.draw(Introduction.title,518.5,243,0,3,3)
  love.graphics.print('Created by L41A',640,525,0,0.9,0.9,77,0)
end

return Introduction
