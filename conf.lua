--//Library loads here first before the game load finishes

--Extended math library created by me
require('lib/mathext')

--Discord rich presence
_G.rich_presence = require('lib/richpresence')

--\\

--Config ini file
local config_ini = love.filesystem.newFile('config.ini')

--This will contain data for configuration
_G.config_data = {}

--Config default array for metatable
local config_default = {
  window = {
    x = nil,
    y = nil,

    width = 1280,
    height = 960,

    fullscreen = false,
    borderless = false,
  },
}

--Well, this is the metatable for config data
local config_mt = {
  __index = function(table, key)
    return config_default[key]
  end
}

--Officially config_data is now a STRONK! table :D
setmetatable(config_data, config_mt)

--IDK
local config_section

--Reads the data of config.ini into table data for config_data
for line in love.filesystem.lines('config.ini') do
  local tempSection = line:match('^%[([^%[%]]+)%]$')

  if(tempSection)then
    config_section = tonumber(tempSection) and tonumber(tempSection) or tempSection
    config_data[config_section] = config_data[config_section] or {}
  end

  local param, value = line:match('^([%w|_]+)%s- = %s-(.+)$')

  if param and value ~= nil then
    if tonumber(value) then
      value = tonumber(value)
    elseif value == 'true' then
      value = true
    elseif value == 'false' then
      value = false
    end
    if tonumber(param) then
      param = tonumber(param)
    end
    config_data[config_section][param] = value
  end
end

--We closes the file after it reads
config_ini:close()

--We apply those configuration data to the love.conf
function love.conf(game)
  game.console = true

  game.window.title = 'Project 4'
  game.window.icon = nil

  game.window.x = config_data.window.x or nil
  game.window.y = config_data.window.y or nil

  game.window.width = config_data.window.width or 1280
  game.window.height = config_data.window.height or 960

  game.window.fullscreen = config_data.window.fullscreen or false
  game.window.fullscreentype = config_data.window.fullscreentype or 'desktop'

  game.window.vsync = config_data.window.vsync or 0

  game.window.borderless = config_data.window.borderless or false
end

--//Discord rich presence
--I want to add this thing cuz i'm a discord user XD
--And also to show it to my friend that i'm working on this game

rich_presence.initialize('860443296160284722', false)

rich_presence.data = {
  state = "Test Run",
  details = '0.1A',
}

rich_presence.updatePresence(rich_presence.data)

rich_presence.runCallbacks()
--\\
