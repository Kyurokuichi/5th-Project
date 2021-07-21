DEBUG = setmetatable({
  text = {},
  font = love.graphics.newFont(12),
  printCount = 0,
  printLimit = 10,

  print = function(text,color)
    color = color or {255,255,255}

    if DEBUG.printCount > DEBUG.printLimit then
      table.remove(DEBUG.text, 1)
    else
      DEBUG.printCount = DEBUG.printCount + 1
    end

    DEBUG.text[DEBUG.printCount] = {text, {color[1]/255, color[2]/255, color[3]/255}}
  end,}
,
{
  __call = function(self, x, y)
    x = x or 16
    y = y or 16

    profile = 'DEBUG Log console' ..
    '\n\nFPS: ' .. love.timer.getFPS() .. ' Frames: ' .. game.time.frames .. ' Ticks: ' .. game.time.ticks ..
    '\n\nCurT: ' .. game.time.current .. ' NexT: ' .. game.time.next

    list = ''

    love.graphics.setFont(self.font)

    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(1,1,1)

    love.graphics.print(profile, x, y)

    for i = 1, self.printCount do
      local text = self.text[i]
      love.graphics.setColor(text[2])
      love.graphics.print(list .. text[1], x, y + 90)
      list = list..'\n'
    end
  end
})
