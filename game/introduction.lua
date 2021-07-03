local Introduction = {}

Introduction.paused = false

Introduction.title = love.graphics.newImage('res/Title_Horizontal.png')
Introduction.fade = 0

Introduction.thread = [[ nil ]]

Introduction.updt = function(dt)
  if time.frames > 60 and time.frames < 280 then Introduction.fade = math.clamp(0,255,Introduction.fade + 4)
  else Introduction.fade = math.clamp(0,255,Introduction.fade - 9) end

  if time.frames > 350 then game.state = game.states.menu end
end

Introduction.draw = function()
  love.graphics.setColor(1,1,1,Introduction.fade/255)

  love.graphics.draw(Introduction.title, 128,96,0,5,5)
  love.graphics.print('A 4th project development. ',704,224)
  love.graphics.print('Created by Touhou-L41A',96,864)
  love.graphics.print('0.0.1 Development 1',960,864)
end

Introduction.input = function()
end

Introduction.inputrelease = function()
end

return Introduction
