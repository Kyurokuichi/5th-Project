local Menu = {}

Menu.shader = love.graphics.newShader([[
uniform vec2 mouse_position;

float lens_size = 0.2;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
  vec2 pos = screen_coords.xy / vec2(1280,1024);
  vec2 mouse_pos = mouse_position.xy / vec2(1280,1024);

  vec2 d = pos - mouse_pos;
  float r = sqrt(dot(d,d));

  vec2 uv;

  if (r > lens_size)
  {
    uv = pos;
    return Texel(tex, uv);
  }
  else if (r < lens_size)
  {
    // SQUAREXY:
    // uv = mouse_pos + vec2(d.x * abs(d.x), d.y * abs(d.y));
    // SQUARER:
    uv = mouse_pos + d * r * 5; // a.k.a. m + normalize(d) * r * r
    // SINER:
    // uv = (mouse_pos + normalize(d) * sin(r * 3.14159 * 0.5));
    // ASINR:
    // uv = mouse_pos + normalize(d) * asin(r) / (3.14159 * 0.5);

    return Texel(tex, uv);
  }

}

]])

Menu.background = {
  canvas = love.graphics.newCanvas(1280,960),

  updt = function(dt)
    love.graphics.setCanvas({Menu.background.canvas})
    love.graphics.push()

    love.graphics.clear()
    love.graphics.origin()

    love.graphics.setColor(140/255,157/255,255/255)
    love.graphics.rectangle('fill',0,0,1280,960)

    local tile_w, tile_h = Menu.title.plaid:getDimensions()

    local tile_x = love.graphics.getWidth() / tile_w * 9
    local tile_y = love.graphics.getHeight() / tile_h * 9

    local start_x = (-camera_x1 % tile_w * 9) - tile_w * 9
    local start_y = (-camera_y1 % tile_h * 9) - tile_h * 9

    for i=0,math.ceil(love.graphics.getWidth() / tile_w) do
      for j=0,math.ceil(love.graphics.getHeight() / tile_h) do
        love.graphics.draw(
          Menu.title.plaid,
          start_x + i * tile_w * 9,   -- Position X
          start_y + j * tile_h * 9,   -- Position Y
          0,                          -- Rotation
          9,                          -- Size X
          9                           -- Size Y
          )
      end
    end

    love.graphics.pop()
    love.graphics.setCanvas()
  end,

  draw = function()
    love.graphics.draw(Menu.background.canvas)
  end
}

