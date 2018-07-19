script_author("qrlk")
script_description("Помогает в добавлении поддержки новых проектов для скрипт Support's Heaven.")

RPC = require 'lib.samp.events'

do
  log = load([[
	--
	-- log.lua
	--
	-- Copyright (c) 2016 rxi
	--
	-- This library is free software; you can redistribute it and/or modify it
	-- under the terms of the MIT license. See LICENSE for details.
	--

	local log = { _version = "0.1.0" }

	log.usecolor = true
	log.outfile = nil
	log.level = "trace"


	local modes = {
		{ name = "trace", color = "\27[34m", },
		{ name = "debug", color = "\27[36m", },
		{ name = "info",  color = "\27[32m", },
		{ name = "warn",  color = "\27[33m", },
		{ name = "error", color = "\27[31m", },
		{ name = "fatal", color = "\27[35m", },
	}


	local levels = {}
	for i, v in ipairs(modes) do
		levels[v.name] = i
	end


	local round = function(x, increment)
		increment = increment or 1
		x = x / increment
		return (x > 0 and math.floor(x + .5) or math.ceil(x - .5)) * increment
	end


	local _tostring = tostring

	local tostring = function(...)
		local t = {}
		for i = 1, select('#', ...) do
			local x = select(i, ...)
			if type(x) == "number" then
				x = round(x, .01)
			end
			t[#t + 1] = _tostring(x)
		end
		return table.concat(t, " ")
	end


	for i, x in ipairs(modes) do
		local nameupper = x.name:upper()
		log[x.name] = function(...)

			-- Return early if we're below the log level
			if i < levels[log.level] then
				return
			end

			local msg = tostring(...)
			local info = debug.getinfo(2, "Sl")
			local lineinfo = info.short_src .. ":" .. info.currentline

			-- Output to log file
			if log.outfile then
				local fp = io.open(log.outfile, "a")
				local str = string.format("[%-6s%s]: %s\n",
																	nameupper, os.date(), msg)
				fp:write(str)
				fp:close()
			end

		end
	end


	return log ]])()
end

log.outfile = getWorkingDirectory().."\\supports-heaven-add-my-server.txt"
log.info("Hello! I'm log")

sf =
[[SH помощник.
Строка - "%s"
Цвет - "%s"
Последняя команда - "%s"
Последний звук - "%s"
onDisplayGameText:
style - "%s"
time - "%s"
text - "%s"]]

function main()
  wait(2000)
  font = renderCreateFont("Arial", 16, 5)
  lua_thread.create(render)
  lua_thread.create(logger)
  while true do
    wait(0)
    if wasKeyPressed(119) then log.warn("F8 pressed") end
  end
end

function logger()
  while true do
    wait(1000)
    log.debug(string.format(sf, SMtext, SMcolor, SCtext, PSsound, DGTstyle, DGTtime, DGTtext))
  end
end

function render()
  resX, resY = getScreenResolution()
  while true do
    wait(0)
    while true do
      wait(0)
      renderFontDrawText(font, string.format(sf, SMtext, SMcolor, SCtext, PSsound, DGTstyle, DGTtime, DGTtext), resX / 50, resY / 3.5, 0xFF00FF00)
      renderFontDrawText(font, [[1. Скр с вопр.
			2. Скр с отв.
			3. Скр с ком для отв.
			4. Скр с onDisplayGameText после логина.
			5. Скр с командой, чтобы начать раб сап.
			6. Скр с вх смс.
			7. Скр с исх смс.
			8. Скр с ком для отпр смс.
			9. Скр с посл звук вх и исх смс.]], resX / 50, resY / 3.5 + 240, 0xFF00FF00)
    end
  end
end

function RPC.onPlaySound(rpcsound)
  PSsound = rpcsound
end

function RPC.onSendCommand(text)
  SCtext = text
end

function RPC.onDisplayGameText(rpcstyle, rpctime, rpctext)
  DGTtext = rpctext
  DGTstyle = rpcstyle
  DGTtime = rpctime
end

function RPC.onServerMessage(color, text)
  SMcolor = color
  SMtext = text
end
