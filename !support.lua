--meta
script_name("Support's Heaven")
script_author("qrlk")
script_version("1.03")
script_dependencies('CLEO 4+', 'SAMPFUNCS', 'Dear Imgui', 'SAMP.Lua')
script_moonloader(026)
script_changelog = [[	v1.03 [16.07.2018]
* /hh для чата.
* /hc для чата.
* FIX: быстрая остановка авто при нажатии хоткея с полем ввода.
* FIX: sduty - диалог не считается непрочитанным при ответе через /pm.
* FIX: sms - диалог не считается непрочитанным при ответе через /sms.
* FIX: списки диалогов смс зависили от настроек sduty.
	v1.02 [16.07.2018]
* FIX: изменение цвета вопроса.
	v1.01 [16.07.2018]
* FIX: вылет скрипта при поступлении вопроса/ответа.
* FIX: изменённые цвета теперь сохраняются правильно.
* FIX: теперь скрипт правильно работает с 0 id.
	v1.0 [15.07.2018]
* Релиз скрипта
]]
--require
do
  -- This is your secret 67-bit key (any random bits are OK)
  local Key53 = 8186484168865098
  local Key14 = 4887

  local inv256

  function decode(str)
    local K, F = Key53, 16384 + Key14
    return (str:gsub('%x%x',
      function(c)
      local L = K % 274877906944 -- 2^38
      local H = (K - L) / 274877906944
      local M = H % 128
      c = tonumber(c, 16)
      local m = (c + (H - M) / 128) * (2 * M + 1) % 256
      K = L * F + H + c + m
      return string.char(m)
    end))
  end
end

do
  function r_smart_cleo_and_sampfuncs()
    if isSampfuncsLoaded() == false then
      while not isPlayerPlaying(PLAYER_HANDLE) do wait(100) end
      wait(1000)
      setPlayerControl(PLAYER_HANDLE, false)
      setGxtEntry('CMLUTTL', 'Support\'s Heaven')
      setGxtEntry('CMLUMSG', 'Skriptu nuzhen SAMPFUNCS.asi dlya raboty.~n~~w~Esli net CLEO, to tozhe budet ustanovlen.~n~~w~Hotite chtoby ya ego skachal?~n~~w~')
      setGxtEntry('CMLUYES', 'Da!')
      setGxtEntry('CMLUY', 'Ne, otkroy ssylku, ia sam!')
      setGxtEntry('CMLUNO', 'Net!')
      local menu = createMenu('CMLUTTL', 120, 110, 400, 1, true, true, 1)
      local dummy = 'DUMMY'
      setMenuColumn(menu, 0, 'CMLUMSG', dummy, dummy, dummy, dummy, 'CMLUYES', 'CMLUY', 'CMLUNO', dummy, dummy, dummy, dummy, dummy, dummy)
      setActiveMenuItem(menu, 4)
      while true do
        wait(0)
        if isButtonPressed(PLAYER_HANDLE, 15) or isButtonPressed(PLAYER_HANDLE, 16) then
          if getMenuItemSelected(menu) == 4 then
            pass = true
            if not isCleoLoaded() then
              pass = false
              downloadUrlToFile("http://rubbishman.ru/dev/moonloader/cleo.asi", getGameDirectory().."\\cleo.asi",
                function(id, status, p1, p2)
                  if status == 5 then
                    printStringNow(string.format("CLEO.asi: %d KB / %d KB", p1 / 1000, p2 / 1000), 5000)
                  elseif status == 58 then
                    printStringNow("CLEO.asi installed.", 5000)
                    pass = true
                  end
                end
              )
            end
            while pass ~= true do wait(100) end
            downloadUrlToFile("http://rubbishman.ru/dev/moonloader/SAMPFUNCS.asi", getGameDirectory().."\\SAMPFUNCS.asi",
              function(id, status, p1, p2)
                if status == 5 then
                  printStringNow(string.format("SAMPFUNCS.asi: %d KB / %d KB", p1 / 1000, p2 / 1000), 5000)
                elseif status == 58 then
                  printStringNow("Installed. You MUST RESTART the game!", 5000)
                  thisScript():unload()
                end
              end
            )
          end
          if getMenuItemSelected(menu) == 5 then
            local ffi = require 'ffi'
            ffi.cdef [[
							void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
							uint32_t __stdcall CoInitializeEx(void*, uint32_t);
						]]
            local shell32 = ffi.load 'Shell32'
            local ole32 = ffi.load 'Ole32'
            ole32.CoInitializeEx(nil, 2 + 4) -- COINIT_APARTMENTTHREADED | COINIT_DISABLE_OLE1DDE
            deleteMenu(menu)
            print(shell32.ShellExecuteA(nil, 'open', 'https://blast.hk/threads/17/', nil, nil, 1))
            thisScript():unload()
          end
          break
        end
      end
      wait(0)
      deleteMenu(menu)
      setPlayerControl(PLAYER_HANDLE, true)
    end
  end

  function r_smart_lib_imgui()
    if not pcall(function() imgui = require 'imgui' end) then
      waiter = true
      local prefix = "[Support's Heaven]: "
      local color = 0xffa500
      sampAddChatMessage(prefix.."Модуль Dear ImGui загружен неудачно. Для работы скрипта этот модуль обязателен.", color)
      sampAddChatMessage(prefix.."Средство автоматического исправления ошибок может попробовать скачать модуль за вас.", color)
      sampAddChatMessage(prefix.."Нажмите F2, чтобы запустить средство автоматического исправления ошибок.", color)
      while not wasKeyPressed(113) do wait(10) end
      if wasKeyPressed(113) then
        sampAddChatMessage(prefix.."Запускаю средство автоматического исправления ошибок.", color)
        local imguifiles = {
          [getGameDirectory().."\\moonloader\\lib\\imgui.lua"] = "http://rubbishman.ru/dev/moonloader/lib/imgui.lua",
          [getGameDirectory().."\\moonloader\\lib\\MoonImGui.dll"] = "http://rubbishman.ru/dev/moonloader/lib/MoonImGui.dll"
        }
        createDirectory(getGameDirectory().."\\moonloader\\lib\\")
        for k, v in pairs(imguifiles) do
          if doesFileExist(k) then
            sampAddChatMessage(prefix.."Файл "..k.." найден.", color)
            sampAddChatMessage(prefix.."Удаляю "..k.." и скачиваю последнюю доступную версию.", color)
            os.remove(k)
          else
            sampAddChatMessage(prefix.."Файл "..k.." не найден.", color)
          end
          sampAddChatMessage(prefix.."Ссылка: "..v..". Пробую скачать.", color)
          pass = false
          wait(1500)
          downloadUrlToFile(v, k,
            function(id, status, p1, p2)
              if status == 5 then
                sampAddChatMessage(string.format(prefix..k..' - Загружено %d KB из %d KB.', p1 / 1000, p2 / 1000), color)
              elseif status == 58 then
                sampAddChatMessage(prefix..k..' - Загрузка завершена.', color)
                pass = true
              end
            end
          )
          while pass == false do wait(1) end
        end
        sampAddChatMessage(prefix.."Кажется, все файлы загружены. Попробую запустить модуль Dear ImGui ещё раз.", color)
        local status, err = pcall(function() imgui = require 'imgui' end)
        if status then
          sampAddChatMessage(prefix.."Модуль Dear ImGui успешно загружен!", color)
          waiter = false
          waitforreload = true
        else
          sampAddChatMessage(prefix.."Модуль Dear ImGui загружен неудачно!", color)
          sampAddChatMessage(prefix.."Обратитесь в поддержку скрипта (vk.me/qrlk.mods), приложив файл moonloader.log", color)
          print(err)
          for k, v in pairs(imguifiles) do
            print(k.." - "..tostring(doesFileExist(k)).." from "..v)
          end
          thisScript():unload()
        end
      end
    end
    while waiter do wait(100) end
  end

  function r_smart_lib_samp_events()
    if not pcall(function() RPC = require 'lib.samp.events' end) then
      waiter = true
      local prefix = "[Support's Heaven]: "
      local color = 0xffa500
      sampAddChatMessage(prefix.."Модуль SAMP.Lua загружен неудачно. Для работы скрипта этот модуль обязателен.", color)
      sampAddChatMessage(prefix.."Средство автоматического исправления ошибок может попробовать скачать модуль за вас.", color)
      sampAddChatMessage(prefix.."Нажмите F2, чтобы запустить средство автоматического исправления ошибок.", color)
      while not wasKeyPressed(113) do wait(10) end
      if wasKeyPressed(113) then
        sampAddChatMessage(prefix.."Запускаю средство автоматического исправления ошибок.", color)
        local sampluafiles = {
          [getGameDirectory().."\\moonloader\\lib\\samp\\events.lua"] = "https://raw.githubusercontent.com/THE-FYP/SAMP.Lua/master/samp/events.lua",
          [getGameDirectory().."\\moonloader\\lib\\samp\\raknet.lua"] = "https://raw.githubusercontent.com/THE-FYP/SAMP.Lua/master/samp/raknet.lua",
          [getGameDirectory().."\\moonloader\\lib\\samp\\synchronization.lua"] = "https://raw.githubusercontent.com/THE-FYP/SAMP.Lua/master/samp/synchronization.lua",
          [getGameDirectory().."\\moonloader\\lib\\samp\\events\\bitstream_io.lua"] = "https://raw.githubusercontent.com/THE-FYP/SAMP.Lua/master/samp/events/bitstream_io.lua",
          [getGameDirectory().."\\moonloader\\lib\\samp\\events\\core.lua"] = "https://raw.githubusercontent.com/THE-FYP/SAMP.Lua/master/samp/events/core.lua",
          [getGameDirectory().."\\moonloader\\lib\\samp\\events\\bitstream_io.lua"] = "https://raw.githubusercontent.com/THE-FYP/SAMP.Lua/master/samp/events/bitstream_io.lua",
          [getGameDirectory().."\\moonloader\\lib\\samp\\events\\extra_types.lua"] = "https://raw.githubusercontent.com/THE-FYP/SAMP.Lua/master/samp/events/extra_types.lua",
          [getGameDirectory().."\\moonloader\\lib\\samp\\events\\handlers.lua"] = "https://raw.githubusercontent.com/THE-FYP/SAMP.Lua/master/samp/events/handlers.lua",
          [getGameDirectory().."\\moonloader\\lib\\samp\\events\\utils.lua"] = "https://raw.githubusercontent.com/THE-FYP/SAMP.Lua/master/samp/events/utils.lua",
        }
        createDirectory(getGameDirectory().."\\moonloader\\lib\\samp\\events")
        for k, v in pairs(sampluafiles) do
          if doesFileExist(k) then
            sampAddChatMessage(prefix.."Файл "..k.." найден.", color)
            sampAddChatMessage(prefix.."Удаляю "..k.." и скачиваю последнюю доступную версию.", color)
            os.remove(k)
          else
            sampAddChatMessage(prefix.."Файл "..k.." не найден.", color)
          end
          sampAddChatMessage(prefix.."Ссылка: "..v..". Пробую скачать.", color)
          pass = false
          wait(1500)
          downloadUrlToFile(v, k,
            function(id, status, p1, p2)
              if status == 5 then
                sampAddChatMessage(string.format(prefix..k..' - Загружено %d KB из %d KB.', p1 / 1000, p2 / 1000), color)
              elseif status == 58 then
                sampAddChatMessage(prefix..k..' - Загрузка завершена.', color)
                pass = true
              end
            end
          )
          while pass == false do wait(1) end
        end
        sampAddChatMessage(prefix.."Кажется, все файлы загружены. Попробую запустить модуль SAMP.Lua ещё раз.", color)
        local status1, err = pcall(function() RPC = require 'lib.samp.events' end)
        if status1 then
          sampAddChatMessage(prefix.."Модуль SAMP.Lua успешно загружен!", color)
          waiter = false
          waitforreload = true
        else
          sampAddChatMessage(prefix.."Модуль SAMP.Lua загружен неудачно!", color)
          sampAddChatMessage(prefix.."Обратитесь в поддержку скрипта (vk.me/qrlk.mods), приложив файл moonloader.log", color)
          print(err)
          for k, v in pairs(sampluafiles) do
            print(k.." - "..tostring(doesFileExist(k)).." from "..v)
          end
          thisScript():unload()
        end
      end
    end
    while waiter do wait(100) end
  end

  function r_smart_get_projectresources()
    if not doesDirectoryExist(getGameDirectory().."\\moonloader\\resource\\sup\\"..mode) then
      local prefix = "[Support's Heaven]: "
      local color = 0xffa500
      sampAddChatMessage(prefix.."Для работы скрипта нужна папка с ресурсами, заготовленными для вашего проекта.", color)
      sampAddChatMessage(prefix.."Нажмите F2, чтобы запустить скачивание файлов для проекта "..mode, color)
      while not wasKeyPressed(113) do wait(10) end
      if wasKeyPressed(113) then
        createDirectory(getGameDirectory().."\\moonloader\\resource\\sup\\"..mode)
        local path = getGameDirectory().."\\moonloader\\resource\\sup\\"..mode.."\\"
        local webpath = "http://rubbishman.ru/dev/moonloader/support's_heaven/resource/sup/"..mode.."/"
        resourcesf = {
          [path.."house.txt"] = webpath.."house.txt",
          [path.."vehicle.txt"] = webpath.."vehicle.txt",
          [path.."spur.txt"] = webpath.."spur.txt",
        }
        for k, v in pairs(resourcesf) do
          sampAddChatMessage(prefix..v.." -> "..k, color)
          pass = false
          wait(100)
          downloadUrlToFile(v, k,
            function(id, status, p1, p2)
              if status == 5 then
                sampAddChatMessage(string.format(prefix..k..' - Загружено %d KB из %d KB.', p1 / 1000, p2 / 1000), color)
              elseif status == 58 then
                sampAddChatMessage(prefix..k..' - Загрузка завершена.', color)
                pass = true
              end
            end
          )
          while pass == false do wait(1) end
        end
        kol = 0
        for _ in io.lines(path.."spur.txt") do
          kol = kol + 1
        end
        for i = 1, kol do
          k = path..i..".png"
          v = webpath..i..".png"
          sampAddChatMessage(prefix..v.." -> "..k, color)
          pass = false
          wait(100)
          downloadUrlToFile(v, k,
            function(id, status, p1, p2)
              if status == 5 then
                sampAddChatMessage(string.format(prefix..k..' - Загружено %d KB из %d KB.', p1 / 1000, p2 / 1000), color)
              elseif status == 58 then
                sampAddChatMessage(prefix..k..' - Загрузка завершена.', color)
                pass = true
              end
            end
          )
          while pass == false do wait(1) end
        end
      end
    end
  end

  function r_smart_get_sounds()
    if not doesDirectoryExist(getGameDirectory().."\\moonloader\\resource\\sup\\sounds\\") then
      createDirectory(getGameDirectory().."\\moonloader\\resource\\sup\\sounds\\")
    end
    kols = 0
    for i = 1, currentaudiokol do
      local file = getGameDirectory().."\\moonloader\\resource\\sup\\sounds\\"..i..".mp3"
      if not doesFileExist(file) then
        kols = kols + 1
      end
    end
    if kols > 0 then
      local prefix = "[Support's Heaven]: "
      local color = 0xffa500
      sampAddChatMessage(prefix.."Для работы скрипта нужно докачать "..kols.." аудиофайлов.", color)
      sampAddChatMessage(prefix.."Нажмите F2, чтобы запустить скачивание аудиофайлов.", color)
      while not wasKeyPressed(113) do wait(10) end
      if wasKeyPressed(113) then
        createDirectory(getGameDirectory().."\\moonloader\\resource\\sup\\"..mode)
        for i = 1, 100 do
          local file = getGameDirectory().."\\moonloader\\resource\\sup\\sounds\\"..i..".mp3"
          if not doesFileExist(file) then
            v = "http://rubbishman.ru/dev/moonloader/support's_heaven/resource/sup/sounds/"..i..".mp3"
            k = file
            sampAddChatMessage(prefix..v.." -> "..k, color)
            pass = false
            wait(10)
            downloadUrlToFile(v, k,
              function(id, status, p1, p2)
                if status == 5 then
                  sampAddChatMessage(string.format(prefix..k..' - Загружено %d KB из %d KB.', p1 / 1000, p2 / 1000), color)
                elseif status == 58 then
                  sampAddChatMessage(prefix..k..' - Загрузка завершена.', color)
                  pass = true
                end
              end
            )
            while pass == false do wait(1) end
          end
        end
      end
    end
  end

  function r_lib_vkeys()
    -- This file is part of SA MoonLoader package.
    -- Licensed under the MIT License.
    -- Copyright (c) 2016, BlastHack Team <blast.hk>


    local k = { VK_LBUTTON = 0x01, VK_RBUTTON = 0x02, VK_CANCEL = 0x03, VK_MBUTTON = 0x04, VK_XBUTTON1 = 0x05, VK_XBUTTON2 = 0x06, VK_BACK = 0x08, VK_TAB = 0x09, VK_CLEAR = 0x0C, VK_RETURN = 0x0D, VK_SHIFT = 0x10, VK_CONTROL = 0x11, VK_MENU = 0x12, VK_PAUSE = 0x13, VK_CAPITAL = 0x14, VK_KANA = 0x15, VK_JUNJA = 0x17, VK_FINAL = 0x18, VK_KANJI = 0x19, VK_ESCAPE = 0x1B, VK_CONVERT = 0x1C, VK_NONCONVERT = 0x1D, VK_ACCEPT = 0x1E, VK_MODECHANGE = 0x1F, VK_SPACE = 0x20, VK_PRIOR = 0x21, VK_NEXT = 0x22, VK_END = 0x23, VK_HOME = 0x24, VK_LEFT = 0x25, VK_UP = 0x26, VK_RIGHT = 0x27, VK_DOWN = 0x28, VK_SELECT = 0x29, VK_PRINT = 0x2A, VK_EXECUTE = 0x2B, VK_SNAPSHOT = 0x2C, VK_INSERT = 0x2D, VK_DELETE = 0x2E, VK_HELP = 0x2F, VK_0 = 0x30, VK_1 = 0x31, VK_2 = 0x32, VK_3 = 0x33, VK_4 = 0x34, VK_5 = 0x35, VK_6 = 0x36, VK_7 = 0x37, VK_8 = 0x38, VK_9 = 0x39, VK_A = 0x41, VK_B = 0x42, VK_C = 0x43, VK_D = 0x44, VK_E = 0x45, VK_F = 0x46, VK_G = 0x47, VK_H = 0x48, VK_I = 0x49, VK_J = 0x4A, VK_K = 0x4B, VK_L = 0x4C, VK_M = 0x4D, VK_N = 0x4E, VK_O = 0x4F, VK_P = 0x50, VK_Q = 0x51, VK_R = 0x52, VK_S = 0x53, VK_T = 0x54, VK_U = 0x55, VK_V = 0x56, VK_W = 0x57, VK_X = 0x58, VK_Y = 0x59, VK_Z = 0x5A, VK_LWIN = 0x5B, VK_RWIN = 0x5C, VK_APPS = 0x5D, VK_SLEEP = 0x5F, VK_NUMPAD0 = 0x60, VK_NUMPAD1 = 0x61, VK_NUMPAD2 = 0x62, VK_NUMPAD3 = 0x63, VK_NUMPAD4 = 0x64, VK_NUMPAD5 = 0x65, VK_NUMPAD6 = 0x66, VK_NUMPAD7 = 0x67, VK_NUMPAD8 = 0x68, VK_NUMPAD9 = 0x69, VK_MULTIPLY = 0x6A, VK_ADD = 0x6B, VK_SEPARATOR = 0x6C, VK_SUBTRACT = 0x6D, VK_DECIMAL = 0x6E, VK_DIVIDE = 0x6F, VK_F1 = 0x70, VK_F2 = 0x71, VK_F3 = 0x72, VK_F4 = 0x73, VK_F5 = 0x74, VK_F6 = 0x75, VK_F7 = 0x76, VK_F8 = 0x77, VK_F9 = 0x78, VK_F10 = 0x79, VK_F11 = 0x7A, VK_F12 = 0x7B, VK_F13 = 0x7C, VK_F14 = 0x7D, VK_F15 = 0x7E, VK_F16 = 0x7F, VK_F17 = 0x80, VK_F18 = 0x81, VK_F19 = 0x82, VK_F20 = 0x83, VK_F21 = 0x84, VK_F22 = 0x85, VK_F23 = 0x86, VK_F24 = 0x87, VK_NUMLOCK = 0x90, VK_SCROLL = 0x91, VK_OEM_FJ_JISHO = 0x92, VK_OEM_FJ_MASSHOU = 0x93, VK_OEM_FJ_TOUROKU = 0x94, VK_OEM_FJ_LOYA = 0x95, VK_OEM_FJ_ROYA = 0x96, VK_LSHIFT = 0xA0, VK_RSHIFT = 0xA1, VK_LCONTROL = 0xA2, VK_RCONTROL = 0xA3, VK_LMENU = 0xA4, VK_RMENU = 0xA5, VK_BROWSER_BACK = 0xA6, VK_BROWSER_FORWARD = 0xA7, VK_BROWSER_REFRESH = 0xA8, VK_BROWSER_STOP = 0xA9, VK_BROWSER_SEARCH = 0xAA, VK_BROWSER_FAVORITES = 0xAB, VK_BROWSER_HOME = 0xAC, VK_VOLUME_MUTE = 0xAD, VK_VOLUME_DOWN = 0xAE, VK_VOLUME_UP = 0xAF, VK_MEDIA_NEXT_TRACK = 0xB0, VK_MEDIA_PREV_TRACK = 0xB1, VK_MEDIA_STOP = 0xB2, VK_MEDIA_PLAY_PAUSE = 0xB3, VK_LAUNCH_MAIL = 0xB4, VK_LAUNCH_MEDIA_SELECT = 0xB5, VK_LAUNCH_APP1 = 0xB6, VK_LAUNCH_APP2 = 0xB7, VK_OEM_1 = 0xBA, VK_OEM_PLUS = 0xBB, VK_OEM_COMMA = 0xBC, VK_OEM_MINUS = 0xBD, VK_OEM_PERIOD = 0xBE, VK_OEM_2 = 0xBF, VK_OEM_3 = 0xC0, VK_ABNT_C1 = 0xC1, VK_ABNT_C2 = 0xC2, VK_OEM_4 = 0xDB, VK_OEM_5 = 0xDC, VK_OEM_6 = 0xDD, VK_OEM_7 = 0xDE, VK_OEM_8 = 0xDF, VK_OEM_AX = 0xE1, VK_OEM_102 = 0xE2, VK_ICO_HELP = 0xE3, VK_PROCESSKEY = 0xE5, VK_ICO_CLEAR = 0xE6, VK_PACKET = 0xE7, VK_OEM_RESET = 0xE9, VK_OEM_JUMP = 0xEA, VK_OEM_PA1 = 0xEB, VK_OEM_PA2 = 0xEC, VK_OEM_PA3 = 0xED, VK_OEM_WSCTRL = 0xEE, VK_OEM_CUSEL = 0xEF, VK_OEM_ATTN = 0xF0, VK_OEM_FINISH = 0xF1, VK_OEM_COPY = 0xF2, VK_OEM_AUTO = 0xF3, VK_OEM_ENLW = 0xF4, VK_OEM_BACKTAB = 0xF5, VK_ATTN = 0xF6, VK_CRSEL = 0xF7, VK_EXSEL = 0xF8, VK_EREOF = 0xF9, VK_PLAY = 0xFA, VK_ZOOM = 0xFB, VK_PA1 = 0xFD, VK_OEM_CLEAR = 0xFE,
    }

    local names = {
      [k.VK_LBUTTON] = 'Left Button',
      [k.VK_RBUTTON] = 'Right Button',
      [k.VK_CANCEL] = 'Break',
      [k.VK_MBUTTON] = 'Middle Button',
      [k.VK_XBUTTON1] = 'X Button 1',
      [k.VK_XBUTTON2] = 'X Button 2',
      [k.VK_BACK] = 'Backspace',
      [k.VK_TAB] = 'Tab',
      [k.VK_CLEAR] = 'Clear',
      [k.VK_RETURN] = 'Enter',
      [k.VK_SHIFT] = 'Shift',
      [k.VK_CONTROL] = 'Ctrl',
      [k.VK_MENU] = 'Alt',
      [k.VK_PAUSE] = 'Pause',
      [k.VK_CAPITAL] = 'Caps Lock',
      [k.VK_KANA] = 'Kana',
      [k.VK_JUNJA] = 'Junja',
      [k.VK_FINAL] = 'Final',
      [k.VK_KANJI] = 'Kanji',
      [k.VK_ESCAPE] = 'Esc',
      [k.VK_CONVERT] = 'Convert',
      [k.VK_NONCONVERT] = 'Non Convert',
      [k.VK_ACCEPT] = 'Accept',
      [k.VK_MODECHANGE] = 'Mode Change',
      [k.VK_SPACE] = 'Space',
      [k.VK_PRIOR] = 'Page Up',
      [k.VK_NEXT] = 'Page Down',
      [k.VK_END] = 'End',
      [k.VK_HOME] = 'Home',
      [k.VK_LEFT] = 'Arrow Left',
      [k.VK_UP] = 'Arrow Up',
      [k.VK_RIGHT] = 'Arrow Right',
      [k.VK_DOWN] = 'Arrow Down',
      [k.VK_SELECT] = 'Select',
      [k.VK_PRINT] = 'Print',
      [k.VK_EXECUTE] = 'Execute',
      [k.VK_SNAPSHOT] = 'Print Screen',
      [k.VK_INSERT] = 'Insert',
      [k.VK_DELETE] = 'Delete',
      [k.VK_HELP] = 'Help',
      [k.VK_0] = '0',
      [k.VK_1] = '1',
      [k.VK_2] = '2',
      [k.VK_3] = '3',
      [k.VK_4] = '4',
      [k.VK_5] = '5',
      [k.VK_6] = '6',
      [k.VK_7] = '7',
      [k.VK_8] = '8',
      [k.VK_9] = '9',
      [k.VK_A] = 'A',
      [k.VK_B] = 'B',
      [k.VK_C] = 'C',
      [k.VK_D] = 'D',
      [k.VK_E] = 'E',
      [k.VK_F] = 'F',
      [k.VK_G] = 'G',
      [k.VK_H] = 'H',
      [k.VK_I] = 'I',
      [k.VK_J] = 'J',
      [k.VK_K] = 'K',
      [k.VK_L] = 'L',
      [k.VK_M] = 'M',
      [k.VK_N] = 'N',
      [k.VK_O] = 'O',
      [k.VK_P] = 'P',
      [k.VK_Q] = 'Q',
      [k.VK_R] = 'R',
      [k.VK_S] = 'S',
      [k.VK_T] = 'T',
      [k.VK_U] = 'U',
      [k.VK_V] = 'V',
      [k.VK_W] = 'W',
      [k.VK_X] = 'X',
      [k.VK_Y] = 'Y',
      [k.VK_Z] = 'Z',
      [k.VK_LWIN] = 'Left Win',
      [k.VK_RWIN] = 'Right Win',
      [k.VK_APPS] = 'Context Menu',
      [k.VK_SLEEP] = 'Sleep',
      [k.VK_NUMPAD0] = 'Numpad 0',
      [k.VK_NUMPAD1] = 'Numpad 1',
      [k.VK_NUMPAD2] = 'Numpad 2',
      [k.VK_NUMPAD3] = 'Numpad 3',
      [k.VK_NUMPAD4] = 'Numpad 4',
      [k.VK_NUMPAD5] = 'Numpad 5',
      [k.VK_NUMPAD6] = 'Numpad 6',
      [k.VK_NUMPAD7] = 'Numpad 7',
      [k.VK_NUMPAD8] = 'Numpad 8',
      [k.VK_NUMPAD9] = 'Numpad 9',
      [k.VK_MULTIPLY] = 'Numpad *',
      [k.VK_ADD] = 'Numpad +',
      [k.VK_SEPARATOR] = 'Separator',
      [k.VK_SUBTRACT] = 'Num -',
      [k.VK_DECIMAL] = 'Numpad .',
      [k.VK_DIVIDE] = 'Numpad /',
      [k.VK_F1] = 'F1',
      [k.VK_F2] = 'F2',
      [k.VK_F3] = 'F3',
      [k.VK_F4] = 'F4',
      [k.VK_F5] = 'F5',
      [k.VK_F6] = 'F6',
      [k.VK_F7] = 'F7',
      [k.VK_F8] = 'F8',
      [k.VK_F9] = 'F9',
      [k.VK_F10] = 'F10',
      [k.VK_F11] = 'F11',
      [k.VK_F12] = 'F12',
      [k.VK_F13] = 'F13',
      [k.VK_F14] = 'F14',
      [k.VK_F15] = 'F15',
      [k.VK_F16] = 'F16',
      [k.VK_F17] = 'F17',
      [k.VK_F18] = 'F18',
      [k.VK_F19] = 'F19',
      [k.VK_F20] = 'F20',
      [k.VK_F21] = 'F21',
      [k.VK_F22] = 'F22',
      [k.VK_F23] = 'F23',
      [k.VK_F24] = 'F24',
      [k.VK_NUMLOCK] = 'Num Lock',
      [k.VK_SCROLL] = 'Scrol Lock',
      [k.VK_OEM_FJ_JISHO] = 'Jisho',
      [k.VK_OEM_FJ_MASSHOU] = 'Mashu',
      [k.VK_OEM_FJ_TOUROKU] = 'Touroku',
      [k.VK_OEM_FJ_LOYA] = 'Loya',
      [k.VK_OEM_FJ_ROYA] = 'Roya',
      [k.VK_LSHIFT] = 'Left Shift',
      [k.VK_RSHIFT] = 'Right Shift',
      [k.VK_LCONTROL] = 'Left Ctrl',
      [k.VK_RCONTROL] = 'Right Ctrl',
      [k.VK_LMENU] = 'Left Alt',
      [k.VK_RMENU] = 'Right Alt',
      [k.VK_BROWSER_BACK] = 'Browser Back',
      [k.VK_BROWSER_FORWARD] = 'Browser Forward',
      [k.VK_BROWSER_REFRESH] = 'Browser Refresh',
      [k.VK_BROWSER_STOP] = 'Browser Stop',
      [k.VK_BROWSER_SEARCH] = 'Browser Search',
      [k.VK_BROWSER_FAVORITES] = 'Browser Favorites',
      [k.VK_BROWSER_HOME] = 'Browser Home',
      [k.VK_VOLUME_MUTE] = 'Volume Mute',
      [k.VK_VOLUME_DOWN] = 'Volume Down',
      [k.VK_VOLUME_UP] = 'Volume Up',
      [k.VK_MEDIA_NEXT_TRACK] = 'Next Track',
      [k.VK_MEDIA_PREV_TRACK] = 'Previous Track',
      [k.VK_MEDIA_STOP] = 'Stop',
      [k.VK_MEDIA_PLAY_PAUSE] = 'Play / Pause',
      [k.VK_LAUNCH_MAIL] = 'Mail',
      [k.VK_LAUNCH_MEDIA_SELECT] = 'Media',
      [k.VK_LAUNCH_APP1] = 'App1',
      [k.VK_LAUNCH_APP2] = 'App2',
      [k.VK_OEM_1] = {';', ':'},
      [k.VK_OEM_PLUS] = {'=', '+'},
      [k.VK_OEM_COMMA] = {',', '<'},
      [k.VK_OEM_MINUS] = {'-', '_'},
      [k.VK_OEM_PERIOD] = {'.', '>'},
      [k.VK_OEM_2] = {'/', '?'},
      [k.VK_OEM_3] = {'`', '~'},
      [k.VK_ABNT_C1] = 'Abnt C1',
      [k.VK_ABNT_C2] = 'Abnt C2',
      [k.VK_OEM_4] = {'[', '{'},
      [k.VK_OEM_5] = {'\'', '|'},
      [k.VK_OEM_6] = {']', '}'},
      [k.VK_OEM_7] = {'\'', '"'},
      [k.VK_OEM_8] = {'!', '§'},
      [k.VK_OEM_AX] = 'Ax',
      [k.VK_OEM_102] = '> <',
      [k.VK_ICO_HELP] = 'IcoHlp',
      [k.VK_PROCESSKEY] = 'Process',
      [k.VK_ICO_CLEAR] = 'IcoClr',
      [k.VK_PACKET] = 'Packet',
      [k.VK_OEM_RESET] = 'Reset',
      [k.VK_OEM_JUMP] = 'Jump',
      [k.VK_OEM_PA1] = 'OemPa1',
      [k.VK_OEM_PA2] = 'OemPa2',
      [k.VK_OEM_PA3] = 'OemPa3',
      [k.VK_OEM_WSCTRL] = 'WsCtrl',
      [k.VK_OEM_CUSEL] = 'Cu Sel',
      [k.VK_OEM_ATTN] = 'Oem Attn',
      [k.VK_OEM_FINISH] = 'Finish',
      [k.VK_OEM_COPY] = 'Copy',
      [k.VK_OEM_AUTO] = 'Auto',
      [k.VK_OEM_ENLW] = 'Enlw',
      [k.VK_OEM_BACKTAB] = 'Back Tab',
      [k.VK_ATTN] = 'Attn',
      [k.VK_CRSEL] = 'Cr Sel',
      [k.VK_EXSEL] = 'Ex Sel',
      [k.VK_EREOF] = 'Er Eof',
      [k.VK_PLAY] = 'Play',
      [k.VK_ZOOM] = 'Zoom',
      [k.VK_PA1] = 'Pa1',
      [k.VK_OEM_CLEAR] = 'OemClr'
    }

    k.key_names = names

    function k.id_to_name(vkey)
      local name = names[vkey]
      if type(name) == 'table' then
        return name[1]
      end
      return name
    end

    function k.name_to_id(keyname, case_sensitive)
      if not case_sensitive then
        keyname = string.upper(keyname)
      end
      for id, v in pairs(names) do
        if type(v) == 'table' then
          for _, v2 in pairs(v) do
            v2 = (case_sensitive) and v2 or string.upper(v2)
            if v2 == keyname then
              return id
            end
          end
        else
          local name = (case_sensitive) and v or string.upper(v)
          if name == keyname then
            return id
          end
        end
      end
    end

    return k
  end

  function r_lib_rkeys()

    --[[Register HotKey for MoonLoader
	   Author: DonHomka
	   Functions:
	      - bool result, int id = registerHotKey(table keys, bool pressed, function callback)
	      - bool result, int count = unRegisterHotKey(table keys)
	      - bool result, int id = isHotKeyDefined(table keys)
	      - bool result, int id = blockNextHotKey(table keys)
	      - bool result, int count = unBlockNextHotKey(table keys)
	      - bool result, int id = isBlockedHotKey(table keys)
	      - table keys = getCurrentHotKey()
	      - table keys = getAllHotKey()
	   HotKey data:
	      - table keys                  Return table keys for active hotkey
	      - bool pressed                True - wasKeyPressed() / False - isKeyDown()
	      - function callback           Call this function on active hotkey
	   E-mail: a.skinfy@gmail.com
	   VK: http://vk.com/DonHomka
	   TeleGramm: http://t.me/DonHomka
	   Discord: DonHomka#2534]]
    local vkeys = r_lib_vkeys()

    vkeys.key_names[vkeys.VK_LMENU] = "LAlt"
    vkeys.key_names[vkeys.VK_RMENU] = "RAlt"
    vkeys.key_names[vkeys.VK_LSHIFT] = "LShift"
    vkeys.key_names[vkeys.VK_RSHIFT] = "RShift"
    vkeys.key_names[vkeys.VK_LCONTROL] = "LCtrl"
    vkeys.key_names[vkeys.VK_RCONTROL] = "RCtrl"

    local tHotKey = {}
    local tKeyList = {}
    local tKeysCheck = {}
    local iCountCheck = 0
    local tBlockKeys = {[vkeys.VK_LMENU] = true, [vkeys.VK_RMENU] = true, [vkeys.VK_RSHIFT] = true, [vkeys.VK_LSHIFT] = true, [vkeys.VK_LCONTROL] = true, [vkeys.VK_RCONTROL] = true}
    local tModKeys = {[vkeys.VK_MENU] = true, [vkeys.VK_SHIFT] = true, [vkeys.VK_CONTROL] = true}
    local tBlockNext = {}
    local module = {}
    module._VERSION = "1.0.7"
    module._MODKEYS = tModKeys
    module._LOCKKEYS = false

    local function getKeyNum(id)
      for k, v in pairs(tKeyList) do
        if v == id then
          return k
        end
      end
      return 0
    end

    function module.blockNextHotKey(keys)
      local bool = false
      if not module.isBlockedHotKey(keys) then
        tBlockNext[#tBlockNext + 1] = keys
        bool = true
      end
      return bool
    end

    function module.isHotKeyHotKey(keys, keys2)
      local bool
      for k, v in pairs(keys) do
        local lBool = true
        for i = 1, #keys2 do
          if v ~= keys2[i] then
            lBool = false
            break
          end
        end
        if lBool then
          bool = true
          break
        end
      end
      return bool
    end


    function module.isBlockedHotKey(keys)
      local bool, hkId = false, - 1
      for k, v in pairs(tBlockNext) do
        if module.isHotKeyHotKey(keys, v) then
          bool = true
          hkId = k
          break
        end
      end
      return bool, hkId
    end

    function module.unBlockNextHotKey(keys)
      local result = false
      local count = 0
      while module.isBlockedHotKey(keys) do
        local _, id = module.isBlockedHotKey(keys)
        tHotKey[id] = nil
        result = true
        count = count + 1
      end
      local id = 1
      for k, v in pairs(tBlockNext) do
        tBlockNext[id] = v
        id = id + 1
      end
      return result, count
    end

    function module.isKeyModified(id)
      return (tModKeys[id] or false) or (tBlockKeys[id] or false)
    end

    function module.isModifiedDown()
      local bool = false
      for k, v in pairs(tModKeys) do
        if isKeyDown(k) then
          bool = true
          break
        end
      end
      return bool
    end

    lua_thread.create(
      function ()
        while true do
          wait(0)
          local tDownKeys = module.getCurrentHotKey()
          for k, v in pairs(tHotKey) do
            if #v.keys > 0 then
              local bool = true
              for i = 1, #v.keys do
                if i ~= #v.keys and (getKeyNum(v.keys[i]) > getKeyNum(v.keys[i + 1]) or getKeyNum(v.keys[i]) == 0) then
                  bool = false
                  break
                elseif i == #v.keys and (v.pressed and not wasKeyPressed(v.keys[i]) or not v.pressed and not isKeyDown(v.keys[i])) or (#v.keys == 1 and module.isModifiedDown()) then
                  bool = false
                  break
                end
              end
              if bool and ((module.onHotKey and module.onHotKey(k, v.keys) ~= false) or module.onHotKey == nil) then
                local result, id = module.isBlockedHotKey(v.keys)
                if not result then
                  v.callback(k, v.keys)
                else
                  tBlockNext[id] = nil
                end
              end
            end
          end
        end
      end
    )

    function module.registerHotKey(keys, pressed, callback)
      tHotKey[#tHotKey + 1] = {keys = keys, pressed = pressed, callback = callback}
      return true, #tHotKey
    end

    function module.getAllHotKey()
      return tHotKey
    end

    function module.unRegisterHotKey(keys)
      local result = false
      local count = 0
      while module.isHotKeyDefined(keys) do
        local _, id = module.isHotKeyDefined(keys)
        tHotKey[id] = nil
        result = true
        count = count + 1
      end
      local id = 1
      local tNewHotKey = {}
      for k, v in pairs(tHotKey) do
        tNewHotKey[id] = v
        id = id + 1
      end
      tHotKey = tNewHotKey
      return result, count
    end

    function module.isHotKeyDefined(keys)
      local bool, hkId = false, - 1
      for k, v in pairs(tHotKey) do
        if module.isHotKeyHotKey(keys, v.keys) then
          bool = true
          hkId = k
          break
        end
      end
      return bool, hkId
    end

    function module.getKeysName(keys)
      local tKeysName = {}
      for k, v in ipairs(keys) do
        tKeysName[k] = vkeys.id_to_name(v)
      end
      return tKeysName
    end

    function module.getCurrentHotKey(type)
      local type = type or 0
      local tCurKeys = {}
      for k, v in pairs(vkeys) do
        if tBlockKeys[v] == nil then
          local num, down = getKeyNum(v), isKeyDown(v)
          if down and num == 0 then
            tKeyList[#tKeyList + 1] = v
          elseif num > 0 and not down then
            tKeyList[num] = nil
          end
        end
      end
      local i = 1
      for k, v in pairs(tKeyList) do
        tCurKeys[i] = type == 0 and v or vkeys.id_to_name(v)
        i = i + 1
      end
      return tCurKeys
    end

    return module
  end

  function r_lib_window_message()
    -- This file is part of SA MoonLoader package.
    -- Licensed under the MIT License.
    -- Copyright (c) 2016, BlastHack Team <blast.hk>

    -- From https://wiki.winehq.org/List_Of_Windows_Messages
    local messages = { WM_CREATE = 0x0001, WM_DESTROY = 0x0002, WM_MOVE = 0x0003, WM_SIZE = 0x0005, WM_ACTIVATE = 0x0006, WM_SETFOCUS = 0x0007, WM_KILLFOCUS = 0x0008, WM_ENABLE = 0x000a, WM_SETREDRAW = 0x000b, WM_SETTEXT = 0x000c, WM_GETTEXT = 0x000d, WM_GETTEXTLENGTH = 0x000e, WM_PAINT = 0x000f, WM_CLOSE = 0x0010, WM_QUERYENDSESSION = 0x0011, WM_QUIT = 0x0012, WM_QUERYOPEN = 0x0013, WM_ERASEBKGND = 0x0014, WM_SYSCOLORCHANGE = 0x0015, WM_ENDSESSION = 0x0016, WM_SHOWWINDOW = 0x0018, WM_CTLCOLOR = 0x0019, WM_WININICHANGE = 0x001a, WM_DEVMODECHANGE = 0x001b, WM_ACTIVATEAPP = 0x001c, WM_FONTCHANGE = 0x001d, WM_TIMECHANGE = 0x001e, WM_CANCELMODE = 0x001f, WM_SETCURSOR = 0x0020, WM_MOUSEACTIVATE = 0x0021, WM_CHILDACTIVATE = 0x0022, WM_QUEUESYNC = 0x0023, WM_GETMINMAXINFO = 0x0024, WM_PAINTICON = 0x0026, WM_ICONERASEBKGND = 0x0027, WM_NEXTDLGCTL = 0x0028, WM_SPOOLERSTATUS = 0x002a, WM_DRAWITEM = 0x002b, WM_MEASUREITEM = 0x002c, WM_DELETEITEM = 0x002d, WM_VKEYTOITEM = 0x002e, WM_CHARTOITEM = 0x002f, WM_SETFONT = 0x0030, WM_GETFONT = 0x0031, WM_SETHOTKEY = 0x0032, WM_GETHOTKEY = 0x0033, WM_QUERYDRAGICON = 0x0037, WM_COMPAREITEM = 0x0039, WM_GETOBJECT = 0x003d, WM_COMPACTING = 0x0041, WM_COMMNOTIFY = 0x0044, WM_WINDOWPOSCHANGING = 0x0046, WM_WINDOWPOSCHANGED = 0x0047, WM_POWER = 0x0048, WM_COPYGLOBALDATA = 0x0049, WM_COPYDATA = 0x004a, WM_CANCELJOURNAL = 0x004b, WM_NOTIFY = 0x004e, WM_INPUTLANGCHANGEREQUEST = 0x0050, WM_INPUTLANGCHANGE = 0x0051, WM_TCARD = 0x0052, WM_HELP = 0x0053, WM_USERCHANGED = 0x0054, WM_NOTIFYFORMAT = 0x0055, WM_CONTEXTMENU = 0x007b, WM_STYLECHANGING = 0x007c, WM_STYLECHANGED = 0x007d, WM_DISPLAYCHANGE = 0x007e, WM_GETICON = 0x007f, WM_SETICON = 0x0080, WM_NCCREATE = 0x0081, WM_NCDESTROY = 0x0082, WM_NCCALCSIZE = 0x0083, WM_NCHITTEST = 0x0084, WM_NCPAINT = 0x0085, WM_NCACTIVATE = 0x0086, WM_GETDLGCODE = 0x0087, WM_SYNCPAINT = 0x0088, WM_NCMOUSEMOVE = 0x00a0, WM_NCLBUTTONDOWN = 0x00a1, WM_NCLBUTTONUP = 0x00a2, WM_NCLBUTTONDBLCLK = 0x00a3, WM_NCRBUTTONDOWN = 0x00a4, WM_NCRBUTTONUP = 0x00a5, WM_NCRBUTTONDBLCLK = 0x00a6, WM_NCMBUTTONDOWN = 0x00a7, WM_NCMBUTTONUP = 0x00a8, WM_NCMBUTTONDBLCLK = 0x00a9, WM_NCXBUTTONDOWN = 0x00ab, WM_NCXBUTTONUP = 0x00ac, WM_NCXBUTTONDBLCLK = 0x00ad, EM_GETSEL = 0x00b0, EM_SETSEL = 0x00b1, EM_GETRECT = 0x00b2, EM_SETRECT = 0x00b3, EM_SETRECTNP = 0x00b4, EM_SCROLL = 0x00b5, EM_LINESCROLL = 0x00b6, EM_SCROLLCARET = 0x00b7, EM_GETMODIFY = 0x00b8, EM_SETMODIFY = 0x00b9, EM_GETLINECOUNT = 0x00ba, EM_LINEINDEX = 0x00bb, EM_SETHANDLE = 0x00bc, EM_GETHANDLE = 0x00bd, EM_GETTHUMB = 0x00be, EM_LINELENGTH = 0x00c1, EM_REPLACESEL = 0x00c2, EM_SETFONT = 0x00c3, EM_GETLINE = 0x00c4, EM_LIMITTEXT = 0x00c5, EM_SETLIMITTEXT = 0x00c5, EM_CANUNDO = 0x00c6, EM_UNDO = 0x00c7, EM_FMTLINES = 0x00c8, EM_LINEFROMCHAR = 0x00c9, EM_SETWORDBREAK = 0x00ca, EM_SETTABSTOPS = 0x00cb, EM_SETPASSWORDCHAR = 0x00cc, EM_EMPTYUNDOBUFFER = 0x00cd, EM_GETFIRSTVISIBLELINE = 0x00ce, EM_SETREADONLY = 0x00cf, EM_SETWORDBREAKPROC = 0x00d0, EM_GETWORDBREAKPROC = 0x00d1, EM_GETPASSWORDCHAR = 0x00d2, EM_SETMARGINS = 0x00d3, EM_GETMARGINS = 0x00d4, EM_GETLIMITTEXT = 0x00d5, EM_POSFROMCHAR = 0x00d6, EM_CHARFROMPOS = 0x00d7, EM_SETIMESTATUS = 0x00d8, EM_GETIMESTATUS = 0x00d9, SBM_SETPOS = 0x00e0, SBM_GETPOS = 0x00e1, SBM_SETRANGE = 0x00e2, SBM_GETRANGE = 0x00e3, SBM_ENABLE_ARROWS = 0x00e4, SBM_SETRANGEREDRAW = 0x00e6, SBM_SETSCROLLINFO = 0x00e9, SBM_GETSCROLLINFO = 0x00ea, SBM_GETSCROLLBARINFO = 0x00eb, BM_GETCHECK = 0x00f0, BM_SETCHECK = 0x00f1, BM_GETSTATE = 0x00f2, BM_SETSTATE = 0x00f3, BM_SETSTYLE = 0x00f4, BM_CLICK = 0x00f5, BM_GETIMAGE = 0x00f6, BM_SETIMAGE = 0x00f7, BM_SETDONTCLICK = 0x00f8, WM_INPUT = 0x00ff, WM_KEYDOWN = 0x0100, WM_KEYFIRST = 0x0100, WM_KEYUP = 0x0101, WM_CHAR = 0x0102, WM_DEADCHAR = 0x0103, WM_SYSKEYDOWN = 0x0104, WM_SYSKEYUP = 0x0105, WM_SYSCHAR = 0x0106, WM_SYSDEADCHAR = 0x0107, WM_KEYLAST = 0x0108, WM_UNICHAR = 0x0109, WM_WNT_CONVERTREQUESTEX = 0x0109, WM_CONVERTREQUEST = 0x010a, WM_CONVERTRESULT = 0x010b, WM_INTERIM = 0x010c, WM_IME_STARTCOMPOSITION = 0x010d, WM_IME_ENDCOMPOSITION = 0x010e, WM_IME_COMPOSITION = 0x010f, WM_IME_KEYLAST = 0x010f, WM_INITDIALOG = 0x0110, WM_COMMAND = 0x0111, WM_SYSCOMMAND = 0x0112, WM_TIMER = 0x0113, WM_HSCROLL = 0x0114, WM_VSCROLL = 0x0115, WM_INITMENU = 0x0116, WM_INITMENUPOPUP = 0x0117, WM_SYSTIMER = 0x0118, WM_MENUSELECT = 0x011f, WM_MENUCHAR = 0x0120, WM_ENTERIDLE = 0x0121, WM_MENURBUTTONUP = 0x0122, WM_MENUDRAG = 0x0123, WM_MENUGETOBJECT = 0x0124, WM_UNINITMENUPOPUP = 0x0125, WM_MENUCOMMAND = 0x0126, WM_CHANGEUISTATE = 0x0127, WM_UPDATEUISTATE = 0x0128, WM_QUERYUISTATE = 0x0129, WM_CTLCOLORMSGBOX = 0x0132, WM_CTLCOLOREDIT = 0x0133, WM_CTLCOLORLISTBOX = 0x0134, WM_CTLCOLORBTN = 0x0135, WM_CTLCOLORDLG = 0x0136, WM_CTLCOLORSCROLLBAR = 0x0137, WM_CTLCOLORSTATIC = 0x0138, WM_MOUSEFIRST = 0x0200, WM_MOUSEMOVE = 0x0200, WM_LBUTTONDOWN = 0x0201, WM_LBUTTONUP = 0x0202, WM_LBUTTONDBLCLK = 0x0203, WM_RBUTTONDOWN = 0x0204, WM_RBUTTONUP = 0x0205, WM_RBUTTONDBLCLK = 0x0206, WM_MBUTTONDOWN = 0x0207, WM_MBUTTONUP = 0x0208, WM_MBUTTONDBLCLK = 0x0209, WM_MOUSELAST = 0x0209, WM_MOUSEWHEEL = 0x020a, WM_XBUTTONDOWN = 0x020b, WM_XBUTTONUP = 0x020c, WM_XBUTTONDBLCLK = 0x020d, WM_PARENTNOTIFY = 0x0210, WM_ENTERMENULOOP = 0x0211, WM_EXITMENULOOP = 0x0212, WM_NEXTMENU = 0x0213, WM_SIZING = 0x0214, WM_CAPTURECHANGED = 0x0215, WM_MOVING = 0x0216, WM_POWERBROADCAST = 0x0218, WM_DEVICECHANGE = 0x0219, WM_MDICREATE = 0x0220, WM_MDIDESTROY = 0x0221, WM_MDIACTIVATE = 0x0222, WM_MDIRESTORE = 0x0223, WM_MDINEXT = 0x0224, WM_MDIMAXIMIZE = 0x0225, WM_MDITILE = 0x0226, WM_MDICASCADE = 0x0227, WM_MDIICONARRANGE = 0x0228, WM_MDIGETACTIVE = 0x0229, WM_MDISETMENU = 0x0230, WM_ENTERSIZEMOVE = 0x0231, WM_EXITSIZEMOVE = 0x0232, WM_DROPFILES = 0x0233, WM_MDIREFRESHMENU = 0x0234, WM_IME_REPORT = 0x0280, WM_IME_SETCONTEXT = 0x0281, WM_IME_NOTIFY = 0x0282, WM_IME_CONTROL = 0x0283, WM_IME_COMPOSITIONFULL = 0x0284, WM_IME_SELECT = 0x0285, WM_IME_CHAR = 0x0286, WM_IME_REQUEST = 0x0288, WM_IMEKEYDOWN = 0x0290, WM_IME_KEYDOWN = 0x0290, WM_IMEKEYUP = 0x0291, WM_IME_KEYUP = 0x0291, WM_NCMOUSEHOVER = 0x02a0, WM_MOUSEHOVER = 0x02a1, WM_NCMOUSELEAVE = 0x02a2, WM_MOUSELEAVE = 0x02a3, WM_CUT = 0x0300, WM_COPY = 0x0301, WM_PASTE = 0x0302, WM_CLEAR = 0x0303, WM_UNDO = 0x0304, WM_RENDERFORMAT = 0x0305, WM_RENDERALLFORMATS = 0x0306, WM_DESTROYCLIPBOARD = 0x0307, WM_DRAWCLIPBOARD = 0x0308, WM_PAINTCLIPBOARD = 0x0309, WM_VSCROLLCLIPBOARD = 0x030a, WM_SIZECLIPBOARD = 0x030b, WM_ASKCBFORMATNAME = 0x030c, WM_CHANGECBCHAIN = 0x030d, WM_HSCROLLCLIPBOARD = 0x030e, WM_QUERYNEWPALETTE = 0x030f, WM_PALETTEISCHANGING = 0x0310, WM_PALETTECHANGED = 0x0311, WM_HOTKEY = 0x0312, WM_PRINT = 0x0317, WM_PRINTCLIENT = 0x0318, WM_APPCOMMAND = 0x0319, WM_HANDHELDFIRST = 0x0358, WM_HANDHELDLAST = 0x035f, WM_AFXFIRST = 0x0360, WM_AFXLAST = 0x037f, WM_PENWINFIRST = 0x0380, WM_RCRESULT = 0x0381, WM_HOOKRCRESULT = 0x0382, WM_GLOBALRCCHANGE = 0x0383, WM_PENMISCINFO = 0x0383, WM_SKB = 0x0384, WM_HEDITCTL = 0x0385, WM_PENCTL = 0x0385, WM_PENMISC = 0x0386, WM_CTLINIT = 0x0387, WM_PENEVENT = 0x0388, WM_PENWINLAST = 0x038f, DDM_SETFMT = 0x0400, DM_GETDEFID = 0x0400, NIN_SELECT = 0x0400, TBM_GETPOS = 0x0400, WM_PSD_PAGESETUPDLG = 0x0400, WM_USER = 0x0400, CBEM_INSERTITEMA = 0x0401, DDM_DRAW = 0x0401, DM_SETDEFID = 0x0401, HKM_SETHOTKEY = 0x0401, PBM_SETRANGE = 0x0401, RB_INSERTBANDA = 0x0401, SB_SETTEXTA = 0x0401, TB_ENABLEBUTTON = 0x0401, TBM_GETRANGEMIN = 0x0401, TTM_ACTIVATE = 0x0401, WM_CHOOSEFONT_GETLOGFONT = 0x0401, WM_PSD_FULLPAGERECT = 0x0401, CBEM_SETIMAGELIST = 0x0402, DDM_CLOSE = 0x0402, DM_REPOSITION = 0x0402, HKM_GETHOTKEY = 0x0402, PBM_SETPOS = 0x0402, RB_DELETEBAND = 0x0402, SB_GETTEXTA = 0x0402, TB_CHECKBUTTON = 0x0402, TBM_GETRANGEMAX = 0x0402, WM_PSD_MINMARGINRECT = 0x0402, CBEM_GETIMAGELIST = 0x0403, DDM_BEGIN = 0x0403, HKM_SETRULES = 0x0403, PBM_DELTAPOS = 0x0403, RB_GETBARINFO = 0x0403, SB_GETTEXTLENGTHA = 0x0403, TBM_GETTIC = 0x0403, TB_PRESSBUTTON = 0x0403, TTM_SETDELAYTIME = 0x0403, WM_PSD_MARGINRECT = 0x0403, CBEM_GETITEMA = 0x0404, DDM_END = 0x0404, PBM_SETSTEP = 0x0404, RB_SETBARINFO = 0x0404, SB_SETPARTS = 0x0404, TB_HIDEBUTTON = 0x0404, TBM_SETTIC = 0x0404, TTM_ADDTOOLA = 0x0404, WM_PSD_GREEKTEXTRECT = 0x0404, CBEM_SETITEMA = 0x0405, PBM_STEPIT = 0x0405, TB_INDETERMINATE = 0x0405, TBM_SETPOS = 0x0405, TTM_DELTOOLA = 0x0405, WM_PSD_ENVSTAMPRECT = 0x0405, CBEM_GETCOMBOCONTROL = 0x0406, PBM_SETRANGE32 = 0x0406, RB_SETBANDINFOA = 0x0406, SB_GETPARTS = 0x0406, TB_MARKBUTTON = 0x0406, TBM_SETRANGE = 0x0406, TTM_NEWTOOLRECTA = 0x0406, WM_PSD_YAFULLPAGERECT = 0x0406, CBEM_GETEDITCONTROL = 0x0407, PBM_GETRANGE = 0x0407, RB_SETPARENT = 0x0407, SB_GETBORDERS = 0x0407, TBM_SETRANGEMIN = 0x0407, TTM_RELAYEVENT = 0x0407, CBEM_SETEXSTYLE = 0x0408, PBM_GETPOS = 0x0408, RB_HITTEST = 0x0408, SB_SETMINHEIGHT = 0x0408, TBM_SETRANGEMAX = 0x0408, TTM_GETTOOLINFOA = 0x0408, CBEM_GETEXSTYLE = 0x0409, CBEM_GETEXTENDEDSTYLE = 0x0409, PBM_SETBARCOLOR = 0x0409, RB_GETRECT = 0x0409, SB_SIMPLE = 0x0409, TB_ISBUTTONENABLED = 0x0409, TBM_CLEARTICS = 0x0409, TTM_SETTOOLINFOA = 0x0409, CBEM_HASEDITCHANGED = 0x040a, RB_INSERTBANDW = 0x040a, SB_GETRECT = 0x040a, TB_ISBUTTONCHECKED = 0x040a, TBM_SETSEL = 0x040a, TTM_HITTESTA = 0x040a, WIZ_QUERYNUMPAGES = 0x040a, CBEM_INSERTITEMW = 0x040b, RB_SETBANDINFOW = 0x040b, SB_SETTEXTW = 0x040b, TB_ISBUTTONPRESSED = 0x040b, TBM_SETSELSTART = 0x040b, TTM_GETTEXTA = 0x040b, WIZ_NEXT = 0x040b, CBEM_SETITEMW = 0x040c, RB_GETBANDCOUNT = 0x040c, SB_GETTEXTLENGTHW = 0x040c, TB_ISBUTTONHIDDEN = 0x040c, TBM_SETSELEND = 0x040c, TTM_UPDATETIPTEXTA = 0x040c, WIZ_PREV = 0x040c, CBEM_GETITEMW = 0x040d, RB_GETROWCOUNT = 0x040d, SB_GETTEXTW = 0x040d, TB_ISBUTTONINDETERMINATE = 0x040d, TTM_GETTOOLCOUNT = 0x040d, CBEM_SETEXTENDEDSTYLE = 0x040e, RB_GETROWHEIGHT = 0x040e, SB_ISSIMPLE = 0x040e, TB_ISBUTTONHIGHLIGHTED = 0x040e, TBM_GETPTICS = 0x040e, TTM_ENUMTOOLSA = 0x040e, SB_SETICON = 0x040f, TBM_GETTICPOS = 0x040f, TTM_GETCURRENTTOOLA = 0x040f, RB_IDTOINDEX = 0x0410, SB_SETTIPTEXTA = 0x0410, TBM_GETNUMTICS = 0x0410, TTM_WINDOWFROMPOINT = 0x0410, RB_GETTOOLTIPS = 0x0411, SB_SETTIPTEXTW = 0x0411, TBM_GETSELSTART = 0x0411, TB_SETSTATE = 0x0411, TTM_TRACKACTIVATE = 0x0411, RB_SETTOOLTIPS = 0x0412, SB_GETTIPTEXTA = 0x0412, TB_GETSTATE = 0x0412, TBM_GETSELEND = 0x0412, TTM_TRACKPOSITION = 0x0412, RB_SETBKCOLOR = 0x0413, SB_GETTIPTEXTW = 0x0413, TB_ADDBITMAP = 0x0413, TBM_CLEARSEL = 0x0413, TTM_SETTIPBKCOLOR = 0x0413, RB_GETBKCOLOR = 0x0414, SB_GETICON = 0x0414, TB_ADDBUTTONSA = 0x0414, TBM_SETTICFREQ = 0x0414, TTM_SETTIPTEXTCOLOR = 0x0414, RB_SETTEXTCOLOR = 0x0415, TB_INSERTBUTTONA = 0x0415, TBM_SETPAGESIZE = 0x0415, TTM_GETDELAYTIME = 0x0415, RB_GETTEXTCOLOR = 0x0416, TB_DELETEBUTTON = 0x0416, TBM_GETPAGESIZE = 0x0416, TTM_GETTIPBKCOLOR = 0x0416, RB_SIZETORECT = 0x0417, TB_GETBUTTON = 0x0417, TBM_SETLINESIZE = 0x0417, TTM_GETTIPTEXTCOLOR = 0x0417, RB_BEGINDRAG = 0x0418, TB_BUTTONCOUNT = 0x0418, TBM_GETLINESIZE = 0x0418, TTM_SETMAXTIPWIDTH = 0x0418, RB_ENDDRAG = 0x0419, TB_COMMANDTOINDEX = 0x0419, TBM_GETTHUMBRECT = 0x0419, TTM_GETMAXTIPWIDTH = 0x0419, RB_DRAGMOVE = 0x041a, TBM_GETCHANNELRECT = 0x041a, TB_SAVERESTOREA = 0x041a, TTM_SETMARGIN = 0x041a, RB_GETBARHEIGHT = 0x041b, TB_CUSTOMIZE = 0x041b, TBM_SETTHUMBLENGTH = 0x041b, TTM_GETMARGIN = 0x041b, RB_GETBANDINFOW = 0x041c, TB_ADDSTRINGA = 0x041c, TBM_GETTHUMBLENGTH = 0x041c, TTM_POP = 0x041c, RB_GETBANDINFOA = 0x041d, TB_GETITEMRECT = 0x041d, TBM_SETTOOLTIPS = 0x041d, TTM_UPDATE = 0x041d, RB_MINIMIZEBAND = 0x041e, TB_BUTTONSTRUCTSIZE = 0x041e, TBM_GETTOOLTIPS = 0x041e, TTM_GETBUBBLESIZE = 0x041e, RB_MAXIMIZEBAND = 0x041f, TBM_SETTIPSIDE = 0x041f, TB_SETBUTTONSIZE = 0x041f, TTM_ADJUSTRECT = 0x041f, TBM_SETBUDDY = 0x0420, TB_SETBITMAPSIZE = 0x0420, TTM_SETTITLEA = 0x0420, MSG_FTS_JUMP_VA = 0x0421, TB_AUTOSIZE = 0x0421, TBM_GETBUDDY = 0x0421, TTM_SETTITLEW = 0x0421, RB_GETBANDBORDERS = 0x0422, MSG_FTS_JUMP_QWORD = 0x0423, RB_SHOWBAND = 0x0423, TB_GETTOOLTIPS = 0x0423, MSG_REINDEX_REQUEST = 0x0424, TB_SETTOOLTIPS = 0x0424, MSG_FTS_WHERE_IS_IT = 0x0425, RB_SETPALETTE = 0x0425, TB_SETPARENT = 0x0425, RB_GETPALETTE = 0x0426, RB_MOVEBAND = 0x0427, TB_SETROWS = 0x0427, TB_GETROWS = 0x0428, TB_GETBITMAPFLAGS = 0x0429, TB_SETCMDID = 0x042a, RB_PUSHCHEVRON = 0x042b, TB_CHANGEBITMAP = 0x042b, TB_GETBITMAP = 0x042c, MSG_GET_DEFFONT = 0x042d, TB_GETBUTTONTEXTA = 0x042d, TB_REPLACEBITMAP = 0x042e, TB_SETINDENT = 0x042f, TB_SETIMAGELIST = 0x0430, TB_GETIMAGELIST = 0x0431, TB_LOADIMAGES = 0x0432, EM_CANPASTE = 0x0432, TTM_ADDTOOLW = 0x0432, EM_DISPLAYBAND = 0x0433, TB_GETRECT = 0x0433, TTM_DELTOOLW = 0x0433, EM_EXGETSEL = 0x0434, TB_SETHOTIMAGELIST = 0x0434, TTM_NEWTOOLRECTW = 0x0434, EM_EXLIMITTEXT = 0x0435, TB_GETHOTIMAGELIST = 0x0435, TTM_GETTOOLINFOW = 0x0435, EM_EXLINEFROMCHAR = 0x0436, TB_SETDISABLEDIMAGELIST = 0x0436, TTM_SETTOOLINFOW = 0x0436, EM_EXSETSEL = 0x0437, TB_GETDISABLEDIMAGELIST = 0x0437, TTM_HITTESTW = 0x0437, EM_FINDTEXT = 0x0438, TB_SETSTYLE = 0x0438, TTM_GETTEXTW = 0x0438, EM_FORMATRANGE = 0x0439, TB_GETSTYLE = 0x0439, TTM_UPDATETIPTEXTW = 0x0439, EM_GETCHARFORMAT = 0x043a, TB_GETBUTTONSIZE = 0x043a, TTM_ENUMTOOLSW = 0x043a, EM_GETEVENTMASK = 0x043b, TB_SETBUTTONWIDTH = 0x043b, TTM_GETCURRENTTOOLW = 0x043b, EM_GETOLEINTERFACE = 0x043c, TB_SETMAXTEXTROWS = 0x043c, EM_GETPARAFORMAT = 0x043d, TB_GETTEXTROWS = 0x043d, EM_GETSELTEXT = 0x043e, TB_GETOBJECT = 0x043e, EM_HIDESELECTION = 0x043f, TB_GETBUTTONINFOW = 0x043f, EM_PASTESPECIAL = 0x0440, TB_SETBUTTONINFOW = 0x0440, EM_REQUESTRESIZE = 0x0441, TB_GETBUTTONINFOA = 0x0441, EM_SELECTIONTYPE = 0x0442, TB_SETBUTTONINFOA = 0x0442, EM_SETBKGNDCOLOR = 0x0443, TB_INSERTBUTTONW = 0x0443, EM_SETCHARFORMAT = 0x0444, TB_ADDBUTTONSW = 0x0444, EM_SETEVENTMASK = 0x0445, TB_HITTEST = 0x0445, EM_SETOLECALLBACK = 0x0446, TB_SETDRAWTEXTFLAGS = 0x0446, EM_SETPARAFORMAT = 0x0447, TB_GETHOTITEM = 0x0447, EM_SETTARGETDEVICE = 0x0448, TB_SETHOTITEM = 0x0448, EM_STREAMIN = 0x0449, TB_SETANCHORHIGHLIGHT = 0x0449, EM_STREAMOUT = 0x044a, TB_GETANCHORHIGHLIGHT = 0x044a, EM_GETTEXTRANGE = 0x044b, TB_GETBUTTONTEXTW = 0x044b, EM_FINDWORDBREAK = 0x044c, TB_SAVERESTOREW = 0x044c, EM_SETOPTIONS = 0x044d, TB_ADDSTRINGW = 0x044d, EM_GETOPTIONS = 0x044e, TB_MAPACCELERATORA = 0x044e, EM_FINDTEXTEX = 0x044f, TB_GETINSERTMARK = 0x044f, EM_GETWORDBREAKPROCEX = 0x0450, TB_SETINSERTMARK = 0x0450, EM_SETWORDBREAKPROCEX = 0x0451, TB_INSERTMARKHITTEST = 0x0451, EM_SETUNDOLIMIT = 0x0452, TB_MOVEBUTTON = 0x0452, TB_GETMAXSIZE = 0x0453, EM_REDO = 0x0454, TB_SETEXTENDEDSTYLE = 0x0454, EM_CANREDO = 0x0455, TB_GETEXTENDEDSTYLE = 0x0455, EM_GETUNDONAME = 0x0456, TB_GETPADDING = 0x0456, EM_GETREDONAME = 0x0457, TB_SETPADDING = 0x0457, EM_STOPGROUPTYPING = 0x0458, TB_SETINSERTMARKCOLOR = 0x0458, EM_SETTEXTMODE = 0x0459, TB_GETINSERTMARKCOLOR = 0x0459, EM_GETTEXTMODE = 0x045a, TB_MAPACCELERATORW = 0x045a, EM_AUTOURLDETECT = 0x045b, TB_GETSTRINGW = 0x045b, EM_GETAUTOURLDETECT = 0x045c, TB_GETSTRINGA = 0x045c, EM_SETPALETTE = 0x045d, EM_GETTEXTEX = 0x045e, EM_GETTEXTLENGTHEX = 0x045f, EM_SHOWSCROLLBAR = 0x0460, EM_SETTEXTEX = 0x0461, TAPI_REPLY = 0x0463, ACM_OPENA = 0x0464, BFFM_SETSTATUSTEXTA = 0x0464, CDM_FIRST = 0x0464, CDM_GETSPEC = 0x0464, EM_SETPUNCTUATION = 0x0464, IPM_CLEARADDRESS = 0x0464, WM_CAP_UNICODE_START = 0x0464, ACM_PLAY = 0x0465, BFFM_ENABLEOK = 0x0465, CDM_GETFILEPATH = 0x0465, EM_GETPUNCTUATION = 0x0465, IPM_SETADDRESS = 0x0465, PSM_SETCURSEL = 0x0465, UDM_SETRANGE = 0x0465, WM_CHOOSEFONT_SETLOGFONT = 0x0465, ACM_STOP = 0x0466, BFFM_SETSELECTIONA = 0x0466, CDM_GETFOLDERPATH = 0x0466, EM_SETWORDWRAPMODE = 0x0466, IPM_GETADDRESS = 0x0466, PSM_REMOVEPAGE = 0x0466, UDM_GETRANGE = 0x0466, WM_CAP_SET_CALLBACK_ERRORW = 0x0466, WM_CHOOSEFONT_SETFLAGS = 0x0466, ACM_OPENW = 0x0467, BFFM_SETSELECTIONW = 0x0467, CDM_GETFOLDERIDLIST = 0x0467, EM_GETWORDWRAPMODE = 0x0467, IPM_SETRANGE = 0x0467, PSM_ADDPAGE = 0x0467, UDM_SETPOS = 0x0467, WM_CAP_SET_CALLBACK_STATUSW = 0x0467, BFFM_SETSTATUSTEXTW = 0x0468, CDM_SETCONTROLTEXT = 0x0468, EM_SETIMECOLOR = 0x0468, IPM_SETFOCUS = 0x0468, PSM_CHANGED = 0x0468, UDM_GETPOS = 0x0468, CDM_HIDECONTROL = 0x0469, EM_GETIMECOLOR = 0x0469, IPM_ISBLANK = 0x0469, PSM_RESTARTWINDOWS = 0x0469, UDM_SETBUDDY = 0x0469, CDM_SETDEFEXT = 0x046a, EM_SETIMEOPTIONS = 0x046a, PSM_REBOOTSYSTEM = 0x046a, UDM_GETBUDDY = 0x046a, EM_GETIMEOPTIONS = 0x046b, PSM_CANCELTOCLOSE = 0x046b, UDM_SETACCEL = 0x046b, EM_CONVPOSITION = 0x046c, EM_CONVPOSITION = 0x046c, PSM_QUERYSIBLINGS = 0x046c, UDM_GETACCEL = 0x046c, MCIWNDM_GETZOOM = 0x046d, PSM_UNCHANGED = 0x046d, UDM_SETBASE = 0x046d, PSM_APPLY = 0x046e, UDM_GETBASE = 0x046e, PSM_SETTITLEA = 0x046f, UDM_SETRANGE32 = 0x046f, PSM_SETWIZBUTTONS = 0x0470, UDM_GETRANGE32 = 0x0470, WM_CAP_DRIVER_GET_NAMEW = 0x0470, PSM_PRESSBUTTON = 0x0471, UDM_SETPOS32 = 0x0471, WM_CAP_DRIVER_GET_VERSIONW = 0x0471, PSM_SETCURSELID = 0x0472, UDM_GETPOS32 = 0x0472, PSM_SETFINISHTEXTA = 0x0473, PSM_GETTABCONTROL = 0x0474, PSM_ISDIALOGMESSAGE = 0x0475, MCIWNDM_REALIZE = 0x0476, PSM_GETCURRENTPAGEHWND = 0x0476, MCIWNDM_SETTIMEFORMATA = 0x0477, PSM_INSERTPAGE = 0x0477, EM_SETLANGOPTIONS = 0x0478, MCIWNDM_GETTIMEFORMATA = 0x0478, PSM_SETTITLEW = 0x0478, WM_CAP_FILE_SET_CAPTURE_FILEW = 0x0478, EM_GETLANGOPTIONS = 0x0479, MCIWNDM_VALIDATEMEDIA = 0x0479, PSM_SETFINISHTEXTW = 0x0479, WM_CAP_FILE_GET_CAPTURE_FILEW = 0x0479, EM_GETIMECOMPMODE = 0x047a, EM_FINDTEXTW = 0x047b, MCIWNDM_PLAYTO = 0x047b, WM_CAP_FILE_SAVEASW = 0x047b, EM_FINDTEXTEXW = 0x047c, MCIWNDM_GETFILENAMEA = 0x047c, EM_RECONVERSION = 0x047d, MCIWNDM_GETDEVICEA = 0x047d, PSM_SETHEADERTITLEA = 0x047d, WM_CAP_FILE_SAVEDIBW = 0x047d, EM_SETIMEMODEBIAS = 0x047e, MCIWNDM_GETPALETTE = 0x047e, PSM_SETHEADERTITLEW = 0x047e, EM_GETIMEMODEBIAS = 0x047f, MCIWNDM_SETPALETTE = 0x047f, PSM_SETHEADERSUBTITLEA = 0x047f, MCIWNDM_GETERRORA = 0x0480, PSM_SETHEADERSUBTITLEW = 0x0480, PSM_HWNDTOINDEX = 0x0481, PSM_INDEXTOHWND = 0x0482, MCIWNDM_SETINACTIVETIMER = 0x0483, PSM_PAGETOINDEX = 0x0483, PSM_INDEXTOPAGE = 0x0484, DL_BEGINDRAG = 0x0485, MCIWNDM_GETINACTIVETIMER = 0x0485, PSM_IDTOINDEX = 0x0485, DL_DRAGGING = 0x0486, PSM_INDEXTOID = 0x0486, DL_DROPPED = 0x0487, PSM_GETRESULT = 0x0487, DL_CANCELDRAG = 0x0488, PSM_RECALCPAGESIZES = 0x0488, MCIWNDM_GET_SOURCE = 0x048c, MCIWNDM_PUT_SOURCE = 0x048d, MCIWNDM_GET_DEST = 0x048e, MCIWNDM_PUT_DEST = 0x048f, MCIWNDM_CAN_PLAY = 0x0490, MCIWNDM_CAN_WINDOW = 0x0491, MCIWNDM_CAN_RECORD = 0x0492, MCIWNDM_CAN_SAVE = 0x0493, MCIWNDM_CAN_EJECT = 0x0494, MCIWNDM_CAN_CONFIG = 0x0495, IE_GETINK = 0x0496, IE_MSGFIRST = 0x0496, MCIWNDM_PALETTEKICK = 0x0496, IE_SETINK = 0x0497, IE_GETPENTIP = 0x0498, IE_SETPENTIP = 0x0499, IE_GETERASERTIP = 0x049a, IE_SETERASERTIP = 0x049b, IE_GETBKGND = 0x049c, IE_SETBKGND = 0x049d, IE_GETGRIDORIGIN = 0x049e, IE_SETGRIDORIGIN = 0x049f, IE_GETGRIDPEN = 0x04a0, IE_SETGRIDPEN = 0x04a1, IE_GETGRIDSIZE = 0x04a2, IE_SETGRIDSIZE = 0x04a3, IE_GETMODE = 0x04a4, IE_SETMODE = 0x04a5, IE_GETINKRECT = 0x04a6, WM_CAP_SET_MCI_DEVICEW = 0x04a6, WM_CAP_GET_MCI_DEVICEW = 0x04a7, WM_CAP_PAL_OPENW = 0x04b4, WM_CAP_PAL_SAVEW = 0x04b5, IE_GETAPPDATA = 0x04b8, IE_SETAPPDATA = 0x04b9, IE_GETDRAWOPTS = 0x04ba, IE_SETDRAWOPTS = 0x04bb, IE_GETFORMAT = 0x04bc, IE_SETFORMAT = 0x04bd, IE_GETINKINPUT = 0x04be, IE_SETINKINPUT = 0x04bf, IE_GETNOTIFY = 0x04c0, IE_SETNOTIFY = 0x04c1, IE_GETRECOG = 0x04c2, IE_SETRECOG = 0x04c3, IE_GETSECURITY = 0x04c4, IE_SETSECURITY = 0x04c5, IE_GETSEL = 0x04c6, IE_SETSEL = 0x04c7, CDM_LAST = 0x04c8, EM_SETBIDIOPTIONS = 0x04c8, IE_DOCOMMAND = 0x04c8, MCIWNDM_NOTIFYMODE = 0x04c8, EM_GETBIDIOPTIONS = 0x04c9, IE_GETCOMMAND = 0x04c9, EM_SETTYPOGRAPHYOPTIONS = 0x04ca, IE_GETCOUNT = 0x04ca, EM_GETTYPOGRAPHYOPTIONS = 0x04cb, IE_GETGESTURE = 0x04cb, MCIWNDM_NOTIFYMEDIA = 0x04cb, EM_SETEDITSTYLE = 0x04cc, IE_GETMENU = 0x04cc, EM_GETEDITSTYLE = 0x04cd, IE_GETPAINTDC = 0x04cd, MCIWNDM_NOTIFYERROR = 0x04cd, IE_GETPDEVENT = 0x04ce, IE_GETSELCOUNT = 0x04cf, IE_GETSELITEMS = 0x04d0, IE_GETSTYLE = 0x04d1, MCIWNDM_SETTIMEFORMATW = 0x04db, EM_OUTLINE = 0x04dc, EM_OUTLINE = 0x04dc, MCIWNDM_GETTIMEFORMATW = 0x04dc, EM_GETSCROLLPOS = 0x04dd, EM_GETSCROLLPOS = 0x04dd, EM_SETSCROLLPOS = 0x04de, EM_SETSCROLLPOS = 0x04de, EM_SETFONTSIZE = 0x04df, EM_SETFONTSIZE = 0x04df, EM_GETZOOM = 0x04e0, MCIWNDM_GETFILENAMEW = 0x04e0, EM_SETZOOM = 0x04e1, MCIWNDM_GETDEVICEW = 0x04e1, EM_GETVIEWKIND = 0x04e2, EM_SETVIEWKIND = 0x04e3, EM_GETPAGE = 0x04e4, MCIWNDM_GETERRORW = 0x04e4, EM_SETPAGE = 0x04e5, EM_GETHYPHENATEINFO = 0x04e6, EM_SETHYPHENATEINFO = 0x04e7, EM_GETPAGEROTATE = 0x04eb, EM_SETPAGEROTATE = 0x04ec, EM_GETCTFMODEBIAS = 0x04ed, EM_SETCTFMODEBIAS = 0x04ee, EM_GETCTFOPENSTATUS = 0x04f0, EM_SETCTFOPENSTATUS = 0x04f1, EM_GETIMECOMPTEXT = 0x04f2, EM_ISIME = 0x04f3, EM_GETIMEPROPERTY = 0x04f4, EM_GETQUERYRTFOBJ = 0x050d, EM_SETQUERYRTFOBJ = 0x050e, FM_GETFOCUS = 0x0600, FM_GETDRIVEINFOA = 0x0601, FM_GETSELCOUNT = 0x0602, FM_GETSELCOUNTLFN = 0x0603, FM_GETFILESELA = 0x0604, FM_GETFILESELLFNA = 0x0605, FM_REFRESH_WINDOWS = 0x0606, FM_RELOAD_EXTENSIONS = 0x0607, FM_GETDRIVEINFOW = 0x0611, FM_GETFILESELW = 0x0614, FM_GETFILESELLFNW = 0x0615, WLX_WM_SAS = 0x0659, SM_GETSELCOUNT = 0x07e8, UM_GETSELCOUNT = 0x07e8, WM_CPL_LAUNCH = 0x07e8, SM_GETSERVERSELA = 0x07e9, UM_GETUSERSELA = 0x07e9, WM_CPL_LAUNCHED = 0x07e9, SM_GETSERVERSELW = 0x07ea, UM_GETUSERSELW = 0x07ea, SM_GETCURFOCUSA = 0x07eb, UM_GETGROUPSELA = 0x07eb, SM_GETCURFOCUSW = 0x07ec, UM_GETGROUPSELW = 0x07ec, SM_GETOPTIONS = 0x07ed, UM_GETCURFOCUSA = 0x07ed, UM_GETCURFOCUSW = 0x07ee, UM_GETOPTIONS = 0x07ef, UM_GETOPTIONS2 = 0x07f0, LVM_FIRST = 0x1000, LVM_GETBKCOLOR = 0x1000, LVM_SETBKCOLOR = 0x1001, LVM_GETIMAGELIST = 0x1002, LVM_SETIMAGELIST = 0x1003, LVM_GETITEMCOUNT = 0x1004, LVM_GETITEMA = 0x1005, LVM_SETITEMA = 0x1006, LVM_INSERTITEMA = 0x1007, LVM_DELETEITEM = 0x1008, LVM_DELETEALLITEMS = 0x1009, LVM_GETCALLBACKMASK = 0x100a, LVM_SETCALLBACKMASK = 0x100b, LVM_GETNEXTITEM = 0x100c, LVM_FINDITEMA = 0x100d, LVM_GETITEMRECT = 0x100e, LVM_SETITEMPOSITION = 0x100f, LVM_GETITEMPOSITION = 0x1010, LVM_GETSTRINGWIDTHA = 0x1011, LVM_HITTEST = 0x1012, LVM_ENSUREVISIBLE = 0x1013, LVM_SCROLL = 0x1014, LVM_REDRAWITEMS = 0x1015, LVM_ARRANGE = 0x1016, LVM_EDITLABELA = 0x1017, LVM_GETEDITCONTROL = 0x1018, LVM_GETCOLUMNA = 0x1019, LVM_SETCOLUMNA = 0x101a, LVM_INSERTCOLUMNA = 0x101b, LVM_DELETECOLUMN = 0x101c, LVM_GETCOLUMNWIDTH = 0x101d, LVM_SETCOLUMNWIDTH = 0x101e, LVM_GETHEADER = 0x101f, LVM_CREATEDRAGIMAGE = 0x1021, LVM_GETVIEWRECT = 0x1022, LVM_GETTEXTCOLOR = 0x1023, LVM_SETTEXTCOLOR = 0x1024, LVM_GETTEXTBKCOLOR = 0x1025, LVM_SETTEXTBKCOLOR = 0x1026, LVM_GETTOPINDEX = 0x1027, LVM_GETCOUNTPERPAGE = 0x1028, LVM_GETORIGIN = 0x1029, LVM_UPDATE = 0x102a, LVM_SETITEMSTATE = 0x102b, LVM_GETITEMSTATE = 0x102c, LVM_GETITEMTEXTA = 0x102d, LVM_SETITEMTEXTA = 0x102e, LVM_SETITEMCOUNT = 0x102f, LVM_SORTITEMS = 0x1030, LVM_SETITEMPOSITION32 = 0x1031, LVM_GETSELECTEDCOUNT = 0x1032, LVM_GETITEMSPACING = 0x1033, LVM_GETISEARCHSTRINGA = 0x1034, LVM_SETICONSPACING = 0x1035, LVM_SETEXTENDEDLISTVIEWSTYLE = 0x1036, LVM_GETEXTENDEDLISTVIEWSTYLE = 0x1037, LVM_GETSUBITEMRECT = 0x1038, LVM_SUBITEMHITTEST = 0x1039, LVM_SETCOLUMNORDERARRAY = 0x103a, LVM_GETCOLUMNORDERARRAY = 0x103b, LVM_SETHOTITEM = 0x103c, LVM_GETHOTITEM = 0x103d, LVM_SETHOTCURSOR = 0x103e, LVM_GETHOTCURSOR = 0x103f, LVM_APPROXIMATEVIEWRECT = 0x1040, LVM_SETWORKAREAS = 0x1041, LVM_GETSELECTIONMARK = 0x1042, LVM_SETSELECTIONMARK = 0x1043, LVM_SETBKIMAGEA = 0x1044, LVM_GETBKIMAGEA = 0x1045, LVM_GETWORKAREAS = 0x1046, LVM_SETHOVERTIME = 0x1047, LVM_GETHOVERTIME = 0x1048, LVM_GETNUMBEROFWORKAREAS = 0x1049, LVM_SETTOOLTIPS = 0x104a, LVM_GETITEMW = 0x104b, LVM_SETITEMW = 0x104c, LVM_INSERTITEMW = 0x104d, LVM_GETTOOLTIPS = 0x104e, LVM_FINDITEMW = 0x1053, LVM_GETSTRINGWIDTHW = 0x1057, LVM_GETCOLUMNW = 0x105f, LVM_SETCOLUMNW = 0x1060, LVM_INSERTCOLUMNW = 0x1061, LVM_GETITEMTEXTW = 0x1073, LVM_SETITEMTEXTW = 0x1074, LVM_GETISEARCHSTRINGW = 0x1075, LVM_EDITLABELW = 0x1076, LVM_GETBKIMAGEW = 0x108b, LVM_SETSELECTEDCOLUMN = 0x108c, LVM_SETTILEWIDTH = 0x108d, LVM_SETVIEW = 0x108e, LVM_GETVIEW = 0x108f, LVM_INSERTGROUP = 0x1091, LVM_SETGROUPINFO = 0x1093, LVM_GETGROUPINFO = 0x1095, LVM_REMOVEGROUP = 0x1096, LVM_MOVEGROUP = 0x1097, LVM_MOVEITEMTOGROUP = 0x109a, LVM_SETGROUPMETRICS = 0x109b, LVM_GETGROUPMETRICS = 0x109c, LVM_ENABLEGROUPVIEW = 0x109d, LVM_SORTGROUPS = 0x109e, LVM_INSERTGROUPSORTED = 0x109f, LVM_REMOVEALLGROUPS = 0x10a0, LVM_HASGROUP = 0x10a1, LVM_SETTILEVIEWINFO = 0x10a2, LVM_GETTILEVIEWINFO = 0x10a3, LVM_SETTILEINFO = 0x10a4, LVM_GETTILEINFO = 0x10a5, LVM_SETINSERTMARK = 0x10a6, LVM_GETINSERTMARK = 0x10a7, LVM_INSERTMARKHITTEST = 0x10a8, LVM_GETINSERTMARKRECT = 0x10a9, LVM_SETINSERTMARKCOLOR = 0x10aa, LVM_GETINSERTMARKCOLOR = 0x10ab, LVM_SETINFOTIP = 0x10ad, LVM_GETSELECTEDCOLUMN = 0x10ae, LVM_ISGROUPVIEWENABLED = 0x10af, LVM_GETOUTLINECOLOR = 0x10b0, LVM_SETOUTLINECOLOR = 0x10b1, LVM_CANCELEDITLABEL = 0x10b3, LVM_MAPINDEXTOID = 0x10b4, LVM_MAPIDTOINDEX = 0x10b5, LVM_ISITEMVISIBLE = 0x10b6, OCM__BASE = 0x2000, LVM_SETUNICODEFORMAT = 0x2005, LVM_GETUNICODEFORMAT = 0x2006, OCM_CTLCOLOR = 0x2019, OCM_DRAWITEM = 0x202b, OCM_MEASUREITEM = 0x202c, OCM_DELETEITEM = 0x202d, OCM_VKEYTOITEM = 0x202e, OCM_CHARTOITEM = 0x202f, OCM_COMPAREITEM = 0x2039, OCM_NOTIFY = 0x204e, OCM_COMMAND = 0x2111, OCM_HSCROLL = 0x2114, OCM_VSCROLL = 0x2115, OCM_CTLCOLORMSGBOX = 0x2132, OCM_CTLCOLOREDIT = 0x2133, OCM_CTLCOLORLISTBOX = 0x2134, OCM_CTLCOLORBTN = 0x2135, OCM_CTLCOLORDLG = 0x2136, OCM_CTLCOLORSCROLLBAR = 0x2137, OCM_CTLCOLORSTATIC = 0x2138, OCM_PARENTNOTIFY = 0x2210, WM_APP = 0x8000, WM_RASDIALEVENT = 0xcccd,
    }

    return messages
  end

  function r_lib_imcustom_hotkey()
    local vkeys = r_lib_vkeys()
    local rkeys = r_lib_rkeys()
    local wm = r_lib_window_message()

    local tBlockKeys = {[vkeys.VK_RETURN] = true, [vkeys.VK_T] = true, [vkeys.VK_F6] = true, [vkeys.VK_F8] = true}
    local tBlockChar = {[116] = true, [84] = true}
    local tBlockNextDown = {}
    local module = {}
    module._VERSION = "1.1.5"
    module._SETTINGS = {
      noKeysMessage = "No"
    }

    local tHotKeyData = {
      edit = nil,
      save = {}
    }
    local tKeys = {}

    function module.HotKey(name, keys, lastkeys, width)
      local width = width or 90
      local name = tostring(name)
      local lastkeys = lastkeys or {}
      local keys, bool = keys or {}, false
      lastkeys.v = keys.v

      local sKeys = table.concat(rkeys.getKeysName(keys.v), " + ")

      if #tHotKeyData.save > 0 and tostring(tHotKeyData.save[1]) == name then
        keys.v = tHotKeyData.save[2]
        sKeys = table.concat(rkeys.getKeysName(keys.v), " + ")
        tHotKeyData.save = {}
        bool = true
      elseif tHotKeyData.edit ~= nil and tostring(tHotKeyData.edit) == name then
        if #tKeys == 0 then
          sKeys = os.time() % 2 == 0 and module._SETTINGS.noKeysMessage or " "
        else
          sKeys = table.concat(rkeys.getKeysName(tKeys), " + ")
        end
      end

      imgui.PushStyleColor(imgui.Col.Button, imgui.GetStyle().Colors[imgui.Col.FrameBg])
      imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.GetStyle().Colors[imgui.Col.FrameBgHovered])
      imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.GetStyle().Colors[imgui.Col.FrameBgActive])
      if imgui.Button((tostring(sKeys):len() == 0 and module._SETTINGS.noKeysMessage or sKeys) .. name, imgui.ImVec2(width, 0)) then
        tHotKeyData.edit = name
      end
      imgui.PopStyleColor(3)
      return bool
    end

    function module.getCurrentEdit()
      return tHotKeyData.edit ~= nil
    end

    function module.getKeysList(bool)
      local bool = bool or false
      local tKeysList = {}
      if bool then
        for k, v in ipairs(tKeys) do
          tKeysList[k] = vkeys.id_to_name(v)
        end
      else
        tKeysList = tKeys
      end
      return tKeysList
    end

    function module.getKeyNumber(id)
      for k, v in ipairs(tKeys) do
        if v == id then
          return k
        end
      end
      return - 1
    end

    local function reloadKeysList()
      local tNewKeys = {}
      for k, v in pairs(tKeys) do
        tNewKeys[#tNewKeys + 1] = v
      end
      tKeys = tNewKeys
      return true
    end

    addEventHandler("onWindowMessage",
      function (msg, wparam, lparam)
        if tHotKeyData.edit ~= nil and msg == wm.WM_CHAR then
          if tBlockChar[wparam] then
            consumeWindowMessage(true, true)
          end
        end
        if msg == wm.WM_KEYDOWN or msg == wm.WM_SYSKEYDOWN then
          if tHotKeyData.edit ~= nil and wparam == vkeys.VK_ESCAPE then
            tKeys = {}
            tHotKeyData.edit = nil
            consumeWindowMessage(true, true)
          end
          if tHotKeyData.edit ~= nil and wparam == vkeys.VK_BACK then
            tHotKeyData.save = {tHotKeyData.edit, {}}
            tHotKeyData.edit = nil
            consumeWindowMessage(true, true)
          end
          local num = module.getKeyNumber(wparam)
          if num == -1 then
            tKeys[#tKeys + 1] = wparam
            if tHotKeyData.edit ~= nil then
              if not rkeys.isKeyModified(wparam) then
                tHotKeyData.save = {tHotKeyData.edit, tKeys}
                tHotKeyData.edit = nil
                tKeys = {}
                consumeWindowMessage(true, true)
              end
            end
          end
          reloadKeysList()
          if tHotKeyData.edit ~= nil then
            consumeWindowMessage(true, true)
          end
        elseif msg == wm.WM_KEYUP or msg == wm.WM_SYSKEYUP then
          local num = module.getKeyNumber(wparam)
          if num > - 1 then
            tKeys[num] = nil
          end
          reloadKeysList()
          if tHotKeyData.edit ~= nil then
            consumeWindowMessage(true, true)
          end
        end
      end
    )

    return module
  end

  function r_lib_encoding()


    local iconv = require 'iconv'

    local encoding = {
      default = 'ASCII'
    }

    local aliases = {
      UTF7 = 'UTF-7',
      UTF8 = 'UTF-8',
      UTF16 = 'UTF-16',
      UTF32 = 'UTF-32'
    }

    local function normalize_encoding_name(e)
      e = string.upper(string.gsub(e, '_', '-'))
      if aliases[e] then return aliases[e] end
      return e
    end

    local converter = {}
    function converter.new(enc)
      local private = {
        encoder = {},
        decoder = {},
      }

      local public = {
        encoding = enc
      }
      function public:encode(str, enc)
        if enc then enc = normalize_encoding_name(enc)
        else enc = encoding.default
        end
        local cd = private.encoder[enc]
        if not cd then
          cd = iconv.new(self.encoding .. '//IGNORE', enc)
          assert(cd)
          private.encoder[enc] = cd
        end
        local encoded = cd:iconv(str)
        return encoded
      end

      function public:decode(str, enc)
        if enc then enc = normalize_encoding_name(enc)
        else enc = encoding.default
        end
        local cd = private.decoder[enc]
        if not cd then
          cd = iconv.new(enc .. '//IGNORE', self.encoding)
          assert(cd)
          private.decoder[enc] = cd
        end
        local decoded = cd:iconv(str)
        return decoded
      end

      local mt = {}
      function mt:__call(str, enc)
        return self:encode(str, enc)
      end

      setmetatable(public, mt)
      return public
    end

    setmetatable(encoding, {
      __index =
      function(table, index)
        assert(type(index) == 'string')
        local enc = normalize_encoding_name(index)
        local already_loaded = rawget(table, enc)
        if already_loaded then
          table[index] = already_loaded
          return already_loaded
        else
          -- create new converter
          local conv = converter.new(enc)
          table[index] = conv
          table[enc] = conv
          return conv
        end
      end
    })

    return encoding
  end
  function r_lib_lockbox()
    local Lockbox = {};

    --[[
		package.path =  "./?.lua;"
						.. "./cipher/?.lua;"
						.. "./digest/?.lua;"
						.. "./kdf/?.lua;"
						.. "./mac/?.lua;"
						.. "./padding/?.lua;"
						.. "./test/?.lua;"
						.. "./util/?.lua;"
						.. package.path;
		]]--
    Lockbox.ALLOW_INSECURE = false;

    Lockbox.insecure = function()
      assert(Lockbox.ALLOW_INSECURE, "");
    end

    return Lockbox;
  end

  function r_lockbox_util_queue()
    local Queue = function()
      local queue = {};
      local tail = 0;
      local head = 0;

      local public = {};

      public.push = function(obj)
        queue[head] = obj;
        head = head + 1;
        return;
      end

      public.pop = function()
        if tail < head
        then
          local obj = queue[tail];
          queue[tail] = nil;
          tail = tail + 1;
          return obj;
        else
          return nil;
        end
      end

      public.size = function()
        return head - tail;
      end

      public.getHead = function()
        return head;
      end

      public.getTail = function()
        return tail;
      end

      public.reset = function()
        queue = {};
        head = 0;
        tail = 0;
      end

      return public;
    end

    return Queue;
  end

  function r_lockbox_util_stream()
    local Queue = r_lockbox_util_queue()

    local Stream = {};


    Stream.fromString = function(string)
      local i = 0;
      return function()
        i = i + 1;
        if(i <= string.len(string)) then
          return string.byte(string, i);
        else
          return nil;
        end
      end
    end


    Stream.toString = function(stream)
      local array = {};
      local i = 1;

      local byte = stream();
      while byte ~= nil do
        array[i] = string.char(byte);
        i = i + 1;
        byte = stream();
      end

      return table.concat(array, "");
    end


    Stream.fromArray = function(array)
      local queue = Queue();
      local i = 1;

      local byte = array[i];
      while byte ~= nil do
        queue.push(byte);
        i = i + 1;
        byte = array[i];
      end

      return queue.pop;
    end


    Stream.toArray = function(stream)
      local array = {};
      local i = 1;

      local byte = stream();
      while byte ~= nil do
        array[i] = byte;
        i = i + 1;
        byte = stream();
      end

      return array;
    end


    local fromHexTable = {};
    for i = 0, 255 do
      fromHexTable[string.format("%02X", i)] = i;
      fromHexTable[string.format("%02x", i)] = i;
    end

    Stream.fromHex = function(hex)
      local queue = Queue();

      for i = 1, string.len(hex) / 2 do
        local h = string.sub(hex, i * 2 - 1, i * 2);
        queue.push(fromHexTable[h]);
      end

      return queue.pop;
    end



    local toHexTable = {};
    for i = 0, 255 do
      toHexTable[i] = string.format("%02X", i);
    end

    Stream.toHex = function(stream)
      local hex = {};
      local i = 1;

      local byte = stream();
      while byte ~= nil do
        hex[i] = toHexTable[byte];
        i = i + 1;
        byte = stream();
      end

      return table.concat(hex, "");
    end

    return Stream;
  end

  function r_lib_lockbox_util_bit()
    local ok, e
    if not ok then
      ok, e = pcall(require, "bit") -- the LuaJIT one ?
    end
    if not ok then
      ok, e = pcall(require, "bit32") -- Lua 5.2
    end
    if not ok then
      ok, e = pcall(require, "bit.numberlua") -- for Lua 5.1, https://github.com/tst2005/lua-bit-numberlua/
    end
    if not ok then
      error("no bitwise support found", 2)
    end
    assert(type(e) == "table", "invalid bit module")

    -- Workaround to support Lua 5.2 bit32 API with the LuaJIT bit one
    if e.rol and not e.lrotate then
      e.lrotate = e.rol
    end
    if e.ror and not e.rrotate then
      e.rrotate = e.ror
    end

    return e
  end

  function r_lib_lockbox_util_array()
    local Bit = r_lib_lockbox_util_bit()
    local XOR = Bit.bxor;

    local Array = {};

    Array.size = function(array)
      return #array;
    end

    Array.fromString = function(string)
      local bytes = {};

      local i = 1;
      local byte = string.byte(string, i);
      while byte ~= nil do
        bytes[i] = byte;
        i = i + 1;
        byte = string.byte(string, i);
      end

      return bytes;

    end

    Array.toString = function(bytes)
      local chars = {};
      local i = 1;

      local byte = bytes[i];
      while byte ~= nil do
        chars[i] = string.char(byte);
        i = i + 1;
        byte = bytes[i];
      end

      return table.concat(chars, "");
    end

    Array.fromStream = function(stream)
      local array = {};
      local i = 1;

      local byte = stream();
      while byte ~= nil do
        array[i] = byte;
        i = i + 1;
        byte = stream();
      end

      return array;
    end

    Array.readFromQueue = function(queue, size)
      local array = {};

      for i = 1, size do
        array[i] = queue.pop();
      end

      return array;
    end

    Array.writeToQueue = function(queue, array)
      local size = Array.size(array);

      for i = 1, size do
        queue.push(array[i]);
      end
    end

    Array.toStream = function(array)
      local queue = Queue();
      local i = 1;

      local byte = array[i];
      while byte ~= nil do
        queue.push(byte);
        i = i + 1;
        byte = array[i];
      end

      return queue.pop;
    end


    local fromHexTable = {};
    for i = 0, 255 do
      fromHexTable[string.format("%02X", i)] = i;
      fromHexTable[string.format("%02x", i)] = i;
    end

    Array.fromHex = function(hex)
      local array = {};

      for i = 1, string.len(hex) / 2 do
        local h = string.sub(hex, i * 2 - 1, i * 2);
        array[i] = fromHexTable[h];
      end

      return array;
    end


    local toHexTable = {};
    for i = 0, 255 do
      toHexTable[i] = string.format("%02X", i);
    end

    Array.toHex = function(array)
      local hex = {};
      local i = 1;

      local byte = array[i];
      while byte ~= nil do
        hex[i] = toHexTable[byte];
        i = i + 1;
        byte = array[i];
      end

      return table.concat(hex, "");

    end

    Array.concat = function(a, b)
      local concat = {};
      local out = 1;

      local i = 1;
      local byte = a[i];
      while byte ~= nil do
        concat[out] = byte;
        i = i + 1;
        out = out + 1;
        byte = a[i];
      end

      local i = 1;
      local byte = b[i];
      while byte ~= nil do
        concat[out] = byte;
        i = i + 1;
        out = out + 1;
        byte = b[i];
      end

      return concat;
    end

    Array.truncate = function(a, newSize)
      local x = {};

      for i = 1, newSize do
        x[i] = a[i];
      end

      return x;
    end

    Array.XOR = function(a, b)
      local x = {};

      for k, v in pairs(a) do
        x[k] = XOR(v, b[k]);
      end

      return x;
    end

    Array.substitute = function(input, sbox)
      local out = {};

      for k, v in pairs(input) do
        out[k] = sbox[v];
      end

      return out;
    end

    Array.permute = function(input, pbox)
      local out = {};

      for k, v in pairs(pbox) do
        out[k] = input[v];
      end

      return out;
    end

    Array.copy = function(input)
      local out = {};

      for k, v in pairs(input) do
        out[k] = v;
      end
      return out;
    end

    Array.slice = function(input, start, stop)
      local out = {};

      for i = start, stop do
        out[i - start + 1] = input[i];
      end
      return out;
    end

    return Array;
  end

  function r_lib_lockbox_cipher_aes128()
    local Stream = r_lockbox_util_stream()
    local Array = r_lib_lockbox_util_array()
    local Bit = r_lib_lockbox_util_bit()
    local Math = require("math");


    local AND = Bit.band;
    local OR = Bit.bor;
    local NOT = Bit.bnot;
    local XOR = Bit.bxor;
    local LROT = Bit.lrotate;
    local RROT = Bit.rrotate;
    local LSHIFT = Bit.lshift;
    local RSHIFT = Bit.rshift;

    local SBOX = {
      [0] = 0x63, 0x7C, 0x77, 0x7B, 0xF2, 0x6B, 0x6F, 0xC5, 0x30, 0x01, 0x67, 0x2B, 0xFE, 0xD7, 0xAB, 0x76,
      0xCA, 0x82, 0xC9, 0x7D, 0xFA, 0x59, 0x47, 0xF0, 0xAD, 0xD4, 0xA2, 0xAF, 0x9C, 0xA4, 0x72, 0xC0,
      0xB7, 0xFD, 0x93, 0x26, 0x36, 0x3F, 0xF7, 0xCC, 0x34, 0xA5, 0xE5, 0xF1, 0x71, 0xD8, 0x31, 0x15,
      0x04, 0xC7, 0x23, 0xC3, 0x18, 0x96, 0x05, 0x9A, 0x07, 0x12, 0x80, 0xE2, 0xEB, 0x27, 0xB2, 0x75,
      0x09, 0x83, 0x2C, 0x1A, 0x1B, 0x6E, 0x5A, 0xA0, 0x52, 0x3B, 0xD6, 0xB3, 0x29, 0xE3, 0x2F, 0x84,
      0x53, 0xD1, 0x00, 0xED, 0x20, 0xFC, 0xB1, 0x5B, 0x6A, 0xCB, 0xBE, 0x39, 0x4A, 0x4C, 0x58, 0xCF,
      0xD0, 0xEF, 0xAA, 0xFB, 0x43, 0x4D, 0x33, 0x85, 0x45, 0xF9, 0x02, 0x7F, 0x50, 0x3C, 0x9F, 0xA8,
      0x51, 0xA3, 0x40, 0x8F, 0x92, 0x9D, 0x38, 0xF5, 0xBC, 0xB6, 0xDA, 0x21, 0x10, 0xFF, 0xF3, 0xD2,
      0xCD, 0x0C, 0x13, 0xEC, 0x5F, 0x97, 0x44, 0x17, 0xC4, 0xA7, 0x7E, 0x3D, 0x64, 0x5D, 0x19, 0x73,
      0x60, 0x81, 0x4F, 0xDC, 0x22, 0x2A, 0x90, 0x88, 0x46, 0xEE, 0xB8, 0x14, 0xDE, 0x5E, 0x0B, 0xDB,
      0xE0, 0x32, 0x3A, 0x0A, 0x49, 0x06, 0x24, 0x5C, 0xC2, 0xD3, 0xAC, 0x62, 0x91, 0x95, 0xE4, 0x79,
      0xE7, 0xC8, 0x37, 0x6D, 0x8D, 0xD5, 0x4E, 0xA9, 0x6C, 0x56, 0xF4, 0xEA, 0x65, 0x7A, 0xAE, 0x08,
      0xBA, 0x78, 0x25, 0x2E, 0x1C, 0xA6, 0xB4, 0xC6, 0xE8, 0xDD, 0x74, 0x1F, 0x4B, 0xBD, 0x8B, 0x8A,
      0x70, 0x3E, 0xB5, 0x66, 0x48, 0x03, 0xF6, 0x0E, 0x61, 0x35, 0x57, 0xB9, 0x86, 0xC1, 0x1D, 0x9E,
      0xE1, 0xF8, 0x98, 0x11, 0x69, 0xD9, 0x8E, 0x94, 0x9B, 0x1E, 0x87, 0xE9, 0xCE, 0x55, 0x28, 0xDF,
    0x8C, 0xA1, 0x89, 0x0D, 0xBF, 0xE6, 0x42, 0x68, 0x41, 0x99, 0x2D, 0x0F, 0xB0, 0x54, 0xBB, 0x16};

    local ISBOX = {
      [0] = 0x52, 0x09, 0x6A, 0xD5, 0x30, 0x36, 0xA5, 0x38, 0xBF, 0x40, 0xA3, 0x9E, 0x81, 0xF3, 0xD7, 0xFB,
      0x7C, 0xE3, 0x39, 0x82, 0x9B, 0x2F, 0xFF, 0x87, 0x34, 0x8E, 0x43, 0x44, 0xC4, 0xDE, 0xE9, 0xCB,
      0x54, 0x7B, 0x94, 0x32, 0xA6, 0xC2, 0x23, 0x3D, 0xEE, 0x4C, 0x95, 0x0B, 0x42, 0xFA, 0xC3, 0x4E,
      0x08, 0x2E, 0xA1, 0x66, 0x28, 0xD9, 0x24, 0xB2, 0x76, 0x5B, 0xA2, 0x49, 0x6D, 0x8B, 0xD1, 0x25,
      0x72, 0xF8, 0xF6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xD4, 0xA4, 0x5C, 0xCC, 0x5D, 0x65, 0xB6, 0x92,
      0x6C, 0x70, 0x48, 0x50, 0xFD, 0xED, 0xB9, 0xDA, 0x5E, 0x15, 0x46, 0x57, 0xA7, 0x8D, 0x9D, 0x84,
      0x90, 0xD8, 0xAB, 0x00, 0x8C, 0xBC, 0xD3, 0x0A, 0xF7, 0xE4, 0x58, 0x05, 0xB8, 0xB3, 0x45, 0x06,
      0xD0, 0x2C, 0x1E, 0x8F, 0xCA, 0x3F, 0x0F, 0x02, 0xC1, 0xAF, 0xBD, 0x03, 0x01, 0x13, 0x8A, 0x6B,
      0x3A, 0x91, 0x11, 0x41, 0x4F, 0x67, 0xDC, 0xEA, 0x97, 0xF2, 0xCF, 0xCE, 0xF0, 0xB4, 0xE6, 0x73,
      0x96, 0xAC, 0x74, 0x22, 0xE7, 0xAD, 0x35, 0x85, 0xE2, 0xF9, 0x37, 0xE8, 0x1C, 0x75, 0xDF, 0x6E,
      0x47, 0xF1, 0x1A, 0x71, 0x1D, 0x29, 0xC5, 0x89, 0x6F, 0xB7, 0x62, 0x0E, 0xAA, 0x18, 0xBE, 0x1B,
      0xFC, 0x56, 0x3E, 0x4B, 0xC6, 0xD2, 0x79, 0x20, 0x9A, 0xDB, 0xC0, 0xFE, 0x78, 0xCD, 0x5A, 0xF4,
      0x1F, 0xDD, 0xA8, 0x33, 0x88, 0x07, 0xC7, 0x31, 0xB1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xEC, 0x5F,
      0x60, 0x51, 0x7F, 0xA9, 0x19, 0xB5, 0x4A, 0x0D, 0x2D, 0xE5, 0x7A, 0x9F, 0x93, 0xC9, 0x9C, 0xEF,
      0xA0, 0xE0, 0x3B, 0x4D, 0xAE, 0x2A, 0xF5, 0xB0, 0xC8, 0xEB, 0xBB, 0x3C, 0x83, 0x53, 0x99, 0x61,
    0x17, 0x2B, 0x04, 0x7E, 0xBA, 0x77, 0xD6, 0x26, 0xE1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0C, 0x7D};

    local ROW_SHIFT = { 1, 6, 11, 16, 5, 10, 15, 4, 9, 14, 3, 8, 13, 2, 7, 12, };
    local IROW_SHIFT = { 1, 14, 11, 8, 5, 2, 15, 12, 9, 6, 3, 16, 13, 10, 7, 4, };

    local ETABLE = {
      [0] = 0x01, 0x03, 0x05, 0x0F, 0x11, 0x33, 0x55, 0xFF, 0x1A, 0x2E, 0x72, 0x96, 0xA1, 0xF8, 0x13, 0x35,
      0x5F, 0xE1, 0x38, 0x48, 0xD8, 0x73, 0x95, 0xA4, 0xF7, 0x02, 0x06, 0x0A, 0x1E, 0x22, 0x66, 0xAA,
      0xE5, 0x34, 0x5C, 0xE4, 0x37, 0x59, 0xEB, 0x26, 0x6A, 0xBE, 0xD9, 0x70, 0x90, 0xAB, 0xE6, 0x31,
      0x53, 0xF5, 0x04, 0x0C, 0x14, 0x3C, 0x44, 0xCC, 0x4F, 0xD1, 0x68, 0xB8, 0xD3, 0x6E, 0xB2, 0xCD,
      0x4C, 0xD4, 0x67, 0xA9, 0xE0, 0x3B, 0x4D, 0xD7, 0x62, 0xA6, 0xF1, 0x08, 0x18, 0x28, 0x78, 0x88,
      0x83, 0x9E, 0xB9, 0xD0, 0x6B, 0xBD, 0xDC, 0x7F, 0x81, 0x98, 0xB3, 0xCE, 0x49, 0xDB, 0x76, 0x9A,
      0xB5, 0xC4, 0x57, 0xF9, 0x10, 0x30, 0x50, 0xF0, 0x0B, 0x1D, 0x27, 0x69, 0xBB, 0xD6, 0x61, 0xA3,
      0xFE, 0x19, 0x2B, 0x7D, 0x87, 0x92, 0xAD, 0xEC, 0x2F, 0x71, 0x93, 0xAE, 0xE9, 0x20, 0x60, 0xA0,
      0xFB, 0x16, 0x3A, 0x4E, 0xD2, 0x6D, 0xB7, 0xC2, 0x5D, 0xE7, 0x32, 0x56, 0xFA, 0x15, 0x3F, 0x41,
      0xC3, 0x5E, 0xE2, 0x3D, 0x47, 0xC9, 0x40, 0xC0, 0x5B, 0xED, 0x2C, 0x74, 0x9C, 0xBF, 0xDA, 0x75,
      0x9F, 0xBA, 0xD5, 0x64, 0xAC, 0xEF, 0x2A, 0x7E, 0x82, 0x9D, 0xBC, 0xDF, 0x7A, 0x8E, 0x89, 0x80,
      0x9B, 0xB6, 0xC1, 0x58, 0xE8, 0x23, 0x65, 0xAF, 0xEA, 0x25, 0x6F, 0xB1, 0xC8, 0x43, 0xC5, 0x54,
      0xFC, 0x1F, 0x21, 0x63, 0xA5, 0xF4, 0x07, 0x09, 0x1B, 0x2D, 0x77, 0x99, 0xB0, 0xCB, 0x46, 0xCA,
      0x45, 0xCF, 0x4A, 0xDE, 0x79, 0x8B, 0x86, 0x91, 0xA8, 0xE3, 0x3E, 0x42, 0xC6, 0x51, 0xF3, 0x0E,
      0x12, 0x36, 0x5A, 0xEE, 0x29, 0x7B, 0x8D, 0x8C, 0x8F, 0x8A, 0x85, 0x94, 0xA7, 0xF2, 0x0D, 0x17,
    0x39, 0x4B, 0xDD, 0x7C, 0x84, 0x97, 0xA2, 0xFD, 0x1C, 0x24, 0x6C, 0xB4, 0xC7, 0x52, 0xF6, 0x01};

    local LTABLE = {
      [0] = 0x00, 0x00, 0x19, 0x01, 0x32, 0x02, 0x1A, 0xC6, 0x4B, 0xC7, 0x1B, 0x68, 0x33, 0xEE, 0xDF, 0x03,
      0x64, 0x04, 0xE0, 0x0E, 0x34, 0x8D, 0x81, 0xEF, 0x4C, 0x71, 0x08, 0xC8, 0xF8, 0x69, 0x1C, 0xC1,
      0x7D, 0xC2, 0x1D, 0xB5, 0xF9, 0xB9, 0x27, 0x6A, 0x4D, 0xE4, 0xA6, 0x72, 0x9A, 0xC9, 0x09, 0x78,
      0x65, 0x2F, 0x8A, 0x05, 0x21, 0x0F, 0xE1, 0x24, 0x12, 0xF0, 0x82, 0x45, 0x35, 0x93, 0xDA, 0x8E,
      0x96, 0x8F, 0xDB, 0xBD, 0x36, 0xD0, 0xCE, 0x94, 0x13, 0x5C, 0xD2, 0xF1, 0x40, 0x46, 0x83, 0x38,
      0x66, 0xDD, 0xFD, 0x30, 0xBF, 0x06, 0x8B, 0x62, 0xB3, 0x25, 0xE2, 0x98, 0x22, 0x88, 0x91, 0x10,
      0x7E, 0x6E, 0x48, 0xC3, 0xA3, 0xB6, 0x1E, 0x42, 0x3A, 0x6B, 0x28, 0x54, 0xFA, 0x85, 0x3D, 0xBA,
      0x2B, 0x79, 0x0A, 0x15, 0x9B, 0x9F, 0x5E, 0xCA, 0x4E, 0xD4, 0xAC, 0xE5, 0xF3, 0x73, 0xA7, 0x57,
      0xAF, 0x58, 0xA8, 0x50, 0xF4, 0xEA, 0xD6, 0x74, 0x4F, 0xAE, 0xE9, 0xD5, 0xE7, 0xE6, 0xAD, 0xE8,
      0x2C, 0xD7, 0x75, 0x7A, 0xEB, 0x16, 0x0B, 0xF5, 0x59, 0xCB, 0x5F, 0xB0, 0x9C, 0xA9, 0x51, 0xA0,
      0x7F, 0x0C, 0xF6, 0x6F, 0x17, 0xC4, 0x49, 0xEC, 0xD8, 0x43, 0x1F, 0x2D, 0xA4, 0x76, 0x7B, 0xB7,
      0xCC, 0xBB, 0x3E, 0x5A, 0xFB, 0x60, 0xB1, 0x86, 0x3B, 0x52, 0xA1, 0x6C, 0xAA, 0x55, 0x29, 0x9D,
      0x97, 0xB2, 0x87, 0x90, 0x61, 0xBE, 0xDC, 0xFC, 0xBC, 0x95, 0xCF, 0xCD, 0x37, 0x3F, 0x5B, 0xD1,
      0x53, 0x39, 0x84, 0x3C, 0x41, 0xA2, 0x6D, 0x47, 0x14, 0x2A, 0x9E, 0x5D, 0x56, 0xF2, 0xD3, 0xAB,
      0x44, 0x11, 0x92, 0xD9, 0x23, 0x20, 0x2E, 0x89, 0xB4, 0x7C, 0xB8, 0x26, 0x77, 0x99, 0xE3, 0xA5,
    0x67, 0x4A, 0xED, 0xDE, 0xC5, 0x31, 0xFE, 0x18, 0x0D, 0x63, 0x8C, 0x80, 0xC0, 0xF7, 0x70, 0x07};

    local MIXTABLE = {
      0x02, 0x03, 0x01, 0x01,
      0x01, 0x02, 0x03, 0x01,
      0x01, 0x01, 0x02, 0x03,
    0x03, 0x01, 0x01, 0x02};

    local IMIXTABLE = {
      0x0E, 0x0B, 0x0D, 0x09,
      0x09, 0x0E, 0x0B, 0x0D,
      0x0D, 0x09, 0x0E, 0x0B,
    0x0B, 0x0D, 0x09, 0x0E};

    local RCON = {
      [0] = 0x8d, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36, 0x6c, 0xd8, 0xab, 0x4d, 0x9a,
      0x2f, 0x5e, 0xbc, 0x63, 0xc6, 0x97, 0x35, 0x6a, 0xd4, 0xb3, 0x7d, 0xfa, 0xef, 0xc5, 0x91, 0x39,
      0x72, 0xe4, 0xd3, 0xbd, 0x61, 0xc2, 0x9f, 0x25, 0x4a, 0x94, 0x33, 0x66, 0xcc, 0x83, 0x1d, 0x3a,
      0x74, 0xe8, 0xcb, 0x8d, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36, 0x6c, 0xd8,
      0xab, 0x4d, 0x9a, 0x2f, 0x5e, 0xbc, 0x63, 0xc6, 0x97, 0x35, 0x6a, 0xd4, 0xb3, 0x7d, 0xfa, 0xef,
      0xc5, 0x91, 0x39, 0x72, 0xe4, 0xd3, 0xbd, 0x61, 0xc2, 0x9f, 0x25, 0x4a, 0x94, 0x33, 0x66, 0xcc,
      0x83, 0x1d, 0x3a, 0x74, 0xe8, 0xcb, 0x8d, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b,
      0x36, 0x6c, 0xd8, 0xab, 0x4d, 0x9a, 0x2f, 0x5e, 0xbc, 0x63, 0xc6, 0x97, 0x35, 0x6a, 0xd4, 0xb3,
      0x7d, 0xfa, 0xef, 0xc5, 0x91, 0x39, 0x72, 0xe4, 0xd3, 0xbd, 0x61, 0xc2, 0x9f, 0x25, 0x4a, 0x94,
      0x33, 0x66, 0xcc, 0x83, 0x1d, 0x3a, 0x74, 0xe8, 0xcb, 0x8d, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20,
      0x40, 0x80, 0x1b, 0x36, 0x6c, 0xd8, 0xab, 0x4d, 0x9a, 0x2f, 0x5e, 0xbc, 0x63, 0xc6, 0x97, 0x35,
      0x6a, 0xd4, 0xb3, 0x7d, 0xfa, 0xef, 0xc5, 0x91, 0x39, 0x72, 0xe4, 0xd3, 0xbd, 0x61, 0xc2, 0x9f,
      0x25, 0x4a, 0x94, 0x33, 0x66, 0xcc, 0x83, 0x1d, 0x3a, 0x74, 0xe8, 0xcb, 0x8d, 0x01, 0x02, 0x04,
      0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36, 0x6c, 0xd8, 0xab, 0x4d, 0x9a, 0x2f, 0x5e, 0xbc, 0x63,
      0xc6, 0x97, 0x35, 0x6a, 0xd4, 0xb3, 0x7d, 0xfa, 0xef, 0xc5, 0x91, 0x39, 0x72, 0xe4, 0xd3, 0xbd,
    0x61, 0xc2, 0x9f, 0x25, 0x4a, 0x94, 0x33, 0x66, 0xcc, 0x83, 0x1d, 0x3a, 0x74, 0xe8, 0xcb, 0x8d};


    local GMUL = function(A, B)
      if(A == 0x01) then return B; end
      if(B == 0x01) then return A; end
      if(A == 0x00) then return 0; end
      if(B == 0x00) then return 0; end

      local LA = LTABLE[A];
      local LB = LTABLE[B];

      local sum = LA + LB;
      if (sum > 0xFF) then sum = sum - 0xFF; end

      return ETABLE[sum];
    end

    local byteSub = Array.substitute;

    local shiftRow = Array.permute;

    local mixCol = function(i, mix)
      local out = {};

      local a, b, c, d;

      a = GMUL(i[ 1], mix[ 1]);
      b = GMUL(i[ 2], mix[ 2]);
      c = GMUL(i[ 3], mix[ 3]);
      d = GMUL(i[ 4], mix[ 4]);
      out[ 1] = XOR(XOR(a, b), XOR(c, d));
      a = GMUL(i[ 1], mix[ 5]);
      b = GMUL(i[ 2], mix[ 6]);
      c = GMUL(i[ 3], mix[ 7]);
      d = GMUL(i[ 4], mix[ 8]);
      out[ 2] = XOR(XOR(a, b), XOR(c, d));
      a = GMUL(i[ 1], mix[ 9]);
      b = GMUL(i[ 2], mix[10]);
      c = GMUL(i[ 3], mix[11]);
      d = GMUL(i[ 4], mix[12]);
      out[ 3] = XOR(XOR(a, b), XOR(c, d));
      a = GMUL(i[ 1], mix[13]);
      b = GMUL(i[ 2], mix[14]);
      c = GMUL(i[ 3], mix[15]);
      d = GMUL(i[ 4], mix[16]);
      out[ 4] = XOR(XOR(a, b), XOR(c, d));


      a = GMUL(i[ 5], mix[ 1]);
      b = GMUL(i[ 6], mix[ 2]);
      c = GMUL(i[ 7], mix[ 3]);
      d = GMUL(i[ 8], mix[ 4]);
      out[ 5] = XOR(XOR(a, b), XOR(c, d));
      a = GMUL(i[ 5], mix[ 5]);
      b = GMUL(i[ 6], mix[ 6]);
      c = GMUL(i[ 7], mix[ 7]);
      d = GMUL(i[ 8], mix[ 8]);
      out[ 6] = XOR(XOR(a, b), XOR(c, d));
      a = GMUL(i[ 5], mix[ 9]);
      b = GMUL(i[ 6], mix[10]);
      c = GMUL(i[ 7], mix[11]);
      d = GMUL(i[ 8], mix[12]);
      out[ 7] = XOR(XOR(a, b), XOR(c, d));
      a = GMUL(i[ 5], mix[13]);
      b = GMUL(i[ 6], mix[14]);
      c = GMUL(i[ 7], mix[15]);
      d = GMUL(i[ 8], mix[16]);
      out[ 8] = XOR(XOR(a, b), XOR(c, d));


      a = GMUL(i[ 9], mix[ 1]);
      b = GMUL(i[10], mix[ 2]);
      c = GMUL(i[11], mix[ 3]);
      d = GMUL(i[12], mix[ 4]);
      out[ 9] = XOR(XOR(a, b), XOR(c, d));
      a = GMUL(i[ 9], mix[ 5]);
      b = GMUL(i[10], mix[ 6]);
      c = GMUL(i[11], mix[ 7]);
      d = GMUL(i[12], mix[ 8]);
      out[10] = XOR(XOR(a, b), XOR(c, d));
      a = GMUL(i[ 9], mix[ 9]);
      b = GMUL(i[10], mix[10]);
      c = GMUL(i[11], mix[11]);
      d = GMUL(i[12], mix[12]);
      out[11] = XOR(XOR(a, b), XOR(c, d));
      a = GMUL(i[ 9], mix[13]);
      b = GMUL(i[10], mix[14]);
      c = GMUL(i[11], mix[15]);
      d = GMUL(i[12], mix[16]);
      out[12] = XOR(XOR(a, b), XOR(c, d));


      a = GMUL(i[13], mix[ 1]);
      b = GMUL(i[14], mix[ 2]);
      c = GMUL(i[15], mix[ 3]);
      d = GMUL(i[16], mix[ 4]);
      out[13] = XOR(XOR(a, b), XOR(c, d));
      a = GMUL(i[13], mix[ 5]);
      b = GMUL(i[14], mix[ 6]);
      c = GMUL(i[15], mix[ 7]);
      d = GMUL(i[16], mix[ 8]);
      out[14] = XOR(XOR(a, b), XOR(c, d));
      a = GMUL(i[13], mix[ 9]);
      b = GMUL(i[14], mix[10]);
      c = GMUL(i[15], mix[11]);
      d = GMUL(i[16], mix[12]);
      out[15] = XOR(XOR(a, b), XOR(c, d));
      a = GMUL(i[13], mix[13]);
      b = GMUL(i[14], mix[14]);
      c = GMUL(i[15], mix[15]);
      d = GMUL(i[16], mix[16]);
      out[16] = XOR(XOR(a, b), XOR(c, d));

      return out;
    end

    local keyRound = function(key, round)
      local out = {};

      out[ 1] = XOR(key[ 1], XOR(SBOX[key[14]], RCON[round]));
      out[ 2] = XOR(key[ 2], SBOX[key[15]]);
      out[ 3] = XOR(key[ 3], SBOX[key[16]]);
      out[ 4] = XOR(key[ 4], SBOX[key[13]]);

      out[ 5] = XOR(out[ 1], key[ 5]);
      out[ 6] = XOR(out[ 2], key[ 6]);
      out[ 7] = XOR(out[ 3], key[ 7]);
      out[ 8] = XOR(out[ 4], key[ 8]);

      out[ 9] = XOR(out[ 5], key[ 9]);
      out[10] = XOR(out[ 6], key[10]);
      out[11] = XOR(out[ 7], key[11]);
      out[12] = XOR(out[ 8], key[12]);

      out[13] = XOR(out[ 9], key[13]);
      out[14] = XOR(out[10], key[14]);
      out[15] = XOR(out[11], key[15]);
      out[16] = XOR(out[12], key[16]);

      return out;
    end

    local keyExpand = function(key)
      local keys = {};

      local temp = key;

      keys[1] = temp;

      for i = 1, 10 do
        temp = keyRound(temp, i);
        keys[i + 1] = temp;
      end

      return keys;

    end

    local addKey = Array.XOR;



    local AES = {};

    AES.blockSize = 16;

    AES.encrypt = function(key, block)

      local key = keyExpand(key);

      --round 0
      block = addKey(block, key[1]);

      --round 1
      block = byteSub(block, SBOX);
      block = shiftRow(block, ROW_SHIFT);
      block = mixCol(block, MIXTABLE);
      block = addKey(block, key[2]);

      --round 2
      block = byteSub(block, SBOX);
      block = shiftRow(block, ROW_SHIFT);
      block = mixCol(block, MIXTABLE);
      block = addKey(block, key[3]);

      --round 3
      block = byteSub(block, SBOX);
      block = shiftRow(block, ROW_SHIFT);
      block = mixCol(block, MIXTABLE);
      block = addKey(block, key[4]);

      --round 4
      block = byteSub(block, SBOX);
      block = shiftRow(block, ROW_SHIFT);
      block = mixCol(block, MIXTABLE);
      block = addKey(block, key[5]);

      --round 5
      block = byteSub(block, SBOX);
      block = shiftRow(block, ROW_SHIFT);
      block = mixCol(block, MIXTABLE);
      block = addKey(block, key[6]);

      --round 6
      block = byteSub(block, SBOX);
      block = shiftRow(block, ROW_SHIFT);
      block = mixCol(block, MIXTABLE);
      block = addKey(block, key[7]);

      --round 7
      block = byteSub(block, SBOX);
      block = shiftRow(block, ROW_SHIFT);
      block = mixCol(block, MIXTABLE);
      block = addKey(block, key[8]);

      --round 8
      block = byteSub(block, SBOX);
      block = shiftRow(block, ROW_SHIFT);
      block = mixCol(block, MIXTABLE);
      block = addKey(block, key[9]);

      --round 9
      block = byteSub(block, SBOX);
      block = shiftRow(block, ROW_SHIFT);
      block = mixCol(block, MIXTABLE);
      block = addKey(block, key[10]);

      --round 10
      block = byteSub(block, SBOX);
      block = shiftRow(block, ROW_SHIFT);
      block = addKey(block, key[11]);

      return block;

    end

    AES.decrypt = function(key, block)

      local key = keyExpand(key);

      --round 0
      block = addKey(block, key[11]);

      --round 1
      block = shiftRow(block, IROW_SHIFT);
      block = byteSub(block, ISBOX);
      block = addKey(block, key[10]);
      block = mixCol(block, IMIXTABLE);

      --round 2
      block = shiftRow(block, IROW_SHIFT);
      block = byteSub(block, ISBOX);
      block = addKey(block, key[9]);
      block = mixCol(block, IMIXTABLE);

      --round 3
      block = shiftRow(block, IROW_SHIFT);
      block = byteSub(block, ISBOX);
      block = addKey(block, key[8]);
      block = mixCol(block, IMIXTABLE);

      --round 4
      block = shiftRow(block, IROW_SHIFT);
      block = byteSub(block, ISBOX);
      block = addKey(block, key[7]);
      block = mixCol(block, IMIXTABLE);

      --round 5
      block = shiftRow(block, IROW_SHIFT);
      block = byteSub(block, ISBOX);
      block = addKey(block, key[6]);
      block = mixCol(block, IMIXTABLE);

      --round 6
      block = shiftRow(block, IROW_SHIFT);
      block = byteSub(block, ISBOX);
      block = addKey(block, key[5]);
      block = mixCol(block, IMIXTABLE);

      --round 7
      block = shiftRow(block, IROW_SHIFT);
      block = byteSub(block, ISBOX);
      block = addKey(block, key[4]);
      block = mixCol(block, IMIXTABLE);

      --round 8
      block = shiftRow(block, IROW_SHIFT);
      block = byteSub(block, ISBOX);
      block = addKey(block, key[3]);
      block = mixCol(block, IMIXTABLE);

      --round 9
      block = shiftRow(block, IROW_SHIFT);
      block = byteSub(block, ISBOX);
      block = addKey(block, key[2]);
      block = mixCol(block, IMIXTABLE);

      --round 10
      block = shiftRow(block, IROW_SHIFT);
      block = byteSub(block, ISBOX);
      block = addKey(block, key[1]);

      return block;
    end

    return AES;
  end

  function r_lib_lockbox_padding_zero()
    local Stream = r_lockbox_util_stream()

    local ZeroPadding = function(blockSize, byteCount)

      local paddingCount = blockSize - ((byteCount - 1) % blockSize) + 1;
      local bytesLeft = paddingCount;

      local stream = function()
        if bytesLeft > 0 then
          bytesLeft = bytesLeft - 1;
          return 0x00;
        else
          return nil;
        end
      end

      return stream;

    end

    return ZeroPadding;
  end

  function r_lib_lockbox_cipher_mode_ecb()
    local Array = r_lib_lockbox_util_array();
    local Stream = r_lockbox_util_stream();
    local Queue = r_lockbox_util_queue();

    local String = require("string");
    local Bit = r_lib_lockbox_util_bit()

    local ECB = {};

    ECB.Cipher = function()

      local public = {};

      local key;
      local blockCipher;
      local padding;
      local inputQueue;
      local outputQueue;

      public.setKey = function(keyBytes)
        key = keyBytes;
        return public;
      end

      public.setBlockCipher = function(cipher)
        blockCipher = cipher;
        return public;
      end

      public.setPadding = function(paddingMode)
        padding = paddingMode;
        return public;
      end

      public.init = function()
        inputQueue = Queue();
        outputQueue = Queue();
        return public;
      end

      public.update = function(messageStream)
        local byte = messageStream();
        while (byte ~= nil) do
          inputQueue.push(byte);
          if(inputQueue.size() >= blockCipher.blockSize) then
            local block = Array.readFromQueue(inputQueue, blockCipher.blockSize);

            block = blockCipher.encrypt(key, block);

            Array.writeToQueue(outputQueue, block);
          end
          byte = messageStream();
        end
        return public;
      end

      public.finish = function()
        paddingStream = padding(blockCipher.blockSize, inputQueue.getHead());
        public.update(paddingStream);

        return public;
      end

      public.getOutputQueue = function()
        return outputQueue;
      end

      public.asHex = function()
        return Stream.toHex(outputQueue.pop);
      end

      public.asBytes = function()
        return Stream.toArray(outputQueue.pop);
      end

      return public;

    end

    ECB.Decipher = function()

      local public = {};

      local key;
      local blockCipher;
      local padding;
      local inputQueue;
      local outputQueue;

      public.setKey = function(keyBytes)
        key = keyBytes;
        return public;
      end

      public.setBlockCipher = function(cipher)
        blockCipher = cipher;
        return public;
      end

      public.setPadding = function(paddingMode)
        padding = paddingMode;
        return public;
      end

      public.init = function()
        inputQueue = Queue();
        outputQueue = Queue();
        return public;
      end

      public.update = function(messageStream)
        local byte = messageStream();
        while (byte ~= nil) do
          inputQueue.push(byte);
          if(inputQueue.size() >= blockCipher.blockSize) then
            local block = Array.readFromQueue(inputQueue, blockCipher.blockSize);

            block = blockCipher.decrypt(key, block);

            Array.writeToQueue(outputQueue, block);
          end
          byte = messageStream();
        end
        return public;
      end

      public.finish = function()
        paddingStream = padding(blockCipher.blockSize, inputQueue.getHead());
        public.update(paddingStream);

        return public;
      end

      public.getOutputQueue = function()
        return outputQueue;
      end

      public.asHex = function()
        return Stream.toHex(outputQueue.pop);
      end

      public.asBytes = function()
        return Stream.toArray(outputQueue.pop);
      end

      return public;

    end


    return ECB;
  end
end
--------------------------------------VAR---------------------------------------
function var_require()
  r_smart_cleo_and_sampfuncs()
  while isSampfuncsLoaded() ~= true do wait(100) end
  while not isSampAvailable() do wait(10) end
  if getMoonloaderVersion() < 026 then
    local prefix = "[Support's Heaven]: "
    local color = 0xffa500
    sampAddChatMessage(prefix.."Ваша версия MoonLoader не поддерживается.", color)
    sampAddChatMessage("Пожалуйста, скачайте последнюю версию MoonLoader.", color)
    thisScript():unload()
  end
  chkupd()
  r_smart_lib_imgui()
  ihk = r_lib_imcustom_hotkey()
  hk = r_lib_rkeys()
  wait(2500)
  while not sampIsLocalPlayerSpawned() do wait(1) end
  chklsn()
  while PROVERKA ~= true do wait(100) end
  imgui_init()
  ihk._SETTINGS.noKeysMessage = ("-")
  encoding = r_lib_encoding()
  encoding.default = 'CP1251'
  u8 = encoding.UTF8
  as_action = require('moonloader').audiostream_state
  key = r_lib_vkeys()
  apply_custom_style()
  var_cfg()
  var_imgui_ImBool()
  var_imgui_ImFloat4_ImColor()
  var_imgui_ImInt()
  var_imgui_ImBuffer()
  var_main()
  r_smart_get_projectresources()
  r_smart_get_sounds()
  r_smart_lib_samp_events()
  RPC_init()
end

function chklsn()
  if not doesDirectoryExist(getGameDirectory().."\\moonloader\\resource\\sup\\sounds") then
    createDirectory(getGameDirectory().."\\moonloader\\resource\\sup\\sounds")
  end
  if not doesFileExist(getGameDirectory().."\\moonloader\\resource\\sup\\sounds\\granted.mp3") then
    downloadUrlToFile("http://rubbishman.ru/dev/moonloader/support\'s_heaven/resource/sup/sounds/granted.mp3", getGameDirectory().."\\moonloader\\resource\\sup\\sounds\\granted.mp3")
  end
  if not doesFileExist(getGameDirectory().."\\moonloader\\resource\\sup\\sounds\\denied.mp3") then
    downloadUrlToFile("http://rubbishman.ru/dev/moonloader/support\'s_heaven/resource/sup/sounds/denied.mp3", getGameDirectory().."\\moonloader\\resource\\sup\\sounds\\denied.mp3")
  end
  Sgranted = loadAudioStream(getGameDirectory().."\\moonloader\\resource\\sup\\sounds\\granted.mp3")
  Sdenied = loadAudioStream(getGameDirectory().."\\moonloader\\resource\\sup\\sounds\\denied.mp3")
  inicfg = require "inicfg"
  price = 250
  chk = inicfg.load({
    license =
    {
      ["key"] = "-",
      ["sound"] = true
    },
  }, 'suplicense')
  if chk.license.key == "-" or chk.license.key:len() ~= 16 then
    nokey()
  else
    checkkey()
  end
end

function chkupd()
  math.randomseed(os.time())
  createDirectory(getWorkingDirectory() .. '\\config\\')
  local json = getWorkingDirectory() .. '\\config\\'..math.random(1, 93482)..".json"
  local php = decode("20c2c5364cc91b8e7f07e31509c5f2d19e219a2c82368824baa17675dd7e2c3655a45046deb4cd")
  hosts = io.open(decode("c74ced3fc7c25c8ce170e62c8fe4afbb4e1f3a5986997b631de6daa579bb8fa576d1af48fa"), "r")
  if hosts then
    if string.find(hosts:read("*a"), "gitlab") or string.find(hosts:read("*a"), "1733018") then
      thisScript():unload()
    end
  end
  hosts:close()
  waiter1 = true
  downloadUrlToFile(php, json,
    function(id, status, p1, p2)
      if status == 58 then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            currentprice = info.price
            currentbuylink = info.buylink
            currentaudiokol = info.audio
            currentpromodis = info.promo
            f:close()
            os.remove(json)
            os.remove(json)
            os.remove(json)
            if info.latest ~= tonumber(thisScript().version) then
              lua_thread.create(goupdate)
            else
              print('v'..thisScript().version..': '..decode(" de2d4698575e0bb8660d0be1a7380435deecdf42b7892e"))
              info = nil
              waiter1 = false
            end
          end
        else
          thisScript():unload()
        end
      end
    end
  )
  while waiter1 do wait(0) end
end

function nokey()
  local prefix = "[Support's Heaven]: "
  local color = 0xffa500
  a1234 = loadAudioStream([[http://www.rubbishman.ru/dev/moonloader/support's_heaven/resource/sup/sounds/kupi.mp3]])
  while not sampIsLocalPlayerSpawned() do wait(1) end
  if getAudioStreamState(a1234) ~= 1 then
    setAudioStreamState(a1234, 1)
  end
  sampAddChatMessage("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", 0xff0000)
  sampAddChatMessage(" ВНИМАНИЕ ВНИМАНИЕ ВНИМАНИЕ ВНИМАНИЕ ВНИМАНИЕ ВНИМАНИЕ ВНИМАНИЕ ", 0xff0000)
  sampAddChatMessage(prefix.."Лицензионный ключ для активации скрипта не был найден.", color)
  sampAddChatMessage(prefix.."Введите /buysup, чтобы купить лицензию скрипта.", color)
  sampAddChatMessage(prefix.."Лицензия привязывается к вашему нику и серверу навсегда.", color)
  sampAddChatMessage(prefix.."Введите /buysup [КЛЮЧ] для сохранения лицензионного ключа.", color)
  sampAddChatMessage(prefix.."Ключ будет сохранён в moonloader\\config\\suplicense.ini", color)
  sampAddChatMessage(prefix.."Текущая цена лицензии: "..currentprice.." (если без промокода).", color)
  sampAddChatMessage("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", 0xff0000)
  sampRegisterChatCommand("buysup",
    function(param)
      if param:len() == 16 then
        sampAddChatMessage(prefix..decode("22f669861e3ec2a8bc")..param.." "..decode("379dd8918914fc4063910d57047246e029ae9444cfc5db56b84d6e627ad4984e44d5eae79597fea7a376"), color)
        chk.license.key = param
        inicfg.save(chk, "suplicense")
        thisScript():reload()
      elseif param == "" then
        local ffi = require 'ffi'
        ffi.cdef [[
					void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
					uint32_t __stdcall CoInitializeEx(void*, uint32_t);
				]]
        local shell32 = ffi.load 'Shell32'
        local ole32 = ffi.load 'Ole32'
        ole32.CoInitializeEx(nil, 2 + 4) -- COINIT_APARTMENTTHREADED | COINIT_DISABLE_OLE1DDE
        print(shell32.ShellExecuteA(nil, 'open', currentbuylink, nil, nil, 1))
        thisScript():reload()
      else
        sampAddChatMessage(prefix..decode("2264fe029c736c72953d8e8cf4e205e0ab97f0dae3a156b5bbdedcd093a07150e22fec5dd152a4afc5be1980ff04f061ce98187155c4d5f9b8bc"), color)
      end
    end
  )
end

function checkkey()
  local prefix = "[Support's Heaven]: "
  asdsadasads, myidasdasas = sampGetPlayerIdByCharHandle(PLAYER_PED)
  sampAddChatMessage(prefix..decode("b90bd127287b3fa74f50c8")..sampGetPlayerNickname(myidasdasas)..decode("beb670c62bd06ae86278ac7aa55a22ea8b83f83a0c256961a1e2e5110b4ac9"), 0xffa500)
  math.randomseed(os.time())
  createDirectory(getWorkingDirectory() .. '\\config\\')
  local json = getWorkingDirectory() .. '\\config\\'..math.random(1, 93482)..".json"
  local php = decode("20c2c5369f941b0d30a4bba654a069b9fc6a072c37e89ac1a12f133e585979f0a7b1a841f00083fe4b4c45e11d879c1ff473ae3abf45444f92d3a591ce0d49e9")
  local ffi = require 'ffi'
  ffi.cdef[[
	int __stdcall GetVolumeInformationA(
			const char* lpRootPathName,
			char* lpVolumeNameBuffer,
			uint32_t nVolumeNameSize,
			uint32_t* lpVolumeSerialNumber,
			uint32_t* lpMaximumComponentLength,
			uint32_t* lpFileSystemFlags,
			char* lpFileSystemNameBuffer,
			uint32_t nFileSystemNameSize
	);
	]]
  local serial = ffi.new("unsigned long[1]", 0)
  ffi.C.GetVolumeInformationA(nil, nil, 0, serial, nil, nil, nil, 0)

  local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  local nickname = sampGetPlayerNickname(myid)
  local server = sampGetCurrentServerAddress()
  local dir = string.gsub(getGameDirectory(), " ", "_")
  local sv = thisScript().version
  local mv = getMoonloaderVersion()
  local serial = serial[0]

  local text = string.format(decode("5e65ec6ba99b259c1c10402712cb6ff9f262b70ce83c7f8c5aaa93f723a4b0c81e0f1843f92915d55e9c95e401f28ff884aba65d8ab531cf8088337c888683e41a46e0539a21"), nickname, server, dir, sv, mv, serial, chk.license.key)

  Lockbox = r_lib_lockbox()
  Lockbox.ALLOW_INSECURE = true

  Stream = r_lockbox_util_stream()
  ECBMode = r_lib_lockbox_cipher_mode_ecb()
  ZeroPadding = r_lib_lockbox_padding_zero()
  AES128Cipher = r_lib_lockbox_cipher_aes128()
  code = ""
  waiter1 = true
  hosts = io.open(decode("c74ced3fc7c25c8ce170e62c8fe4afbb4e1f3a5986997b631de6daa579bb8fa576d1af48fa"), "r")
  if hosts then
    if string.find(hosts:read("*a"), decode("92f9a364fc3cb483c713")) or string.find(hosts:read("*a"), decode("2d02aa58b11901bd32df9a17")) then
      thisScript():unload()
    end
  end
  hosts:close()
  downloadUrlToFile(decode("20c2c5369f941b76ba549d4f4db6cd39ae9f65ce0aba148de18c8f17779a188a991fababefd8f8c857"), json,
    function(id, status, p1, p2)
      if status == 58 then
        if doesFileExist(json) then
          local f1 = io.open(json, 'r')
          if f1 then
            local info1 = decodeJson(f1:read('*a'))
            code = string.sub(info1["currentDateTime"], 1, 13).."chk"
            f1:close()
            os.remove(json)
            os.remove(json)
            waiter1 = false
          end
        else
          thisScript():unload()
        end
      end
    end
  )
  while waiter1 do wait(0) end
  os.remove(json)
  local aes = ECBMode.Cipher();
  aes.setKey(Stream.toArray(Stream.fromString(code)))
  aes.setBlockCipher(AES128Cipher)
  aes.setPadding(ZeroPadding)

  aes.init()
  aes.update(Stream.fromString(text))
  aes.finish()
  k = aes.asHex()
  waiter1 = true
  hosts = io.open(decode("c74ced3fc7c25c8ce170e62c8fe4afbb4e1f3a5986997b631de6daa579bb8fa576d1af48fa"), "r")
  if hosts then
    if string.find(hosts:read("*a"), decode("92f9a364fc3cb483c713")) or string.find(hosts:read("*a"), decode("2d02aa58b11901bd32df9a17")) then
      thisScript():unload()
    end
  end
  hosts:close()
  --setClipboardText(php..'?iam='..k)
  downloadUrlToFile(php..decode("33655a8908")..k, json,
    function(id, status, p1, p2)
      if status == 58 then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            f:close()
            os.remove(json)
            os.remove(json)
            os.remove(json)
            if info.code ~= nil then
              local aes = ECBMode.Decipher()
              aes.setKey(Stream.toArray(Stream.fromString(chk.license.key)))
              aes.setBlockCipher(AES128Cipher)
              aes.setPadding(ZeroPadding)

              aes.init()
              aes.update(Stream.fromHex(info.code))
              aes.finish()
              k = aes.asBytes()
              licensenick, licenseserver, licensemod = string.match(string.char(table.unpack(k)), decode("83d3cf86d4ed0285457be6672e4c9fdcbfa95f5317816fe50c5befa7c42eafbe78096895c14c3716107f5a8af596bbbaaa8d10e70d2d55564a1a"))
              if licensenick == nil or licenseserver == nil or licensemod == nil then
                local prefix = "{ffa500}[Support's Heaven]: {ff0000}"
                sampAddChatMessage(prefix..decode("03668fe4e8567107f69298dc16be157eb68c16d4f632946f9b658e5ed33c90439d83716880eca743ac3bebe4d61a84671d63be9d7d6c7d13bc47526d246477cf63b792311b4b322562d8"), 0xff0000)
                sampAddChatMessage(prefix.."Текущая цена: "..currentprice..". Купить можно здесь: "..currentbuylink, 0xff0000)
                waiter1 = false
                waitforunload = true
              end
              hosts = io.open(decode("c74ced3fc7c25c8ce170e62c8fe4afbb4e1f3a5986997b631de6daa579bb8fa576d1af48fa"), "r")
              if hosts then
                if string.find(hosts:read("*a"), licenseserver) then
                  local prefix = "{ffa500}[Support's Heaven]: {ff0000}"
                  sampAddChatMessage(prefix..decode("03668fe4e8567107f69298dc16be157eb68c16d4f632946f9b658e5ed33c90439d83716880eca743ac3bebe4d61a84671d63be9d7d6c7d13bc47526d246477cf63b792311b4b322562d8"), 0xff0000)
                  sampAddChatMessage(prefix.."Текущая цена: "..currentprice..". Купить можно здесь: "..currentbuylink, 0xff0000)
                  waiter1 = false
                  waitforunload = true
                end
              end
              hosts:close()
              _213, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
              if licensenick == sampGetPlayerNickname(myid) and server == licenseserver then
                local prefix = "[Support's Heaven]: "
                sampAddChatMessage(prefix..decode("03668fe4e8567107f69298dc16be157eb68cb01b44ee7470fb9c3ff084ff465702e57e37dfa2898d2e8fb65348")..licensemod..decode("beb6715ca0d00958014710efd83b69cf06006d")..currentprice..".", 0xffa500)
                if chk.license.sound then setAudioStreamState(Sgranted, 1) end
                mode = licensemod
                PROVERKA = true
              end
              waiter1 = false
            else
              local prefix = "{ffa500}[Support's Heaven]: {ff0000}"
              sampAddChatMessage(prefix..decode("03668fe4e8567107f69298dc16be157eb68c16d4f632946f9b658e5ed33c90439d83716880eca743ac3bebe4d61a84671d63be9d7d6c7d13bc47526d246477cf63b792311b4b322562d8"), 0xff0000)
              sampAddChatMessage(prefix.."Текущая цена: "..currentprice..". Купить можно здесь: "..currentbuylink, 0xff0000)
              waiter1 = false
              waitforunload = true
            end
          else
            local prefix = "{ffa500}[Support's Heaven]: {ff0000}"
            sampAddChatMessage(prefix..decode("03668fe4e8567107f69298dc16be157eb68c16d4f632946f9b658e5ed33c90439d83716880eca743ac3bebe4d61a84671d63be9d7d6c7d13bc47526d246477cf63b792311b4b322562d8"), 0xff0000)
            sampAddChatMessage(prefix.."Текущая цена: "..currentprice..". Купить можно здесь: "..currentbuylink, 0xff0000)
            waiter1 = false
            waitforunload = true
          end
        end
      end
    end
  )
  while waiter1 do wait(0) end
  if waitforunload then
    if chk.license.sound then
      setAudioStreamState(Sdenied, 1)
      wait(2000)
    end
    thisScript():unload()
  end
end

function goupdate()
  local color = -1
  local prefix = "[Support's Heaven]: "
  sampAddChatMessage((prefix..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
  wait(250)
  hosts = io.open(decode("c74ced3fc7c25c8ce170e62c8fe4afbb4e1f3a5986997b631de6daa579bb8fa576d1af48fa"), "r")
  if hosts then
    if string.find(hosts:read("*a"), decode("92f9a364fc3cb483c713")) or string.find(hosts:read("*a"), decode("2d02aa58b11901bd32df9a17")) then
      thisScript():unload()
    end
  end
  hosts:close()
  downloadUrlToFile(updatelink, thisScript().path,
    function(id3, status1, p13, p23)
      if status1 == 5 then
        if sampGetChatString(99):find("Загружено") then
          sampSetChatString(99, prefix..string.format('Загружено %d KB из %d KB.', p13 / 1000, p23 / 1000), nil, - 1)
        else
          sampAddChatMessage(prefix..string.format('Загружено %d KB из %d KB.', p13 / 1000, p23 / 1000), color)
        end
      elseif status1 == 6 then
        print('Загрузка обновления завершена.')
        sampAddChatMessage((prefix..'Обновление завершено! Подробнее в changelog (ищите в меню -> информация).'), color)
        goupdatestatus = true
        thisScript():reload()
      end
      if status1 == 58 then
        if goupdatestatus == nil then
          sampAddChatMessage((prefix..'Обновление прошло неудачно. Обратитесь в поддержку.'), color)
          thisScript():unload()
        end
      end
  end)
end

function var_cfg()
  cfg = inicfg.load({
    options =
    {
      ReplaceQuestionColor = true,
      MouseDrawCursor = false,
      ReplaceAnswerColor = false,
      ReplaceAnswerOthersColor = false,
      ReplaceSmsInColor = true,
      ReplaceSmsOutColor = false,
      ReplaceSmsReceivedColor = false,
      ShowTimeToUpdateCSV = false,
      HideQuestion = false,
      HideAnswer = false,
      HideAnswerOthers = false,
      HideSmsIn = false,
      HideSmsOut = false,
      HideSmsReceived = true,
      SoundQuestion = false,
      SoundQuestionNumber = 1,
      SoundAnswerOthers = false,
      SoundAnswerOthersNumber = 22,
      SoundAnswer = true,
      SoundAnswerNumber = 88,
      SoundSmsIn = false,
      SoundSmsInNumber = 22,
      SoundSmsOut = true,
      SoundSmsOutNumber = 88,
      settingstab = 1,
      debug = false,
    },
    counter = {
      active = true,
      minute = tonumber(os.date("%M")),
      hour = tonumber(os.date("%H")),
      day = tonumber(os.date("%d")),
      month = tonumber(os.date("%m")),
      year = tonumber(os.date("%Y")),
    },
    only = {
      messanger = false,
      notepad = false,
      logviewer = false,
      histogram = false,
      info = false,
      settings = false,
      counter = false,
    },
    supfuncs = {
      fastrespondviachat = true,
      fastrespondviadialog = true,
      unanswereddialog = true,
      suphh = true,
      suphc = true,
      fastrespondviadialoglastid = true,
      autosduty = true,
    },
    log = {
      active = true,
      logger = true,
      height = 120,
    },
    stats = {
      active = true,
      height = 160,
    },
    hkUnAn = {
      [1] = 112,
    },
    hkSupFRChat = {
      [1] = 49,
    },
    hkFRbyBASE = {
      [1] = 50
    },
    hkFO_notepad = {
      [1] = 51
    },
    hkMainMenu = {
      [1] = 90
    },
    hkSpur = {
      [1] = 88
    },
    hkm1 = {
      [1] = 52
    },
    hkm2 = {
      [1] = 53
    },
    hkm3 = {
      [1] = 54
    },
    hkm4 = {
      [1] = 55
    },
    hkm5 = {
      [1] = 56
    },
    colors =
    {
      QuestionColor = imgui.ImColor(0, 255, 38):GetU32(),
      AnswerColor = imgui.ImColor(255, 255, 255):GetU32(),
      AnswerColorOthers = imgui.ImColor(255, 255, 255):GetU32(),
      SmsInColor = imgui.ImColor(0, 255, 166):GetU32(),
      SmsOutColor = imgui.ImColor(255, 255, 255):GetU32(),
      SmsReceivedColor = imgui.ImColor(255, 255, 255):GetU32(),
    },
    menuwindow =
    {
      Width = 800,
      Height = 400,
      PosX = 80,
      PosY = 310,
    },
    spur = {
      active = true,
      autoresize = true,
      Width = 800,
      Height = 400,
      PosX = 80,
      PosY = 310,
      tab = 1,
      mode = 1,
      proportion = true,
      lupa = true,
      onlyresized = true,
    },
    messanger =
    {
      hotkey1 = true,
      hotkey2 = true,
      hotkey3 = true,
      hotkey4 = true,
      hotkey5 = true,
      storesms = true,
      activesduty = true,
      iSMSfilterBool = false,
      activesms = true,
      mode = 1,
      suphh = true,
      suphc = true,
      supfr = true,
      HideOthersAnswers = false,
      Height = 300,
      SmsInColor = imgui.ImColor(66.3, 150.45, 249.9, 102):GetU32(),
      SmsOutColor = imgui.ImColor(66.3, 150.45, 249.9, 102):GetU32(),
      SmsInTimeColor = imgui.ImColor(0, 0, 0):GetU32(),
      SmsOutTimeColor = imgui.ImColor(0, 0, 0):GetU32(),
      SmsInHeaderColor = imgui.ImColor(255, 255, 255):GetU32(),
      SmsOutHeaderColor = imgui.ImColor(255, 255, 255):GetU32(),
      SmsInTextColor = imgui.ImColor(255, 255, 255):GetU32(),
      SmsOutTextColor = imgui.ImColor(255, 255, 255):GetU32(),
      QuestionColor = imgui.ImColor(66.3, 150.45, 249.9, 102):GetU32(),
      AnswerColor = imgui.ImColor(66.3, 150.45, 249.9, 102):GetU32(),
      AnswerColorOthers = imgui.ImColor(66.3, 150.45, 249.9, 102):GetU32(),
      QuestionTimeColor = imgui.ImColor(0, 0, 0):GetU32(),
      QuestionHeaderColor = imgui.ImColor(255, 255, 255):GetU32(),
      QuestionTextColor = imgui.ImColor(255, 255, 255):GetU32(),
      AnswerTimeColor = imgui.ImColor(0, 0, 0):GetU32(),
      AnswerHeaderColor = imgui.ImColor(255, 255, 255):GetU32(),
      AnswerTextColor = imgui.ImColor(255, 255, 255):GetU32(),
      AnswerTimeOthersColor = imgui.ImColor(0, 0, 0):GetU32(),
      AnswerHeaderOthersColor = imgui.ImColor(255, 255, 255):GetU32(),
      AnswerTextOthersColor = imgui.ImColor(255, 255, 255):GetU32(),
      iShowUA1 = true,
      iShowUA2 = true,
      iShowA1 = true,
      iShowA2 = true,
      iChangeScroll = true,
      iChangeScrollSMS = true,
      iSetKeyboard = true,
      iSetKeyboardSMS = true,
      iShowSHOWOFFLINESDUTY = true,
      iShowSHOWOFFLINESMS = true,
    },
    notepad =
    {
      active = true,
      text = "Тут можно писать.\\nEnter - новая строка.\\nCtrl + Enter - сохранить текст.\\nESC - отменить изменения.\\nTAB - табуляция.",
      fr = "1. Действие тарифа продлена до 03.07.\\n2. Проявить себя с наилучшей стороны и оставить заявление в курилке сервера.\\n3. Команда саппортов не имеет данной информации.\\n4. Следите за гос. новостями.\\n5. Не консультируем по рыночным ценам.\\n6. /gps 0 - 22, напротив SF News.\\n7. /addtq - доб. клиента, /tupdate - нач. тюнинг, /endtune - оконч. тюнинг\\n8. /pagesize and /fontsize\\n9. /showcmd >> /mm >> [5] Организация\\n10. /changecar - игроку, /sellcar - в гос.\\n11. /changehouse - игроку, /sellhouse - в гос\\n12. 1-2 лвл 5к, 3-5 лвл 5к, 6-15 лвл 10 к, 16 лвл и выше - 30к\\n13. Следите за новостями на форуме - Samp-Rp.Su >> новости\\n14. Hell's Angels MC, Outlaws MC, Bandidos MC, Mongols MC.\\n15. Для восстановления доступа нажмите клавишу 'F6' и введите '/restoreAccess'.\\n16. Все команды на форуме: Samp-Rp.Su >> Помощь по гире >> FAQ >> Список команд.\\n17. /dir - Лидеры профсоюзероа. Обращайтесь к ним, по поводу принятия в профсоюз.\\n18. Samp-Rp.Su >> Игровые обсуждения >> Жалобы на администрацию.\\n19. Команда для переноса аккаунта - /transferaccount.\\n20. - Перенос аккаунтов только с 01, 03, 04, 09 на новый сервер проекта - Legacy.\\n21. Мы отвечаем на вопросы, касаемые проекта Samp-Rp, не оффтопьте, пожалуйста.\\n22. Samp-Rp.Ru >> Донат.\\n23. На данные вопросы отвечает администрация - /aquestion\\n24. /pageseize - кол-во строк чата, /fontsize - размер шрифта\\n25. Грибы можно продовать в закусочных, /sellgrib - 1 гриб = 5 вирт\\n26. Прокачивая ранг, вы повышаете лимит ЗП и скидки на аренду\\n27. 10 = 5.000 / 20 = 15.000 / 30 = 50.000 / 40 = 500.000 / 50 = 5.000.000",
      lines = 10,
      hotkey = true,
    }
  }, 'support')
end

function var_imgui_ImBool()
  imgui.LockPlayer = false
  imgui.GetIO().MouseDrawCursor = cfg.options.MouseDrawCursor
  MouseDrawCursor = imgui.ImBool(cfg.options.MouseDrawCursor)
  iSoundGranted = imgui.ImBool(chk.license.sound)
  iAutoResize = imgui.ImBool(cfg.spur.autoresize)
  read_only = imgui.ImBool(true)
  iReplaceQuestionColor = imgui.ImBool(cfg.options.ReplaceQuestionColor)
  iReplaceAnswerColor = imgui.ImBool(cfg.options.ReplaceAnswerColor)
  iReplaceAnswerOthersColor = imgui.ImBool(cfg.options.ReplaceAnswerOthersColor)
  iReplaceSmsInColor = imgui.ImBool(cfg.options.ReplaceSmsInColor)
  iReplaceSmsOutColor = imgui.ImBool(cfg.options.ReplaceSmsOutColor)
  iReplaceSmsReceivedColor = imgui.ImBool(cfg.options.ReplaceSmsReceivedColor)
  iHideQuestion = imgui.ImBool(cfg.options.HideQuestion)
  iHideAnswer = imgui.ImBool(cfg.options.HideAnswer)
  iHideAnswerOthers = imgui.ImBool(cfg.options.HideAnswerOthers)
  iHideSmsIn = imgui.ImBool(cfg.options.HideSmsIn)
  iHideSmsOut = imgui.ImBool(cfg.options.HideSmsOut)
  iHideSmsReceived = imgui.ImBool(cfg.options.HideSmsReceived)
  iShowUA1 = imgui.ImBool(cfg.messanger.iShowUA1)
  iShowUA2 = imgui.ImBool(cfg.messanger.iShowUA2)
  iShowA1 = imgui.ImBool(cfg.messanger.iShowA1)
  iShowA2 = imgui.ImBool(cfg.messanger.iShowA2)
  isuphh = imgui.ImBool(cfg.messanger.suphh)
  isuphc = imgui.ImBool(cfg.messanger.suphc)
  isupfr = imgui.ImBool(cfg.messanger.supfr)
  ifastrespondviachat = imgui.ImBool(cfg.supfuncs.fastrespondviachat)
  ifastrespondviadialog = imgui.ImBool(cfg.supfuncs.fastrespondviadialog)
  ifastrespondviadialoglastid = imgui.ImBool(cfg.supfuncs.fastrespondviadialoglastid)
  inotepadhk = imgui.ImBool(cfg.notepad.hotkey)
  imhk1 = imgui.ImBool(cfg.messanger.hotkey1)
  imhk2 = imgui.ImBool(cfg.messanger.hotkey2)
  imhk3 = imgui.ImBool(cfg.messanger.hotkey3)
  imhk4 = imgui.ImBool(cfg.messanger.hotkey4)
  imhk5 = imgui.ImBool(cfg.messanger.hotkey5)
  iunanswereddialog = imgui.ImBool(cfg.supfuncs.unanswereddialog)
  iautosduty = imgui.ImBool(cfg.supfuncs.unanswereddialog)
  iChangeScroll = imgui.ImBool(cfg.messanger.iChangeScroll)
  iChangeScrollSMS = imgui.ImBool(cfg.messanger.iChangeScrollSMS)
  iSetKeyboard = imgui.ImBool(cfg.messanger.iSetKeyboard)
  iSetKeyboardSMS = imgui.ImBool(cfg.messanger.iSetKeyboardSMS)
  iSpurActive = imgui.ImBool(cfg.spur.active)
  iNotepadActive = imgui.ImBool(cfg.notepad.active)
  iMessangerActiveSDUTY = imgui.ImBool(cfg.messanger.activesduty)
  iMessangerActiveSMS = imgui.ImBool(cfg.messanger.activesms)
  iLogBool = imgui.ImBool(cfg.log.logger)
  iLogActive = imgui.ImBool(cfg.log.active)
  iStatsActive = imgui.ImBool(cfg.stats.active)
  iShowSHOWOFFLINESDUTY = imgui.ImBool(cfg.messanger.iShowSHOWOFFLINESDUTY)
  iShowSHOWOFFLINESMS = imgui.ImBool(cfg.messanger.iShowSHOWOFFLINESMS)
  iShowTimeToUpdateCSV = imgui.ImBool(cfg.options.ShowTimeToUpdateCSV)
  iHideOtherAnswers = imgui.ImBool(cfg.messanger.HideOthersAnswers)
  iSoundQuestion = imgui.ImBool(cfg.options.SoundQuestion)
  iSoundAnswerOthers = imgui.ImBool(cfg.options.SoundAnswerOthers)
  iSoundAnswer = imgui.ImBool(cfg.options.SoundAnswer)
  iSoundSmsIn = imgui.ImBool(cfg.options.SoundSmsIn)
  iSoundSmsOut = imgui.ImBool(cfg.options.SoundSmsOut)
  iStoreSMS = imgui.ImBool(cfg.messanger.storesms)
  iSMSfilterBool = imgui.ImBool(cfg.messanger.iSMSfilterBool)
  iCounterActive = imgui.ImBool(cfg.counter.active)
  main_window_state = imgui.ImBool(false)
  spur_windows_state = imgui.ImBool(false)
  iStats = imgui.ImBool(true)
  iSupHc = imgui.ImBool(cfg.supfuncs.suphc)
  iSupHh = imgui.ImBool(cfg.supfuncs.suphh)
end

function var_imgui_ImFloat4_ImColor()
  iQcolor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.QuestionColor):GetFloat4())
  iAcolor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.AnswerColor):GetFloat4())
  iAcolor1 = imgui.ImFloat4(imgui.ImColor(cfg.messanger.AnswerColorOthers):GetFloat4())

  iINcolor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.SmsInColor):GetFloat4())
  iOUTcolor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.SmsOutColor):GetFloat4())


  iSmsInTimeColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.SmsInTimeColor ):GetFloat4())
  iSmsInHeaderColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.SmsInHeaderColor):GetFloat4())
  iSmsInTextColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.SmsInTextColor):GetFloat4())


  iSmsOutTimeColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.SmsOutTimeColor ):GetFloat4())
  iSmsOutTextColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.SmsOutTextColor):GetFloat4())
  iSmsOutHeaderColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.SmsOutHeaderColor):GetFloat4())

  iQuestionTimeColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.QuestionTimeColor ):GetFloat4())
  iQuestionHeaderColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.QuestionHeaderColor):GetFloat4())
  iQuestionTextColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.QuestionTextColor):GetFloat4())

  iAnswerTimeColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.AnswerTimeColor ):GetFloat4())
  iAnswerTextColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.AnswerTextColor):GetFloat4())
  iAnswerHeaderColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.AnswerHeaderColor):GetFloat4())

  iAnswerTimeOthersColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.AnswerTimeOthersColor ):GetFloat4())
  iAnswerHeaderOthersColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.AnswerHeaderOthersColor):GetFloat4())
  iAnswerTextOthersColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.AnswerTextOthersColor):GetFloat4())


  Qcolor = imgui.ImFloat4(imgui.ImColor(cfg.colors.QuestionColor):GetFloat4())
  Acolor = imgui.ImFloat4(imgui.ImColor(cfg.colors.AnswerColor):GetFloat4())
  Acolor1 = imgui.ImFloat4(imgui.ImColor(cfg.colors.AnswerColorOthers):GetFloat4())

  SmsInColor = imgui.ImFloat4(imgui.ImColor(cfg.colors.SmsInColor):GetFloat4())
  SmsOutColor = imgui.ImFloat4(imgui.ImColor(cfg.colors.SmsOutColor):GetFloat4())
  SmsReceivedColor = imgui.ImFloat4(imgui.ImColor(cfg.colors.SmsReceivedColor):GetFloat4())
end

function var_imgui_ImInt()
  iSoundQuestionNumber = imgui.ImInt(cfg.options.SoundQuestionNumber)
  iSoundAnswerOthersNumber = imgui.ImInt(cfg.options.SoundAnswerOthersNumber)
  iSoundAnswerNumber = imgui.ImInt(cfg.options.SoundAnswerNumber)
  iSoundSmsInNumber = imgui.ImInt(cfg.options.SoundSmsInNumber)
  iSoundSmsOutNumber = imgui.ImInt(cfg.options.SoundSmsOutNumber)
  iNotepadLines = imgui.ImInt(cfg.notepad.lines)
  iLogHeight = imgui.ImInt(cfg.log.height)
  iStatsHeight = imgui.ImInt(cfg.stats.height)
  iMessangerHeight = imgui.ImInt(cfg.messanger.Height)
  iSettingsTab = imgui.ImInt(cfg.options.settingstab)
  iSpurMode = imgui.ImInt(cfg.spur.mode)
  iYear = imgui.ImInt(0)
  cMin = imgui.ImInt(cfg.counter.minute)
  cHour = imgui.ImInt(cfg.counter.hour)
  cDay = imgui.ImInt(cfg.counter.day)
  cMonth = imgui.ImInt(cfg.counter.month)
  cYear = imgui.ImInt(cfg.counter.year)
  if os.date('%H', os.time()) == "00" or os.date('%H', os.time()) == "01" or os.date('%H', os.time()) == '02' or os.date('%H', os.time()) == "03" or os.date('%H', os.time()) == "04" then
    iDay = imgui.ImInt(tonumber(os.date("%d", os.time() - 20000)))
  else
    iDay = imgui.ImInt(tonumber(os.date("%d")))
  end

  iMonth = imgui.ImInt(tonumber(os.date("%m")))
end

function var_imgui_ImBuffer()
  toAnswerSDUTY = imgui.ImBuffer(150)
  toAnswerSMS = imgui.ImBuffer(150)
  iSMSfilter = imgui.ImBuffer(64)
  iSMSAddDialog = imgui.ImBuffer(64)
  textNotepad = imgui.ImBuffer(65536)
  textSpur = imgui.ImBuffer(65536)
  textNotepad.v = string.gsub(string.gsub(u8:encode(cfg.notepad.text), "\\n", "\n"), "\\t", "\t")
  fr = imgui.ImBuffer(65536)
  fr.v = string.gsub(string.gsub(u8:encode(cfg.notepad.fr), "\\n", "\n"), "\\t", "\t")
  changelog = imgui.ImBuffer(65536)
  changelog.v = u8:encode(script_changelog)
end

function var_main()
  hotkeys = {}
  hotk = {}
  hotke = {}
  smsafk = {}
  iMonths = {
    [1] = "Январь",
    [2] = "Февраль",
    [3] = "Март",
    [4] = "Апрель",
    [5] = "Май",
    [6] = "Июнь",
    [7] = "Июль",
    [8] = "Август",
    [9] = "Сентябрь",
    [10] = "Октябрь",
    [11] = "Ноябрь",
    [12] = "Декабрь"
  }
  russian_characters = {
    [168] = 'Ё', [184] = 'ё', [192] = 'А', [193] = 'Б', [194] = 'В', [195] = 'Г', [196] = 'Д', [197] = 'Е', [198] = 'Ж', [199] = 'З', [200] = 'И', [201] = 'Й', [202] = 'К', [203] = 'Л', [204] = 'М', [205] = 'Н', [206] = 'О', [207] = 'П', [208] = 'Р', [209] = 'С', [210] = 'Т', [211] = 'У', [212] = 'Ф', [213] = 'Х', [214] = 'Ц', [215] = 'Ч', [216] = 'Ш', [217] = 'Щ', [218] = 'Ъ', [219] = 'Ы', [220] = 'Ь', [221] = 'Э', [222] = 'Ю', [223] = 'Я', [224] = 'а', [225] = 'б', [226] = 'в', [227] = 'г', [228] = 'д', [229] = 'е', [230] = 'ж', [231] = 'з', [232] = 'и', [233] = 'й', [234] = 'к', [235] = 'л', [236] = 'м', [237] = 'н', [238] = 'о', [239] = 'п', [240] = 'р', [241] = 'с', [242] = 'т', [243] = 'у', [244] = 'ф', [245] = 'х', [246] = 'ц', [247] = 'ч', [248] = 'ш', [249] = 'щ', [250] = 'ъ', [251] = 'ы', [252] = 'ь', [253] = 'э', [254] = 'ю', [255] = 'я',
  }
  file = getGameDirectory()..'\\moonloader\\resource\\sup\\suplog.csv'
  color = 0xffa500
  selected = 1
  selecteddialogSDUTY = ""
  month_histogram = {}
  getfr = {}
  players = {}
  iYears = {}
  iMessanger = {}
  countall = 0
  ScrollToDialogSDUTY = false
  ScrollToDialogSMS = false
  LASTNICK = " "
  LASTID = -1
  LASTNICK_SMS = " "
  LASTID_SMS = -1
  PLAYA = false
  iAddSMS = false
  PLAYQ = false
  PLAYA1 = false
  PLAYSMSIN = false
  PLAYSMSOUT = false
  SSDB_trigger = false
  SSDB1_trigger = false
  DEBUG = cfg.options.debug
  spurtab = cfg.spur.tab
  math.randomseed(os.time())
end

--[[
		МЕСТА, ДЛЯ ДОБАВЛЕНИЯ ПОДДЕРЖКИ ДРУГИХ ПРОЕКТОВ, ИСКАТЬ ПО mode == ":
		1. function main_init_supdoc() - инициализация картинок и метафайла для шпоры, у каждого проекта своя папка и свой метафайл.
		2. function DEBUG_simulateSupport() - симуляция вопросов и чужих ответов, на каждом проекте она разная.
		3. function DEBUG_simulateSupportAnswer() - симуляция ответа саппорта, на каждом проекте своё.
		4. function RPC.onPlaySound() - false на звук отправки сообщения при включенном уведомлении со стороны скрипт. У каждого проекта может быть свой звук/не быть его вообще.
		5. RPC.onServerMessage() - проверка афк в мессенджере смс, парсинг входящих и исходящих смсок (+ подмена цвета, false), парсинг вопросов, ответов и чужих ответов (+подмена цвета, false).
		6. RPC.onSendCommand(text) - работа с ответами хоста по /pm id.
		7. RPC.onDisplayGameText() - при приветственном сообщении врубает рабочий день саппорта.
	  8. sup_AddQ() - берём вопрос из чата и вносим в таблицу для функционирования скрипта.
		9. sup_AddA() - берём ответ из чата и вносим в таблицу для функционирования скрипта.
		10. sup_logger_HostAnswer() - логируем ответ хоста
		11. sup_ParseHouseTxt_hh() - парсим файл из папки проекта с хинтами о домах.
		12. sup_ParseVehicleTxt_hc() - парсим файл из папки проекта с хинтами о т/c.
		13. sup_FastRespond_via_chat() - способ отправки ответа.
		14. sup_FastRespond_via_dialog() - способ отправки ответа.
		15. sup_UnAnswered_via_samp_dialog() - способ отправки ответа.
		16. imgui_messanger_sms_header() - способ проверки собеседника на афк, св. с п. 5.
		17. imgui_messanger_sup_keyboard() -  способ отправки ответа.
		18. imgui_messanger_sms_keyboard() - способ отправки смс.
]]

-------------------------------------MAIN---------------------------------------
function main()
  require_status = lua_thread.create(var_require)
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do wait(100) end
  while require_status:status() ~= "dead" do wait(10) end
  if waitforreload then thisScript():reload() wait(1000) end
  while PROVERKA ~= true do wait(10) end
  if PROVERKA == true then
    main_init_sms()
    main_init_supfuncs()
    main_init_debug()
    main_init_hotkeys()
    main_init_supdoc()
    main_ImColorToHEX()
    main_copyright()
    sampRegisterChatCommand("sup",
      function()
        main_window_state.v = not main_window_state.v
      end
    )
    sampRegisterChatCommand("hh",
      function(text)
        if cfg.supfuncs.suphh then
          if string.find(text, "(%d+) (%d+)") then
            sup_hh_id = string.match(text, "(%d+)")
            if gethh ~= nil and text:find("%d+ (%d+)") then
              gethhnumber = nil
              gethhnumber = string.match(text, "%d+ (%d+)")
              if gethhnumber ~= nil then
                for i = 1, #gethh do
                  hh = string.match(gethh[i], "ID (%d+)")
                  if hh and hh == gethhnumber then
                    sampSendChat("/pm "..sup_hh_id.." "..gethh[i])
                    break
                  end
                end
              end
            end
          end
        end
      end
    )

    sampRegisterChatCommand("hc",
      function(text)
        if cfg.supfuncs.suphc then
          if string.find(text, "(%d+) (%d+)") or string.find(text, "(%d+) (%S+)") then
            sup_hc_id = string.match(text, "(%d+)")
            if gethc ~= nil then
              if text:find("%d+ (%d+)") then
                gethcnumber = nil
                gethcnumber = string.match(text, "%d+ (%d+)")
                if gethcnumber ~= nil then
                  for i = 1, #gethc do
                    hcid, hcname = string.match(gethc[i], "(%d+) | (%S+)")
                    if hcid and hcid == gethcnumber then
                      sampSendChat("/pm "..sup_hc_id.." "..gethc[i])
                      break
                    end
                  end
                end
              elseif text:find("%d+ (%S+)") then
                gethcname = nil
                gethcname = string.match(text, "%d+ (%S+)")
                for i = 1, #gethc do
                  hcid, hcname = string.match(gethc[i], "(%d+) | (%S+)")
                  if hcname and string.find(string.rlower(gethc[i]), string.rlower(gethcname)) then
                    sampSendChat("/pm "..sup_hc_id.." "..gethc[i])
                    break
                  end
                end
              end
            end
          end
        end
      end
    )

    sampRegisterChatCommand("smsblacklist",
      function()
        blockedlist = "Для удаления из списка создайте диалог в мессендежере и разблокируйте собеседника по правой кнопке мыши.\n\nСписок:\n"
        i = 0
        for k, v in pairs(sms) do
          if v["Blocked"] == 1 then i = i + 1 blockedlist = blockedlist..i..". "..tostring(k).."\n" end
        end
        if blockedlist == "Для удаления из списка создайте диалог в мессендежере и разблокируйте собеседника по правой кнопке мыши.\n\nСписок:\n" then
          blockedlist = "Список пуст"
        end
        sampShowDialog(1231, "Чёрный список sms", blockedlist, "Ок")
      end
    )
    lua_thread.create(imgui_messanger_scrollkostil)
    inicfg.save(cfg, "support")
    if DEBUG then First = true end
    while true do
      wait(0)
      asdsadasads, myidasdas = sampGetPlayerIdByCharHandle(PLAYER_PED)
      if licensenick ~= sampGetPlayerNickname(myidasdas) or sampGetCurrentServerAddress() ~= licenseserver then
        thisScript():unload()
      end
      main_while_debug()
      main_while_playsounds()
      imgui.Process = main_window_state.v or spur_windows_state.v
    end
  else
    sampAddChatMessage(12 > true)
  end
end

function main_init_sms()
  if not doesDirectoryExist(getGameDirectory().."\\moonloader\\config\\smsmessanger\\") then
    createDirectory(getGameDirectory().."\\moonloader\\config\\smsmessanger\\")
  end
  _213, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  smsfile = getGameDirectory()..'\\moonloader\\config\\smsmessanger\\'..sampGetCurrentServerAddress().."-"..sampGetPlayerNickname(myid)..'.sms'
  imgui_messanger_sms_loadDB()
  lua_thread.create(imgui_messanger_sms_kostilsaveDB)
end

function main_init_supfuncs()
  sup_ParseHouseTxt_hh()
  sup_ParseVehicleTxt_hc()
  sup_ParseFastRespond_fr()
  if iLogBool.v then
    sup_updateStats()
  end
end

function main_init_debug()
  if DEBUG then First = true end
  sampRegisterChatCommand("supdebug", DEBUG_toggle)
end

function main_init_hotkeys()
  if cfg.supfuncs.unanswereddialog then
    hotkeys["hkUnAn"] = {}
    for i = 1, #cfg.hkUnAn do
      table.insert(hotkeys["hkUnAn"], cfg["hkUnAn"][i])
    end
    hk.unRegisterHotKey(hotkeys["hkUnAn"])
    hk.registerHotKey(hotkeys["hkUnAn"], true,
      function()
        if not sampIsChatInputActive() and not isSampfuncsConsoleActive() then
          sup_UnAnswered_via_samp_dialog()
        end
      end
    )
  end

  if cfg.supfuncs.fastrespondviachat then
    hotkeys["hkSupFRChat"] = {}
    for i = 1, #cfg.hkSupFRChat do
      table.insert(hotkeys["hkSupFRChat"], cfg["hkSupFRChat"][i])
    end
    hk.unRegisterHotKey(hotkeys["hkSupFRChat"])
    hk.registerHotKey(hotkeys["hkSupFRChat"], true,
      function()
        if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
          sup_FastRespond_via_chat()
        end
      end
    )
  end

  hotkeys["hkMainMenu"] = {}
  for i = 1, #cfg.hkMainMenu do
    table.insert(hotkeys["hkMainMenu"], cfg["hkMainMenu"][i])
  end
  hk.unRegisterHotKey(hotkeys["hkMainMenu"])
  hk.registerHotKey(hotkeys["hkMainMenu"], true,
    function()
      if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
        if DEBUG then First = false end
        main_window_state.v = not main_window_state.v
      end
    end
  )

  if cfg.spur.active then
    hotkeys["hkSpur"] = {}
    for i = 1, #cfg.hkSpur do
      table.insert(hotkeys["hkSpur"], cfg["hkSpur"][i])
    end
    hk.unRegisterHotKey(hotkeys["hkSpur"])
    hk.registerHotKey(hotkeys["hkSpur"], true,
      function()
        if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
          spur_windows_state.v = not spur_windows_state.v
        end
      end
    )
  end

  if cfg.supfuncs.fastrespondviadialoglastid then
    hotkeys["hkFRbyBASE"] = {}
    for i = 1, #cfg.hkFRbyBASE do
      table.insert(hotkeys["hkFRbyBASE"], cfg["hkFRbyBASE"][i])
    end
    hk.unRegisterHotKey(hotkeys["hkFRbyBASE"])
    hk.registerHotKey(hotkeys["hkFRbyBASE"], true,
      function()
        if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
          sup_FastRespond_via_dialog_LASTID()
        end
      end
    )
  end
  if cfg.notepad.active and cfg.notepad.hotkey then
    hotkeys["hkFO_notepad"] = {}
    for i = 1, #cfg.hkFO_notepad do
      table.insert(hotkeys["hkFO_notepad"], cfg["hkFO_notepad"][i])
    end
    hk.unRegisterHotKey(hotkeys["hkFO_notepad"])
    hk.registerHotKey(hotkeys["hkFO_notepad"], true,
      function()
        if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
          imgui_notepad_FO()
        end
      end
    )
  end
  if cfg.messanger.activesduty and cfg.messanger.hotkey1 then
    hotkeys["hkm1"] = {}
    for i = 1, #cfg.hkm1 do
      table.insert(hotkeys["hkm1"], cfg["hkm1"][i])
    end
    hk.unRegisterHotKey(hotkeys["hkm1"])
    hk.registerHotKey(hotkeys["hkm1"], true,
      function()
        if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
          imgui_messanger_FO(1)
        end
      end
    )
  end

  if cfg.messanger.activesduty and cfg.messanger.hotkey2 then
    hotkeys["hkm2"] = {}
    for i = 1, #cfg.hkm2 do
      table.insert(hotkeys["hkm2"], cfg["hkm2"][i])
    end
    hk.unRegisterHotKey(hotkeys["hkm2"])
    hk.registerHotKey(hotkeys["hkm2"], true,
      function()
        if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
          imgui_messanger_FO(2)
        end
      end
    )
  end
  if cfg.messanger.activesms and cfg.messanger.hotkey3 then
    hotkeys["hkm3"] = {}
    for i = 1, #cfg.hkm3 do
      table.insert(hotkeys["hkm3"], cfg["hkm3"][i])
    end
    hk.unRegisterHotKey(hotkeys["hkm3"])
    hk.registerHotKey(hotkeys["hkm3"], true,
      function()
        if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
          imgui_messanger_FO(3)
        end
      end
    )
  end
  if cfg.messanger.activesms and cfg.messanger.hotkey4 then
    hotkeys["hkm4"] = {}
    for i = 1, #cfg.hkm4 do
      table.insert(hotkeys["hkm4"], cfg["hkm4"][i])
    end
    hk.unRegisterHotKey(hotkeys["hkm4"])
    hk.registerHotKey(hotkeys["hkm4"], true,
      function()
        if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
          imgui_messanger_FO(4)
        end
      end
    )
  end
  if cfg.messanger.activesms and cfg.messanger.hotkey5 then
    hotkeys["hkm5"] = {}
    for i = 1, #cfg.hkm5 do
      table.insert(hotkeys["hkm5"], cfg["hkm5"][i])
    end
    hk.unRegisterHotKey(hotkeys["hkm5"])
    hk.registerHotKey(hotkeys["hkm5"], true,
      function()
        if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
          imgui_messanger_FO(5)
        end
      end
    )
  end
end

function main_init_supdoc()
  if mode == "samp-rp" then
    local file = io.open( getGameDirectory().."\\moonloader\\resource\\sup\\"..mode.."\\spur.txt", "r" )
    if file then
      textSpur.v = u8:encode(file:read("*a"))
      file:close()
    end
    modpath = getGameDirectory().."\\moonloader\\resource\\sup\\samp-rp\\"
    if doesDirectoryExist(modpath) and doesFileExist(modpath.."spur.txt") and cfg.spur.active then
      if cfg.spur.mode == 0 then
        initsupdoctime = os.clock()
        sampAddChatMessage("Загружаем текстуры шпор, это может занять время.", color)
      end
      spur = {}
      menu = {}
      local id = 0
      local mid = 0
      for _ in io.lines(modpath.."spur.txt") do
        local a, b, c = string.match(_, [["(.+)" = "(.+)" = "(.+)"]])
        if doesFileExist(modpath..a) then
          id = id + 1
          local width, height = GetImageWidthHeight(modpath..a)
          if menu[c] == nil then mid = mid + 1 menu[c] = {order = mid} end
          table.insert(menu[c], {name = b, id = id})
          if cfg.spur.mode == 0 then
            table.insert(spur, {img = imgui.CreateTextureFromFile(modpath..a), path = modpath..a, name = b, width = width, height = height})
          else
            table.insert(spur, {img = "skip", path = modpath..a, name = b, width = width, height = height})
          end
        end
      end
      menuindex = {}
      for k in pairs(menu) do
        table.insert(menuindex, k)
      end
      table.sort(menuindex, function(a, b) return menu[a]["order"] < menu[b]["order"] end)
    end
    if cfg.spur.mode == 0 then

      if os.clock() - initsupdoctime > 5 then
        sampAddChatMessage("Загрузка шпор заняла "..math.ceil(os.clock() - initsupdoctime).." сек. Это много. Рекомендуется сменить режим в настройках.", color)
      else
        sampAddChatMessage("Загрузка текстур шпор заняла "..math.ceil(os.clock() - initsupdoctime).." сек.", color)
      end
    end
  end
end

function main_ImColorToHEX()
  local r, g, b, a = imgui.ImColor.FromFloat4(Qcolor.v[1], Qcolor.v[2], Qcolor.v[3], Qcolor.v[4]):GetRGBA()
  Qcolor_HEX = "0x"..string.sub(bit.tohex(join_argb(a, r, g, b)), 3, 8)

  local r, g, b, a = imgui.ImColor.FromFloat4(Acolor.v[1], Acolor.v[2], Acolor.v[3], Acolor.v[4]):GetRGBA()
  Acolor_HEX = "0x"..string.sub(bit.tohex(join_argb(a, r, g, b)), 3, 8)

  local r, g, b, a = imgui.ImColor.FromFloat4(Acolor1.v[1], Acolor1.v[2], Acolor1.v[3], Acolor1.v[4]):GetRGBA()
  Acolor1_HEX = "0x"..string.sub(bit.tohex(join_argb(a, r, g, b)), 3, 8)

  local r, g, b, a = imgui.ImColor.FromFloat4(SmsInColor.v[1], SmsInColor.v[2], SmsInColor.v[3], SmsInColor.v[4]):GetRGBA()
  SmsInColor_HEX = "0x"..string.sub(bit.tohex(join_argb(a, r, g, b)), 3, 8)

  local r, g, b, a = imgui.ImColor.FromFloat4(SmsOutColor.v[1], SmsOutColor.v[2], SmsOutColor.v[3], SmsOutColor.v[4]):GetRGBA()
  SmsOutColor_HEX = "0x"..string.sub(bit.tohex(join_argb(a, r, g, b)), 3, 8)

  local r, g, b, a = imgui.ImColor.FromFloat4(SmsReceivedColor.v[1], SmsReceivedColor.v[2], SmsReceivedColor.v[3], SmsReceivedColor.v[4]):GetRGBA()
  SmsReceivedColor_HEX = "0x"..string.sub(bit.tohex(join_argb(a, r, g, b)), 3, 8)

  inicfg.save(cfg, "support")
end

function main_copyright()
  local prefix = "[Support's Heaven]: "
  sampAddChatMessage(prefix.."Все системы готовы. Версия скрипта: "..thisScript().version..". Активация: /sup. Приятной игры, "..licensenick..".", 0xffa500)
end

function main_while_debug()
  if SSDB_trigger == true then if DEBUG then sampAddChatMessage("сохраняем", color) end imgui_messanger_sms_saveDB() SSDB_trigger = false end
end

function main_while_playsounds()
  if PLAYQ then
    PLAYQ = false
    a1 = loadAudioStream(getGameDirectory()..[[\moonloader\resource\sup\sounds\]]..iSoundQuestionNumber.v..[[.mp3]])
    if getAudioStreamState(a1) ~= as_action.PLAY then
      setAudioStreamState(a1, as_action.PLAY)
    end
  end
  if PLAYA1 then
    PLAYA1 = false
    a2 = loadAudioStream(getGameDirectory()..[[\moonloader\resource\sup\sounds\]]..iSoundAnswerOthersNumber.v..[[.mp3]])
    if getAudioStreamState(a2) ~= as_action.PLAY then
      setAudioStreamState(a2, as_action.PLAY)
    end
  end
  if PLAYA then
    PLAYA = false
    a3 = loadAudioStream(getGameDirectory()..[[\moonloader\resource\sup\sounds\]]..iSoundAnswerNumber.v..[[.mp3]])
    if getAudioStreamState(a3) ~= as_action.PLAY then
      setAudioStreamState(a3, as_action.PLAY)
    end
  end
  if PLAYSMSIN then
    PLAYSMSIN = false
    a4 = loadAudioStream(getGameDirectory()..[[\moonloader\resource\sup\sounds\]]..iSoundSmsInNumber.v..[[.mp3]])
    if getAudioStreamState(a4) ~= as_action.PLAY then
      setAudioStreamState(a4, as_action.PLAY)
    end
  end
  if PLAYSMSOUT then
    PLAYSMSOUT = false
    a5 = loadAudioStream(getGameDirectory()..[[\moonloader\resource\sup\sounds\]]..iSoundSmsOutNumber.v..[[.mp3]])
    if getAudioStreamState(a5) ~= as_action.PLAY then
      setAudioStreamState(a5, as_action.PLAY)
    end
  end
end

--симулируем саппорта
function DEBUG_simulateSupport(text)
  if mode == "samp-rp" then
    if not string.find(text, "недос") then
      tempid = math.random(1, 100)
      if sampIsPlayerConnected(tempid) then
        if math.random(1, 10) ~= 1 then
          if iSoundQuestion.v then PLAYQ = true end
          text = "->Вопрос "..sampGetPlayerNickname(tempid).."["..tempid.."]: "..text
          sampAddChatMessage(text, Qcolor_HEX)
          sup_AddQ(text)
        else
          if iSoundAnswerOthers.v then PLAYA1 = true end
          text = "<-FutureAdmin[228] to "..LASTNICK.."["..LASTID.."]: "..text
          sampAddChatMessage(text, Acolor1_HEX)
          sup_AddA(text)
        end
        if selecteddialogSDUTY == LASTNICK or selecteddialogSDUTY == sampGetPlayerNickname(tempid) then ScrollToDialogSDUTY = true end
      end
    end
  end
end

function DEBUG_simulateSupportAnswer(text)
  if mode == "samp-rp" then
    sampAddChatMessage(text, Acolor_HEX)
    sup_AddA(text)
  end
end

function DEBUG_toggle()
  cfg.options.debug = not cfg.options.debug
  DEBUG = cfg.options.debug
  if DEBUG then
    addOneOffSound(0.0, 0.0, 0.0, 1054)
  else
    addOneOffSound(0.0, 0.0, 0.0, 1055)
  end
  inicfg.save(cfg, "support")
end

function RPC_init()
  function RPC.onPlaySound(sound)
    if mode == "samp-rp" then
      if sound == 1052 and iSoundSmsOut.v then
        return false
      end
    end
  end

  function RPC.onServerMessage(color, text)
    if mode == "samp-rp" then
      if main_window_state.v and text:match(" "..tostring(selecteddialogSMS).." %[(%d+)%]") then
        if string.find(text, "AFK") then
          smsafk[selecteddialogSMS] = "AFK "..string.match(text, "AFK: (%d+) сек").." s"
        else
          smsafk[selecteddialogSMS] = "NOT AFK"
        end
        return false
      end
      if DEBUG then DEBUG_simulateSupport(text) end
      if text:find("SMS") then
        text = string.gsub(text, "{FFFF00}", "")
        text = string.gsub(text, "{FF8000}", "")
        local smsText, smsNick, smsId = string.match(text, "^ SMS%: (.*)%. Отправитель%: (.*)%[(%d+)%]")
        if smsText and smsNick and smsId then
          LASTID_SMS = smsId
          LASTNICK_SMS = smsNick
          if sms[smsNick] and sms[smsNick].Chat then

          else
            sms[smsNick] = {}
            sms[smsNick]["Chat"] = {}
            sms[smsNick]["Checked"] = 0
            sms[smsNick]["Pinned"] = 0
          end
          if sms[smsNick]["Blocked"] ~= nil and sms[smsNick]["Blocked"] == 1 then return false end
          if iSoundSmsIn.v then PLAYSMSIN = true end
          table.insert(sms[smsNick]["Chat"], {text = smsText, Nick = smsNick, type = "FROM", time = os.time()})
          if selecteddialogSMS == smsNick then ScrollToDialogSMS = true end
          SSDB_trigger = true
          if not iHideSmsIn.v then
            if iReplaceSmsInColor.v then
              sampAddChatMessage(text, SmsInColor_HEX)
              return false
            else
              --do nothing
            end
          else
            return false
          end
        end
        local smsText, smsNick, smsId = string.match(text, "^ SMS%: (.*)%. Получатель%: (.*)%[(%d+)%]")
        if smsText and smsNick and smsId then
          LASTID_SMS = smsId
          LASTNICK_SMS = smsNick
          if iSoundSmsOut.v then PLAYSMSOUT = true end
          local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
          if sms[smsNick] and sms[smsNick].Chat then

          else
            sms[smsNick] = {}
            sms[smsNick]["Chat"] = {}
            sms[smsNick]["Checked"] = 0
            sms[smsNick]["Pinned"] = 0
          end
          table.insert(sms[smsNick]["Chat"], {text = smsText, Nick = sampGetPlayerNickname(myid), type = "TO", time = os.time()})
          if selecteddialogSMS == smsNick then ScrollToDialogSMS = true end
          if sampIsPlayerConnected(smsId) then
            if sms ~= nil and sms[sampGetPlayerNickname(smsId)] ~= nil and sms[sampGetPlayerNickname(smsId)]["Checked"] ~= nil then
              sms[sampGetPlayerNickname(smsId)]["Checked"] = os.time()
            end
          end
          SSDB_trigger = true
          if not iHideSmsOut.v then
            if iReplaceSmsOutColor.v then
              sampAddChatMessage(text, SmsOutColor_HEX)
              return false
            else
              --do nothing
            end
          else
            return false
          end
        end
      end
      if text == " Сообщение доставлено" then
        if iHideSmsReceived.v then return false end
        if not iHideSmsReceived.v then
          if iReplaceSmsReceivedColor.v then
            sampAddChatMessage(text, SmsReceivedColor_HEX)
            return false
          else
            --do nothing
          end
        else
          return false
        end
      end
      if color == -5963521 then
        if text:find("->Вопрос", 1, true) then
          sup_AddQ(text)
          if iSoundQuestion.v then PLAYQ = true end
          if not iHideQuestion.v then
            if iReplaceQuestionColor.v then
              sampAddChatMessage(text, Qcolor_HEX)
              return false
            else
              --do nothing
            end
          else
            return false
          end
        end
        if text:find("<-", 1, true) and text:find("to", 1, true) then
          sup_AddA(text)
          SupportNick, SupportID, ClientNick, ClientID, Answer = string.match(text, "<%-(%a.+)%[(%d+)%] to ([%a_]+)%[(%d+)%]: (.+)")
          asdsadasads, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
          if SupportNick == sampGetPlayerNickname(myid) then
            if iSoundAnswer.v then PLAYA = true end
            if not iHideAnswer.v then
              if iReplaceAnswerColor.v then
                sampAddChatMessage(text, Acolor_HEX)
                return false
              else
                --do nothing
              end
            else
              return false
            end
          else
            if iSoundAnswerOthers.v then PLAYA1 = true end
            if not iHideAnswerOthers.v then
              if iReplaceAnswerOthersColor.v then
                sampAddChatMessage(text, Acolor1_HEX)
                return false
              else
                --do nothing
              end
            else
              return false
            end
          end
        end
      end
      if DEBUG then return false end
    end
  end
  --считаем активность саппорта
  function RPC.onSendCommand(text)
    if mode == "samp-rp" then
      if string.find(text, '/pm') then
        if text:match('/pm (%d+) $') then
          lua_thread.create(sup_FastRespond_via_dialog, text:match('/pm (%d+) $'))
          return false
        else
          if string.match(text, "(%d+) (.+)") then
            sup_logger_HostAnswer(text)
            if iSoundAnswer.v then PLAYA = true end
            id, text = string.match(text, "(%d+) (.+)")
            if sampIsPlayerConnected(id) then
              if iMessanger ~= nil and iMessanger[sampGetPlayerNickname(id)] ~= nil and iMessanger[sampGetPlayerNickname(id)]["Checked"] ~= nil then
                iMessanger[sampGetPlayerNickname(id)]["Checked"] = os.time()
              end
              if selecteddialogSDUTY == sampGetPlayerNickname(id) then ScrollToDialogSDUTY = true end
              if DEBUG then
                local _asdasd, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
                DEBUG_simulateSupportAnswer("<-"..sampGetPlayerNickname(myid).."["..myid.."]".." to "..sampGetPlayerNickname(id).."["..id.."]: "..text)
              end
              sup_AddA(text)
            end
          end
        end
      end
    end
  end

  function RPC.onDisplayGameText(style, time, text)
    if mode == "samp-rp" then
      if text:find("Welcome") then
        if cfg.supfuncs.autosduty then
          lua_thread.create(function() wait(1500) sampSendChat("/sduty") end)
        end
      end
    end
  end
end

function sup_AddQ(text)
  if mode == "samp-rp" then
    ClientNick, ClientID, Question = string.match(text, "->Вопрос ([%a_]+)%[(%d+)%]: (.+)")
    if ClientNick ~= nil and ClientID ~= nil and Question ~= nil then
      LASTID = ClientID
      LASTNICK = ClientNick
      if iMessanger[ClientNick] == nil then
        iMessanger[ClientNick] = {}
        iMessanger[ClientNick]["A"] = {}
        iMessanger[ClientNick]["Q"] = {{Nick = ClientNick, ID = ClientID, Question = Question, time = os.time()}}
        iMessanger[ClientNick]["Chat"] = {{Nick = ClientNick, type = "client", ID = ClientID, text = Question, time = os.time()}}
        iMessanger[ClientNick]["Checked"] = 0
      else
        table.insert(iMessanger[ClientNick]["Q"], {Nick = ClientNick, ID = ClientID, Question = Question, time = os.time()})
        table.insert(iMessanger[ClientNick]["Chat"], {Nick = ClientNick, type = "client", ID = ClientID, text = Question, time = os.time()})
      end
    end
  end
end

function sup_AddA(text)
  if mode == "samp-rp" then
    SupportNick, SupportID, ClientNick, ClientID, Answer = string.match(text, "<%-(%a.+)%[(%d+)%] to ([%a_]+)%[(%d+)%]: (.+)")
    if SupportNick ~= nil and SupportID ~= nil and ClientNick ~= nil and Answer ~= nil then
      if iMessanger[ClientNick] == nil then
        iMessanger[ClientNick] = {}
        iMessanger[ClientNick]["A"] = {{From = SupportNick, FromID = SupportID, To = ClientNick, ToID = ClientID, Answer = Answer, time = os.time()}}
        iMessanger[ClientNick]["Q"] = {}
        iMessanger[ClientNick]["Chat"] = {{Nick = SupportNick, type = "support", ID = SupportID, text = Answer, time = os.time()}}
        iMessanger[ClientNick]["Checked"] = 0
      else
        table.insert(iMessanger[ClientNick]["A"], {From = SupportNick, FromID = SupportID, To = ClientNick, ToID = ClientID, Answer = Answer, time = os.time()})
        table.insert(iMessanger[ClientNick]["Chat"], {Nick = SupportNick, type = "support", ID = SupportID, text = Answer, time = os.time()})
      end
    end
  end
end

function sup_logger_HostAnswer(text)
  if mode == "samp-rp" then
    if iLogBool.v then
      id, text = string.match(text, "(%d+) (.+)")
      pattern = [[\"\',]]
      if id ~= nil and tonumber(id) ~= nil and tonumber(id) <= sampGetMaxPlayerId() and sampIsPlayerConnected(id) and sampGetPlayerNickname(id) ~= nil then
        string = string.format("%s,%s,%s,%s,%s,%s,%s", sup_logger_autoincrement(), sampGetPlayerNickname(id), string.gsub(sup_getLastQuestion(sampGetPlayerNickname(id)), "["..pattern.."]", ""),
        string.gsub(text, "["..pattern.."]", ""), sup_getRespondTime(sampGetPlayerNickname(id), os.time()), os.date('%Y - %m - %d %X'), os.time())
        sup_logger_writecsv(file, string)
      end
    end
  end
end
--возвращает автоинкремент id'a в csv
function sup_logger_autoincrement()
  if doesFileExist(file) then
    ctr = 0
    for _ in io.lines(file) do
      ctr = ctr + 1
    end
    return ctr
  else
    return 1
  end
end
--отвечает за csv
function sup_logger_writecsv(file, string)
  if not doesFileExist(file) then
    f = io.open(file, "wb+")
    f:write("")
    f:close()
    sup_logger_writecsv(file, string)
  else
    f = io.open(file, "a")
    io.output(f)
    io.write(string.."\n")
    io.close(f)
  end
end

function sup_ParseHouseTxt_hh()
  if mode == "samp-rp" then
    local hhfile = getGameDirectory().."\\moonloader\\resource\\sup\\samp-rp\\house.txt"
    if doesFileExist(hhfile) then
      gethh = {}
      for line in io.lines(hhfile) do
        table.insert(gethh, line)
      end
    end
  end
end

function sup_ParseVehicleTxt_hc()
  if mode == "samp-rp" then
    local hcfile = getGameDirectory().."\\moonloader\\resource\\sup\\samp-rp\\vehicle.txt"
    if doesFileExist(hcfile) then
      gethc = {}
      for line in io.lines(hcfile) do
        table.insert(gethc, line)
      end
    end
  end
end

function sup_ParseFastRespond_fr()
  getfr = {}
  ftbasetext = string.gsub(cfg.notepad.fr, "\\n", "\n")
  for s in ftbasetext:gmatch("[^\n]+") do
    s = s:gsub("\\", "")
    number, text = string.match(s, "(%d+%.) (.+)")
    if number ~= 0 and text ~= 0 then
      table.insert(getfr, text)
    end
  end
end

function sup_FastRespond_via_chat()
  if cfg.supfuncs.fastrespondviachat then
    if LASTID ~= -1 then
      if sampIsPlayerConnected(LASTID) and sampGetPlayerNickname(LASTID) == LASTNICK then
        sampSetChatInputEnabled(true)
        if mode == "samp-rp" then sampSetChatInputText("/pm "..LASTID.." ") end
      else
        sampAddChatMessage("Ошибка: игрок, задавший вопрос, отключился.", color)
      end
    end
  end
end

function sup_FastRespond_via_dialog_LASTID()
  if cfg.supfuncs.fastrespondviadialoglastid then
    lua_thread.create(sup_FastRespond_via_dialog, LASTID, true)
  end
end

function sup_FastRespond_via_dialog(param, mod)
  if cfg.supfuncs.fastrespondviadialog or mod then
    if tonumber(param) ~= nil then
      id = tonumber(param)
      if sampIsPlayerConnected(id) then
        if getfr == {} then
          sampShowDialog(8320, "{D2D2D2}Ответ для "..sampGetPlayerNickname(id).."["..id.."]", "База быстрых ответов пуста.\nПополнить базу можно в настройках.", "Ясно.")
        else
          FRtext_D = "{FFD700}Вопрос{40E0D0}:{FF9D00} "..sup_getLastQuestion(sampGetPlayerNickname(id)).."\n\n"
          for k, v in pairs(getfr) do
            FRtext_D = FRtext_D..string.format("{FFD700}%s {40E0D0}- {FF9D00}%s", k, v).."\n"
          end
          sampShowDialog(8320, "{D2D2D2}Ответ для "..sampGetPlayerNickname(id).."["..id.."]", FRtext_D, "Выбрать", "", 1)
          while sampIsDialogActive() do wait(0) end
          local result, button, list, input = sampHasDialogRespond(8320)
          if button == 1 then
            FRnumber_D = sampGetCurrentDialogEditboxText(8320)
            if tonumber(FRnumber_D) ~= nil and getfr[tonumber(FRnumber_D)] ~= nil then
              if mode == "samp-rp" then sampSendChat("/pm "..id.." "..getfr[tonumber(FRnumber_D)]) end
            end
          end
        end
      else
        sampAddChatMessage("Ошибка: игрок с заданным id оффлайн.", color)
      end
    end
  end
end

function sup_UnAnswered_via_samp_dialog()
  if mode == "samp-rp" then
    if cfg.supfuncs.unanswereddialog then
      if main_window_state.v then main_window_state.v = false end
      local UNANindex = {}
      for k in pairs(iMessanger) do
        if #iMessanger[k]["A"] == 0 then table.insert(UNANindex, k) end
      end
      table.sort(UNANindex, function(a, b) return iMessanger[a]["Chat"][#iMessanger[a]["Chat"]]["time"] < iMessanger[b]["Chat"][#iMessanger[b]["Chat"]]["time"] end)
      UNANi = 1
      UNANtext = ""
      UNANbase = {}
      for k, v in pairs(UNANindex) do
        for i = 0, sampGetMaxPlayerId() + 1 do
          if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == v then
            UNANsec = math.fmod(os.time() - iMessanger[v]["Chat"][#iMessanger[v]["Chat"]]["time"], 60)
            if UNANsec < 10 then UNANsec = "0"..UNANsec end
            UNANmin = math.floor((os.time() - iMessanger[v]["Chat"][#iMessanger[v]["Chat"]]["time"]) / 60)
            UNANtext = UNANtext..string.format("{FFD700}%s {40E0D0}- {ADD8E6}[%s:%s] %s[%s]: {FF9D00}%s", UNANi, UNANmin, UNANsec, v, i, iMessanger[v]["Chat"][#iMessanger[v]["Chat"]]["text"]).."\n"
            UNANbase[UNANi] = i
            UNANi = UNANi + 1
            break
          else
            if i == sampGetMaxPlayerId() + 1 then
              break
            end
          end
        end
      end
      if UNANtext == "" then
        sampShowDialog(9899, "{D2D2D2}Вопросы без ответа", "Таких нет.", "Ясно.")
      else
        sampShowDialog(9899, "{D2D2D2}Вопросы без ответа (номер/номер ответ)", UNANtext, "Выбрать", "", 1)
        while sampIsDialogActive() do wait(0) end
        local result, button, list, input = sampHasDialogRespond(9899)
        if button == 1 then
          UNANanswer = sampGetCurrentDialogEditboxText(9899)
          if string.find(UNANanswer, "(%d+) (.+)") then
            UNID, UNANanswe = string.match(UNANanswer, "(%d+) (.+)")
            UNANid = string.match(string.gsub(UNANtext, "{......}", ""), "%[(%d+)%]")
            UNANid = string.match(UNANtext, UNID.." - .+%[(%d+)%].+\n")
            if UNANid ~= nil and sampIsPlayerConnected(UNANid) then
              if mode == "samp-rp" then sampSendChat("/pm "..tonumber(UNANid).." "..UNANanswe) end
            end
          else
            if tonumber(UNANanswer) ~= nil then
              UNANanswer = tonumber(UNANanswer)
              if UNANanswer ~= nil and UNANbase[UNANanswer] ~= nil then
                UNANid = UNANbase[UNANanswer]
                if sampIsPlayerConnected(UNANid) then
                  sampSetChatInputEnabled(true)
                  if mode == "samp-rp" then sampSetChatInputText("/pm "..UNANid.." ") end
                end
              end
            end
          end
        end
      end
    end
  end
end

function sup_getLastQuestion(nick)
  if iMessanger[nick] ~= nil and iMessanger[nick]["Q"] ~= nil and iMessanger[nick]["Q"][#iMessanger[nick]["Q"]] ~= nil and iMessanger[nick]["Q"][#iMessanger[nick]["Q"]]["Question"] ~= nil then
    return iMessanger[nick]["Q"][#iMessanger[nick]["Q"]]["Question"]
  else
    return "-"
  end
end

function sup_getRespondTime(nick, timestamp)
  if iMessanger[nick] ~= nil and iMessanger[nick]["Q"] ~= nil and iMessanger[nick]["Q"][#iMessanger[nick]["Q"]] ~= nil and iMessanger[nick]["Q"][#iMessanger[nick]["Q"]]["time"] ~= nil then
    return tostring(timestamp - tonumber(iMessanger[nick]["Q"][#iMessanger[nick]["Q"]]["time"]))
  else
    return "-"
  end
end

function sup_updateStats()
  if iLogBool.v then
    local a = os.clock()
    if not doesFileExist(file) then
      f = io.open(file, "wb+")
      f:write("")
      f:close()
    else
      csv = {}
      csvall = {}
      countall = 0
      for _ in io.lines(file) do
        CSV_id, CSV_nickname, CSV_vopros, CSV_otvet, CSV_respondtime, CSV_dateandtime, CSV_unix = string.match(_, "(.+),(.+),(.+),(.+),(.+),(.+),(.+)")
        if tonumber(CSV_unix) ~= nil then
          countall = countall + 1
          CSV_unix = tonumber(CSV_unix)
          CSV_year = os.date("%Y", CSV_unix)
          if os.date('%H', CSV_unix) == "00" or os.date('%H', CSV_unix) == "01" or os.date('%H', CSV_unix) == '02' or os.date('%H', CSV_unix) == "03" or os.date('%H', CSV_unix) == "04" then
            date = os.date("%x", CSV_unix - (tonumber(os.date("%H", CSV_unix) + 1) * 3600))
          else
            date = os.date("%x", CSV_unix)
          end
          if csv[date] == nil then csv[date] = 0 end
          csv[date] = csv[date] + 1
          if csvall[date] == nil then csvall[date] = {} end
          table.insert(csvall[date], _)
          checkyear = false
          for i = 0, #iYears do
            if CSV_year == iYears[i] then checkyear = true end
          end
          if checkyear == false then
            table.insert(iYears, CSV_year)
          end
        end
      end
      table.sort(iYears, function(a, b) return a > b end)
    end
    if iShowTimeToUpdateCSV.v then
      printStringNow(os.clock() - a.." sec.", 2000)
    end
  end
end

function imgui_init()
  function imgui.OnDrawFrame()
    imgui_main()
    imgui_spur()
  end
end

function imgui_main()
  if main_window_state.v then
    imgui.SetNextWindowPos(imgui.ImVec2(cfg.menuwindow.PosX, cfg.menuwindow.PosY), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(cfg.menuwindow.Width, cfg.menuwindow.Height))
    if cfg.only.messanger or cfg.only.notepad or cfg.only.logviewer or cfg.only.histogram or cfg.only.settings or cfg.only.counter or cfg.only.info then
      beginflags = imgui.WindowFlags.NoCollapse + imgui.WindowFlags.MenuBar
    else
      beginflags = imgui.WindowFlags.NoCollapse
    end
    imgui.Begin(u8:encode(thisScript().name.." v"..thisScript().version), main_window_state, beginflags)
    imgui_saveposandsize()
    if not cfg.only.messanger and not cfg.only.notepad and not cfg.only.logviewer and not cfg.only.histogram and not cfg.only.counter and not cfg.only.settings and not cfg.only.info then
      if cfg.messanger.activesduty or cfg.messanger.activesms then imgui_messanger() end
      if cfg.notepad.active then imgui_notepad() end
      if cfg.log.active then imgui_log() end
      if cfg.stats.active then imgui_histogram() end
      if cfg.counter.active then imgui_counter() end
      imgui_info()
      imgui_settings()
    else
      if cfg.only.messanger then if cfg.messanger.activesduty or cfg.messanger.activesms then imgui_messanger() end end
      if cfg.only.notepad then if cfg.notepad.active then imgui_notepad() end end
      if cfg.only.logviewer then if cfg.log.active then imgui_log() end end
      if cfg.only.histogram then if cfg.stats.active then imgui_histogram() end end
      if cfg.only.counter and cfg.counter.active then imgui_counter() end
      if cfg.only.info then imgui_info() end
      if cfg.only.settings then imgui_settings() end
    end
    imgui.End()
  end
end

function imgui_spur()
  if spur_windows_state.v and cfg.spur.active then
    imgui.SetNextWindowPos(imgui.ImVec2(cfg.spur.PosX, cfg.spur.PosY), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(cfg.spur.Width, cfg.spur.Height), imgui.Cond.FirstUseEver)
    if cfg.spur.autoresize then
      flagsSpur = imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.MenuBar + imgui.WindowFlags.HorizontalScrollbar
    else
      flagsSpur = imgui.WindowFlags.MenuBar + imgui.WindowFlags.HorizontalScrollbar
    end
    imgui.Begin("Spur mode: "..mode, spur_windows_state, flagsSpur)
    imgui_saveposandsize2()
    imgui.BeginMenuBar()
    for k, v in pairs(menuindex) do
      if imgui.BeginMenu(u8:encode(v)) then
        for z, i in ipairs(menu[v]) do
          if imgui.MenuItem(u8:encode(i["name"])) then
            spurtab = i["id"]
            if cfg.spur.mode == 2 then
              if spur[cfg.spur.tab]["img"] ~= "skip" then
                imgui.ReleaseTexture(spur[cfg.spur.tab]["img"])
                spur[cfg.spur.tab]["img"] = "skip"
              end
            end
            cfg.spur.tab = i["id"]
            inicfg.save(cfg, "support")
          end
        end
        imgui.EndMenu()
      end
    end
    if imgui.BeginMenu(u8"Настройки") then
      if imgui.MenuItem(u8"Авторесайз", nil, cfg.spur.autoresize) then
        cfg.spur.autoresize = not cfg.spur.autoresize
        inicfg.save(cfg, "support")
      end
      if imgui.MenuItem(u8"Сохранять пропорции при ресайзе", nil, cfg.spur.proportion) then
        cfg.spur.proportion = not cfg.spur.proportion
        inicfg.save(cfg, "support")
      end
      if not cfg.spur.lupa then
        if imgui.MenuItem(u8"Лупа", nil, cfg.spur.lupa) then
          cfg.spur.lupa = not cfg.spur.lupa
          inicfg.save(cfg, "support")
        end
      else
        if imgui.BeginMenu(u8"Лупа") then
          if imgui.MenuItem(u8"Лупа", nil, cfg.spur.lupa) then
            cfg.spur.lupa = not cfg.spur.lupa
            inicfg.save(cfg, "support")
          end
          if imgui.MenuItem(u8"Только в сжатых", nil, cfg.spur.onlyresized) then
            cfg.spur.onlyresized = not cfg.spur.onlyresized
            inicfg.save(cfg, "support")
          end
          imgui.EndMenu()
        end
      end
      imgui.EndMenu()
    end
    imgui.EndMenuBar()
    if spurtab ~= nil and spur[spurtab] ~= nil then
      if spur[spurtab]["img"] == "skip" then spur[spurtab]["img"] = imgui.CreateTextureFromFile(spur[spurtab]["path"]) end
      local width, height = spur[spurtab]["width"], spur[spurtab]["height"]
      if not cfg.spur.autoresize and cfg.spur.proportion and width > imgui.GetContentRegionAvailWidth() then
        width = imgui.GetContentRegionAvailWidth() - imgui.GetStyle().ScrollbarSize
        height = spur[spurtab]["height"] / spur[spurtab]["width"] * (imgui.GetContentRegionAvailWidth() - imgui.GetStyle().ScrollbarSize)
      end
      imgui.Image(spur[spurtab]["img"], imgui.ImVec2(width, height))
      pos = imgui.GetCursorScreenPos()
      if cfg.spur.lupa and imgui.IsItemHovered() then
        if spur[spurtab]["width"] > (imgui.GetContentRegionAvailWidth() - imgui.GetStyle().ScrollbarSize) or not cfg.spur.onlyresized then
          my_tex_h = height
          my_tex_w = width
          imgui.BeginTooltip()
          local region_sz = 64
          local region_x = imgui.GetIO().MousePos.x - pos.x - region_sz * 0.5
          if region_x < 0.0 then
            region_x = 0.0
          elseif region_x > my_tex_w - region_sz then
            region_x = my_tex_w - region_sz
          end
          local region_y = my_tex_h - ( imgui.GetIO().MousePos.y - pos.y - region_sz * 0.5) * - 1
          if region_y < 0.0 then
            region_y = 0.0
          elseif region_y > my_tex_h - region_sz then
            region_y = my_tex_h - region_sz
          end
          local zoom = 2.0
          uv0 = imgui.ImVec2((region_x) / my_tex_w, (region_y) / my_tex_h)
          uv1 = imgui.ImVec2((region_x + region_sz) / my_tex_w, (region_y + region_sz) / my_tex_h)
          imgui.Image(spur[spurtab]["img"], imgui.ImVec2(region_sz * zoom, region_sz * zoom), uv0, uv1, imgui.ImColor(255, 255, 255, 255), imgui.ImColor(255, 255, 255, 128))
          imgui.EndTooltip()
        end
      end
    end
    imgui.End()
  end
end

function imgui_menu()
  imgui.BeginMenuBar()
  if imgui.MenuItem(u8'В меню') then
    cfg.only.messanger = false
    cfg.only.notepad = false
    cfg.only.logviewer = false
    cfg.only.histogram = false
    cfg.only.settings = false
    cfg.only.counter = false
    cfg.only.info = false
    inicfg.save(cfg, "support")
  end
  imgui.EndMenuBar()
end

function imgui_saveposandsize()
  if cfg.menuwindow.Width ~= imgui.GetWindowWidth() or cfg.menuwindow.Height ~= imgui.GetWindowHeight() then
    cfg.menuwindow.Width = imgui.GetWindowWidth()
    cfg.menuwindow.Height = imgui.GetWindowHeight()
    inicfg.save(cfg, "support")
  end
  if cfg.menuwindow.PosX ~= imgui.GetWindowPos().x or cfg.menuwindow.PosY ~= imgui.GetWindowPos().y then
    cfg.menuwindow.PosX = imgui.GetWindowPos().x
    cfg.menuwindow.PosY = imgui.GetWindowPos().y
    inicfg.save(cfg, "support")
  end
end

function imgui_saveposandsize2()
  if cfg.spur.Width ~= imgui.GetWindowWidth() or cfg.spur.Height ~= imgui.GetWindowHeight() then
    cfg.spur.Width = imgui.GetWindowWidth()
    cfg.spur.Height = imgui.GetWindowHeight()
    inicfg.save(cfg, "support")
  end
  if cfg.spur.PosX ~= imgui.GetWindowPos().x or cfg.spur.PosY ~= imgui.GetWindowPos().y then
    cfg.spur.PosX = imgui.GetWindowPos().x
    cfg.spur.PosY = imgui.GetWindowPos().y
    inicfg.save(cfg, "support")
  end
end

function imgui_messanger()
  if not cfg.only.messanger then
    ch1 = imgui.CollapsingHeader(u8"Мессенджер")
    if ch1 then
      imgui_messanger_rightclick()
      imgui_messanger_content()
    end
    imgui.Columns(1)
    if not ch1 then imgui_messanger_rightclick() end
  else
    imgui_menu()
    imgui_messanger_content()
  end
end

function imgui_messanger_scrollkostil()
  while true do
    wait(0)
    if scroll then
      wait(100)
      scroll = false
    end
  end
end

function imgui_messanger_FO(mode)
  --mode = 1 => открыть sup
  --mode = 2 => открыть sup на последнем вопросе
  --mode = 3 => открыть sms
  --mode = 4 => открыть смс на последней смс
  --mode = 5 => открыть смс на создании диалога
  if mode == 1 then
    if not cfg.only.messanger then
      main_window_state.v = true
    elseif cfg.messanger.mode == 2 then
      cfg.messanger.mode = 1
    else
      main_window_state.v = not main_window_state.v
    end
    if cfg.messanger.activesduty and cfg.messanger.hotkey1 then
      cfg.only.messanger = true
      cfg.messanger.mode = 1
      cfg.only.notepad = false
      cfg.only.logviewer = false
      cfg.only.histogram = false
      cfg.only.settings = false
      cfg.only.counter = false
      inicfg.save(cfg, "support")
    end
  end
  if mode == 2 then
    if not cfg.only.messanger then
      main_window_state.v = true
    elseif cfg.messanger.mode == 2 then
      cfg.messanger.mode = 1
    elseif selecteddialogSDUTY ~= LASTNICK then
      --do nothing
      if not main_window_state.v then main_window_state.v = true end
    else
      main_window_state.v = not main_window_state.v
    end
    if cfg.messanger.activesduty and cfg.messanger.hotkey2 then
      cfg.only.messanger = true
      if sampIsPlayerConnected(LASTID) and sampGetPlayerNickname(LASTID) == LASTNICK then
        online = "Онлайн"
      else
        online = "Оффлайн"
      end
      selecteddialogSDUTY = LASTNICK
      if not isCharInAnyCar(playerPed) then keyboard = true end
      cfg.messanger.mode = 1
      cfg.only.notepad = false
      cfg.only.logviewer = false
      ScrollToDialogSDUTY = true
      cfg.only.histogram = false
      cfg.only.settings = false
      cfg.only.counter = false
      inicfg.save(cfg, "support")
    end
  end
  if mode == 3 then
    if not cfg.only.messanger then
      main_window_state.v = true
    elseif cfg.messanger.mode == 1 then
      cfg.messanger.mode = 2
    else
      main_window_state.v = not main_window_state.v
    end
    if cfg.messanger.activesms and cfg.messanger.hotkey3 then
      cfg.only.messanger = true
      cfg.messanger.mode = 2
      cfg.only.notepad = false
      cfg.only.logviewer = false
      cfg.only.histogram = false
      cfg.only.counter = false
      cfg.only.settings = false
      inicfg.save(cfg, "support")
    end
  end
  if mode == 4 then
    if LASTNICK_SMS == " " then
      sampAddChatMessage("Ошибка: вам/вы ещё не писали смс.", color)
    else
      if not cfg.only.messanger then
        main_window_state.v = true
      elseif cfg.messanger.mode == 1 then
        cfg.messanger.mode = 2
      elseif selecteddialogSMS ~= LASTNICK_SMS then
        --do nothing
        if not main_window_state.v then main_window_state.v = true end
      else
        main_window_state.v = not main_window_state.v
      end
      if cfg.messanger.activesms and cfg.messanger.hotkey4 then
        cfg.only.messanger = true
        if sampIsPlayerConnected(LASTID_SMS) and sampGetPlayerNickname(LASTID_SMS) == LASTNICK_SMS then
          online = "Онлайн"
        else
          online = "Оффлайн"
        end
        selecteddialogSMS = LASTNICK_SMS
        smsafk[selecteddialogSMS] = "CHECK AFK"
        if not isCharInAnyCar(playerPed) then keyboard = true end
        cfg.messanger.mode = 2
        cfg.only.notepad = false
        ScrollToDialogSMS = true
        cfg.only.logviewer = false
        cfg.only.histogram = false
        cfg.only.counter = false
        cfg.only.settings = false
        inicfg.save(cfg, "support")
      end
    end
  end
  if mode == 5 then
    if not cfg.only.messanger then
      main_window_state.v = true
    elseif cfg.messanger.mode == 1 then
      cfg.messanger.mode = 2
    else
      main_window_state.v = not main_window_state.v
    end
    if cfg.messanger.activesms and cfg.messanger.hotkey5 then
      cfg.only.messanger = true
      iAddSMS = true
      if not isCharInAnyCar(playerPed) then KeyboardFocusResetForNewDialog = true end
      cfg.messanger.mode = 2
      cfg.only.notepad = false
      cfg.only.counter = false
      cfg.only.logviewer = false
      cfg.only.histogram = false
      cfg.only.settings = false
      inicfg.save(cfg, "support")
    end
  end
end

function imgui_messanger_content()
  imgui.Columns(2, nil, false)
  imgui.SetColumnWidth(-1, 200)
  if cfg.messanger.mode == 1 then imgui_messanger_sup_settings() end
  if cfg.messanger.mode == 2 then imgui_messanger_sms_settings() end
  if cfg.messanger.mode == 1 then imgui_messanger_sup_player_list() end
  if cfg.messanger.mode == 2 then imgui_messanger_sms_player_list() end
  if cfg.messanger.activesduty and cfg.messanger.activesms then imgui_messanger_switchmode() end
  imgui.NextColumn()
  if cfg.messanger.mode == 1 then imgui_messanger_sup_header() end
  if cfg.messanger.mode == 2 then imgui_messanger_sms_header() end
  if cfg.messanger.mode == 1 then imgui_messanger_sup_dialog() end
  if cfg.messanger.mode == 2 then imgui_messanger_sms_dialog() end
  if cfg.messanger.mode == 1 then imgui_messanger_sup_keyboard() end
  if cfg.messanger.mode == 2 then imgui_messanger_sms_keyboard() end
  imgui.Columns(1)
end

function imgui_messanger_rightclick()
  if imgui.IsItemHovered(imgui.HoveredFlags.RootWindow) and imgui.IsMouseClicked(1) then
    cfg.only.messanger = true
    inicfg.save(cfg, "support")
  end
end

function imgui_messanger_sup_settings()
  imgui.BeginChild("##settings", imgui.ImVec2(192, 35), true)
  imgui.SameLine(6)
  imgui.Text("")
  imgui.SameLine()
  if imgui.Checkbox("##ShowSHOWOFFLINE", iShowSHOWOFFLINESDUTY) then
    cfg.messanger.iShowSHOWOFFLINESDUTY = iShowSHOWOFFLINESDUTY.v
    inicfg.save(cfg, "support")
  end
  if imgui.IsItemHovered() then
    imgui.SetTooltip(u8"Показывать оффлайн игроков?")
  end
  imgui.SameLine()
  if imgui.Checkbox("##ShowUA", iShowUA1) then
    cfg.messanger.iShowUA1 = iShowUA1.v
    inicfg.save(cfg, "support")
  end
  if imgui.IsItemHovered() then
    imgui.SetTooltip(u8"Показывать неотвеченные и непросмотренные?")
  end
  imgui.SameLine()
  if imgui.Checkbox("##ShowUA_V", iShowUA2) then
    cfg.messanger.iShowUA2 = iShowUA2.v
    inicfg.save(cfg, "support")
  end
  if imgui.IsItemHovered() then
    imgui.SetTooltip(u8"Показывать неотвеченные и просмотренные?")
  end
  imgui.SameLine()
  if imgui.Checkbox("##ShowA_V", iShowA1) then
    cfg.messanger.iShowA1 = iShowA1.v
    inicfg.save(cfg, "support")
  end
  if imgui.IsItemHovered() then
    imgui.SetTooltip(u8"Показывать отвеченные и непросмотренные?")
  end
  imgui.SameLine()
  if imgui.Checkbox("##ShowA_NV", iShowA2) then
    cfg.messanger.iShowA2 = iShowA2.v
    inicfg.save(cfg, "support")
  end
  if imgui.IsItemHovered() then
    imgui.SetTooltip(u8"Показывать отвеченные и просмотренные?")
  end
  imgui.SameLine()
  if imgui.Checkbox("##iSetKeyboard", iSetKeyboard) then
    cfg.messanger.iSetKeyboard = iSetKeyboard.v
    inicfg.save(cfg, "support")
  end
  if imgui.IsItemHovered() then
    imgui.SetTooltip(u8"Курсор на ввод текста при выборе диалога?")
  end
  imgui.SameLine()
  if imgui.Checkbox("##iChangeScroll", iChangeScroll) then
    cfg.messanger.iChangeScroll = iChangeScroll.v
    inicfg.save(cfg, "support")
  end
  if imgui.IsItemHovered() then
    imgui.SetTooltip(u8"Менять позицию скролла в списке диалогов при выборе диалога?")
  end
  imgui.EndChild()
end

function imgui_messanger_sms_settings()
  imgui.BeginChild("##settings", imgui.ImVec2(192, 35), true)
  imgui.SameLine(6)
  imgui.Text("")
  imgui.SameLine()
  imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.16, 0.29, 0.48, 0.54))
  if not iAddSMS then
    if imgui.Checkbox("##ShowSHO2WOFFLINE", iShowSHOWOFFLINESMS) then
      cfg.messanger.iShowSHOWOFFLINESMS = iShowSHOWOFFLINESMS.v
      inicfg.save(cfg, "support")
    end
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8"Показывать оффлайн игроков?")
    end
    imgui.SameLine()
    if imgui.Checkbox("##SMSFILTER", iSMSfilterBool) then
      cfg.messanger.iSMSfilterBool = iSMSfilterBool.v
      inicfg.save(cfg, "support")
    end
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8"Включить фильтр по нику?")
    end
    if iSMSfilterBool.v then
      imgui.SameLine()
      if imgui.InputText("##keyboardSMSFILTER", iSMSfilter) then
        cfg.messanger.smsfiltertext = iSMSfilter.v
        inicfg.save(cfg, "support")
      end
    end
    if not iSMSfilterBool.v then
      imgui.SameLine()
      if imgui.Checkbox("##iSetKeyboardSMS", iSetKeyboardSMS) then
        cfg.messanger.iSetKeyboardSMS = iSetKeyboardSMS.v
        inicfg.save(cfg, "support")
      end
      if imgui.IsItemHovered() then
        imgui.SetTooltip(u8"Курсор на ввод текста при выборе диалога?")
      end
      imgui.SameLine()
      if imgui.Checkbox("##iChangeScrollSMS", iChangeScrollSMS) then
        cfg.messanger.iChangeScrollSMS = iChangeScrollSMS.v
        inicfg.save(cfg, "support")
      end
      if imgui.IsItemHovered() then
        imgui.SetTooltip(u8"Менять позицию скролла в списке диалогов при выборе диалога?")
      end
      imgui.SameLine()
      if imgui.Button(u8"Добавить", imgui.ImVec2(imgui.GetContentRegionAvailWidth() + 1, 20)) then
        iAddSMS = true
        KeyboardFocusResetForNewDialog = true
      end
    end
  else
    if imgui.InputText("##keyboardSMADD", iSMSAddDialog, imgui.InputTextFlags.EnterReturnsTrue) then
      createnewdialognick = iSMSAddDialog.v
      if iSMSAddDialog.v == "" then
        iAddSMS = false
        lockPlayerControl(false)
      else
        iSMSAddDialog.v = ""
        for i = 0, sampGetMaxPlayerId() + 1 do
          if sampIsPlayerConnected(i) and i == tonumber(createnewdialognick) or sampIsPlayerConnected(i) and string.find(string.rlower(sampGetPlayerNickname(i)), string.rlower(createnewdialognick)) then
            if sms[sampGetPlayerNickname(i)] == nil then
              sms[sampGetPlayerNickname(i)] = {}
              sms[sampGetPlayerNickname(i)]["Chat"] = {}
              sms[sampGetPlayerNickname(i)]["Checked"] = 0
              sms[sampGetPlayerNickname(i)]["Pinned"] = 0
              iAddSMS = false
              table.insert(sms[sampGetPlayerNickname(i)]["Chat"], {text = "Диалог создан", Nick = "мессенджер", type = "service", time = os.time()})
              selecteddialogSMS = sampGetPlayerNickname(i)
              SSDB_trigger = true
              ScrollToDialogSMS = true
              break
            else
              selecteddialogSMS = sampGetPlayerNickname(i)
              iAddSMS = false
              ScrollToDialogSMS = true
              break
            end
          end
        end
      end
    end
    if imgui.IsKeyPressed(key.VK_ESCAPE) then
      iSMSAddDialog.v = ""
      iAddSMS = false
      lockPlayerControl(false)
    end
    if KeyboardFocusResetForNewDialog then imgui.SetKeyboardFocusHere() lockPlayerControl(true) KeyboardFocusResetForNewDialog = false end
    if iSMSAddDialog.v ~= "" then
      for i = 0, sampGetMaxPlayerId() do
        if sampIsPlayerConnected(i) and i == tonumber(iSMSAddDialog.v) or sampIsPlayerConnected(i) and string.find(string.rlower(sampGetPlayerNickname(i)), string.rlower(iSMSAddDialog.v)) then
          imgui.SetTooltip(u8:encode(sampGetPlayerNickname(i).."["..i.."]"))
          break
        end
      end
    end
    imgui.SameLine()
    if imgui.Button(u8"close", imgui.ImVec2(imgui.GetContentRegionAvailWidth(), 20)) then
      iSMSAddDialog.v = ""
      iAddSMS = false
      lockPlayerControl(false)
    end
  end
  imgui.PopStyleColor()
  imgui.EndChild()
end

function imgui_messanger_sms_player_list()
  if cfg.messanger.activesduty and cfg.messanger.activesms then
    if cfg.only.messanger then
      playerlistY = imgui.GetContentRegionAvail().y - 35
    else
      playerlistY = iMessangerHeight.v - 35
    end
  else
    if cfg.only.messanger then
      playerlistY = imgui.GetContentRegionAvail().y + 4
    else
      playerlistY = iMessangerHeight.v + 4
    end
  end
  imgui.BeginChild("список ников", imgui.ImVec2(192, playerlistY), true)
  smsindex_PINNED = {}
  smsindex_PINNEDVIEWED = {}
  smsindex_NEW = {}
  smsindex_NEWVIEWED = {}
  for k in pairs(sms) do
    if cfg.messanger.iSMSfilterBool and cfg.messanger.smsfiltertext ~= nil then
      if cfg.messanger.smsfiltertext ~= "" then
        if string.find(string.rlower(k), string.rlower(cfg.messanger.smsfiltertext)) ~= nil then
          imgui_messanger_sms_player_list_filter(k)
        end
      else
        imgui_messanger_sms_player_list_filter(k)
      end
    else
      imgui_messanger_sms_player_list_filter(k)
    end
  end
  table.sort(smsindex_PINNED, function(a, b) return sms[a]["Chat"][#sms[a]["Chat"]]["time"] > sms[b]["Chat"][#sms[b]["Chat"]]["time"] end)
  table.sort(smsindex_PINNEDVIEWED, function(a, b) return sms[a]["Chat"][#sms[a]["Chat"]]["time"] > sms[b]["Chat"][#sms[b]["Chat"]]["time"] end)
  table.sort(smsindex_NEW, function(a, b) return sms[a]["Chat"][#sms[a]["Chat"]]["time"] > sms[b]["Chat"][#sms[b]["Chat"]]["time"] end)
  table.sort(smsindex_NEWVIEWED, function(a, b) return sms[a]["Chat"][#sms[a]["Chat"]]["time"] > sms[b]["Chat"][#sms[b]["Chat"]]["time"] end)
  imgui_messanger_sms_showdialogs(smsindex_PINNED, "Pinned")
  imgui_messanger_sms_showdialogs(smsindex_PINNEDVIEWED, "Pinned")
  imgui_messanger_sms_showdialogs(smsindex_NEW, "NotPinned")
  imgui_messanger_sms_showdialogs(smsindex_NEWVIEWED, "NotPinned")
  imgui.EndChild()
end

function imgui_messanger_sms_player_list_filter(k)
  if sms[k]["Pinned"] ~= nil and sms[k]["Chat"] ~= nil and sms[k]["Checked"] then
    if sms[k]["Pinned"] == 1 then
      kolvo = 0
      if #sms[k]["Chat"] ~= 0 then
        for i, z in pairs(sms[k]["Chat"]) do
          if z["type"] == "FROM" and z["time"] > sms[k]["Checked"] then
            kolvo = kolvo + 1
          end
        end
      end
      if kolvo > 0 then
        table.insert(smsindex_PINNED, k)
      else
        table.insert(smsindex_PINNEDVIEWED, k)
      end
    else
      kolvo = 0
      if #sms[k]["Chat"] ~= 0 then
        for i, z in pairs(sms[k]["Chat"]) do
          if z["type"] == "FROM" and z["time"] > sms[k]["Checked"] then
            kolvo = kolvo + 1
          end
        end
      end
      if kolvo > 0 then
        table.insert(smsindex_NEW, k)
      else
        table.insert(smsindex_NEWVIEWED, k)
      end
    end
  end
end

function imgui_messanger_sup_player_list()
  if cfg.messanger.activesduty and cfg.messanger.activesms then
    if cfg.only.messanger then
      playerlistY = imgui.GetContentRegionAvail().y - 35
    else
      playerlistY = iMessangerHeight.v - 35
    end
  else
    if cfg.only.messanger then
      playerlistY = imgui.GetContentRegionAvail().y + 4
    else
      playerlistY = iMessangerHeight.v + 4
    end
  end
  imgui.BeginChild("список ников", imgui.ImVec2(192, playerlistY), true)
  chatindex_V = {}
  chatindex_NV = {}
  chatindexNEW = {}
  chatindexNEW_V = {}
  for k in pairs(iMessanger) do
    if #iMessanger[k]["A"] == 0 then
      kolvo = 0
      if #iMessanger[k]["Chat"] ~= 0 then
        for i, z in pairs(iMessanger[k]["Chat"]) do
          if z["type"] ~= "support" and z["time"] > iMessanger[k]["Checked"] then
            kolvo = kolvo + 1
          end
        end
      end
      if kolvo > 0 then
        table.insert(chatindexNEW, k)
      else
        table.insert(chatindexNEW_V, k)
      end
    else
      kolvo = 0
      if #iMessanger[k]["Chat"] ~= 0 then
        for i, z in pairs(iMessanger[k]["Chat"]) do
          if z["type"] == "client" and z["time"] > iMessanger[k]["Checked"] then
            kolvo = kolvo + 1
          end
        end
      end
      if kolvo > 0 then
        table.insert(chatindex_NV, k)
      else
        table.insert(chatindex_V, k)
      end
    end
  end
  table.sort(chatindexNEW, function(a, b) return iMessanger[a]["Chat"][#iMessanger[a]["Chat"]]["time"] > iMessanger[b]["Chat"][#iMessanger[b]["Chat"]]["time"] end)
  table.sort(chatindexNEW_V, function(a, b) return iMessanger[a]["Chat"][#iMessanger[a]["Chat"]]["time"] > iMessanger[b]["Chat"][#iMessanger[b]["Chat"]]["time"] end)
  table.sort(chatindex_V, function(a, b) return iMessanger[a]["Chat"][#iMessanger[a]["Chat"]]["time"] > iMessanger[b]["Chat"][#iMessanger[b]["Chat"]]["time"] end)
  table.sort(chatindex_NV, function(a, b) return iMessanger[a]["Chat"][#iMessanger[a]["Chat"]]["time"] > iMessanger[b]["Chat"][#iMessanger[b]["Chat"]]["time"] end)
  if iShowUA1.v then imgui_messanger_sup_showdialogs(chatindexNEW, "UnAnswered") end
  if iShowUA2.v then imgui_messanger_sup_showdialogs(chatindexNEW_V, "UnAnswered") end
  if iShowA1.v then imgui_messanger_sup_showdialogs(chatindex_NV, "Answered") end
  if iShowA2.v then imgui_messanger_sup_showdialogs(chatindex_V, "Answered") end
  imgui.EndChild()
end

function imgui_messanger_sms_showdialogs(table, typ)
  for _, v in ipairs(table) do
    k = v
    v = sms[v]
    if k ~= " " then
      for id = 0, sampGetMaxPlayerId() do
        if sampIsPlayerConnected(id) and sampGetPlayerNickname(id) == k then
          pId = id
          break
        end
      end
      kolvo = 0
      if #v["Chat"] ~= 0 then
        for i, z in pairs(v["Chat"]) do
          if z["type"] == "FROM" and z["time"] > v["Checked"] then
            kolvo = kolvo + 1
          end
        end
      end

      if typ == "Pinned" then
        imgui.PushID(1)
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImColor(0, 0, 0, 113):GetVec4())
        if kolvo > 0 then
          imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(0, 255, 0, 255):GetVec4())
        else
          imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(255, 255, 255, 255):GetVec4())
        end
        if k == selecteddialogSMS then
          imgui.PushStyleColor(imgui.Col.Button, imgui.ImColor(54, 12, 42, 113):GetVec4())
          sms[selecteddialogSMS]["Checked"] = os.time()

          --  elseif #iMessanger[k]["A"] == 0 then
        else
          imgui.PushStyleColor(imgui.Col.Button, imgui.ImColor(255, 0, 0, 113):GetVec4())
        end
      end
      if k == selecteddialogSMS then
        sms[selecteddialogSMS]["Checked"] = os.time()

      end
      if typ == "NotPinned" then
        imgui.PushID(2)
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImColor(0, 0, 0, 113):GetVec4())
        if kolvo > 0 then
          imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(0, 255, 0, 255):GetVec4())
        else
          imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(255, 255, 255, 255):GetVec4())
        end
        if k == selecteddialogSMS then
          imgui.PushStyleColor(imgui.Col.Button, imgui.ImColor(54, 12, 42, 113):GetVec4())
          sms[selecteddialogSMS]["Checked"] = os.time()
        else
          imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.26, 0.59, 0.98, 0.40))
        end
      end

      if kolvo > 0 then
        if pId ~= nil and sampIsPlayerConnected(pId) and sampGetPlayerNickname(pId) == k then
          if imgui.Button(u8(k .. "[" .. pId .. "] - "..kolvo), imgui.ImVec2(-0.0001, 30)) then
            selecteddialogSMS = k
            ScrollToDialogSMS = true
            online = "Онлайн"
            smsafk[selecteddialogSMS] = "CHECK AFK"
            scroll = true
            keyboard = true
            SSDB1_trigger = true
          end
        elseif iShowSHOWOFFLINESMS.v then
          if imgui.Button(u8(k .. "[-] - "..kolvo), imgui.ImVec2(-0.0001, 30)) then
            selecteddialogSMS = k
            ScrollToDialogSMS = true
            online = "Оффлайн"
            scroll = true
            keyboard = true
            SSDB1_trigger = true
          end
        end
      else
        if pId ~= nil and sampIsPlayerConnected(pId) and sampGetPlayerNickname(pId) == k then
          if imgui.Button(u8(k .. "[" .. pId .. "]"), imgui.ImVec2(-0.0001, 30)) then
            selecteddialogSMS = k
            ScrollToDialogSMS = true
            smsafk[selecteddialogSMS] = "CHECK AFK"
            online = "Онлайн"
            scroll = true
            keyboard = true
            SSDB1_trigger = true
          end
        elseif iShowSHOWOFFLINESMS.v then
          if imgui.Button(u8(k .. "[-]"), imgui.ImVec2(-0.0001, 30)) then
            selecteddialogSMS = k
            ScrollToDialogSMS = true
            online = "Оффлайн"
            scroll = true
            keyboard = true
            SSDB1_trigger = true
          end
        end
      end
      if scroll and selecteddialogSMS == k and iChangeScrollSMS.v then
        imgui.SetScrollHere()
      end
      imgui.PopStyleColor()
      imgui_messanger_sms_player_list_contextmenu(k, typ)
      if typ == "Pinned" then
        imgui.PopStyleColor(2)
        imgui.PopID()
      end
      if typ == "NotPinned" then
        imgui.PopStyleColor(2)
        imgui.PopID()
      end
    end
  end
end

function imgui_messanger_sms_player_list_contextmenu(k, typ)
  if imgui.BeginPopupContextItem("item context menu"..k) then
    if typ == "NotPinned" then
      if imgui.Selectable(u8"Закрепить") then
        sms[k]["Pinned"] = 1
        SSDB_trigger = true
        table.insert(sms[k]["Chat"], {text = "Собеседник закреплён", Nick = "мессенджер", type = "service", time = os.time()})
        ScrollToDialogSMS = true
      end
    else
      if imgui.Selectable(u8"Открепить") then
        sms[k]["Pinned"] = 0
        SSDB_trigger = true
        table.insert(sms[k]["Chat"], {text = "Собеседник откреплён", Nick = "мессенджер", type = "service", time = os.time()})
        ScrollToDialogSMS = true
      end
    end
    if sms[k]["Blocked"] ~= nil then
      if imgui.Selectable(u8"Разблокировать") then
        sms[k]["Blocked"] = nil
        table.insert(sms[k]["Chat"], {text = "Собеседник разблокирован", Nick = "мессенджер", type = "service", time = os.time()})
        SSDB_trigger = true
        ScrollToDialogSMS = true
      end
    else
      if imgui.Selectable(u8"Заблокировать") then
        sms[k]["Blocked"] = 1
        table.insert(sms[k]["Chat"], {text = "Собеседник заблокирован", Nick = "мессенджер", type = "service", time = os.time()})
        SSDB_trigger = true
        ScrollToDialogSMS = true
      end
    end
    if imgui.Selectable(u8"Очистить") then
      ispinned = 0
      if sms[k] and sms[k]["Pinned"] == 1 then
        ispinned = sms[k]["Pinned"]
      end
      sms[k] = {}
      sms[k]["Chat"] = {}
      sms[k]["Checked"] = 0
      sms[k]["Pinned"] = ispinned
      sms[k]["Chat"][1] = {text = "Диалог очищен", Nick = "мессенджер", type = "service", time = os.time()}
      selecteddialogSMS = k
      SSDB_trigger = true
      ScrollToDialogSMS = true
    end
    if imgui.Selectable(u8"Удалить") then
      sms[k] = nil
      SSDB_trigger = true
    end
    imgui.EndPopup()
  end
end

function imgui_messanger_sup_showdialogs(table, typ)
  for _, v in ipairs(table) do
    k = v
    v = iMessanger[v]
    if k ~= " " then
      for id = 0, sampGetMaxPlayerId() do
        if sampIsPlayerConnected(id) and sampGetPlayerNickname(id) == k then
          pId = id
          break
        end
      end
      kolvo = 0
      if #v["Chat"] ~= 0 then
        for i, z in pairs(v["Chat"]) do
          if z["type"] ~= "support" and z["time"] > v["Checked"] then
            kolvo = kolvo + 1
          end
        end
      end

      if typ == "UnAnswered" then
        imgui.PushID(1)
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImColor(0, 0, 0, 113):GetVec4())
        if kolvo > 0 then
          imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(0, 255, 0, 255):GetVec4())
        else
          imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(255, 255, 255, 255):GetVec4())
        end
        if k == selecteddialogSDUTY then
          imgui.PushStyleColor(imgui.Col.Button, imgui.ImColor(54, 12, 42, 113):GetVec4())
          iMessanger[selecteddialogSDUTY]["Checked"] = os.time()
          --  elseif #iMessanger[k]["A"] == 0 then
        else
          imgui.PushStyleColor(imgui.Col.Button, imgui.ImColor(255, 0, 0, 113):GetVec4())
        end
      end
      if k == selecteddialogSDUTY then
        iMessanger[selecteddialogSDUTY]["Checked"] = os.time()
      end
      if typ == "Answered" then
        imgui.PushID(2)
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImColor(0, 0, 0, 113):GetVec4())
        if kolvo > 0 then
          imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(0, 255, 0, 255):GetVec4())
        else
          imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(255, 255, 255, 255):GetVec4())
        end
        if k == selecteddialogSDUTY then
          imgui.PushStyleColor(imgui.Col.Button, imgui.ImColor(54, 12, 42, 113):GetVec4())
          iMessanger[selecteddialogSDUTY]["Checked"] = os.time()
        else
          imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.26, 0.59, 0.98, 0.40))
        end
      end
      if scroll and selecteddialogSDUTY == k and iChangeScroll.v then
        imgui.SetScrollHere()
      end
      if kolvo > 0 then
        if pId ~= nil and sampIsPlayerConnected(pId) and sampGetPlayerNickname(pId) == k then
          if imgui.Button(u8(k .. "[" .. pId .. "] - "..kolvo), imgui.ImVec2(-0.0001, 30)) then
            selecteddialogSDUTY = k
            online = "Онлайн"
            scroll = true
            keyboard = true
          end
        elseif iShowSHOWOFFLINESDUTY.v then
          if imgui.Button(u8(k .. "[-] - "..kolvo), imgui.ImVec2(-0.0001, 30)) then
            selecteddialogSDUTY = k
            online = "Оффлайн"
            scroll = true
            keyboard = true
          end
        end
      else
        if pId ~= nil and sampIsPlayerConnected(pId) and sampGetPlayerNickname(pId) == k then
          if imgui.Button(u8(k .. "[" .. pId .. "]"), imgui.ImVec2(-0.0001, 30)) then
            selecteddialogSDUTY = k
            online = "Онлайн"
            scroll = true
            keyboard = true
          end
        elseif iShowSHOWOFFLINESDUTY.v then
          if imgui.Button(u8(k .. "[-]"), imgui.ImVec2(-0.0001, 30)) then
            selecteddialogSDUTY = k
            online = "Оффлайн"
            scroll = true
            keyboard = true
          end
        end
      end

      if imgui.IsItemHovered() and imgui.IsMouseClicked(1) then
        iMessanger[k] = nil
      end
      if typ == "UnAnswered" then
        imgui.PopStyleColor(3)
        imgui.PopID()
      end
      if typ == "Answered" then
        imgui.PopStyleColor(3)
        imgui.PopID()
      end
    end
  end
end

function imgui_messanger_switchmode()
  imgui.BeginChild("Переключатель режимов", imgui.ImVec2(192, 35), true)
  kolvo1 = 0
  for k in pairs(iMessanger) do
    if #iMessanger[k]["A"] == 0 then
      if #iMessanger[k]["Chat"] ~= 0 then
        for i, z in pairs(iMessanger[k]["Chat"]) do
          if z["type"] ~= "support" and z["time"] > iMessanger[k]["Checked"] then
            kolvo1 = kolvo1 + 1
          end
        end
      end
    end
  end
  if cfg.messanger.mode == 1 then
    imgui.PushStyleColor(imgui.Col.Button, imgui.ImColor(0, 0, 0, 200):GetVec4())
    imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(255, 255, 255, 255):GetVec4())
  else
    if kolvo1 ~= nil and kolvo1 > 0 then
      imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(0, 255, 0, 255):GetVec4())
    else
      imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(255, 255, 255, 255):GetVec4())
    end
    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.26, 0.59, 0.98, 0.40))
  end
  if imgui.Button(u8("SDUTY"), imgui.ImVec2(85, 20)) then
    cfg.messanger.mode = 1
    inicfg.save(cfg, "support")
  end
  imgui.PopStyleColor(2)
  kolvo2 = 0
  for k in pairs(sms) do
    if #sms[k]["Chat"] ~= 0 then
      for i, z in pairs(sms[k]["Chat"]) do
        if z["type"] == "FROM" and z["time"] > sms[k]["Checked"] then
          kolvo2 = kolvo2 + 1
        end
      end
    end
  end
  if cfg.messanger.mode == 2 then
    imgui.PushStyleColor(imgui.Col.Button, imgui.ImColor(0, 0, 0, 200):GetVec4())
    imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(255, 255, 255, 255):GetVec4())
  else
    if kolvo2 ~= nil and kolvo2 > 0 then
      imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(0, 255, 0, 255):GetVec4())
    else
      imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(255, 255, 255, 255):GetVec4())
    end
    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.26, 0.59, 0.98, 0.40))
  end
  imgui.SameLine()
  if imgui.Button(u8("SMS"), imgui.ImVec2(85, 20)) then
    cfg.messanger.mode = 2
    inicfg.save(cfg, "support")
  end
  imgui.PopStyleColor(2)
  imgui.EndChild()
end

function imgui_messanger_sup_header()
  imgui.BeginChild("##header", imgui.ImVec2(imgui.GetContentRegionAvailWidth(), 35), true)
  if iMessanger[selecteddialogSDUTY] ~= nil and iMessanger[selecteddialogSDUTY]["Chat"] ~= nil and iMessanger[selecteddialogSDUTY]["Q"] ~= nil then
    for id = 0, sampGetMaxPlayerId() do
      if sampIsPlayerConnected(id) and sampGetPlayerNickname(id) == selecteddialogSDUTY then
        sId = id
        break
        if id == sampGetMaxPlayerId() then sId = "-" end
      end
    end
    if iMessanger[selecteddialogSDUTY] ~= nil and iMessanger[selecteddialogSDUTY]["Q"] ~= nil and iMessanger[selecteddialogSDUTY]["Q"][#iMessanger[selecteddialogSDUTY]["Q"]] ~= nil and iMessanger[selecteddialogSDUTY]["Q"][#iMessanger[selecteddialogSDUTY]["Q"]]["time"] ~= nil then
      qtime = os.time() - iMessanger[selecteddialogSDUTY]["Q"][#iMessanger[selecteddialogSDUTY]["Q"]]["time"]
    else
      qtime = "-"
    end
    imgui.Text(u8:encode("["..tostring(online).."] Ник: "..selecteddialogSDUTY..". ID: "..tonumber(sId)..". LVL: "..sampGetPlayerScore(tonumber(sId))..". Время: "..qtime.." сек."))
    imgui.SameLine(imgui.GetContentRegionAvailWidth() - 10)
    if imgui.Checkbox("##iHideOtherAnswers", iHideOtherAnswers) then
      cfg.messanger.HideOthersAnswers = iHideOtherAnswers.v
      inicfg.save(cfg, "support")
    end
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8"Скрывать ответы других саппортов?")
    end
  end
  imgui.EndChild()
end

function imgui_messanger_sms_header()
  imgui.BeginChild("##header", imgui.ImVec2(imgui.GetContentRegionAvailWidth(), 35), true)
  if sms[selecteddialogSMS] ~= nil and sms[selecteddialogSMS]["Chat"] ~= nil then
    for id = 0, sampGetMaxPlayerId() + 1 do
      if sampIsPlayerConnected(id) and sampGetPlayerNickname(id) == selecteddialogSMS then
        shId = id
        break
      end
      if id == sampGetMaxPlayerId() + 1 then shId = "-" end
    end
    if shId == "-" then
      imgui.Text(u8:encode("[Оффлайн] Ник: "..tostring(selecteddialogSMS)..". Всего сообщений: "..tostring(#sms[selecteddialogSMS]["Chat"]).."."))
    else
      imgui.Text(u8:encode("[Онлайн] Ник: "..selecteddialogSMS..". ID: "..tostring(shId)..". LVL: "..tostring(sampGetPlayerScore(tonumber(shId)))..". Всего сообщений: "..tostring(#sms[selecteddialogSMS]["Chat"]).."."))
      if smsafk[selecteddialogSMS] == nil then smsafk[selecteddialogSMS] = "CHECK AFK" end
      imgui.SameLine(imgui.GetContentRegionAvailWidth() - imgui.CalcTextSize(smsafk[selecteddialogSMS]).x)
      if smsafk[selecteddialogSMS]:find("s") then
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImColor(255, 0, 0, 113):GetVec4())
      end
      if smsafk[selecteddialogSMS]:find("NOT") then
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImColor(0, 255, 0, 113):GetVec4())
      end
      if imgui.Button(smsafk[selecteddialogSMS]) then
        for i = 0, sampGetMaxPlayerId() do
          if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == selecteddialogSMS then
            if mode == "samp-rp" then
              sampSendChat("/id "..i)
            end
            break
          end
        end
      end
      if smsafk[selecteddialogSMS]:find("s") or smsafk[selecteddialogSMS]:find("NOT") then
        imgui.PopStyleColor()
      end
    end
  end
  imgui.EndChild()
end

function imgui_messanger_sup_dialog()
  if cfg.messanger.activesduty and cfg.messanger.activesms then
    if cfg.only.messanger then
      dialogY = imgui.GetContentRegionAvail().y - 35
    else
      dialogY = iMessangerHeight.v - 35
    end
  else
    if cfg.only.messanger then
      dialogY = imgui.GetContentRegionAvail().y - 35
    else
      dialogY = iMessangerHeight.v - 35
    end
  end
  imgui.BeginChild("##middle", imgui.ImVec2(imgui.GetContentRegionAvailWidth(), dialogY), true)
  if selecteddialogSDUTY ~= nil and iMessanger[selecteddialogSDUTY] ~= nil and iMessanger[selecteddialogSDUTY]["Chat"] ~= nil then
    for k, v in ipairs(iMessanger[selecteddialogSDUTY]["Chat"]) do
      _213, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
      if cfg.messanger.HideOthersAnswers and v.type == "support" and v.Nick ~= sampGetPlayerNickname(myid) then
      else
        msg = string.format("%s", u8:encode(v.text))
        time = u8:encode(os.date("%X", v.time))
        if v.type == "client" then
          header = u8:encode("->Вопрос от "..v.Nick)
          local r, g, b, a = imgui.ImColor(cfg.messanger.QuestionColor):GetRGBA()
          imgui.PushStyleColor(imgui.Col.ChildWindowBg, imgui.ImColor(r, g, b, a):GetVec4())
        end
        if v.type == "support" then
          header = u8:encode("<-Ответ от "..v.Nick)
          _213, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
          if v.Nick == sampGetPlayerNickname(myid) then
            local r, g, b, a = imgui.ImColor(cfg.messanger.AnswerColor):GetRGBA()
            imgui.PushStyleColor(imgui.Col.ChildWindowBg, imgui.ImColor(r, g, b, a):GetVec4())
          else
            local r, g, b, a = imgui.ImColor(cfg.messanger.AnswerColorOthers):GetRGBA()
            imgui.PushStyleColor(imgui.Col.ChildWindowBg, imgui.ImColor(r, g, b, a):GetVec4())
          end
        end

        Xmin = imgui.CalcTextSize(time).x + imgui.CalcTextSize(header).x
        Xmax = imgui.GetContentRegionAvailWidth() / 2 + imgui.GetContentRegionAvailWidth() / 4
        Xmes = imgui.CalcTextSize(msg).x

        if Xmin < Xmes then
          if Xmes < Xmax then
            X = Xmes + 15
            if (Xmin + 5) > X then anomaly = true else anomaly = false end
          else
            X = Xmax
            if (Xmin + 5) > X then anomaly = true else anomaly = false end
          end
        else
          if (Xmin + 5) < Xmax then
            X = Xmin + 15
            if (Xmin + 5) > X then anomaly = true else anomaly = false end
          else
            X = Xmax
            if (Xmin + 5) > X then anomaly = true else anomaly = false end
          end
        end
        Y = imgui.CalcTextSize(time).y + 7 + (imgui.CalcTextSize(time).y + 7) * math.ceil((imgui.CalcTextSize(msg).x) / (X - 6))
        if anomaly then Y = Y + imgui.CalcTextSize(time).y + 3 end

        _213, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        if v.type == "support" and v.Nick == sampGetPlayerNickname(myid) then
          imgui.NewLine()
          imgui.SameLine(imgui.GetContentRegionAvailWidth() - X + 20 - imgui.GetStyle().ScrollbarSize)
        end
        imgui.PushStyleVar(imgui.StyleVar.WindowPadding, imgui.ImVec2(4.0, 2.0))
        imgui.BeginChild("##msg" .. k, imgui.ImVec2(X, Y), false, imgui.WindowFlags.AlwaysUseWindowPadding + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
        if v.type == "client" then
          local r, g, b, a = imgui.ImColor(cfg.messanger.QuestionTimeColor):GetRGBA()
          imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(r, g, b, a):GetVec4())
          imgui.Text(time)
          imgui.PopStyleColor()
          if not anomaly then imgui.SameLine() end
          local r, g, b, a = imgui.ImColor(cfg.messanger.QuestionHeaderColor):GetRGBA()
          imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(r, g, b, a):GetVec4())
          imgui.Text(header)
          imgui.PopStyleColor()
          local r, g, b, a = imgui.ImColor(cfg.messanger.QuestionTextColor):GetRGBA()
          imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(r, g, b, a):GetVec4())
        end
        if v.type == "support" then
          if v.Nick == sampGetPlayerNickname(myid) then
            local r, g, b, a = imgui.ImColor(cfg.messanger.AnswerTimeColor):GetRGBA()
            imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(r, g, b, a):GetVec4())
            imgui.Text(time)
            imgui.PopStyleColor()
            if not anomaly then imgui.SameLine() end
            local r, g, b, a = imgui.ImColor(cfg.messanger.AnswerHeaderColor):GetRGBA()
            imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(r, g, b, a):GetVec4())
            imgui.Text(header)
            imgui.PopStyleColor()
            local r, g, b, a = imgui.ImColor(cfg.messanger.AnswerTextColor):GetRGBA()
            imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(r, g, b, a):GetVec4())
          else
            local r, g, b, a = imgui.ImColor(cfg.messanger.AnswerTimeOthersColor):GetRGBA()
            imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(r, g, b, a):GetVec4())
            imgui.Text(time)
            imgui.PopStyleColor()
            if not anomaly then imgui.SameLine() end
            local r, g, b, a = imgui.ImColor(cfg.messanger.AnswerHeaderOthersColor):GetRGBA()
            imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(r, g, b, a):GetVec4())
            imgui.Text(header)
            imgui.PopStyleColor()
            local r, g, b, a = imgui.ImColor(cfg.messanger.AnswerTextOthersColor):GetRGBA()
            imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(r, g, b, a):GetVec4())
          end
        end
        imgui.TextWrapped(msg)
        imgui.PopStyleColor()
        imgui.EndChild()
        imgui.PopStyleVar()
        imgui.PopStyleColor()
      end
    end
    if ScrollToDialogSDUTY then
      imgui.SetScrollHere()
      ScrollToDialogSDUTY = false
    end
  else
    if iMessanger[selecteddialogSDUTY] == nil then
      local text = u8"Выберите диалог."
      local width = imgui.GetWindowWidth()
      local height = imgui.GetWindowHeight()
      local calc = imgui.CalcTextSize(text)
      imgui.SetCursorPos(imgui.ImVec2( width / 2 - calc.x / 2, height / 2 - calc.y / 2))
      imgui.Text(text)
    end
  end
  imgui.EndChild()
end

function imgui_messanger_sms_dialog()
  if cfg.messanger.activesduty and cfg.messanger.activesms then
    if cfg.only.messanger then
      dialogY = imgui.GetContentRegionAvail().y - 35
    else
      dialogY = iMessangerHeight.v - 35
    end
  else
    if cfg.only.messanger then
      dialogY = imgui.GetContentRegionAvail().y - 35
    else
      dialogY = iMessangerHeight.v - 35
    end
  end
  imgui.BeginChild("##middle", imgui.ImVec2(imgui.GetContentRegionAvailWidth(), dialogY), true)
  if selecteddialogSMS ~= nil and sms[selecteddialogSMS] ~= nil and sms[selecteddialogSMS]["Chat"] ~= nil then
    for k, v in ipairs(sms[selecteddialogSMS]["Chat"]) do
      msg = string.format("%s", u8:encode(v.text))
      time = u8:encode(os.date("%x %X", v.time))
      if v.type == "FROM" then
        header = u8:encode("->SMS от "..v.Nick)
        local r, g, b, a = imgui.ImColor(cfg.messanger.SmsInColor):GetRGBA()
        imgui.PushStyleColor(imgui.Col.ChildWindowBg, imgui.ImColor(r, g, b, a):GetVec4())
      end
      if v.type == "TO" then
        header = u8:encode("<-SMS от "..v.Nick)
        local r, g, b, a = imgui.ImColor(cfg.messanger.SmsOutColor):GetRGBA()
        imgui.PushStyleColor(imgui.Col.ChildWindowBg, imgui.ImColor(r, g, b, a):GetVec4())
      end
      if v.type ~= "service" then
        Xmin = imgui.CalcTextSize(time).x + imgui.CalcTextSize(header).x
        Xmax = imgui.GetContentRegionAvailWidth() / 2 + imgui.GetContentRegionAvailWidth() / 4
        Xmes = imgui.CalcTextSize(msg).x

        if Xmin < Xmes then
          if Xmes < Xmax then
            X = Xmes + 15
            if (Xmin + 5) > X then anomaly = true else anomaly = false end
          else
            X = Xmax
            if (Xmin + 5) > X then anomaly = true else anomaly = false end
          end
        else
          if (Xmin + 5) < Xmax then
            X = Xmin + 15
            if (Xmin + 5) > X then anomaly = true else anomaly = false end
          else
            X = Xmax
            if (Xmin + 5) > X then anomaly = true else anomaly = false end
          end
        end
        Y = imgui.CalcTextSize(time).y + 7 + (imgui.CalcTextSize(time).y + 5) * math.ceil((imgui.CalcTextSize(msg).x) / (X - 14))
        if anomaly then Y = Y + imgui.CalcTextSize(time).y + 3 end
      else
        local r, g, b, a = imgui.ImColor(cfg.messanger.SmsOutColor):GetRGBA()
        imgui.PushStyleColor(imgui.Col.ChildWindowBg, imgui.ImColor(r, g, b, a):GetVec4())
        X = imgui.CalcTextSize(msg).x + 9
        Y = imgui.CalcTextSize(msg).y + 5
      end
      if v.type == "TO" then
        imgui.NewLine()
        imgui.SameLine(imgui.GetContentRegionAvailWidth() - X + 20 - imgui.GetStyle().ScrollbarSize)
      end
      if v.type == "service" then
        imgui.NewLine()
        local width = imgui.GetWindowWidth()
        local calc = imgui.CalcTextSize(msg)
        imgui.SameLine(width / 2 - calc.x / 2 - 3)
      end
      imgui.PushStyleVar(imgui.StyleVar.WindowPadding, imgui.ImVec2(4.0, 2.0))
      imgui.BeginChild("##msg" .. k, imgui.ImVec2(X, Y), false, imgui.WindowFlags.AlwaysUseWindowPadding + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
      if v.type == "FROM" then
        local r, g, b, a = imgui.ImColor(cfg.messanger.SmsInTextColor):GetRGBA()
        imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(r, g, b, a):GetVec4())
        local r, g, b, a = imgui.ImColor(cfg.messanger.SmsInTimeColor):GetRGBA()
        imgui.TextColored(imgui.ImColor(r, g, b, a):GetVec4(), time)
        if not anomaly then imgui.SameLine() end
        local r, g, b, a = imgui.ImColor(cfg.messanger.SmsInHeaderColor):GetRGBA()
        imgui.TextColored(imgui.ImColor(r, g, b, a):GetVec4(), header)
      end
      if v.type == "TO" then
        local r, g, b, a = imgui.ImColor(cfg.messanger.SmsOutTextColor):GetRGBA()
        imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(r, g, b, a):GetVec4())
        local r, g, b, a = imgui.ImColor(cfg.messanger.SmsOutTimeColor):GetRGBA()
        imgui.TextColored(imgui.ImColor(r, g, b, a):GetVec4(), time)
        if not anomaly then imgui.SameLine() end
        local r, g, b, a = imgui.ImColor(cfg.messanger.SmsOutHeaderColor):GetRGBA()
        imgui.TextColored(imgui.ImColor(r, g, b, a):GetVec4(), header)
      end
      if v.type == "service" then
        local r, g, b, a = imgui.ImColor(cfg.messanger.SmsOutTextColor):GetRGBA()
        imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(r, g, b, a):GetVec4())
      end
      imgui.TextWrapped(msg)
      if v.type == "service" and imgui.IsItemHovered() then
        imgui.SetTooltip(time)
      end
      imgui.PopStyleColor()
      imgui.EndChild()
      imgui.PopStyleVar()
      imgui.PopStyleColor()
    end
    if ScrollToDialogSMS then
      imgui.SetScrollHere()
      ScrollToDialogSMS = false
    end
  else
    if sms[selecteddialogSMS] == nil then
      local text = u8"Выберите диалог."
      local width = imgui.GetWindowWidth()
      local height = imgui.GetWindowHeight()
      local calc = imgui.CalcTextSize(text)
      imgui.SetCursorPos(imgui.ImVec2( width / 2 - calc.x / 2, height / 2 - calc.y / 2))
      imgui.Text(text)
    end
  end
  imgui.EndChild()
end

function imgui_messanger_sup_keyboard()
  imgui.BeginChild("##keyboard", imgui.ImVec2(imgui.GetContentRegionAvailWidth(), 35), true)
  if iMessanger[selecteddialogSDUTY] == nil then

  else
    if KeyboardFocusReset then
      imgui.SetKeyboardFocusHere()
      KeyboardFocusReset = false
    end
    if keyboard and iSetKeyboard.v then
      imgui.SetKeyboardFocusHere()
      keyboard = false
    end
    imgui.PushItemWidth(imgui.GetContentRegionAvailWidth() - 70)
    if imgui.InputText("##keyboard", toAnswerSDUTY, imgui.InputTextFlags.EnterReturnsTrue) then
      if gethh ~= nil and toAnswerSDUTY.v:find("/hh (%d+)") then
        imgui_messanger_sup_keyboard_gethh(1)
      elseif gethc ~= nil and toAnswerSDUTY.v:find("/hc (%d+)") then
        imgui_messanger_sup_keyboard_gethc(1)
      elseif gethc ~= nil and toAnswerSDUTY.v:find("/hc (%S+)") then
        imgui_messanger_sup_keyboard_gethc(1)
      elseif getfr ~= nil and toAnswerSDUTY.v:find("/fr (%d+)") then
        imgui_messanger_sup_keyboard_getfr(1)
      elseif getfr ~= nil and toAnswerSDUTY.v:find("/fr (%S+)") then
        imgui_messanger_sup_keyboard_getfr(1)
      else
        for i = 0, sampGetMaxPlayerId() do
          if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == selecteddialogSDUTY then k = i break end
          if i == sampGetMaxPlayerId() then k = "-" end
        end
        if k ~= "-" then
          if mode == "samp-rp" then
            sampSendChat("/pm " .. k .. " " .. u8:decode(toAnswerSDUTY.v))
            toAnswerSDUTY.v = ''
          end
        end
        KeyboardFocusReset = true
      end
    end
    if imgui.IsItemActive() then
      lockPlayerControl(true)
      imgui_messanger_sup_keyboard_gethh(2)
      imgui_messanger_sup_keyboard_gethc(2)
      imgui_messanger_sup_keyboard_getfr(2)
    else
      lockPlayerControl(false)
    end
    if imgui.SameLine() or imgui.Button(u8"Отправить") then
      if gethh ~= nil and toAnswerSDUTY.v:find("/hh (%d+)") then
        imgui_messanger_sup_keyboard_gethh(1)
      elseif gethc ~= nil and toAnswerSDUTY.v:find("/hc (%d+)") then
        imgui_messanger_sup_keyboard_gethc(1)
      elseif gethc ~= nil and toAnswerSDUTY.v:find("/hc (%S+)") then
        imgui_messanger_sup_keyboard_gethc(1)
      elseif getfr ~= nil and toAnswerSDUTY.v:find("/fr (%d+)") then
        imgui_messanger_sup_keyboard_getfr(1)
      elseif getfr ~= nil and toAnswerSDUTY.v:find("/fr (%S+)") then
        imgui_messanger_sup_keyboard_getfr(1)
      else
        for i = 0, sampGetMaxPlayerId() do
          if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == selecteddialogSDUTY then k = i break end
          if i == sampGetMaxPlayerId() then k = "-" end
        end
        if k ~= "-" then
          if mode == "samp-rp" then
            sampSendChat("/pm " .. k .. " " .. u8:decode(toAnswerSDUTY.v))
          end
          toAnswerSDUTY.v = ''
        end
        KeyboardFocusReset = true
      end
    end
  end
  imgui.EndChild()
end

function imgui_messanger_sup_keyboard_gethh(mode)
  if cfg.messanger.suphh then
    if mode == 1 then
      if gethh ~= nil and toAnswerSDUTY.v:find("/hh (%d+)") then
        gethhnumber = nil
        gethhnumber = string.match(toAnswerSDUTY.v, "/hh (%d+)")
        if gethhnumber ~= nil then
          for i = 1, #gethh do
            hh = string.match(gethh[i], "ID (%d+)")
            if hh and hh == gethhnumber then
              toAnswerSDUTY.v = string.gsub(toAnswerSDUTY.v, "/hh (%d+)", gethh[i])
              break
            end
          end
        end
        KeyboardFocusReset = true
      end
    else
      if gethh ~= nil and toAnswerSDUTY.v:find("/hh (%d+)") then
        gethhnumber = nil
        gethhnumber = string.match(toAnswerSDUTY.v, "/hh (%d+)")
        if gethhnumber ~= nil then
          for i = 1, #gethh do
            hh = string.match(gethh[i], "ID (%d+)")
            if hh and hh == gethhnumber then
              imgui.SetTooltip(u8:encode(gethh[i]))
              break
            end
          end
        end
      end
    end
  end
end

function imgui_messanger_sup_keyboard_gethc(mode)
  if cfg.messanger.suphc then
    if mode == 1 then
      if gethc ~= nil then
        if toAnswerSDUTY.v:find("/hc (%d+)") then
          gethcnumber = nil
          gethcnumber = string.match(toAnswerSDUTY.v, "/hc (%d+)")
          if gethcnumber ~= nil then
            for i = 1, #gethc do
              hcid, hcname = string.match(gethc[i], "(%d+) | (%S+)")
              if hcid and hcid == gethcnumber then
                toAnswerSDUTY.v = string.gsub(toAnswerSDUTY.v, "/hc (%d+)", gethc[i])
                break
              end
            end
          end
          KeyboardFocusReset = true
        elseif toAnswerSDUTY.v:find("/hc (%S+)") then
          gethcname = nil
          gethcname = string.match(toAnswerSDUTY.v, "/hc (%S+)")
          for i = 1, #gethc do
            hcid, hcname = string.match(gethc[i], "(%d+) | (%S+)")
            if hcname and string.find(string.rlower(gethc[i]), string.rlower(gethcname)) then
              toAnswerSDUTY.v = string.gsub(toAnswerSDUTY.v, "/hc (%S+)", gethc[i])
              break
            end
          end
          KeyboardFocusReset = true
        end
      end
    else
      if gethc ~= nil then
        if toAnswerSDUTY.v:find("/hc (%d+)") then
          gethcnumber = nil
          gethcnumber = string.match(toAnswerSDUTY.v, "/hc (%d+)")
          if gethcnumber ~= nil then
            for i = 1, #gethc do
              hcid, hcname = string.match(gethc[i], "(%d+) | (%S+)")
              if hcid and hcid == gethcnumber then
                imgui.SetTooltip(u8:encode(gethc[i]))
                break
              end
            end
          end
        elseif toAnswerSDUTY.v:find("/hc (%S+)") then
          gethcname = nil
          gethcname = string.match(toAnswerSDUTY.v, "/hc (%S+)")
          for i = 1, #gethc do
            hcid, hcname = string.match(gethc[i], "(%d+) | (%S+)")
            if hcname and string.find(string.rlower(gethc[i]), string.rlower(gethcname)) then
              imgui.SetTooltip(u8:encode(gethc[i]))
              break
            end
          end
        end
      end
    end
  end
end

function imgui_messanger_sup_keyboard_getfr(mode)
  if cfg.messanger.supfr then
    if mode == 1 then
      if getfr ~= nil then
        if toAnswerSDUTY.v:find("/fr (%d+)") then
          getfrnumber = nil
          getfrnumber = string.match(toAnswerSDUTY.v, "/fr (%d+)")
          if getfrnumber ~= nil then
            if getfr[tonumber(getfrnumber)] ~= nil then
              toAnswerSDUTY.v = string.gsub(toAnswerSDUTY.v, "/fr (%d+)", u8:encode(getfr[tonumber(getfrnumber)]))
            end
          end
          KeyboardFocusReset = true
        elseif toAnswerSDUTY.v:find("/fr (%S+)") then
          getfrname = nil
          getfrname = u8:decode(string.match(toAnswerSDUTY.v, "/fr (%S+)"))
          for i = 1, #getfr do
            if getfr[i] and getfrname and string.find(string.rlower(getfr[i]), string.rlower(getfrname)) then
              toAnswerSDUTY.v = string.gsub(toAnswerSDUTY.v, "/fr (%S+)", u8:encode(getfr[i]))
              break
            end
          end
          KeyboardFocusReset = true
        end
      end
    else
      if getfr ~= nil then
        if toAnswerSDUTY.v:find("/fr (%d+)") then
          getfrnumber = nil
          getfrnumber = string.match(toAnswerSDUTY.v, "/fr (%d+)")
          if getfrnumber ~= nil then
            if getfr[tonumber(getfrnumber)] ~= nil then
              imgui.SetTooltip(u8:encode(tonumber(getfrnumber)..". "..getfr[tonumber(getfrnumber)]))
            end
          end
        elseif toAnswerSDUTY.v:find("/fr (%S+)") then
          getfrname = nil
          getfrname = u8:decode(string.match(toAnswerSDUTY.v, "/fr (%S+)"))
          for i = 1, #getfr do
            if getfr[i] and getfrname and string.find(string.rlower(getfr[i]), string.rlower(getfrname)) then
              imgui.SetTooltip(u8:encode(i..". "..getfr[i]))
              break
            end
          end
        end
      end
    end
  end
end

function imgui_messanger_sms_keyboard()
  imgui.BeginChild("##keyboardSMS", imgui.ImVec2(imgui.GetContentRegionAvailWidth(), 35), true)
  if sms[selecteddialogSMS] == nil then

  else
    if KeyboardFocusReset then
      imgui.SetKeyboardFocusHere()
      KeyboardFocusReset = false
    end
    if keyboard and iSetKeyboardSMS.v then
      imgui.SetKeyboardFocusHere()
      keyboard = false
    end
    imgui.PushItemWidth(imgui.GetContentRegionAvailWidth() - 70)
    if imgui.InputText("##keyboardSMSKA", toAnswerSMS, imgui.InputTextFlags.EnterReturnsTrue) then
      for i = 0, sampGetMaxPlayerId() do
        if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == selecteddialogSMS then k = i break end
        if i == sampGetMaxPlayerId() then k = "-" end
      end
      if k ~= "-" then
        if mode == "samp-rp" then
          sampSendChat("/t " .. k .. " " .. u8:decode(toAnswerSMS.v))
          toAnswerSMS.v = ''
        end
      end
      KeyboardFocusReset = true
    end
    if imgui.IsItemActive() then
      lockPlayerControl(true)
      imgui_messanger_sup_keyboard_gethh(2)
      imgui_messanger_sup_keyboard_gethc(2)
    else
      lockPlayerControl(false)
    end
    if imgui.SameLine() or imgui.Button(u8"Отправить") then
      for i = 0, sampGetMaxPlayerId() do
        if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == selecteddialogSMS then k = i break end
        if i == sampGetMaxPlayerId() then k = "-" end
      end
      if k ~= "-" then
        if mode == "samp-rp" then
          sampSendChat("/t " .. k .. " " .. u8:decode(toAnswerSMS.v))
          toAnswerSMS.v = ''
        end
      end
      KeyboardFocusReset = true
    end
  end
  imgui.EndChild()
end

function imgui_messanger_sms_loadDB()
  _213, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  smsfile = getGameDirectory()..'\\moonloader\\config\\smsmessanger\\'..sampGetCurrentServerAddress().."-"..sampGetPlayerNickname(myid)..'.sms'
  if cfg.messanger.storesms or ingamelaunch then
    ingamelaunch = nil
    if doesFileExist(smsfile) then
      sms = table.load(smsfile)
    else
      if sms == nil then sms = {} end
      table.save(sms, smsfile)
      sms = table.load(smsfile)
    end
  else
    sms = {}
  end
end

function imgui_messanger_sms_saveDB()
  if cfg.messanger.storesms then
    if type(sms) == "table" and doesFileExist(smsfile) then
      table.save(sms, smsfile)
    end
  end
end

function imgui_messanger_sms_kostilsaveDB()
  while true do
    wait(3000)
    if SSDB1_trigger == true then
      imgui_messanger_sms_saveDB()
      SSDB1_trigger = false
      wait(10000)
    end
  end
end

function imgui_notepad()
  if not cfg.only.notepad then
    ch2 = imgui.CollapsingHeader(u8"Блокнот")
    if ch2 then
      imgui_notepad_rightclick()
      imgui_notepad_content()
    end
    if not ch2 then imgui_notepad_rightclick() end
  else
    imgui_menu()
    imgui_notepad_content()
  end
end

function imgui_notepad_content()
  if cfg.only.notepad then
    notY = imgui.GetContentRegionAvail().y
  else
    notY = imgui.GetTextLineHeight() * cfg.notepad.lines
  end
  if imgui.InputTextMultiline("##notepad", textNotepad, imgui.ImVec2(-1, notY), imgui.InputTextFlags.EnterReturnsTrue + imgui.InputTextFlags.AllowTabInput) then
    notepadtext = textNotepad.v
    notepadtext = string.gsub(notepadtext, "\n", "\\n")
    notepadtext = string.gsub(notepadtext, "\t", "\\t")
    cfg.notepad.text = u8:decode(notepadtext)
    if inicfg.save(cfg, "support") then
      printStringNow("Text saved", 1000)
    else
      printStringNow("Text not saved", 1000)
    end
  end
  if imgui.IsItemActive() then
    lockPlayerControl(true)
  else
    lockPlayerControl(false)
  end
end

function imgui_notepad_FO()
  if not cfg.only.notepad then
    main_window_state.v = true
  else
    main_window_state.v = not main_window_state.v
  end
  if cfg.notepad.active and cfg.notepad.hotkey then
    cfg.only.messanger = false
    cfg.only.notepad = true
    cfg.only.logviewer = false
    cfg.only.histogram = false
    cfg.only.settings = false
    cfg.only.counter = false
    inicfg.save(cfg, "support")
  end
end

function imgui_notepad_rightclick()
  if imgui.IsItemHovered(imgui.HoveredFlags.RootWindow) and imgui.IsMouseClicked(1) then
    cfg.only.notepad = true
    inicfg.save(cfg, "support")
  end
end

function imgui_log()
  if not cfg.only.logviewer then
    ch3 = imgui.CollapsingHeader(u8"Лог моих ответов")
    if ch3 then
      imgui_log_rightclick()
      imgui_log_content()
    end
    if not ch3 then imgui_log_rightclick() end
  else
    imgui_menu()
    imgui_log_content()
  end
end

function imgui_log_content()
  if #iYears ~= 0 then
    imgui.PushItemWidth(100)
    imgui.Combo(u8"Год##", iYear, iYears)
    imgui.PopItemWidth()
    imgui.SameLine()
    imgui.PushItemWidth(100)
    imgui.SliderInt(u8"Месяц##", iMonth, 1, 12)
    imgui.SameLine()
    imgui.SliderInt(u8"День", iDay, 1, 31)
    imgui.SameLine()
    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.16, 0.29, 0.48, 0.54))
    if imgui.Button(u8"Обновить") then
      sup_updateStats()
    end
    imgui.PopStyleColor()
    imgui_log_getDayLogs(iMonth.v, string.sub(iYears[iYear.v + 1], 3, 4), iDay.v)
    imgui.Columns(6, "mycolumns")
    imgui.Separator()
    imgui.Text(u8"ID")
    imgui.SetColumnWidth(-1, 50)
    imgui.NextColumn()
    imgui.SetColumnWidth(-1, 135)
    imgui.Text(u8"Ник")
    imgui.NextColumn()
    if ((cfg.menuwindow.Width - 400) / 2) > 50 then
      AQWidth = ((cfg.menuwindow.Width - 400) / 2)
    else
      AQWidth = 50
    end
    imgui.SetColumnWidth(-1, AQWidth)
    imgui.Text(u8"Вопрос")
    imgui.NextColumn()
    imgui.SetColumnWidth(-1, AQWidth)
    imgui.Text(u8"Ответ")
    imgui.NextColumn()
    imgui.SetColumnWidth(-1, 40)
    imgui.Text(u8"Сек")
    imgui.NextColumn()
    imgui.SetColumnWidth(-1, 150 + imgui.GetStyle().ScrollbarSize)
    imgui.Text(u8"Дата")
    imgui.NextColumn()
    imgui.Columns(1)
    if csvall[date] ~= nil then
      if cfg.only.logviewer then
        logY = imgui.GetContentRegionAvail().y
      else
        logY = cfg.log.height
      end
      imgui.BeginChild("##scrollingregion", imgui.ImVec2(0, logY))
      imgui.Columns(6)
      imgui.Separator()
      for _ = #csvall[date], 1, - 1 do
        if _ > 0 then
          _ = csvall[date][_]
          CSV_id, CSV_nickname, CSV_vopros, CSV_otvet, CSV_respondtime, CSV_dateandtime, CSV_unix = string.match(_, "(.+),(.+),(.+),(.+),(.+),(.+),(.+)")
          imgui.Text(CSV_id)
          imgui.SetColumnWidth(-1, 50)
          imgui.NextColumn()
          imgui.SetColumnWidth(-1, 135)
          imgui.Text(CSV_nickname)
          imgui.NextColumn()
          imgui.SetColumnWidth(-1, AQWidth)
          imgui.TextWrapped(u8:encode(CSV_vopros))
          if imgui.IsItemHovered() and imgui.IsMouseClicked(1) then
            setClipboardText(CSV_vopros)
            printStringNow("Text copied", 1000)
          end
          imgui.NextColumn()
          imgui.SetColumnWidth(-1, AQWidth)
          imgui.TextWrapped(u8:encode(CSV_otvet))
          if imgui.IsItemHovered() and imgui.IsMouseClicked(1) then
            setClipboardText(CSV_otvet)
            printStringNow("Text copied", 1000)
          end
          imgui.NextColumn()
          imgui.SetColumnWidth(-1, 40)
          imgui.Text(CSV_respondtime)
          imgui.NextColumn()
          imgui.SetColumnWidth(-1, 150 + imgui.GetStyle().ScrollbarSize)
          imgui.Text(CSV_dateandtime)
          imgui.NextColumn()
          imgui.Separator()
        end
      end
      imgui.Columns(1)
      imgui.EndChild()
    end
  else
    imgui.Text(u8"Ошибка: лог пуст или невалиден.")
  end
end

function imgui_log_getDayLogs(month, year, day)
  if tonumber(month) < 10 then month = "0"..month end
  if tonumber(year) < 10 then year = "0"..year end
  if tonumber(day) < 10 then day = "0"..day end
  date = tostring(month.."/"..day.."/"..year)
end

function imgui_log_rightclick()
  if imgui.IsItemHovered(imgui.HoveredFlags.RootWindow) and imgui.IsMouseClicked(1) then
    cfg.only.logviewer = true
    inicfg.save(cfg, "support")
  end
end

function imgui_histogram()
  if not cfg.only.histogram then
    ch4 = imgui.CollapsingHeader(u8"Гистограмма")
    if ch4 then
      imgui_histogram_rightclick()
      imgui_histogram_content()
    end
    if not ch4 then imgui_histogram_rightclick() end
  else
    imgui_menu()
    imgui_histogram_content()
  end
end

function imgui_histogram_content()
  if #iYears ~= 0 then
    imgui.PushItemWidth(100)
    imgui.Combo(u8"Год", iYear, iYears)
    imgui.PopItemWidth()
    imgui.PushItemWidth(200)
    imgui.SameLine()
    imgui.SliderInt(u8"Месяц", iMonth, 1, 12)
    imgui.SameLine()
    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.16, 0.29, 0.48, 0.54))
    if imgui.Button(u8"Обновить") then
      sup_updateStats()
    end
    imgui.PopStyleColor()
    imgui_histogram_getMonthStats(iMonth.v, string.sub(iYears[iYear.v + 1], 3, 4))
    if cfg.only.histogram then
      histY = imgui.GetContentRegionAvail().y
    else
      histY = cfg.stats.height
    end
    imgui.PlotHistogram("##Статистика", month_histogram, 0, u8:encode(iMonths[iMonth.v].." "..iYears[iYear.v + 1]), 0, math.max(unpack(month_histogram)) + math.max(unpack(month_histogram)) * 0.15, imgui.ImVec2(imgui.GetWindowContentRegionWidth(), histY))
  else
    imgui.Text(u8"Ошибка: лог пуст или невалиден.")
  end
end

function imgui_histogram_getMonthStats(month, year)
  if tonumber(month) < 10 then month = "0"..month end
  if tonumber(year) < 10 then year = "0"..year end
  local sum = 0
  for day = 1, 31 do
    if tonumber(day) < 10 then day = "0"..day end
    date = tostring(month.."/"..day.."/"..year)
    if csv[date] == nil then csv[date] = 0 end
    month_histogram[tonumber(day)] = csv[date]
    sum = sum + csv[date]
  end
  month_histogram[0] = sum
end

function imgui_histogram_rightclick()
  if imgui.IsItemHovered(imgui.HoveredFlags.RootWindow) and imgui.IsMouseClicked(1) then
    cfg.only.histogram = true
  end
end

function imgui_counter()
  if not cfg.only.counter then
    ch7 = imgui.CollapsingHeader(u8"Счётчик саппорта")
    if ch7 then
      imgui_counter_rightclick()
      imgui_counter_content()
    end
    if not ch7 then imgui_counter_rightclick() end
  else
    imgui_menu()
    imgui_counter_content()
  end
end

function imgui_counter_content()
  imgui.Text(u8:encode(imgui_counter_gettime(os.time() - os.time{year = cfg.counter.year, month = cfg.counter.month, day = cfg.counter.day, hour = cfg.counter.hour, min = cfg.counter.minute})))
end

function imgui_counter_gettime(time)
  if time > 0 then
    years = math.floor(time / 31536000)
    time = time - years * 31536000
    months = math.floor(time / 2628000)
    time = time - months * 2628000
    days = math.floor(time / 86400)
    time = time - days * 86400
    hours = math.floor(time / 3600)
    time = time - hours * 3600
    minutes = math.floor(time / 60)
    seconds = math.floor(time % 60)
    if years == 1 then
      years = tostring(years).." год, "
    elseif years == 2 or years == 3 or years == 4 then
      years = tostring(years).." года, "
    else
      years = tostring(years).." лет, "
    end

    if months == 1 then
      months = tostring(months).." месяц, "
    elseif months == 2 or months == 3 or months == 4 then
      months = tostring(months).." месяца, "
    else
      months = tostring(months).." месяцев, "
    end

    if days == 0 or days > 4 and days < 21 or days > 24 and days < 31 then
      days = tostring(days).." дней, "
    elseif days == 1 or days == 21 or days == 31 then
      days = tostring(days).." день, "
    else
      days = tostring(days).." дня, "
    end

    if hours == 0 or hours > 4 and hours < 21 then
      hours = tostring(hours).." часов, "
    elseif hours == 1 or hours == 21 then
      hours = tostring(hours).." час, "
    else
      hours = tostring(hours).." часа, "
    end

    if minutes == 0 or minutes > 4 and minutes < 21 or minutes > 24 and minutes < 31 or minutes > 34 and minutes < 41 or minutes > 44 and minutes < 51 or minutes > 54 and minutes < 60 then
      minutes = tostring(minutes).." минут, "
    elseif minutes == 1 or minutes == 21 or minutes == 31 or minutes == 41 or minutes == 51 then
      minutes = tostring(minutes).." минута, "
    else
      minutes = tostring(minutes).." минуты, "
    end

    if seconds == 0 or seconds > 4 and seconds < 21 or seconds > 24 and seconds < 31 or seconds > 34 and seconds < 41 or seconds > 44 and seconds < 51 or seconds > 54 and seconds < 60 then
      seconds = tostring(seconds).." секунд."
    elseif seconds == 1 or seconds == 21 or seconds == 31 or seconds == 41 or seconds == 51 then
      seconds = tostring(seconds).." секунда. "
    else
      seconds = tostring(seconds).." секунды."
    end


    answer = "На посту уже "..years..months..days..hours..minutes..seconds
    return answer
  else
    return "error"
  end
end

function imgui_counter_rightclick()
  if imgui.IsItemHovered(imgui.HoveredFlags.RootWindow) and imgui.IsMouseClicked(1) then
    cfg.only.counter = true
  end
end

function imgui_info()
  if not cfg.only.info then
    ch9 = imgui.CollapsingHeader(u8"Информация о скрипте")
    if ch9 then
      imgui_info_rightclick()
      imgui_info_content()
    end
    if not ch9 then imgui_info_rightclick() end
  else
    imgui_menu()
    imgui_info_content()
  end
end

function imgui_info_content()
  imgui.Text(thisScript().name.." v"..thisScript().version)
  imgui_info_open(currentbuylink)
  imgui.Text("<> by "..thisScript().authors[1])
  imgui_info_open("https://blast.hk/members/156833/")
  imgui.Text("")
  imgui.Text(u8"Группа ВКонтакте (все новости здесь): ".."http://vk.com/qrlk.mods")
  imgui_info_open("http://vk.com/qrlk.mods")
  imgui.Text(u8"Сообщение автору (все баги только сюда): ".."http://vk.me/qrlk.mods")
  imgui_info_open("http://vk.me/qrlk.mods")
  imgui.Text("")
  if imgui.TreeNode("Changelog") then
    imgui.InputTextMultiline("##changelog", changelog, imgui.ImVec2(-1, 200), imgui.InputTextFlags.ReadOnly)
    imgui.TreePop()
  end
  imgui.Text("")
  imgui.Text(u8:encode("Лицензия принадлежит: "..licensenick..", сервер: "..licenseserver..", купленный мод: "..mode.."."))
  imgui.Text(u8:encode("Текущая цена: "..currentprice..", (с промокодом скидка "..currentpromodis.."). Купить можно тут: "..currentbuylink))
  imgui_info_open(currentbuylink)
  imgui.Text("")
  imgui.Text(u8:encode("В скрипте задействованы следующие сампотехнологии:"))

  imgui.BeginChild("##credits", imgui.ImVec2(580, 175), true)
  imgui.Columns(4, nil, false)

  cp1 = 25
  cp2 = 125
  cp3 = 260
  cp4 = 160

  imgui.Text("1")
  imgui.SetColumnWidth(-1, cp1)
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp2)
  imgui.Text("Moonloader v0"..getMoonloaderVersion())
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp3)
  link = "https://blast.hk/threads/13305/"
  imgui.Text(link)
  imgui_info_open(link)
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp4)
  imgui.Text("FYP, ")
  imgui_info_open("https://blast.hk/members/2/")
  imgui.SameLine()
  imgui.Text("hnnssy, ")
  imgui_info_open("https://blast.hk/members/66797/")
  imgui.SameLine()
  imgui.Text("EvgeN 1137.")
  imgui_info_open("https://blast.hk/members/1/")
  imgui.NextColumn()


  imgui.Text("2")
  imgui.SetColumnWidth(-1, cp1)
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp2)
  imgui.Text("SAMPFUNCS v5.3.3")
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp3)
  link = "https://blast.hk/threads/17/"
  imgui.Text(link)
  imgui_info_open(link)
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp4)
  imgui.Text("FYP")
  imgui_info_open("https://blast.hk/members/2/")
  imgui.NextColumn()

  imgui.Text("3")
  imgui.SetColumnWidth(-1, cp1)
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp2)
  imgui.Text("ImGui v1.52")
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp3)
  link = "https://github.com/ocornut/imgui/"
  imgui.Text(link)
  imgui_info_open(link)
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp4)
  imgui.Text("ocornut")
  imgui_info_open("https://github.com/ocornut/")
  imgui.NextColumn()

  imgui.Text("4")
  imgui.SetColumnWidth(-1, cp1)
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp2)
  imgui.Text("Moon ImGui v1.1.3")
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp3)
  link = "https://blast.hk/threads/19292/"
  imgui.Text(link)
  imgui_info_open(link)
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp4)
  imgui.Text("FYP")
  imgui_info_open("https://blast.hk/members/2/")
  imgui.NextColumn()

  imgui.Text("5")
  imgui.SetColumnWidth(-1, cp1)
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp2)
  imgui.Text("SAMP.Lua v2.0.5")
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp3)
  link = "https://github.com/THE-FYP/SAMP.Lua/"
  imgui.Text(link)
  imgui_info_open(link)
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp4)
  imgui.Text("FYP, ")
  imgui_info_open("https://blast.hk/members/2")
  imgui.SameLine()
  imgui.Text("MISTERGONWIK.")
  imgui_info_open("https://blast.hk/members/3")
  imgui.NextColumn()

  imgui.Text("6")
  imgui.SetColumnWidth(-1, cp1)
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp2)
  imgui.Text("lua-lockbox v0.1.0")
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp3)
  link = "https://github.com/somesocks/lua-lockbox/"
  imgui.Text(link)
  imgui_info_open(link)
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp4)
  imgui.Text("somesocks")
  imgui_info_open("https://github.com/somesocks/")
  imgui.NextColumn()

  imgui.Text("7")
  imgui.SetColumnWidth(-1, cp1)
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp2)
  imgui.Text("ImGui Custom v1.1.5")
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp3)
  link = "https://blast.hk/threads/22080/"
  imgui.Text(link)
  imgui_info_open(link)
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp4)
  imgui.Text("DonHomka")
  imgui_info_open("https://blast.hk/members/161656/")
  imgui.NextColumn()

  imgui.Text("8")
  imgui.SetColumnWidth(-1, cp1)
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp2)
  imgui.Text("RKeys v1.0.7")
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp3)
  link = "https://blast.hk/threads/22145/"
  imgui.Text(link)
  imgui_info_open(link)
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp4)
  imgui.Text("DonHomka")
  imgui_info_open("https://blast.hk/members/161656/")
  imgui.NextColumn()

  imgui.Text("9")
  imgui.SetColumnWidth(-1, cp1)
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp2)
  imgui.Text("SupportTools")
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp3)
  link = "https://github.com/Yafis/SupportTools/"
  imgui.Text(link)
  imgui_info_open(link)
  imgui.NextColumn()
  imgui.SetColumnWidth(-1, cp4)
  imgui.Text("Yafis")
  imgui_info_open("https://github.com/Yafis/")
  imgui.NextColumn()

  imgui.Columns(1)
  imgui.EndChild()
end


--[[
1. Moonloader VERSION - https://blast.hk/threads/13305/ - FYP https://blast.hk/members/2/ hnnssy https://blast.hk/members/66797/ EvgeN 1137 https://blast.hk/members/1/
2. SAMPFUNCS v5.3.3 - https://blast.hk/threads/17/ - FYP https://blast.hk/members/2/
3. ImGui v1.52 - https://github.com/ocornut/imgui - ocornut https://github.com/ocornut/
4. Moon ImGui v1.1.3 - https://blast.hk/threads/19292/ - FYP https://blast.hk/members/2
5. SAMP.Lua v2.0.5 - https://github.com/THE-FYP/SAMP.Lua - FYP https://blast.hk/members/2 MISTERGONWIK https://blast.hk/members/3/
6. lua-lockbox - https://github.com/somesocks/lua-lockbox - somesocks https://github.com/somesocks/
7. ImGui Custom v1.1.5 - https://blast.hk/threads/22080/ - DonHomka https://blast.hk/members/161656/
8. RKeys v1.0.7 - https://blast.hk/threads/22145/ - DonHomka https
9. SupportTools - https://github.com/Yafis/SupportTools/ - Yafis https://github.com/Yafis/
]]

function imgui_info_open(link)
  if imgui.IsItemHovered() and imgui.IsMouseClicked(0) then
    local ffi = require 'ffi'
    ffi.cdef [[
			void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
			uint32_t __stdcall CoInitializeEx(void*, uint32_t);
		]]
    local shell32 = ffi.load 'Shell32'
    local ole32 = ffi.load 'Ole32'
    ole32.CoInitializeEx(nil, 2 + 4) -- COINIT_APARTMENTTHREADED | COINIT_DISABLE_OLE1DDE
    print(shell32.ShellExecuteA(nil, 'open', link, nil, nil, 1))
  end
end

function imgui_info_rightclick()
  if imgui.IsItemHovered(imgui.HoveredFlags.RootWindow) and imgui.IsMouseClicked(1) then
    cfg.only.info = true
  end
end

function imgui_settings()
  if not cfg.only.settings then
    ch5 = imgui.CollapsingHeader(u8"Настройки")
    if ch5 then
      imgui_settings_rightclick()
      imgui_settings_content()
    end
    if not ch5 then imgui_settings_rightclick() end
  else
    imgui_menu()
    imgui_settings_content()
  end
end

function imgui_settings_content()
  imgui.PushItemWidth(imgui.GetContentRegionAvailWidth())
  imgui.SliderInt(u8"##выбор вкладки настроек", iSettingsTab, 1, 15)
  if iSettingsTab.v ~= cfg.options.settingstab then
    cfg.options.settingstab = iSettingsTab.v
    inicfg.save(cfg, "support")
  end
  imgui.Separator()
  if iSettingsTab.v == 1 then imgui_settings_1_sup_hideandcol() end
  if iSettingsTab.v == 2 then imgui_settings_2_sms_hideandcol() end
  if iSettingsTab.v == 3 then imgui_settings_3_sup_funcs() end
  if iSettingsTab.v == 4 then imgui_settings_4_spur() end
  if iSettingsTab.v == 5 then imgui_settings_5_sup_messanger() end
  if iSettingsTab.v == 6 then imgui_settings_6_sms_messanger() end
  if iSettingsTab.v == 7 then imgui_settings_7_notepad() end
  if iSettingsTab.v == 8 then imgui_settings_8_logger() end
  if iSettingsTab.v == 9 then imgui_settings_9_logviewer() end
  if iSettingsTab.v == 10 then imgui_settings_10_histogram() end
  if iSettingsTab.v == 11 then imgui_settings_11_counter() end
  if iSettingsTab.v == 12 then imgui_settings_12_sup_sounds() end
  if iSettingsTab.v == 13 then imgui_settings_13_sms_sounds() end
  if iSettingsTab.v == 14 then imgui_settings_14_hotkeys() end
  if iSettingsTab.v == 15 then imgui_settings_15_extra() end
end

function imgui_settings_rightclick()
  if imgui.IsItemHovered(imgui.HoveredFlags.RootWindow) and imgui.IsMouseClicked(1) then
    cfg.only.settings = true
    inicfg.save(cfg, "support")
  end
end

function imgui_settings_1_sup_hideandcol()
  if imgui.Checkbox("##HideQuestionCheck", iHideQuestion) then
    cfg.options.HideQuestion = iHideQuestion.v
    inicfg.save(cfg, "support")
  end
  imgui.SameLine()
  if iHideQuestion.v then
    imgui.Text(u8("Скрывать вопросы в чате?"))
  else
    imgui.TextDisabled(u8"Скрывать вопросы в чате?")
  end

  if imgui.Checkbox("##HideAnswerCheck", iHideAnswer) then
    cfg.options.HideAnswer = iHideAnswer.v
    inicfg.save(cfg, "support")
  end
  imgui.SameLine()
  if iHideAnswer.v then
    imgui.Text(u8("Скрывать ваши ответы в чате?"))
  else
    imgui.TextDisabled(u8"Скрывать ваши ответы в чате?")
  end

  if imgui.Checkbox("##HideAnswerOthersCheck", iHideAnswerOthers) then
    cfg.options.HideAnswerOthers = iHideAnswerOthers.v
    inicfg.save(cfg, "support")
  end
  imgui.SameLine()
  if iHideAnswerOthers.v then
    imgui.Text(u8("Скрывать чужие ответы в чате?"))
  else
    imgui.TextDisabled(u8"Скрывать чужие ответы в чате?")
  end
  if not cfg.options.HideQuestion then
    if imgui.Checkbox("##ReplaceQuestionColorCheck", iReplaceQuestionColor) then
      cfg.options.ReplaceQuestionColor = iReplaceQuestionColor.v
      inicfg.save(cfg, "support")
    end
    imgui.SameLine()
    if iReplaceQuestionColor.v then
      imgui.Text(u8("Цвет вопросов в чате изменяется на: "))
      imgui.SameLine(295)
      imgui.Text("")
      imgui.SameLine()
      if imgui.ColorEdit4("##Qcolor", Qcolor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha + imgui.ColorEditFlags.NoOptions) then
        cfg.colors.QuestionColor = imgui.ImColor.FromFloat4(Qcolor.v[1], Qcolor.v[2], Qcolor.v[3], Qcolor.v[4]):GetU32()
        local r, g, b, a = imgui.ImColor.FromFloat4(Qcolor.v[1], Qcolor.v[2], Qcolor.v[3], Qcolor.v[4]):GetRGBA()
        Qcolor_HEX = "0x"..string.sub(bit.tohex(join_argb(a, r, g, b)), 3, 8)
        inicfg.save(cfg, "support")
      end
    else
      imgui.TextDisabled(u8"Изменять цвет вопросов в чате?")
    end
  end

  if not cfg.options.HideAnswer then
    if imgui.Checkbox("##ReplaceAnswerColorCheck", iReplaceAnswerColor) then
      cfg.options.ReplaceAnswerColor = iReplaceAnswerColor.v
      inicfg.save(cfg, "support")
    end
    imgui.SameLine()
    if iReplaceAnswerColor.v then
      imgui.Text(u8("Цвет ваших ответов в чате изменяется на: "))
      imgui.SameLine(295)
      imgui.Text("")
      imgui.SameLine()
      if imgui.ColorEdit4("##Acolor", Acolor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha + imgui.ColorEditFlags.NoOptions) then
        cfg.colors.AnswerColor = imgui.ImColor.FromFloat4(Acolor.v[1], Acolor.v[2], Acolor.v[3], Acolor.v[4]):GetU32()
        local r, g, b, a = imgui.ImColor.FromFloat4(Acolor.v[1], Acolor.v[2], Acolor.v[3], Acolor.v[4]):GetRGBA()
        Acolor_HEX = "0x"..string.sub(bit.tohex(join_argb(a, r, g, b)), 3, 8)
        inicfg.save(cfg, "support")
      end
    else imgui.TextDisabled(u8"Изменять цвет ваших ответов в чате?")
    end
  end

  if not cfg.options.HideAnswerOthers then
    if imgui.Checkbox("##ReplaceAnswerOthersColorCheck", iReplaceAnswerOthersColor) then
      cfg.options.ReplaceAnswerOthersColor = iReplaceAnswerOthersColor.v
      inicfg.save(cfg, "support")
    end
    imgui.SameLine()
    if iReplaceAnswerOthersColor.v then
      imgui.Text(u8("Цвет чужих ответов в чате изменяется на: "))
      imgui.SameLine(295)
      imgui.Text("")
      imgui.SameLine()
      if imgui.ColorEdit4("##Acolor1", Acolor1, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha + imgui.ColorEditFlags.NoOptions) then
        cfg.colors.AnswerColorOthers = imgui.ImColor.FromFloat4(Acolor1.v[1], Acolor1.v[2], Acolor1.v[3], Acolor1.v[4]):GetU32()
        local r, g, b, a = imgui.ImColor.FromFloat4(Acolor1.v[1], Acolor1.v[2], Acolor1.v[3], Acolor1.v[4]):GetRGBA()
        Acolor1_HEX = "0x"..string.sub(bit.tohex(join_argb(a, r, g, b)), 3, 8)
        inicfg.save(cfg, "support")
      end
    else imgui.TextDisabled(u8"Изменять цвет чужих ответов в чате?")
    end
  end
end

function imgui_settings_2_sms_hideandcol()
  if imgui.Checkbox("##HideSmsIn2", iHideSmsIn) then
    cfg.options.HideSmsIn = iHideSmsIn.v
    inicfg.save(cfg, "support")
  end
  imgui.SameLine()
  if iHideSmsIn.v then
    imgui.Text(u8("Скрывать входящие сообщения?"))
  else
    imgui.TextDisabled(u8"Скрывать входящие сообщения?")
  end

  if imgui.Checkbox("##HideSmsOut", iHideSmsOut) then
    cfg.options.HideSmsOut = iHideSmsOut.v
    inicfg.save(cfg, "support")
  end
  imgui.SameLine()
  if iHideSmsOut.v then
    imgui.Text(u8("Скрывать исходящие сообщения?"))
  else
    imgui.TextDisabled(u8"Скрывать исходящие сообщения?")
  end

  if imgui.Checkbox("##HideSmsReceived", iHideSmsReceived) then
    cfg.options.HideSmsReceived = iHideSmsReceived.v
    inicfg.save(cfg, "support")
  end
  imgui.SameLine()
  if iHideSmsReceived.v then
    imgui.Text(u8("Скрывать \"Сообщение доставлено\"?"))
  else
    imgui.TextDisabled(u8"Скрывать \"Сообщение доставлено\"?")
  end

  if not cfg.options.HideSmsIn then
    if imgui.Checkbox("##iReplaceSmsInColor", iReplaceSmsInColor) then
      cfg.options.ReplaceSmsInColor = iReplaceSmsInColor.v
      inicfg.save(cfg, "support")
    end
    imgui.SameLine()
    if iReplaceSmsInColor.v then
      imgui.Text(u8("Цвет входящих сообщений изменяется на: "))
      imgui.SameLine(295)
      imgui.Text("")
      imgui.SameLine()
      if imgui.ColorEdit4("##SmsInColor", SmsInColor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha + imgui.ColorEditFlags.NoOptions) then
        cfg.colors.SmsInColor = imgui.ImColor.FromFloat4(SmsInColor.v[1], SmsInColor.v[2], SmsInColor.v[3], SmsInColor.v[4]):GetU32()
        local r, g, b, a = imgui.ImColor.FromFloat4(SmsInColor.v[1], SmsInColor.v[2], SmsInColor.v[3], SmsInColor.v[4]):GetRGBA()
        SmsInColor_HEX = "0x"..string.sub(bit.tohex(join_argb(a, r, g, b)), 3, 8)
        inicfg.save(cfg, "support")
      end
    else
      imgui.TextDisabled(u8"Изменять цвет входящих сообщений?")
    end
  end

  if not cfg.options.HideSmsOut then
    if imgui.Checkbox("##iReplaceSmsOutColor", iReplaceSmsOutColor) then
      cfg.options.ReplaceSmsOutColor = iReplaceSmsOutColor.v
      inicfg.save(cfg, "support")
    end
    imgui.SameLine()
    if iReplaceSmsOutColor.v then
      imgui.Text(u8("Цвет исходящих сообщений изменяется на: "))
      imgui.SameLine(295)
      imgui.Text("")
      imgui.SameLine()
      if imgui.ColorEdit4("##SmsOutColor", SmsOutColor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha + imgui.ColorEditFlags.NoOptions) then
        cfg.colors.SmsOutColor = imgui.ImColor.FromFloat4(SmsOutColor.v[1], SmsOutColor.v[2], SmsOutColor.v[3], SmsOutColor.v[4]):GetU32()
        local r, g, b, a = imgui.ImColor.FromFloat4(SmsOutColor.v[1], SmsOutColor.v[2], SmsOutColor.v[3], SmsOutColor.v[4]):GetRGBA()
        SmsOutColor_HEX = "0x"..string.sub(bit.tohex(join_argb(a, r, g, b)), 3, 8)
        inicfg.save(cfg, "support")
      end
    else imgui.TextDisabled(u8"Изменять цвет исходящих сообщений в чате?")
    end
  end

  if not cfg.options.HideSmsReceived then
    if imgui.Checkbox("##iReplaceSmsReceivedColor", iReplaceSmsReceivedColor) then
      cfg.options.ReplaceSmsReceivedColor = iReplaceSmsReceivedColor.v
      inicfg.save(cfg, "support")
    end
    imgui.SameLine()
    if iReplaceSmsReceivedColor.v then
      imgui.Text(u8("Цвет \"SMS доставлено\" изменяется на: "))
      imgui.SameLine(295)
      imgui.Text("")
      imgui.SameLine()
      if imgui.ColorEdit4("##SmsReceivedColor", SmsReceivedColor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha + imgui.ColorEditFlags.NoOptions) then
        cfg.colors.SmsReceivedColor = imgui.ImColor.FromFloat4(SmsReceivedColor.v[1], SmsReceivedColor.v[2], SmsReceivedColor.v[3], SmsReceivedColor.v[4]):GetU32()
        local r, g, b, a = imgui.ImColor.FromFloat4(SmsReceivedColor.v[1], SmsReceivedColor.v[2], SmsReceivedColor.v[3], SmsReceivedColor.v[4]):GetRGBA()
        SmsReceivedColor_HEX = "0x"..string.sub(bit.tohex(join_argb(a, r, g, b)), 3, 8)
        inicfg.save(cfg, "support")
      end
    else
      imgui.TextDisabled(u8"Изменять \"Сообщение доставлено\" в чате?")
    end
  end
end

function imgui_settings_3_sup_funcs()
  if imgui.Checkbox("##autosduty", iautosduty) then
    cfg.supfuncs.autosduty = iautosduty.v
    inicfg.save(cfg, "support")
  end
  imgui.SameLine()
  if iautosduty.v then
    imgui.Text(u8("Авто /sduty включено."))
  else
    imgui.TextDisabled(u8"Включить авто /sduty?")
  end
  imgui.SameLine()
  imgui.TextDisabled("(?)")
  if imgui.IsItemHovered() then
    imgui.SetTooltip(u8"Если включено, при входе в игру рабочий день саппорта начнется автоматически.\nРаботает не только при старте игры, но и при потере соединения/реконнекте.")
  end

  if imgui.Checkbox("##ifastrespondviachat", ifastrespondviachat) then
    cfg.supfuncs.fastrespondviachat = ifastrespondviachat.v
    if cfg.supfuncs.fastrespondviachat then main_init_hotkeys() end
    inicfg.save(cfg, "support")
  end
  imgui.SameLine()
  if ifastrespondviachat.v then
    imgui.Text(u8("Быстрый ответ включен."))
  else
    imgui.TextDisabled(u8"Включить быстрый ответ?")
  end
  imgui.SameLine()
  imgui.TextDisabled("(?)")
  if imgui.IsItemHovered() then
    imgui.SetTooltip(u8"По нажатию хоткея открывается чат с /pm id последнего вопроса.")
  end

  if imgui.Checkbox("##iSupHh", iSupHh) then
    cfg.supfuncs.suphh = iSupHh.v
    inicfg.save(cfg, "support")
  end
  imgui.SameLine()
  if iSupHh.v then
    imgui.Text(u8("/hh в чате включено."))
  else
    imgui.TextDisabled(u8"Включить /hh в чате?")
  end
  imgui.SameLine()
  imgui.TextDisabled("(?)")
  if imgui.IsItemHovered() then
    imgui.SetTooltip(u8"/hh id [id дома]\nБерет из house.txt информацию о домах.")
  end

  if imgui.Checkbox("##iSupHc", iSupHc) then
    cfg.supfuncs.suphc = iSupHc.v
    inicfg.save(cfg, "support")
  end
  imgui.SameLine()
  if iSupHc.v then
    imgui.Text(u8("/hc в чате включено."))
  else
    imgui.TextDisabled(u8"Включить /hc в чате?")
  end
  imgui.SameLine()
  imgui.TextDisabled("(?)")
  if imgui.IsItemHovered() then
    imgui.SetTooltip(u8"/hc id [id/название тс]\nБерет из vehicle.txt информацию о т/с.")
  end

  if imgui.Checkbox("##iunanswereddialog", iunanswereddialog) then
    cfg.supfuncs.unanswereddialog = iunanswereddialog.v
    if cfg.supfuncs.unanswereddialog then main_init_hotkeys() end
    inicfg.save(cfg, "support")
  end
  imgui.SameLine()
  if iunanswereddialog.v then
    imgui.Text(u8("Список проигнорированных вопросов включен.")) else
    imgui.TextDisabled(u8"Включить список проигнорированных вопросов?")
  end
  imgui.SameLine()
  imgui.TextDisabled("(?)")
  if imgui.IsItemHovered() then
    imgui.SetTooltip(u8"По нажатию хоткея открывается список с проигнорированными саппортами вопросами.\nВ поле можно ввести порядковый номер вопроса, либо порядковый номер, пробел, ответ.")
  end

  if imgui.Checkbox("##fastrespondviadialoglastid", ifastrespondviadialoglastid) then
    cfg.supfuncs.fastrespondviadialoglastid = ifastrespondviadialoglastid.v
    if cfg.supfuncs.fastrespondviadialoglastid then main_init_hotkeys() end
    inicfg.save(cfg, "support")
  end
  imgui.SameLine()
  if ifastrespondviadialoglastid.v then
    imgui.Text(u8("Быстрый ответ по базе на последний вопрос по базе ответов включен."))
  else
    imgui.TextDisabled(u8"Включить быстрый ответ на последний вопрос по базе ответов?")
  end
  imgui.SameLine()
  imgui.TextDisabled("(?)")
  if imgui.IsItemHovered() then
    imgui.SetTooltip(u8"По нажатию хоткея открывается диалог с вариантами быстрого ответа на последний заданный вопрос.\nВопросы берутся из базы, заполненной заранее.")
  end

  if imgui.Checkbox("##fastrespondviadialog", ifastrespondviadialog) then
    cfg.supfuncs.fastrespondviadialog = ifastrespondviadialog.v
    inicfg.save(cfg, "support")
  end
  imgui.SameLine()
  if ifastrespondviadialog.v then
    imgui.Text(u8("Быстрый ответ по базе ответов включен."))
  else
    imgui.TextDisabled(u8"Включить быстрый ответ по базе ответов?")
  end
  imgui.SameLine()
  imgui.TextDisabled("(?)")
  if imgui.IsItemHovered() then
    imgui.SetTooltip(u8"\" / pm id \" открывает диалог с вариантами быстрого ответа.\nВопросы берутся из базы, заполненной заранее.")
  end
  if ifastrespondviadialog.v or ifastrespondviadialoglastid.v then
    imgui_settings_extra_setupFRbase()
  end
end

function imgui_settings_4_spur()
  if imgui.Checkbox("##включить spur", iSpurActive) then
    cfg.spur.active = iSpurActive.v
    main_init_hotkeys()
    inicfg.save(cfg, "support")
  end
  if iSpurActive.v then
    imgui.SameLine()
    imgui.Text(u8("Шпора активирована!"))
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8:encode("По нажатию хоткея открывает отдельное окно с изображениями.\nИнформация об изображениях и категориях берётся из файла spur.txt\nЭтот файл находится в папке moonloder\\resource\\sup\\"..mode.."\nОбычно в картинках содержится информация о моде."))
    end
    if imgui.RadioButton(u8"Загружать все изображения при старте игры", iSpurMode, 0) then
      cfg.spur.mode = iSpurMode.v
      inicfg.save(cfg, "support")
    end
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8:encode("Рекомендуется для мощных ПК. Загружает все изображения при старте игры."))
    end
    if imgui.RadioButton(u8"Загружать изображения при активации", iSpurMode, 1) then
      cfg.spur.mode = iSpurMode.v
      inicfg.save(cfg, "support")
    end
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8:encode("Рекомендуется для слабых ПК. Загружает изображения только тогда, когда их нужно показать."))
    end
    if imgui.RadioButton(u8"Загружать каждое изображение при активации", iSpurMode, 2) then
      cfg.spur.mode = iSpurMode.v
      inicfg.save(cfg, "support")
    end
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8:encode("Рекомендуется для очень слабых ПК. Загружает изображение только тогда, когда нужно его показать.\nПосле использования выгружает из паияти."))
    end

    imgui.Checkbox("Read-only", read_only)
    imgui.SameLine()
    imgui.TextDisabled(u8"Как настроить?")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8:encode([[Файл заполняется так:
"картинка" = "имя в подменю" = "меню"
Заполняйте в том порядке, в каком хотите, чтобы у вас отображалось в меню.
Сохранить - Ctrl + Enter, отменить изменения - Esc.]]))
    end
    if read_only.v then
      flagsS = imgui.InputTextFlags.EnterReturnsTrue + imgui.InputTextFlags.ReadOnly
    else
      flagsS = imgui.InputTextFlags.EnterReturnsTrue
    end
    if imgui.InputTextMultiline("##notepad4", textSpur, imgui.ImVec2(-1, imgui.GetContentRegionAvail().y), flagsS) then
      local file = io.open( getGameDirectory().."\\moonloader\\resource\\sup\\"..mode.."\\spur.txt", "w" )
      if file then
        file:write(u8:decode(textSpur.v))
        printStringNow("Text saved", 1000)
        file:close()
        main_init_supdoc()
      else
        printStringNow("Text not saved", 1000)
      end
    end
    if imgui.IsItemActive() then
      lockPlayerControl(true)
    else
      lockPlayerControl(false)
    end
  else
    imgui.SameLine()
    imgui.TextDisabled(u8"Включить шпору?")
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8:encode("По нажатию хоткея открывает отдельное окно с изображениями.\nИнформация об изображениях и категориях берётся из файла spur.txt\nЭтот файл находится в папке moonloder\\resource\\sup\\"..mode.."\nОбычно в картинках содержится информация о моде."))
    end
  end

end

function imgui_settings_5_sup_messanger()
  if imgui.Checkbox("##включить мессенджер", iMessangerActiveSDUTY) then
    if iMessangerActiveSDUTY.v then
      cfg.messanger.mode = 1
    else
      if cfg.messanger.activesms then
        cfg.messanger.mode = 2
      end
    end
    cfg.messanger.activesduty = iMessangerActiveSDUTY.v
    if cfg.messanger.activesduty then main_init_hotkeys() end
    inicfg.save(cfg, "support")
  end
  if iMessangerActiveSDUTY.v then
    imgui.SameLine()
    imgui.Text(u8("Мессенджер sduty активирован!"))
    imgui.PushItemWidth(325)
    imgui.SliderInt(u8"Высота мессенджера", iMessangerHeight, 100, 1000)
    if iMessangerHeight.v ~= cfg.messanger.Height then
      cfg.messanger.Height = iMessangerHeight.v
      inicfg.save(cfg, "support")
    end

    if imgui.Checkbox("##imhk1", imhk1) then
      cfg.messanger.hotkey1 = imhk1.v
      if cfg.messanger.hotkey1 then main_init_hotkeys() end
      inicfg.save(cfg, "support")
    end
    imgui.SameLine()
    if imhk1.v then
      imgui.Text(u8("Хоткей открытия мессенджера sduty включен."))
    else
      imgui.TextDisabled(u8"Включить хоткей открытия мессенджера sduty?")
    end
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8"По нажатию хоткея открывается sduty мессенджер.")
    end


    if imgui.Checkbox("##imhk2", imhk2) then
      cfg.messanger.hotkey2 = imhk2.v
      if cfg.messanger.hotkey2 then main_init_hotkeys() end
      inicfg.save(cfg, "support")
    end
    imgui.SameLine()
    if imhk2.v then
      imgui.Text(u8("Хоткей быстрого ответа через мессенджер sduty включен."))
    else
      imgui.TextDisabled(u8"Включить хоткей быстрого ответа через мессенджер sduty?")
    end
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8"По нажатию хоткея открывается/закрывается мессенджер sduty с последним вопросом.\nЕсли он уже открыт, то фокус меняется на последний вопрос.")
    end
    imgui.Text(u8("Цвета вопросов в диалогах:"))
    imgui.SameLine(210)
    imgui.Text("")
    imgui.SameLine()
    if imgui.ColorEdit4(u8"Цвет вопросов", iQcolor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.AlphaBar) then
      cfg.messanger.QuestionColor = imgui.ImColor.FromFloat4(iQcolor.v[1], iQcolor.v[2], iQcolor.v[3], iQcolor.v[4]):GetU32()
      inicfg.save(cfg, "support")
    end
    imgui.SameLine()
    if imgui.ColorEdit4(u8"Цвет времени вопроса", iQuestionTimeColor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.AlphaBar) then
      cfg.messanger.QuestionTimeColor = imgui.ImColor.FromFloat4(iQuestionTimeColor.v[1], iQuestionTimeColor.v[2], iQuestionTimeColor.v[3], iQuestionTimeColor.v[4]):GetU32()
      inicfg.save(cfg, "support")
    end

    imgui.SameLine()
    if imgui.ColorEdit4(u8"Цвет заголовка вопроса", iQuestionHeaderColor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.AlphaBar) then
      cfg.messanger.QuestionHeaderColor = imgui.ImColor.FromFloat4(iQuestionHeaderColor.v[1], iQuestionHeaderColor.v[2], iQuestionHeaderColor.v[3], iQuestionHeaderColor.v[4]):GetU32()
      inicfg.save(cfg, "support")
    end

    imgui.SameLine()
    if imgui.ColorEdit4(u8"Цвет текста вопроса", iQuestionTextColor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.AlphaBar) then
      cfg.messanger.QuestionTextColor = imgui.ImColor.FromFloat4(iQuestionTextColor.v[1], iQuestionTextColor.v[2], iQuestionTextColor.v[3], iQuestionTextColor.v[4]):GetU32()
      inicfg.save(cfg, "support")
    end

    if cfg.messanger.QuestionColor ~= imgui.ImColor(66.3, 150.45, 249.9, 102):GetU32() or cfg.messanger.QuestionTimeColor ~= imgui.ImColor(0, 0, 0):GetU32() or cfg.messanger.QuestionHeaderColor ~= imgui.ImColor(255, 255, 255):GetU32() or cfg.messanger.QuestionTextColor ~= imgui.ImColor(255, 255, 255):GetU32() then
      imgui.SameLine()
      if imgui.Button(u8"Сброс") then
        cfg.messanger.QuestionColor = imgui.ImColor(66.3, 150.45, 249.9, 102):GetU32()
        cfg.messanger.QuestionTimeColor = imgui.ImColor(0, 0, 0):GetU32()
        cfg.messanger.QuestionHeaderColor = imgui.ImColor(255, 255, 255):GetU32()
        cfg.messanger.QuestionTextColor = imgui.ImColor(255, 255, 255):GetU32()
        iQcolor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.QuestionColor):GetFloat4())
        iQuestionTimeColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.QuestionTimeColor ):GetFloat4())
        iQuestionHeaderColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.QuestionHeaderColor):GetFloat4())
        iQuestionTextColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.QuestionTextColor):GetFloat4())
        inicfg.save(cfg, "support")
      end
    end

    imgui.Text(u8("Цвета ваших ответов в диалогах:"))
    imgui.SameLine(210)
    imgui.Text("")
    imgui.SameLine()
    if imgui.ColorEdit4(u8"Цвет фона ваших ответов", iAcolor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.AlphaBar) then
      cfg.messanger.AnswerColor = imgui.ImColor.FromFloat4(iAcolor.v[1], iAcolor.v[2], iAcolor.v[3], iAcolor.v[4]):GetU32()
      inicfg.save(cfg, "support")
    end

    imgui.SameLine()
    if imgui.ColorEdit4(u8"Цвет времени ответа", iAnswerTimeColor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.AlphaBar) then
      cfg.messanger.AnswerTimeColor = imgui.ImColor.FromFloat4(iAnswerTimeColor.v[1], iAnswerTimeColor.v[2], iAnswerTimeColor.v[3], iAnswerTimeColor.v[4]):GetU32()
      inicfg.save(cfg, "support")
    end

    imgui.SameLine()
    if imgui.ColorEdit4(u8"Цвет заголовка ответа", iAnswerHeaderColor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.AlphaBar) then
      cfg.messanger.AnswerHeaderColor = imgui.ImColor.FromFloat4(iAnswerHeaderColor.v[1], iAnswerHeaderColor.v[2], iAnswerHeaderColor.v[3], iAnswerHeaderColor.v[4]):GetU32()
      inicfg.save(cfg, "support")
    end

    imgui.SameLine()
    if imgui.ColorEdit4(u8"Цвет текста ответа", iAnswerTextColor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.AlphaBar) then
      cfg.messanger.AnswerTextColor = imgui.ImColor.FromFloat4(iAnswerTextColor.v[1], iAnswerTextColor.v[2], iAnswerTextColor.v[3], iAnswerTextColor.v[4]):GetU32()
      inicfg.save(cfg, "support")
    end
    --
    if cfg.messanger.AnswerColor ~= imgui.ImColor(66.3, 150.45, 249.9, 102):GetU32() or cfg.messanger.AnswerTimeColor ~= imgui.ImColor(0, 0, 0):GetU32() or cfg.messanger.AnswerHeaderColor ~= imgui.ImColor(255, 255, 255):GetU32() or cfg.messanger.AnswerTextColor ~= imgui.ImColor(255, 255, 255):GetU32() then
      imgui.SameLine()
      if imgui.Button(u8"Сброс") then
        cfg.messanger.AnswerColor = imgui.ImColor(66.3, 150.45, 249.9, 102):GetU32()
        cfg.messanger.AnswerTimeColor = imgui.ImColor(0, 0, 0):GetU32()
        cfg.messanger.AnswerHeaderColor = imgui.ImColor(255, 255, 255):GetU32()
        cfg.messanger.AnswerTextColor = imgui.ImColor(255, 255, 255):GetU32()
        iAcolor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.AnswerColor):GetFloat4())
        iAnswerTimeColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.AnswerTimeColor ):GetFloat4())
        iAnswerHeaderColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.AnswerHeaderColor):GetFloat4())
        iAnswerTextColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.AnswerTextColor):GetFloat4())
        inicfg.save(cfg, "support")
      end
    end
    --
    imgui.Text(u8("Цвета чужих ответов в диалогах:"))
    imgui.SameLine(210)
    imgui.Text("")
    imgui.SameLine()
    if imgui.ColorEdit4(u8"Цвет фона ответов других саппортов", iAcolor1, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.AlphaBar) then
      cfg.messanger.AnswerColorOthers = imgui.ImColor.FromFloat4(iAcolor1.v[1], iAcolor1.v[2], iAcolor1.v[3], iAcolor1.v[4]):GetU32()
      inicfg.save(cfg, "support")
    end

    imgui.SameLine()
    if imgui.ColorEdit4(u8"Цвет времени ответа других саппортов", iAnswerTimeOthersColor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.AlphaBar) then
      cfg.messanger.AnswerTimeOthersColor = imgui.ImColor.FromFloat4(iAnswerTimeOthersColor.v[1], iAnswerTimeOthersColor.v[2], iAnswerTimeOthersColor.v[3], iAnswerTimeOthersColor.v[4]):GetU32()
      inicfg.save(cfg, "support")
    end

    imgui.SameLine()
    if imgui.ColorEdit4(u8"Цвет заголовка ответа других саппортов", iAnswerHeaderOthersColor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.AlphaBar) then
      cfg.messanger.AnswerHeaderOthersColor = imgui.ImColor.FromFloat4(iAnswerHeaderOthersColor.v[1], iAnswerHeaderOthersColor.v[2], iAnswerHeaderOthersColor.v[3], iAnswerHeaderOthersColor.v[4]):GetU32()
      inicfg.save(cfg, "support")
    end

    imgui.SameLine()
    if imgui.ColorEdit4(u8"Цвет текста ответа других саппортов", iAnswerTextOthersColor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.AlphaBar) then
      cfg.messanger.AnswerTextOthersColor = imgui.ImColor.FromFloat4(iAnswerTextOthersColor.v[1], iAnswerTextOthersColor.v[2], iAnswerTextOthersColor.v[3], iAnswerTextOthersColor.v[4]):GetU32()
      inicfg.save(cfg, "support")
    end
    --
    if cfg.messanger.AnswerColorOthers ~= imgui.ImColor(66.3, 150.45, 249.9, 102):GetU32() or cfg.messanger.AnswerTimeOthersColor ~= imgui.ImColor(0, 0, 0):GetU32() or cfg.messanger.AnswerHeaderOthersColor ~= imgui.ImColor(255, 255, 255):GetU32() or cfg.messanger.AnswerTextOthersColor ~= imgui.ImColor(255, 255, 255):GetU32() then
      imgui.SameLine()
      if imgui.Button(u8"Сброс") then
        cfg.messanger.AnswerColorOthers = imgui.ImColor(66.3, 150.45, 249.9, 102):GetU32()
        cfg.messanger.AnswerTimeOthersColor = imgui.ImColor(0, 0, 0):GetU32()
        cfg.messanger.AnswerHeaderOthersColor = imgui.ImColor(255, 255, 255):GetU32()
        cfg.messanger.AnswerTextOthersColor = imgui.ImColor(255, 255, 255):GetU32()
        iAcolor1 = imgui.ImFloat4(imgui.ImColor(cfg.messanger.AnswerColorOthers):GetFloat4())
        iAnswerTimeOthersColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.AnswerTimeOthersColor ):GetFloat4())
        iAnswerHeaderOthersColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.AnswerHeaderOthersColor):GetFloat4())
        iAnswerTextOthersColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.AnswerTextOthersColor):GetFloat4())
        inicfg.save(cfg, "support")
      end
    end
    if imgui.Checkbox("##включить suphh", isuphh) then
      cfg.messanger.suphh = isuphh.v
      inicfg.save(cfg, "support")
    end
    if isuphh.v then
      imgui.SameLine()
      imgui.Text(u8"/hh [номер дома] работает!")
      imgui.SameLine()
      imgui.TextDisabled("(?)")
      if imgui.IsItemHovered() then
        imgui.SetTooltip(u8"Берет из house.txt информацию о домах.\nРаботает в sduty мессенджере.")
      end
    else
      imgui.SameLine()
      imgui.TextDisabled(u8"Включить /hh [номер дома]")
      imgui.SameLine()
      imgui.TextDisabled("(?)")
      if imgui.IsItemHovered() then
        imgui.SetTooltip(u8"Берет из house.txt информацию о домах.\nРаботает в sduty мессенджере.")
      end
    end
    if imgui.Checkbox("##включить suphc", isuphc) then
      cfg.messanger.suphc = isuphc.v
      inicfg.save(cfg, "support")
    end
    if isuphc.v then
      imgui.SameLine()
      imgui.Text(u8"/hc [id] [name] работает!")
      imgui.SameLine()
      imgui.TextDisabled("(?)")
      if imgui.IsItemHovered() then
        imgui.SetTooltip(u8"Берет из vehicle.txt информацию о т/с.\nРаботает в sduty мессенджере.")
      end
    else
      imgui.SameLine()
      imgui.TextDisabled(u8"Включить /hc [id] [name]")
      imgui.SameLine()
      imgui.TextDisabled("(?)")
      if imgui.IsItemHovered() then
        imgui.SetTooltip(u8"Берет из vehicle.txt информацию о т/с.\nРаботает в sduty мессенджере.")
      end
    end

    if imgui.Checkbox("##включить supfr", isupfr) then
      cfg.messanger.supfr = isupfr.v
      inicfg.save(cfg, "support")
    end
    if isupfr.v then
      imgui.SameLine()
      imgui.Text(u8"/fr [id] [text] работает!")
      imgui.SameLine()
      imgui.TextDisabled("(?)")
      if imgui.IsItemHovered() then
        imgui.SetTooltip(u8"Берёт быстрые ответы из базы.\nРаботает в sduty мессенджере.")
      end
    else
      imgui.SameLine()
      imgui.TextDisabled(u8"Включить /fr [id] [text]")
      imgui.SameLine()
      imgui.TextDisabled("(?)")
      if imgui.IsItemHovered() then
        imgui.SetTooltip(u8"Берёт быстрые ответы из базы.\nРаботает в sduty мессенджере.")
      end
    end
    if cfg.messanger.supfr then
      imgui_settings_extra_setupFRbase()
    end
  else
    imgui.SameLine()
    imgui.TextDisabled(u8"Включить sduty мессенджер?")
  end
end

function imgui_settings_6_sms_messanger()
  if imgui.Checkbox("##включить sms мессенджер", iMessangerActiveSMS) then
    if iMessangerActiveSMS.v then
      cfg.messanger.mode = 2
    else
      if cfg.messanger.activesduty then
        cfg.messanger.mode = 1
        print('mode')
      end
    end
    cfg.messanger.activesms = iMessangerActiveSMS.v
    if cfg.messanger.activesms then main_init_hotkeys() end
    inicfg.save(cfg, "support")
  end
  if iMessangerActiveSMS.v then
    imgui.SameLine()
    imgui.Text(u8("Мессенджер sms активирован!"))
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8"/smsblacklist - просмотреть чёрный список смс")
    end
    imgui.PushItemWidth(325)
    imgui.SliderInt(u8"Высота мессенджера##1", iMessangerHeight, 100, 1000)
    if iMessangerHeight.v ~= cfg.messanger.Height then
      cfg.messanger.Height = iMessangerHeight.v
      inicfg.save(cfg, "support")
    end

    if imgui.Checkbox("##imhk3", imhk3) then
      cfg.messanger.hotkey3 = imhk3.v
      if cfg.messanger.hotkey3 then main_init_hotkeys() end
      inicfg.save(cfg, "support")
    end
    imgui.SameLine()
    if imhk3.v then
      imgui.Text(u8("Хоткей открытия мессенджера sms включен."))
    else
      imgui.TextDisabled(u8"Включить хоткей открытия мессенджера sms?")
    end
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8"По нажатию хоткея открывается sms мессенджер.")
    end


    if imgui.Checkbox("##imhk4", imhk4) then
      cfg.messanger.hotkey4 = imhk4.v
      if cfg.messanger.hotkey4 then main_init_hotkeys() end
      inicfg.save(cfg, "support")
    end
    imgui.SameLine()
    if imhk4.v then
      imgui.Text(u8("Хоткей быстрого ответа через мессенджер sms включен."))
    else
      imgui.TextDisabled(u8"Включить хоткей быстрого ответа через мессенджер sms?")
    end
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8"По нажатию хоткея открывается/закрывается мессенджер sms с последним сообщением.\nЕсли он уже открыт, то фокус меняется на последнее сообщение.")
    end


    if imgui.Checkbox("##imhk5", imhk5) then
      cfg.messanger.hotkey5 = imhk5.v
      if cfg.messanger.hotkey5 then main_init_hotkeys() end
      inicfg.save(cfg, "support")
    end
    imgui.SameLine()
    if imhk5.v then
      imgui.Text(u8("Хоткей создания диалога через sms мессенджер включен."))
    else
      imgui.TextDisabled(u8"Включить хоткей создания диалога через sms мессенджер?")
    end
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8"По нажатию хоткея открывается мессенджер смс с фокусом на ввод ника/id нового собеседника.")
    end


    imgui.Text(u8("Цвета входящих смс в диалогах:"))
    imgui.SameLine(210)
    imgui.Text("")
    imgui.SameLine()
    if imgui.ColorEdit4(u8"Цвет фона входящего смс", iINcolor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.AlphaBar) then
      cfg.messanger.SmsInColor = imgui.ImColor.FromFloat4(iINcolor.v[1], iINcolor.v[2], iINcolor.v[3], iINcolor.v[4]):GetU32()
      inicfg.save(cfg, "support")
    end
    imgui.SameLine()
    if imgui.ColorEdit4(u8"Цвет времени входящего смс", iSmsInTimeColor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.AlphaBar) then
      cfg.messanger.SmsInTimeColor = imgui.ImColor.FromFloat4(iSmsInTimeColor.v[1], iSmsInTimeColor.v[2], iSmsInTimeColor.v[3], iSmsInTimeColor.v[4]):GetU32()
      inicfg.save(cfg, "support")
    end

    imgui.SameLine()
    if imgui.ColorEdit4(u8"Цвет заголовка входящего смс", iSmsInHeaderColor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.AlphaBar) then
      cfg.messanger.SmsInHeaderColor = imgui.ImColor.FromFloat4(iSmsInHeaderColor.v[1], iSmsInHeaderColor.v[2], iSmsInHeaderColor.v[3], iSmsInHeaderColor.v[4]):GetU32()
      inicfg.save(cfg, "support")
    end

    imgui.SameLine()
    if imgui.ColorEdit4(u8"Цвет текста входящего смс", iSmsInTextColor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.AlphaBar) then
      cfg.messanger.SmsInTextColor = imgui.ImColor.FromFloat4(iSmsInTextColor.v[1], iSmsInTextColor.v[2], iSmsInTextColor.v[3], iSmsInTextColor.v[4]):GetU32()
      inicfg.save(cfg, "support")
    end

    if cfg.messanger.SmsInColor ~= imgui.ImColor(66.3, 150.45, 249.9, 102):GetU32() or cfg.messanger.SmsInTimeColor ~= imgui.ImColor(0, 0, 0):GetU32() or cfg.messanger.SmsInHeaderColor ~= imgui.ImColor(255, 255, 255):GetU32() or cfg.messanger.SmsInTextColor ~= imgui.ImColor(255, 255, 255):GetU32() then
      imgui.SameLine()
      if imgui.Button(u8"Сброс") then
        cfg.messanger.SmsInColor = imgui.ImColor(66.3, 150.45, 249.9, 102):GetU32()
        cfg.messanger.SmsInTimeColor = imgui.ImColor(0, 0, 0):GetU32()
        cfg.messanger.SmsInHeaderColor = imgui.ImColor(255, 255, 255):GetU32()
        cfg.messanger.SmsInTextColor = imgui.ImColor(255, 255, 255):GetU32()
        iINcolor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.SmsInColor):GetFloat4())
        iSmsInTimeColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.SmsInTimeColor ):GetFloat4())
        iSmsInHeaderColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.SmsInHeaderColor):GetFloat4())
        iSmsInTextColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.SmsInTextColor):GetFloat4())
        inicfg.save(cfg, "support")
      end
    end

    imgui.Text(u8("Цвета исходящих смс в диалогах:"))
    imgui.SameLine(210)
    imgui.Text("")
    imgui.SameLine()


    if imgui.ColorEdit4(u8"Цвет фона исходящих смс", iOUTcolor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.AlphaBar) then
      cfg.messanger.SmsOutColor = imgui.ImColor.FromFloat4(iOUTcolor.v[1], iOUTcolor.v[2], iOUTcolor.v[3], iOUTcolor.v[4]):GetU32()
      inicfg.save(cfg, "support")
    end

    imgui.SameLine()
    if imgui.ColorEdit4(u8"Цвет времени исходящего смс", iSmsOutTimeColor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.AlphaBar) then
      cfg.messanger.SmsOutTimeColor = imgui.ImColor.FromFloat4(iSmsOutTimeColor.v[1], iSmsOutTimeColor.v[2], iSmsOutTimeColor.v[3], iSmsOutTimeColor.v[4]):GetU32()
      inicfg.save(cfg, "support")
    end

    imgui.SameLine()
    if imgui.ColorEdit4(u8"Цвет заголовка исходящего смс", iSmsOutHeaderColor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.AlphaBar) then
      cfg.messanger.SmsOutHeaderColor = imgui.ImColor.FromFloat4(iSmsOutHeaderColor.v[1], iSmsOutHeaderColor.v[2], iSmsOutHeaderColor.v[3], iSmsOutHeaderColor.v[4]):GetU32()
      inicfg.save(cfg, "support")
    end

    imgui.SameLine()
    if imgui.ColorEdit4(u8"Цвет текста исходящего смс", iSmsOutTextColor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.AlphaBar) then
      cfg.messanger.SmsOutTextColor = imgui.ImColor.FromFloat4(iSmsOutTextColor.v[1], iSmsOutTextColor.v[2], iSmsOutTextColor.v[3], iSmsOutTextColor.v[4]):GetU32()
      inicfg.save(cfg, "support")
    end
    --
    if cfg.messanger.SmsOutColor ~= imgui.ImColor(66.3, 150.45, 249.9, 102):GetU32() or cfg.messanger.SmsOutTimeColor ~= imgui.ImColor(0, 0, 0):GetU32() or cfg.messanger.SmsOutHeaderColor ~= imgui.ImColor(255, 255, 255):GetU32() or cfg.messanger.SmsOutTextColor ~= imgui.ImColor(255, 255, 255):GetU32() then
      imgui.SameLine()
      if imgui.Button(u8"Сброс") then
        cfg.messanger.SmsOutColor = imgui.ImColor(66.3, 150.45, 249.9, 102):GetU32()
        cfg.messanger.SmsOutTimeColor = imgui.ImColor(0, 0, 0):GetU32()
        cfg.messanger.SmsOutHeaderColor = imgui.ImColor(255, 255, 255):GetU32()
        cfg.messanger.SmsOutTextColor = imgui.ImColor(255, 255, 255):GetU32()
        iOUTcolor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.SmsOutColor):GetFloat4())
        iSmsOutTimeColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.SmsOutTimeColor ):GetFloat4())
        iSmsOutHeaderColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.SmsOutHeaderColor):GetFloat4())
        iSmsOutTextColor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.SmsOutTextColor):GetFloat4())
        inicfg.save(cfg, "support")
      end
    end
    if imgui.Checkbox("##включить сохранение бд смс", iStoreSMS) then
      if cfg.messanger.storesms == false then ingamelaunch = true imgui_messanger_sms_loadDB() end
      cfg.messanger.storesms = iStoreSMS.v
      inicfg.save(cfg, "support")
    end
    if iStoreSMS.v then
      imgui.SameLine()
      kol = 0
      for k, v in pairs(sms) do
        kol = kol + 1
      end
      imgui.Text(u8:encode("СУБД активна. Количество диалогов: "..kol.."."))
      imgui.NewLine()
      imgui.SameLine(32)
      imgui.TextWrapped(u8:encode("Путь к БД: "..smsfile))
    else
      imgui.SameLine()
      imgui.TextDisabled(u8"Сохранять БД смс?")
      --imgui_messanger_sms_loadDB()
      if doesFileExist(smsfile) then
        imgui.SameLine()
        if imgui.Button(u8("Удалить БД")) then
          os.remove(smsfile)
          sms = {}
        end
      end
    end
    --
  else
    imgui.SameLine()
    imgui.TextDisabled(u8"Включить sms мессенджер?")
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8"/smsblacklist - просмотреть чёрный список смс")
    end
  end
end

function imgui_settings_7_notepad()
  if imgui.Checkbox("##включить блокнот", iNotepadActive) then
    cfg.notepad.active = iNotepadActive.v
    if cfg.notepad.active then main_init_hotkeys() end
    inicfg.save(cfg, "support")
  end

  if iNotepadActive.v then
    imgui.SameLine()
    imgui.Text(u8"Блокнот активирован!")

    if imgui.Checkbox("##inotepadhk", inotepadhk) then
      cfg.notepad.hotkey = inotepadhk.v
      if cfg.notepad.hotkey then main_init_hotkeys() end
      inicfg.save(cfg, "support")
    end
    imgui.SameLine()
    if inotepadhk.v then
      imgui.Text(u8("Хоткей для быстрого открытия блокнота включен."))
    else
      imgui.TextDisabled(u8"Включить хоткей для быстрого открытия блокнота?")
    end
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8"По нажатию хоткея открывается блокнот.")
    end

    imgui.PushItemWidth(325)
    imgui.SliderInt(u8"Количество строк блокнота", iNotepadLines, 1, 50)
    if iNotepadLines.v ~= cfg.notepad.lines then
      cfg.notepad.lines = iNotepadLines.v
      inicfg.save(cfg, "support")
    end
  else
    imgui.SameLine()
    imgui.TextDisabled(u8"Включить блокнот?")
  end
end

function imgui_settings_8_logger()
  if imgui.Checkbox("##включить логгер", iLogBool) then
    if cfg.log.logger == false then sup_updateStats() end
    cfg.log.logger = iLogBool.v
    inicfg.save(cfg, "support")
  end
  if iLogBool.v then
    imgui.SameLine()
    imgui.Text(u8:encode("Ответы пишутся в suplog.csv! Записей в логе: "..countall.."."))
  else
    imgui.SameLine()
    imgui.TextDisabled(u8"Включить запись ответов в лог?")

    if doesFileExist(file) then
      imgui.SameLine()
      if imgui.Button(u8("Удалить лог")) then
        os.remove(file)
        countall = 0
      end
    end
  end
  if imgui.Checkbox("##ShowTimeToUpdateCSV", iShowTimeToUpdateCSV) then
    cfg.options.ShowTimeToUpdateCSV = iShowTimeToUpdateCSV.v
    inicfg.save(cfg, "support")
  end
  imgui.SameLine()
  if iShowTimeToUpdateCSV.v and cfg.log.logger then
    imgui.Text(u8("Показывать время обработки лога?"))
  else
    imgui.TextDisabled(u8"Показывать время обработки лога?")
  end
end

function imgui_settings_9_logviewer()

  if imgui.Checkbox("##включить лог", iLogActive) then
    cfg.log.active = iLogActive.v
    inicfg.save(cfg, "support")
  end
  if iLogActive.v then
    imgui.SameLine()
    imgui.Text(u8"Лог ответов активирован!")
    imgui.PushItemWidth(325)
    imgui.SliderInt(u8"Высота лога", iLogHeight, 1, 500)
    if iLogHeight.v ~= cfg.log.height then
      cfg.log.height = iLogHeight.v
      inicfg.save(cfg, "support")
    end
  else
    imgui.SameLine()
    imgui.TextDisabled(u8"Включить лог ответов?")
  end
end

function imgui_settings_10_histogram()
  if imgui.Checkbox("##включить Гистограмма", iStatsActive) then
    cfg.stats.active = iStatsActive.v
    inicfg.save(cfg, "support")
  end
  if iStatsActive.v then
    imgui.SameLine()
    imgui.Text(u8"Гистограмма активирована!")
    imgui.PushItemWidth(325)
    imgui.SliderInt(u8"Высота гистограммы", iStatsHeight, 1, 500)
    if iStatsHeight.v ~= cfg.stats.height then
      cfg.stats.height = iStatsHeight.v
      inicfg.save(cfg, "support")
    end
  else
    imgui.SameLine()
    imgui.TextDisabled(u8"Включить гистограмму?")
  end
end

function imgui_settings_11_counter()
  if imgui.Checkbox("##включить Счётчик", iCounterActive) then
    cfg.counter.active = iCounterActive.v
    inicfg.save(cfg, "support")
  end
  if iCounterActive.v then
    imgui.SameLine()
    imgui.Text(u8"Счётчик саппорта активирован!")
    imgui.PushItemWidth(200)
    imgui.SliderInt(u8"Год ##выбор cYear", cYear, 2012, tonumber(os.date("%Y")))
    imgui.PushItemWidth(200)
    imgui.SliderInt(u8"Месяц ##выбор cMonth", cMonth, 1, 12)
    imgui.PushItemWidth(200)
    imgui.SliderInt(u8"День ##выбор cDay", cDay, 1, 31)
    imgui.PushItemWidth(200)
    imgui.SliderInt(u8"Час ##выбор cHour", cHour, 1, 24)
    imgui.PushItemWidth(200)
    imgui.SliderInt(u8"Минута ##выбор cMin", cMin, 1, 60)
    if cMin.v ~= cfg.counter.minute or cHour.v ~= cfg.counter.hour or cDay.v ~= cfg.counter.day or cMonth.v ~= cfg.counter.month or cYear.v ~= cfg.counter.year then
      cfg.counter.minute = cMin.v
      cfg.counter.hour = cHour.v
      cfg.counter.day = cDay.v
      cfg.counter.month = cMonth.v
      cfg.counter.year = cYear.v
      inicfg.save(cfg, "support")
    end
  else
    imgui.SameLine()
    imgui.TextDisabled(u8"Включить счётчик саппорта?")
  end
end

function imgui_settings_12_sup_sounds()
  if imgui.Checkbox("##SoundQuestion", iSoundQuestion) then
    cfg.options.SoundQuestion = iSoundQuestion.v
    inicfg.save(cfg, "support")
  end
  if iSoundQuestion.v then
    imgui.SameLine()
    imgui.PushItemWidth(300)
    imgui.SliderInt(u8"Звук вопроса", iSoundQuestionNumber, 1, 100)
    if iSoundQuestionNumber.v ~= cfg.options.SoundQuestionNumber then
      PLAYQ = true
      cfg.options.SoundQuestionNumber = iSoundQuestionNumber.v
      inicfg.save(cfg, "support")
    end
  else
    imgui.SameLine()
    imgui.TextDisabled(u8"Включить уведомление о вопросе?")
  end
  if imgui.Checkbox("##SoundAnswer", iSoundAnswer) then
    cfg.options.SoundAnswer = iSoundAnswer.v
    inicfg.save(cfg, "support")
  end
  if iSoundAnswer.v then
    imgui.SameLine()
    imgui.PushItemWidth(300)
    imgui.SliderInt(u8"Звук ответа", iSoundAnswerNumber, 1, 100)
    if iSoundAnswerNumber.v ~= cfg.options.SoundAnswerNumber then
      PLAYA = true
      cfg.options.SoundAnswerNumber = iSoundAnswerNumber.v
      inicfg.save(cfg, "support")
    end
  else
    imgui.SameLine()
    imgui.TextDisabled(u8"Включить уведомление об ответе?")
  end
  if imgui.Checkbox("##SoundAnswerOthers", iSoundAnswerOthers) then
    cfg.options.SoundAnswerOthers = iSoundAnswerOthers.v
    inicfg.save(cfg, "support")
  end
  if iSoundAnswerOthers.v then
    imgui.SameLine()
    imgui.PushItemWidth(300)
    imgui.SliderInt(u8"Звук чужого ответа", iSoundAnswerOthersNumber, 1, 100)
    if iSoundAnswerOthersNumber.v ~= cfg.options.SoundAnswerOthersNumber then
      PLAYA1 = true
      cfg.options.SoundAnswerOthersNumber = iSoundAnswerOthersNumber.v
      inicfg.save(cfg, "support")
    end
  else
    imgui.SameLine()
    imgui.TextDisabled(u8"Включить уведомление о чужом ответе?")
  end
end

function imgui_settings_13_sms_sounds()
  if imgui.Checkbox("##SoundSmsIn", iSoundSmsIn) then
    cfg.options.SoundSmsIn = iSoundSmsIn.v
    inicfg.save(cfg, "support")
  end
  if iSoundSmsIn.v then
    imgui.SameLine()
    imgui.PushItemWidth(300)
    imgui.SliderInt(u8"Звук входящего сообщения", iSoundSmsInNumber, 1, 100)
    if iSoundSmsInNumber.v ~= cfg.options.SoundSmsInNumber then
      PLAYSMSIN = true
      cfg.options.SoundSmsInNumber = iSoundSmsInNumber.v
      inicfg.save(cfg, "support")
    end
  else
    imgui.SameLine()
    imgui.TextDisabled(u8"Включить уведомление о входящем сообщении?")
  end

  if imgui.Checkbox("##SoundSmsOut", iSoundSmsOut) then
    cfg.options.SoundSmsOut = iSoundSmsOut.v
    inicfg.save(cfg, "support")
  end
  if iSoundSmsOut.v then
    imgui.SameLine()
    imgui.PushItemWidth(300)
    imgui.SliderInt(u8"Звук исходящего сообщения", iSoundSmsOutNumber, 1, 100)
    if iSoundSmsOutNumber.v ~= cfg.options.SoundSmsOutNumber then
      PLAYSMSOUT = true
      cfg.options.SoundSmsOutNumber = iSoundSmsOutNumber.v
      inicfg.save(cfg, "support")
    end
  else
    imgui.SameLine()
    imgui.TextDisabled(u8"Включить уведомление об исходящем сообщении?")
  end
end

function imgui_settings_14_hotkeys()
  hotk.v = {}
  hotke.v = hotkeys["hkMainMenu"]
  if ihk.HotKey("##hkMainMenu", hotke, hotk, 100) then
    if not hk.isHotKeyDefined(hotke.v) then
      if hk.isHotKeyDefined(hotk.v) then
        hk.unRegisterHotKey(hotk.v)
      end
    end
    cfg.hkMainMenu = {}
    for k, v in pairs(hotke.v) do
      table.insert(cfg.hkMainMenu, v)
    end
    if cfg.hkMainMenu == {} then cfg["hkMainMenu"][1] = 90 end
    inicfg.save(cfg, "support")
    main_init_hotkeys()
  end
  imgui.SameLine()
  imgui.Text(u8"Горячая клавиша активации скрипта.")
  imgui.SameLine()
  imgui.TextDisabled("(?)")
  if imgui.IsItemHovered() then
    imgui.SetTooltip(u8"По нажатию хоткея открывается окно скрипта.")
  end
  if cfg.spur.active then
    hotk.v = {}
    hotke.v = hotkeys["hkSpur"]
    if ihk.HotKey("##hkSpur", hotke, hotk, 100) then
      if not hk.isHotKeyDefined(hotke.v) then
        if hk.isHotKeyDefined(hotk.v) then
          hk.unRegisterHotKey(hotk.v)
        end
      end
      cfg.hkSpur = {}
      for k, v in pairs(hotke.v) do
        table.insert(cfg.hkSpur, v)
      end
      if cfg.hkSpur == {} then cfg["hkSpur"][1] = 88 end
      inicfg.save(cfg, "support")
      main_init_hotkeys()
    end
    imgui.SameLine()
    imgui.Text(u8"Горячая клавиша активации шпоры.")
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8"По нажатию хоткея открывается окно шпоры.")
    end
  end
  if iunanswereddialog.v then
    hotk.v = {}
    hotke.v = hotkeys["hkUnAn"]
    if ihk.HotKey(u8"##hkUnAn", hotke, hotk, 100) then
      if not hk.isHotKeyDefined(hotke.v) then
        if hk.isHotKeyDefined(hotk.v) then
          hk.unRegisterHotKey(hotk.v)
        end
      end
      cfg.hkUnAn = {}
      for k, v in pairs(hotke.v) do
        table.insert(cfg.hkUnAn, v)
      end
      if cfg.hkUnAn == {} then cfg["hkUnAn"][1] = 112 end
      inicfg.save(cfg, "support")
      main_init_hotkeys()
    end
    imgui.SameLine()
    imgui.Text(u8"Горячая клавиша списка проигнорированных вопросов.")
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8"По нажатию хоткея открывается список с проигнорированными саппортами вопросами.\nВ поле можно ввести порядковый номер вопроса, либо порядковый номер, пробел, ответ.")
    end
  end

  if ifastrespondviachat.v then
    hotk.v = {}
    hotke.v = hotkeys["hkSupFRChat"]
    if ihk.HotKey("##hkSupFRChat", hotke, hotk, 100) then
      if not hk.isHotKeyDefined(hotke.v) then
        if hk.isHotKeyDefined(hotk.v) then
          hk.unRegisterHotKey(hotk.v)
        end
      end
      cfg.hkSupFRChat = {}
      for k, v in pairs(hotke.v) do
        table.insert(cfg.hkSupFRChat, v)
      end
      if cfg.hkSupFRChat == {} then cfg["hkSupFRChat"][1] = 49 end
      inicfg.save(cfg, "support")
      main_init_hotkeys()
    end
    imgui.SameLine()
    imgui.Text(u8"Горячая клавиша быстрого ответа в чат.")
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8"По нажатию хоткея открывается чат с /pm id последнего вопроса.")
    end
  end

  if ifastrespondviadialoglastid.v then
    hotk.v = {}
    hotke.v = hotkeys["hkFRbyBASE"]
    if ihk.HotKey(u8"##hkFRbyBASE", hotke, hotk, 100) then
      if not hk.isHotKeyDefined(hotke.v) then
        if hk.isHotKeyDefined(hotk.v) then
          hk.unRegisterHotKey(hotk.v)
        end
      end
      cfg.hkFRbyBASE = {}
      for k, v in pairs(hotke.v) do
        table.insert(cfg.hkFRbyBASE, v)
      end
      if cfg.hkFRbyBASE == {} then cfg["hkFRbyBASE"][1] = 50 end
      inicfg.save(cfg, "support")
      main_init_hotkeys()
    end
    imgui.SameLine()
    imgui.Text(u8"Горячая клавиша быстрого ответа на последний вопрос по базе готовых ответов.")
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8"По нажатию хоткея открывается список с проигнорированными саппортами вопросами.\nВ поле можно ввести порядковый номер вопроса, либо порядковый номер, пробел, ответ.")
    end
  end

  if inotepadhk.v then
    hotk.v = {}
    hotke.v = hotkeys["hkFO_notepad"]
    if ihk.HotKey(u8"##hkFO_notepad", hotke, hotk, 100) then
      if not hk.isHotKeyDefined(hotke.v) then
        if hk.isHotKeyDefined(hotk.v) then
          hk.unRegisterHotKey(hotk.v)
        end
      end
      cfg.hkFO_notepad = {}
      for k, v in pairs(hotke.v) do
        table.insert(cfg.hkFO_notepad, v)
      end
      if cfg.hkFO_notepad == {} then cfg["hkFO_notepad"][1] = 51 end
      inicfg.save(cfg, "support")
      main_init_hotkeys()
    end
    imgui.SameLine()
    imgui.Text(u8"Горячая клавиша открытия блокнота.")
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8"По нажатию хоткея открывается/закрывается блокнот.")
    end
  end

  if imhk1.v then
    hotk.v = {}
    hotke.v = hotkeys["hkm1"]
    if ihk.HotKey(u8"##hkm1", hotke, hotk, 100) then
      if not hk.isHotKeyDefined(hotke.v) then
        if hk.isHotKeyDefined(hotk.v) then
          hk.unRegisterHotKey(hotk.v)
        end
      end
      cfg.hkm1 = {}
      for k, v in pairs(hotke.v) do
        table.insert(cfg.hkm1, v)
      end
      if cfg.hkm1 == {} then cfg["hkm1"][1] = 51 end
      inicfg.save(cfg, "support")
      main_init_hotkeys()
    end
    imgui.SameLine()
    imgui.Text(u8"Горячая клавиша открытия мессенджера sduty.")
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8"По нажатию хоткея открывается/закрывается мессенджер sduty.")
    end
  end

  if imhk2.v then
    hotk.v = {}
    hotke.v = hotkeys["hkm2"]
    if ihk.HotKey(u8"##hkm2", hotke, hotk, 100) then
      if not hk.isHotKeyDefined(hotke.v) then
        if hk.isHotKeyDefined(hotk.v) then
          hk.unRegisterHotKey(hotk.v)
        end
      end
      cfg.hkm2 = {}
      for k, v in pairs(hotke.v) do
        table.insert(cfg.hkm2, v)
      end
      if cfg.hkm2 == {} then cfg["hkm2"][2] = 52 end
      inicfg.save(cfg, "support")
      main_init_hotkeys()
    end
    imgui.SameLine()
    imgui.Text(u8"Горячая клавиша быстрого ответа через мессенджер sduty.")
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8"По нажатию хоткея открывается/закрывается мессенджер sduty с последним вопросом.\nЕсли он уже открыт, то фокус меняется на последний вопрос.")
    end
  end

  if imhk3.v then
    hotk.v = {}
    hotke.v = hotkeys["hkm3"]
    if ihk.HotKey(u8"##hkm3", hotke, hotk, 100) then
      if not hk.isHotKeyDefined(hotke.v) then
        if hk.isHotKeyDefined(hotk.v) then
          hk.unRegisterHotKey(hotk.v)
        end
      end
      cfg.hkm3 = {}
      for k, v in pairs(hotke.v) do
        table.insert(cfg.hkm3, v)
      end
      if cfg.hkm3 == {} then cfg["hkm3"][3] = 53 end
      inicfg.save(cfg, "support")
      main_init_hotkeys()
    end
    imgui.SameLine()
    imgui.Text(u8"Горячая клавиша открытия мессенджера sms.")
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8"По нажатию хоткея открывается sms мессенджер.")
    end
  end

  if imhk4.v then
    hotk.v = {}
    hotke.v = hotkeys["hkm4"]
    if ihk.HotKey(u8"##hkm4", hotke, hotk, 100) then
      if not hk.isHotKeyDefined(hotke.v) then
        if hk.isHotKeyDefined(hotk.v) then
          hk.unRegisterHotKey(hotk.v)
        end
      end
      cfg.hkm4 = {}
      for k, v in pairs(hotke.v) do
        table.insert(cfg.hkm4, v)
      end
      if cfg.hkm4 == {} then cfg["hkm4"][4] = 54 end
      inicfg.save(cfg, "support")
      main_init_hotkeys()
    end
    imgui.SameLine()
    imgui.Text(u8"Горячая клавиша быстрого ответа через мессенджер sms.")
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8"По нажатию хоткея открывается/закрывается мессенджер sms с последним сообщением.\nЕсли он уже открыт, то фокус меняется на последнее сообщение.")
    end
  end

  if imhk5.v then
    hotk.v = {}
    hotke.v = hotkeys["hkm5"]
    if ihk.HotKey(u8"##hkm5", hotke, hotk, 100) then
      if not hk.isHotKeyDefined(hotke.v) then
        if hk.isHotKeyDefined(hotk.v) then
          hk.unRegisterHotKey(hotk.v)
        end
      end
      cfg.hkm5 = {}
      for k, v in pairs(hotke.v) do
        table.insert(cfg.hkm5, v)
      end
      if cfg.hkm5 == {} then cfg["hkm5"][5] = 55 end
      inicfg.save(cfg, "support")
      main_init_hotkeys()
    end
    imgui.SameLine()
    imgui.Text(u8"Горячая клавиша создания диалога через sms мессенджер.")
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8"По нажатию хоткея открывается мессенджер смс с фокусом на ввод ника/id нового собеседника.")
    end
  end
end

function imgui_settings_15_extra()
  if imgui.Checkbox(u8"Рендерить курсор силами gta?", MouseDrawCursor) then
    cfg.options.MouseDrawCursor = MouseDrawCursor.v
    imgui.GetIO().MouseDrawCursor = MouseDrawCursor.v
    inicfg.save(cfg, "support")
  end
  imgui.SameLine()
  imgui.TextDisabled("(?)")
  if imgui.IsItemHovered() then
    imgui.SetTooltip(u8"Если включить, курсор будет отображаться на скринах.\nМинус: курсор будет немного лагать.")
  end
  if imgui.Checkbox(u8"Звуковое уведомление при успешной проверке лицензии?", iSoundGranted) then
    chk.license.sound = iSoundGranted.v
    inicfg.save(chk, "suplicense")
  end
  imgui.SameLine()
  imgui.TextDisabled("(?)")
  if imgui.IsItemHovered() then
    imgui.SetTooltip(u8"Вкл/выкл звуковое уведомление об успешной проверки лицензии.")
  end
end

function imgui_settings_extra_setupFRbase()
  imgui.SameLine()
  imgui.TextDisabled(u8"Как настроить ответы?")
  if imgui.IsItemHovered() then
    imgui.SetTooltip(u8"Одна строка - один быстрый ответ, всё просто.\nНумеровать не нужно, при сохранении каждой строке будет присвоен номер.\nCtrl+Enter - сохранить, Esc - Отменить изменения, Ctrl+Z, Ctrl+A, Ctrl+C, Ctrl+X, Ctrl+V - работают!")
  end
  if imgui.InputTextMultiline("##notepad3", fr, imgui.ImVec2(-1, imgui.GetContentRegionAvail().y), imgui.InputTextFlags.EnterReturnsTrue) then
    frtext = fr.v
    str = 1
    frtextF = ""
    for s in string.gmatch(u8:decode(frtext), "[^\n]+") do
      number, text = string.match(s, "(%d+%.) (.+)")
      if number == nil then
        frtextF = frtextF..str..". "..s.."\n"
      else
        frtextF = frtextF..str..". "..text.."\n"
      end
      str = str + 1
    end
    frtextF = string.gsub(frtextF, "\n$", "")
    fr.v = u8:encode(frtextF)
    frtext = fr.v
    frtext = string.gsub(frtext, "\n", "\\n")
    frtext = string.gsub(frtext, "\t", "\\t")
    cfg.notepad.fr = u8:decode(frtext)
    if inicfg.save(cfg, "support") then
      printStringNow("Text saved", 1000)
      sup_ParseFastRespond_fr()
    else
      printStringNow("Text not saved", 1000)
    end
  end
  if imgui.IsItemActive() then
    lockPlayerControl(true)
  else
    lockPlayerControl(false)
  end
end

--style
function apply_custom_style()
  imgui.SwitchContext()
  local style = imgui.GetStyle()
  local colors = style.Colors
  local clr = imgui.Col
  local ImVec4 = imgui.ImVec4
  style.WindowRounding = 2.0
  style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
  style.ChildWindowRounding = 2.0
  style.FrameRounding = 2.0
  style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
  style.ScrollbarSize = 13.0
  style.ScrollbarRounding = 0
  style.GrabMinSize = 8.0
  style.GrabRounding = 1.0
  colors[clr.Text] = ImVec4(1.00, 1.00, 1.00, 1.00)
  colors[clr.TextDisabled] = ImVec4(0.50, 0.50, 0.50, 1.00)
  colors[clr.WindowBg] = ImVec4(0.06, 0.06, 0.06, 0.94)
  colors[clr.ChildWindowBg] = ImVec4(1.00, 1.00, 1.00, 0.00)
  colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
  colors[clr.ComboBg] = colors[clr.PopupBg]
  colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
  colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.FrameBg] = ImVec4(0.16, 0.29, 0.48, 0.54)
  colors[clr.FrameBgHovered] = ImVec4(0.26, 0.59, 0.98, 0.40)
  colors[clr.FrameBgActive] = ImVec4(0.26, 0.59, 0.98, 0.67)
  colors[clr.TitleBg] = ImVec4(0.04, 0.04, 0.04, 1.00)
  colors[clr.TitleBgActive] = ImVec4(0.16, 0.29, 0.48, 1.00)
  colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
  colors[clr.MenuBarBg] = ImVec4(0.14, 0.14, 0.14, 1.00)
  colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.53)
  colors[clr.ScrollbarGrab] = ImVec4(0.31, 0.31, 0.31, 1.00)
  colors[clr.ScrollbarGrabHovered] = ImVec4(0.41, 0.41, 0.41, 1.00)
  colors[clr.ScrollbarGrabActive] = ImVec4(0.51, 0.51, 0.51, 1.00)
  colors[clr.CheckMark] = ImVec4(0.26, 0.59, 0.98, 1.00)
  colors[clr.SliderGrab] = ImVec4(0.24, 0.52, 0.88, 1.00)
  colors[clr.SliderGrabActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
  colors[clr.Button] = ImVec4(0.26, 0.59, 0.98, 0.40)
  colors[clr.ButtonHovered] = ImVec4(0, 0, 0, 1.00)
  colors[clr.ButtonActive] = ImVec4(0.06, 0.53, 0.98, 1.00)
  colors[clr.Header] = ImVec4(0.26, 0.59, 0.98, 0.31)
  colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
  colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
  colors[clr.Separator] = colors[clr.Border]
  colors[clr.SeparatorHovered] = ImVec4(0.26, 0.59, 0.98, 0.78)
  colors[clr.SeparatorActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
  colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
  colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
  colors[clr.ResizeGripActive] = ImVec4(0.26, 0.59, 0.98, 0.95)
  colors[clr.CloseButton] = ImVec4(0.41, 0.41, 0.41, 0.50)
  colors[clr.CloseButtonHovered] = ImVec4(0.98, 0.39, 0.36, 1.00)
  colors[clr.CloseButtonActive] = ImVec4(0.98, 0.39, 0.36, 1.00)
  colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
  colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
  colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
  colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
  colors[clr.TextSelectedBg] = ImVec4(0.26, 0.59, 0.98, 0.35)
  colors[clr.ModalWindowDarkening] = ImVec4(0.80, 0.80, 0.80, 0.35)
end


----------------------------------HELPERS---------------------------------------
do
  function join_argb(a, r, g, b)
    local argb = b -- b
    argb = bit.bor(argb, bit.lshift(g, 8)) -- g
    argb = bit.bor(argb, bit.lshift(r, 16)) -- r
    argb = bit.bor(argb, bit.lshift(a, 24)) -- a
    return argb
  end

  function string.rlower(s)
    s = s:lower()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:lower()
    local output = ''
    for i = 1, strlen do
      local ch = s:byte(i)
      if ch >= 192 and ch <= 223 then -- upper russian characters
        output = output .. russian_characters[ch + 32]
      elseif ch == 168 then -- Ё
        output = output .. russian_characters[184]
      else
        output = output .. string.char(ch)
      end
    end
    return output
  end

  function string.rupper(s)
    s = s:upper()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:upper()
    local output = ''
    for i = 1, strlen do
      local ch = s:byte(i)
      if ch >= 224 and ch <= 255 then -- lower russian characters
        output = output .. russian_characters[ch - 32]
      elseif ch == 184 then -- ё
        output = output .. russian_characters[168]
      else
        output = output .. string.char(ch)
      end
    end
    return output
  end


  local function exportstring( s )
    return string.format("%q", s)
  end

  --// The Save Function
  function table.save( tbl, filename )
    local charS, charE = "   ", "\n"
    local file, err = io.open( filename, "wb" )
    if err then return err end

    -- initiate variables for save procedure
    local tables, lookup = { tbl }, { [tbl] = 1 }
    file:write( "return {"..charE )

    for idx, t in ipairs( tables ) do
      file:write( "-- Table: {"..idx.."}"..charE )
      file:write( "{"..charE )
      local thandled = {}

      for i, v in ipairs( t ) do
        thandled[i] = true
        local stype = type( v )
        -- only handle value
        if stype == "table" then
          if not lookup[v] then
            table.insert( tables, v )
            lookup[v] = #tables
          end
          file:write( charS.."{"..lookup[v].."},"..charE )
        elseif stype == "string" then
          file:write( charS..exportstring( v )..","..charE )
        elseif stype == "number" then
          file:write( charS..tostring( v )..","..charE )
        end
      end

      for i, v in pairs( t ) do
        -- escape handled values
        if (not thandled[i]) then

          local str = ""
          local stype = type( i )
          -- handle index
          if stype == "table" then
            if not lookup[i] then
              table.insert( tables, i )
              lookup[i] = #tables
            end
            str = charS.."[{"..lookup[i].."}]="
          elseif stype == "string" then
            str = charS.."["..exportstring( i ).."]="
          elseif stype == "number" then
            str = charS.."["..tostring( i ).."]="
          end

          if str ~= "" then
            stype = type( v )
            -- handle value
            if stype == "table" then
              if not lookup[v] then
                table.insert( tables, v )
                lookup[v] = #tables
              end
              file:write( str.."{"..lookup[v].."},"..charE )
            elseif stype == "string" then
              file:write( str..exportstring( v )..","..charE )
            elseif stype == "number" then
              file:write( str..tostring( v )..","..charE )
            end
          end
        end
      end
      file:write( "},"..charE )
    end
    file:write( "}" )
    file:close()
  end

  --// The Load Function
  function table.load( sfile )
    local ftables, err = loadfile( sfile )
    if err then return _, err end
    local tables = ftables()
    for idx = 1, #tables do
      local tolinki = {}
      for i, v in pairs( tables[idx] ) do
        if type( v ) == "table" then
          tables[idx][i] = tables[v[1]]
        end
        if type( i ) == "table" and tables[i[1]] then
          table.insert( tolinki, { i, tables[i[1]] } )
        end
      end
      -- link indices
      for _, v in ipairs( tolinki ) do
        tables[idx][v[2]], tables[idx][v[1]] = tables[idx][v[1]], nil
      end
    end
    return tables[1]
  end


  function GetImageWidthHeight(file)
    local fileinfo = type(file)
    if type(file) == "string" then
      file = assert(io.open(file, "rb"))
    else
      fileinfo = file:seek("cur")
    end
    local function refresh()
      if type(fileinfo) == "number" then
        file:seek("set", fileinfo)
      else
        file:close()
      end
    end
    local width, height = 0, 0
    file:seek("set", 1)
    -- Detect if PNG
    if file:read(3) == "PNG" then
      --[[
			The strategy is
			1. Seek to position 0x10
			2. Get value in big-endian order
		]]
      file:seek("set", 16)
      local widthstr, heightstr = file:read(4), file:read(4)
      if type(fileinfo) == "number" then
        file:seek("set", fileinfo)
      else
        file:close()
      end
      width = widthstr:sub(1, 1):byte() * 16777216 + widthstr:sub(2, 2):byte() * 65536 + widthstr:sub(3, 3):byte() * 256 + widthstr:sub(4, 4):byte()
      height = heightstr:sub(1, 1):byte() * 16777216 + heightstr:sub(2, 2):byte() * 65536 + heightstr:sub(3, 3):byte() * 256 + heightstr:sub(4, 4):byte()
      return width, height
    end
    file:seek("set")
    -- Detect if BMP
    if file:read(2) == "BM" then
      --[[
			The strategy is:
			1. Seek to position 0x12
			2. Get value in little-endian order
		]]
      file:seek("set", 18)
      local widthstr, heightstr = file:read(4), file:read(4)
      refresh()
      width = widthstr:sub(4, 4):byte() * 16777216 + widthstr:sub(3, 3):byte() * 65536 + widthstr:sub(2, 2):byte() * 256 + widthstr:sub(1, 1):byte()
      height = heightstr:sub(4, 4):byte() * 16777216 + heightstr:sub(3, 3):byte() * 65536 + heightstr:sub(2, 2):byte() * 256 + heightstr:sub(1, 1):byte()
      return width, height
    end
    -- Detect if JPG/JPEG
    file:seek("set")
    if file:read(2) == "\255\216" then
      --[[
			The strategy is
			1. Find necessary markers
			2. Store biggest value in variable
			3. Return biggest value
		]]
      local lastb, curb = 0, 0
      local xylist = {}
      local sstr = file:read(1)
      while sstr ~= nil do
        lastb = curb
        curb = sstr:byte()
        if (curb == 194 or curb == 192) and lastb == 255 then
          file:seek("cur", 3)
          local sizestr = file:read(4)
          local h = sizestr:sub(1, 1):byte() * 256 + sizestr:sub(2, 2):byte()
          local w = sizestr:sub(3, 3):byte() * 256 + sizestr:sub(4, 4):byte()
          if w > width and h > height then
            width = w
            height = h
          end
        end
        sstr = file:read(1)
      end
      if width > 0 and height > 0 then
        refresh()
        return width, height
      end
    end
    file:seek("set")
    -- Detect if GIF
    if file:read(4) == "GIF8" then
      --[[
			The strategy is
			1. Seek to 0x06 position
			2. Extract value in little-endian order
		]]
      file:seek("set", 6)
      width, height = file:read(1):byte() + file:read(1):byte() * 256, file:read(1):byte() + file:read(1):byte() * 256
      refresh()
      return width, height
    end
    -- More image support
    file:seek("set")
    -- Detect if Photoshop Document
    if file:read(4) == "8BPS" then
      --[[
			The strategy is
			1. Seek to position 0x0E
			2. Get value in big-endian order
		]]
      file:seek("set", 14)
      local heightstr, widthstr = file:read(4), file:read(4)
      refresh()
      width = widthstr:sub(1, 1):byte() * 16777216 + widthstr:sub(2, 2):byte() * 65536 + widthstr:sub(3, 3):byte() * 256 + widthstr:sub(4, 4):byte()
      height = heightstr:sub(1, 1):byte() * 16777216 + heightstr:sub(2, 2):byte() * 65536 + heightstr:sub(3, 3):byte() * 256 + heightstr:sub(4, 4):byte()
      return width, height
    end
    file:seek("end", - 18)
    -- Detect if Truevision TGA file
    if file:read(10) == "TRUEVISION" then
      --[[
			The strategy is
			1. Seek to position 0x0C
			2. Get image width and height in little-endian order
		]]
      file:seek("set", 12)
      width = file:read(1):byte() + file:read(1):byte() * 256
      height = file:read(1):byte() + file:read(1):byte() * 256
      refresh()
      return width, height
    end
    file:seek("set")
    -- Detect if JPEG XR/Tagged Image File (Format)
    if file:read(2) == "II" then
      -- It would slow, tell me how to get it faster
      --[[
			The strategy is
			1. Read all file contents
			2. Find "Btomlong" and "Rghtlong" string
			3. Extract values in big-endian order(strangely, II stands for Intel byte ordering(little-endian) but it's in big-endian)
		]]
      temp = file:read("*a")
      btomlong = {temp:find("Btomlong")}
      rghtlong = {temp:find("Rghtlong")}
      if #btomlong == 2 and #rghtlong == 2 then
        heightstr = temp:sub(btomlong[2] + 1, btomlong[2] + 5)
        widthstr = temp:sub(rghtlong[2] + 1, rghtlong[2] + 5)
        refresh()
        width = widthstr:sub(1, 1):byte() * 16777216 + widthstr:sub(2, 2):byte() * 65536 + widthstr:sub(3, 3):byte() * 256 + widthstr:sub(4, 4):byte()
        height = heightstr:sub(1, 1):byte() * 16777216 + heightstr:sub(2, 2):byte() * 65536 + heightstr:sub(3, 3):byte() * 256 + heightstr:sub(4, 4):byte()
        return width, height
      end
    end
    -- Video support
    file:seek("set", 4)
    -- Detect if MP4
    if file:read(7) == "ftypmp4" then
      --[[
			The strategy is
			1. Seek to 0xFB
			2. Get value in big-endian order
		]]
      file:seek("set", 0xFB)
      local widthstr, heightstr = file:read(4), file:read(4)
      refresh()
      width = widthstr:sub(1, 1):byte() * 16777216 + widthstr:sub(2, 2):byte() * 65536 + widthstr:sub(3, 3):byte() * 256 + widthstr:sub(4, 4):byte()
      height = heightstr:sub(1, 1):byte() * 16777216 + heightstr:sub(2, 2):byte() * 65536 + heightstr:sub(3, 3):byte() * 256 + heightstr:sub(4, 4):byte()
      return width, height
    end
    file:seek("set", 8)
    -- Detect if AVI
    if file:read(3) == "AVI" then
      file:seek("set", 0x40)
      width = file:read(1):byte() + file:read(1):byte() * 256 + file:read(1):byte() * 65536 + file:read(1):byte() * 16777216
      height = file:read(1):byte() + file:read(1):byte() * 256 + file:read(1):byte() * 65536 + file:read(1):byte() * 16777216
      refresh()
      return width, height
    end
    refresh()
    return nil
  end
end

function onScriptTerminate(scr)
  if scr == script.this then
    lockPlayerControl(false)
  end
end
--start script here
