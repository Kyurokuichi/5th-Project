local menu = {}

local defaultCanvas = love.graphics.newCanvas(1280,960)

local assets = {

  title = love.graphics.newImage('res/Title1.png'),
  plaid = love.graphics.newImage('res/plaid.png'),
}

--------------------------------------------------------------------------------------------------------------------------------
local backgroundMain = {}

backgroundMain.canvas = love.graphics.newCanvas(1280,960)

backgroundMain.plaidCamera = {0,0}

function backgroundMain.update(dt)
  backgroundMain.plaidCamera = {backgroundMain.plaidCamera[1] + 50 * dt, backgroundMain.plaidCamera[2] + 10 * dt}
end

function backgroundMain.draw()
  --Set Canvas
  love.graphics.setCanvas({backgroundMain.canvas})
  --Push to transformation stack
  love.graphics.push()
  --Clear Canvas
  love.graphics.clear()
  --Resets coord tranformation
  love.graphics.origin()


  --Tile image size
  local tileSize = 10

  --Tile image width and height (The actual image size multiplied by tileSize)
  local tileWidth, tileHeight = assets.plaid:getDimensions()

  --Tile coords
  local tileX, tileY = love.graphics.getWidth() / tileWidth * tileSize ,love.graphics.getHeight() / tileHeight * tileSize

  --For camera position
  local startX = (-backgroundMain.plaidCamera[1] % tileWidth * tileSize) - tileWidth * tileSize
  local startY = (-backgroundMain.plaidCamera[2] % tileHeight * tileSize) - tileHeight * tileSize

  love.graphics.setColor(140/255,157/255,255/255)
  love.graphics.rectangle('fill', 0, 0, 1280, 960)


  love.graphics.setColor(1,1,1)
  for x = 0, math.min(love.graphics.getWidth() / tileWidth) do
    for y = 0, math.min(love.graphics.getHeight() / tileHeight) do
      love.graphics.draw(
      assets.plaid,
      startX + x * tileWidth * tileSize,
      startY + y * tileHeight * tileSize,
      0,
      tileSize,
      tileSize
      )
    end
  end
  --Pop from transformation stack
  love.graphics.pop()
  --Set Canvas to nil
  love.graphics.setCanvas()

  love.graphics.draw(backgroundMain.canvas)
end
--------------------------------------------------------------------------------------------------------------------------------
local title = {}

title.canvas = love.graphics.newCanvas(1280,960)

title.offset = {640,480}

title.ticks = 0

title.title = love.graphics.newImage('res/Title1.png')

title.plaidCamera = {0,0}

function title.stencil()
  --Push to transformation stack
  love.graphics.push()

  love.graphics.translate(title.offset[1], title.offset[2])
  love.graphics.rotate(math.rad(4))
  love.graphics.rectangle('fill', -322/2,-999/2,322 + 10,999)

  --Pop from transformation stack
  love.graphics.pop()
end

function title.update(dt)
  title.plaidCamera = {title.plaidCamera[1] + 50 * dt, title.plaidCamera[2] + 10 * dt}

  if menu.state == 'main' then
    title.ticks = title.ticks + dt
    title.offset = {title.ticks > 0.5 and 222 or math.ease.inOutQuad(640, -418, title.ticks, 0.5),480}
  end
end