Menu.title = {
  clicked = false,

  image = love.graphics.newImage('res/Title1.png'),
  plaid = love.graphics.newImage('res/plaid.png'),

  canvas = love.graphics.newCanvas(1280,960),

  transparency = 0,

  ticks = 0,

  stencil = function()
    love.graphics.push() -- push block
    love.graphics.translate(Menu.title.ticks > 1 and 222 or math.ease.inOutCubic(640, -418, Menu.title.ticks, 1), 480)
    love.graphics.setColor(1,1,1,0.9)
    love.graphics.rotate(math.rad(4))
    love.graphics.rectangle('fill', -322/2,-999/2,322,999)
    love.graphics.pop()
  end,

  updt = function(dt)
    Menu.title.ticks = Menu.title.clicked and Menu.title.ticks + dt or 0

    if Menu.running[4] ~= nil then
      Menu.title.transparency = Menu.title.transparency - 9

      if Menu.title.transparency <= 0 then
        table.remove(Menu.running, 2)
        table.remove(Menu.running, 3)
      end
    else
      Menu.title.transparency = Menu.transparency
    end

    love.graphics.setCanvas({Menu.title.canvas, stencil = true}) -- canvas block
      love.graphics.push() -- push block
        love.graphics.clear()
        love.graphics.origin()

        love.graphics.stencil(Menu.title.stencil, "replace", 1)
        love.graphics.setStencilTest("greater", 0)

        love.graphics.setColor(255/255, 183/255, 197/255)
        love.graphics.rectangle('fill',0,0,1280,960)

        local tile_w, tile_h = Menu.title.plaid:getDimensions()

        local start_x = (-camera_x % tile_w * 5) - tile_w * 5
        local start_y = (-camera_y % tile_h * 5) - tile_h * 5

        for i=0,math.ceil(love.graphics.getWidth() / tile_w) do
          for j=0,math.ceil(love.graphics.getHeight() / tile_h) do
            love.graphics.draw(
              Menu.title.plaid,
              start_x + i * tile_w * 5,   -- Position X
              start_y + j * tile_h * 5,   -- Position Y
              0,                          -- Rotation
              5,                          -- Size X
              5                           -- Size Y
              )
          end
        end

        --[[
        for i = 0, love.graphics.getWidth() / Menu.title.plaid:getWidth() do
          for j = 0, love.graphics.getHeight() / Menu.title.plaid:getHeight() do
            love.graphics.draw(Menu.title.plaid,
            (i * Menu.title.plaid:getWidth()) + start_x,
            (j * Menu.title.plaid:getHeight()) + start_y
            )
          end
        end
        --]]



        love.graphics.translate(Menu.title.ticks > 1 and 222 or math.ease.inOutCubic(640, -418, Menu.title.ticks, 1), 480)
        love.graphics.rotate(math.rad(4))
        love.graphics.setBlendMode("alpha")

        for i = 1,10 do
          love.graphics.setColor(0,0,0, (255 * math.abs(i)/14)/255)

          love.graphics.rectangle('fill', -222/2 - (5 * i), -999/2, 5, 999)
          love.graphics.rectangle('fill', 222/2 + (5 * i), -999/2, 5, 999)
        end



        if not Menu.title.clicked then
          love.graphics.setColor(1, 1, 1, math.abs(math.cos(game.time.current * 1 % 2 * math.pi)))
          love.graphics.print('Press Z to proceed',-178/2,333,math.rad(-4))
        end

        love.graphics.setColor(1,1,1)
        love.graphics.draw(Menu.title.image,0,0,0,4.5,4.5,21,67)
        love.graphics.setStencilTest()
      love.graphics.pop()
    love.graphics.setCanvas()
  end,

  draw = function()
    love.graphics.setColor(1,1,1,Menu.title.transparency/255)
    love.graphics.draw(Menu.title.canvas)
  end,

  keypressed = function()
    if love.keyboard.isDown('z') and not Menu.title.clicked and Menu.transparency == 255 then
      Menu.title.clicked = true
      table.insert(Menu.running, Menu.main)

      Menu.title.keypressed = nil
    end
  end,
}

Menu.main = {
  canvas = love.graphics.newCanvas(1280,960),

  transparency = 0,

  ticks = 0,

  updt = function(dt)
    Menu.main.ticks = Menu.main.ticks + dt

    Menu.select_enabled = true

    love.graphics.setCanvas({Menu.main.canvas}) -- canvas block
      love.graphics.push() -- push block
        love.graphics.clear()
        love.graphics.origin()
        love.graphics.setColor(1,1,1,math.clamp(0, 255, (Menu.title.ticks * 100) * 9 / 255))
        love.graphics.print('Version 0.1',1164,926)

        love.graphics.translate(math.ease.inOutCubic(1350, -250, Menu.main.ticks < 1 and Menu.main.ticks or 1,1),256)

        for i,v in ipairs(Menu.selections[1]) do
          love.graphics.setColor(i == Menu.selected and {1,1,1} or {1,1,1})

          local duration = 0.05

          local x = (4 * -i) + math.ease.inOutQuad(
          Menu.selected == i and 0 or Menu.last_selected == i and -20 or 0,
          Menu.selected == i and -20 or Menu.last_selected == i and 20 or 0,
          Menu.select_tick < duration and Menu.select_tick or duration,
          duration
          )

          love.graphics.print(v[1],x,60 * i,0,2,2)
        end

      love.graphics.pop()
    love.graphics.setCanvas()
  end,

  draw = function()
    love.graphics.setColor(1,1,1,Menu.title.transparency/255)
    love.graphics.draw(Menu.main.canvas)
  end,
}

Menu.start = {
  canvas = love.graphics.newCanvas(1280,960),

  ticks = 0,

  updt = function(dt)
    love.graphics.setCanvas({Menu.start.canvas})
      love.graphics.push()
        love.graphics.clear()
        love.graphics.origin()


      love.graphics.pop()
    love.graphics.setCanvas()
  end,

  draw = function()

  end,

  keypressed = function()

  end
}

