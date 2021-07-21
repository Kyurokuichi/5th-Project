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

  game.window.title = 'Project 5'
  game.window.icon = 'res/unused/Title.png'

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

rich_presence.initialize('860443296160284722', true)

rich_presence.data = {
  state = "Test Run by L41A",
  details = '0.1A',
}

rich_presence.updatePresence(rich_presence.data)

rich_presence.runCallbacks()
--\\

local utf8 = require("utf8")

local function error_printer(msg, layer)
	print((debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
end

function love.errorhandler(msg)
	msg = tostring(msg)

	error_printer(msg, 2)

	if not love.window or not love.graphics or not love.event then
		return
	end

	if not love.graphics.isCreated() or not love.window.isOpen() then
		local success, status = pcall(love.window.setMode, 800, 600)
		if not success or not status then
			return
		end
	end

	-- Reset state.
	if love.mouse then
		love.mouse.setVisible(true)
		love.mouse.setGrabbed(false)
		love.mouse.setRelativeMode(false)
		if love.mouse.isCursorSupported() then
			love.mouse.setCursor()
		end
	end
	if love.joystick then
		-- Stop all joystick vibrations.
		for i,v in ipairs(love.joystick.getJoysticks()) do
			v:setVibration()
		end
	end
	if love.audio then love.audio.stop() end

	love.graphics.reset()
	local font = love.graphics.setNewFont(14)

	love.graphics.setColor(1, 1, 1, 1)

	local trace = debug.traceback()

	love.graphics.origin()

	local sanitizedmsg = {}
	for char in msg:gmatch(utf8.charpattern) do
		table.insert(sanitizedmsg, char)
	end
	sanitizedmsg = table.concat(sanitizedmsg)

	local err = {}

	table.insert(err, "Error\n")
	table.insert(err, sanitizedmsg)

	if #sanitizedmsg ~= #msg then
		table.insert(err, "Invalid UTF-8 string in error message.")
	end

	table.insert(err, "\n")

	for l in trace:gmatch("(.-)\n") do
		if not l:match("boot.lua") then
			l = l:gsub("stack traceback:", "Traceback\n")
			table.insert(err, l)
		end
	end

	local p = table.concat(err, "\n")

	p = p:gsub("\t", "")
	p = p:gsub("%[string \"(.-)\"%]", "%1")

	local function draw()
		local pos = 70
		love.graphics.clear(89/255, 157/255, 220/255)
		love.graphics.printf(p, pos, pos, love.graphics.getWidth() - pos)
		love.graphics.present()
	end

	local fullErrorText = p
	local function copyToClipboard()
		if not love.system then return end
		love.system.setClipboardText(fullErrorText)
		p = p .. "\nCopied to clipboard!"
		draw()
	end

	if love.system then
		p = p .. "\n\nPress Ctrl+C or tap to copy this error"
	end

	return function()
		love.event.pump()

		for e, a, b, c in love.event.poll() do
			if e == "quit" then
				return 1
			elseif e == "keypressed" and a == "escape" then
				return 1
			elseif e == "keypressed" and a == "c" and love.keyboard.isDown("lctrl", "rctrl") then
				copyToClipboard()
			elseif e == "touchpressed" then
				local name = love.window.getTitle()
				if #name == 0 or name == "Untitled" then name = "Game" end
				local buttons = {"OK", "Cancel"}
				if love.system then
					buttons[3] = "Copy to clipboard"
				end
				local pressed = love.window.showMessageBox("Quit "..name.."?", "", buttons)
				if pressed == 1 then
					return 1
				elseif pressed == 3 then
					copyToClipboard()
				end
			end
		end

		draw()

		if love.timer then
			love.timer.sleep(0.1)
		end
	end

end