function title.draw()
  --Set Canvas
  love.graphics.setCanvas({title.canvas, stencil = true})
  --Push to transformation stack
  love.graphics.push()
  --Clear Canvas
  love.graphics.clear()
  --Resets coord tranformation
  love.graphics.origin()

  --Apply stencil to drawables below
  love.graphics.stencil(title.stencil,'replace', 1)

  --Apply stencil to drawables below
  love.graphics.setStencilTest('greater',0)

  --Color and background of plaid background
  love.graphics.setColor(255/255, 183/255, 197/255)
  love.graphics.rectangle('fill',0,0,1280,960)

  --Tile image size
  local tileSize = 5

  --Tile image width and height (The actual image size multiplied by tileSize)
  local tileWidth, tileHeight = assets.plaid:getDimensions()

  --Tile coords
  local tileX, tileY = love.graphics.getWidth() / tileWidth * tileSize ,love.graphics.getHeight() / tileHeight * tileSize

  --For camera position
  local startX = (-title.plaidCamera[1] % tileWidth * tileSize) - tileWidth * tileSize
  local startY = (-title.plaidCamera[2] % tileHeight * tileSize) - tileHeight * tileSize

  love.graphics.setColor(1,1,1)

  for x = 0, math.min(love.graphics.getWidth() / tileWidth) do
    for y = 0, math.min(love.graphics.getHeight() / tileHeight) do
      love.graphics.draw(
      assets.plaid,
      startX + x * tileWidth * tileSize,
      startY + y * tileHeight * tileSize,
      0,
      tileSize,
      tileSize
      )
    end
  end

  love.graphics.translate(title.offset[1], title.offset[2])
  love.graphics.rotate(math.rad(4))

  for i = 1,5 do
    love.graphics.setColor(0,0,0,math.abs((i / 9) * 255/255))

    love.graphics.rectangle('fill', -222/2 - (i * 10), -999/2, 10, 999)
    love.graphics.rectangle('fill', 222/2 + ((i * 10)), -999/2, 10, 999)
  end

  love.graphics.setColor(1,1,1)
  love.graphics.draw(assets.title,0,0,0,4.5,4.5,21,67)
  love.graphics.setBlendMode("alpha")

  if menu.state == 'title' then
    love.graphics.setColor(1, 1, 1, math.abs(math.cos(game.time.current * 0.9 % 2 * math.pi)))
    love.graphics.print('Press Z to proceed',-178/2,333,math.rad(-4))
  end

  love.graphics.setColor(1,1,1)

  --Remove the stencil by setting it to nil
  love.graphics.setStencilTest()
  --Pop from transformation stack
  love.graphics.pop()
  --Set Canvas to nil
  love.graphics.setCanvas()

  love.graphics.draw(title.canvas,0,0)
end
--------------------------------------------------------------------------------------------------------------------------------
local mainSelection = {}

mainSelection.canvas = love.graphics.newCanvas(1280, 960)

mainSelection.offset = {0,0}

mainSelection.ticks = 0

mainSelection.transparency = 0

function mainSelection.update(dt)
  mainSelection.transparency = math.clamp(1, 255, mainSelection.transparency + 18)
end

function mainSelection.draw()
  love.graphics.setCanvas({mainSelection.canvas})
  --Push to transformation stack
  love.graphics.push()
  --Clear Canvas
  love.graphics.clear()
  --Resets coord tranformation
  love.graphics.origin()

  love.graphics.print('Version 0.1',1164,926)

  --Pop from transformation stack
  love.graphics.pop()
  --Set Canvas to nil
  love.graphics.setCanvas()

  love.graphics.setColor(1, 1, 1, mainSelection.transparency/255)
  love.graphics.draw(mainSelection.canvas,0,0)
end
--------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------


local selections = {
  {'Start','Practice','Extra','Scores','Option','Quit'},
  {'Easy','Normal','Hard','Lunatic'},
}

local selected = {0,0}
local selectEnabled
local selectTicks

menu.running = {backgroundMain,title}
menu.state = 'title'

menu.ticks = 0

function menu.updt(dt)
  menu.ticks = menu.ticks + dt

  for index,data in ipairs(menu.running) do
    data.update(dt)
  end
end

function menu.draw()
  for index,data in ipairs(menu.running) do
    data.draw()
  end
end

function menu.keypressed()
  for index,data in ipairs(menu.running) do
    pcall(data.keypressed)
  end

  if menu.state == 'title' and love.keyboard.isDown('z') then
    menu.state = 'main'
    table.insert(menu.running, mainSelection)
  end
end

function menu.keyreleased()
  for index,data in ipairs(menu.running) do
    pcall(data.keyreleased)
  end
end

return menu