camera_x = 0
camera_y = 0
camera_x1 = 0
camera_y1 = 0

Menu.running = {Menu.background,Menu.title,}
Menu.transparency = 0

Menu.selections = {
  -- Main
  {
    {'Start'},
    {'Extra'},
    {'Practice'},
    {'Score'},
    {'Option'},
    {'Quit'},
  },

  -- Start
  {
    {'Easy'},
    {'Normal'},
    {'Hard'},
    {'Lunatic'},
  },

  -- Extra
  {
    {'Extra'},
  },

  -- Practice
  {
    {'Stage 1'},
  },

  -- Score
  {
    {'nil'},
  },

  -- Option
  {
    {'Fullscreen'},
  },
}

Menu.selected = 1                             -- Current Selected
Menu.last_selected = 0                        -- The previous value of Current Selected
Menu.select_tick = 0                          -- Selection Tick (used in easing)
Menu.select_enabled = false                   -- Enable able to select
Menu.current_selection = Menu.selections[1]   -- Current Selection (list of things [see ])

Menu.ticks = 0

function Menu.updt(dt)
  Menu.ticks = Menu.ticks + dt
  Menu.select_tick = Menu.select_tick + dt

  local SPEED = 50
  camera_x = camera_x + SPEED * dt
  camera_y = camera_y + SPEED * dt

  local SPEED1 = 10
  camera_x1 = camera_x1 + SPEED1 * dt
  camera_y1 = camera_y1 + SPEED1 * dt

  Menu.transparency = math.clamp(0, 255, Menu.transparency + 4)

  for i,v in ipairs(Menu.running) do
    v.updt(dt)
  end

end

function Menu.draw()
  love.graphics.push() --push main
  love.graphics.setShader(Menu.shader)
  Menu.shader:send('mouse_position', {love.mouse.getX(), love.mouse.getY()})
  love.graphics.setColor(1,1,1,Menu.transparency/255)

  for i,v in ipairs(Menu.running) do
    v.draw()
  end
  love.graphics.setShader()
  love.graphics.pop()
end

function Menu.keypressed()

  for i,v in ipairs(Menu.running) do
    pcall(v.keypressed)
  end

  if Menu.select_enabled then
    if love.keyboard.isDown('up') or love.keyboard.isDown('down') then
      Menu.select_tick = 0
      Menu.last_selected = Menu.selected

      Menu.selected = love.keyboard.isDown('up') and Menu.selected - 1 or Menu.selected     -- if Up key is pressed
      Menu.selected = love.keyboard.isDown('down') and Menu.selected + 1 or Menu.selected   -- [Else] if Down key is pressed

      print(Menu.selected)
      print(Menu.last_selected)

      Menu.selected = Menu.selected < 1 and #Menu.current_selection or Menu.selected        -- if the value is lower than 1
      Menu.selected = Menu.selected > #Menu.current_selection and 1 or Menu.selected        -- [Else] if the value is higher than current solution
    end

    if love.keyboard.isDown('z') then
      if Menu.current_selection[Menu.selected][1] == 'Start' then
        Menu.current_selection = Menu.selections[2]
        table.insert(Menu.running, Menu.start)
      end

      if Menu.current_selection[Menu.selected][1] == 'Quit' then
        love.event.quit()
      end
    end
  end
end

return Menu

--[[

love.graphics.push() -- push block
love.graphics.translate(640, 480)
love.graphics.setColor(1,1,1)
love.graphics.circle('fill',0,0,10)
love.graphics.draw(Menu.title,0,0,0,4.5,4.5,21,67)

love.graphics.pop()

love.graphics.setColor(1,1,1)

love.graphics.line(640,0,640,960)
love.graphics.line(0,480,1280,480)

love.graphics.pop()

--]]

--[[

for i = -fade_lines, fade_lines do
  love.graphics.setColor(0,0,0, (255 * math.abs(i)/fade_lines)/255)

  love.graphics.rectangle(
  'fill',
  math.sign(i) == 1 and -222/2 - (fade_width * i) or 222/2 + (fade_width * -i),
  -999/2,
  fade_width,
  999
)
end

--]]
