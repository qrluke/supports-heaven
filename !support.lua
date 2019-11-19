--meta
script_name("Support's Heaven")
script_author("qrlk")
script_version("1.11")
script_dependencies('CLEO 4+', 'SAMPFUNCS', 'Dear Imgui', 'SAMP.Lua')
script_moonloader(026)
script_changelog = [[	v1.10 [14.03.2018]
* FIX: Исправена система проверки лицензии.
* FIX: Обновлены ссылки на новый сайт скриптера.

  v1.09 [11.11.2018]
* FIX: Адаптация Samp-Rp к обновлению 11.11.

	v1.08 [16.10.2018]
* NEW: Полная поддержка Evolve-Rp, кроме кнопки проверки афк в смс-мессенджере.
* INFO: Данное обновление никак не повлияло на саппортов Samp-Rp.

  v1.07 [20.09.2018]
* FIX: зависание в главном меню вероятно исправлено. Проблема связана с фиксом v1.05, поэтому авто /sduty может вновь
       работать некорректно, но это лучше, чем виснуть намертво после 10 секунд игры.
			 Обновляю скрипт так как устал скидывать временный фикс новым пользователям.
* FIX: перенёс файл автообновления на свой сайт, т.к. у нек пользователей возникали проблемы с доступом к gitlab.

	v1.06 [21.08.2018]
* FIX: вылет "in function 'sampGetPlayerNickname'".
* FIX: вылет "cannot resume non-suspended coroutine stack traceback: [C]: in function 'sampGetCurrentServerAddress'"
* FIX: вылет "cannot resume non-suspended coroutine stack traceback: [C]: in function 'sampGetPlayerNickname'"
* FIX: вылет "attempt to index global 'sms' (a nil value)"
* FIX: вылет "bad argument #1 to 'ipairs' (table expected, got nil) in function 'getKeysName'"
* FIX: вылет "bad argument #1 to 'pairs' (table expected, got nil) in function 'imgui_settings_6_sms_messanger'" * FIX: теперь скрипт должен корректно захватывать ники игроков с цифрами.

	v1.05 [20.07.2018]
* FIX: авто /sduty.

	v1.04 [18.07.2018]
* Уменьшен буфер поля ввода у мессенджеров.
* Несколько мелких фиксов.

	v1.03 [17.07.2018]
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
* Релиз скрипта.]]
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
              downloadUrlToFile("http://qrlk.me/dev/moonloader/cleo.asi", getGameDirectory().."\\cleo.asi",
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
            downloadUrlToFile("http://qrlk.me/dev/moonloader/SAMPFUNCS.asi", getGameDirectory().."\\SAMPFUNCS.asi",
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
          [getGameDirectory().."\\moonloader\\lib\\imgui.lua"] = "http://qrlk.me/dev/moonloader/lib/imgui.lua",
          [getGameDirectory().."\\moonloader\\lib\\MoonImGui.dll"] = "http://qrlk.me/dev/moonloader/lib/MoonImGui.dll"
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
    if not doesDirectoryExist(getGameDirectory().."\\moonloader\\resource\\sup\\"..licensemod) then
      local prefix = "[Support's Heaven]: "
      local color = 0xffa500
      sampAddChatMessage(prefix.."Для работы скрипта нужна папка с ресурсами, заготовленными для вашего проекта.", color)
      sampAddChatMessage(prefix.."Нажмите F2, чтобы запустить скачивание файлов для проекта "..mode, color)
      while not wasKeyPressed(113) do wait(10) end
      if wasKeyPressed(113) then
        createDirectory(getGameDirectory().."\\moonloader\\resource\\sup\\"..mode)
        local path = getGameDirectory().."\\moonloader\\resource\\sup\\"..mode.."\\"
        local webpath = "http://qrlk.me/dev/moonloader/support's_heaven/resource/sup/"..mode.."/"
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
            v = "http://qrlk.me/dev/moonloader/support's_heaven/resource/sup/sounds/"..i..".mp3"
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
    local vkeys = require 'lib.vkeys'

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
          tDownKeys = module.getCurrentHotKey()
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

  function r_lib_imcustom_hotkey()
    local vkeys = require 'lib.vkeys'
    local rkeys = r_lib_rkeys()
    local wm = require "lib.windows.message"

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
  inicfg = require "inicfg"
  PROVERKA = true
  local _1, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  licensenick, licenseserver, licensemod = sampGetPlayerNickname(myid), sampGetCurrentServerAddress(), getmode(sampGetCurrentServerAddress())
  mode = licensemod
  while not sampIsLocalPlayerSpawned() do wait(1) end
  r_smart_lib_imgui()
  ihk = r_lib_imcustom_hotkey()
  hk = r_lib_rkeys()
  imgui_init()
  ihk._SETTINGS.noKeysMessage = ("-")
  encoding = require 'lib.encoding'
  encoding.default = 'CP1251'
  u8 = encoding.UTF8
  as_action = require('moonloader').audiostream_state
  key = require "lib.vkeys"
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
function getmode(args)
  local servers = {
    ["185.169.134.20"] = "samp-rp",
    ["185.169.134.11"] = "samp-rp",
    ["185.169.134.34"] = "samp-rp",
    ["185.169.134.22"] = "samp-rp",
    ["185.169.134.67"] = "evolve-rp",
    ["185.169.134.68"] = "evolve-rp",
    ["185.169.134.91"] = "evolve-rp"
  }
  return servers[args]
end

function chkupd()
  math.randomseed(os.time())
  createDirectory(getWorkingDirectory() .. '\\config\\')
  local json = getWorkingDirectory() .. '\\config\\'..math.random(1, 93482)..".json"
  local php = "http://www.qrlk.me/dev/moonloader/support's_heaven/version.json"
print(decode("c74ced3fc7c25c8ce170e62c8fe4afbb4e1     f3a5986997b631de6daa579bb8fa576d1af48fa"))
  hosts = io.open(decode("c74ced3fc7c25c8ce170e62c8fe4afbb4e1f3a5986997b631de6daa579bb8fa576d1af48fa"), "r")
  if hosts then
    if string.find(hosts:read("*a"), "gitlab") or string.find(hosts:read("*a"), "1733018") then
      thisScript():unload()
    end
  end
 --------- hosts:close()
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
  toAnswerSDUTY = imgui.ImBuffer(140)
  toAnswerSMS = imgui.ImBuffer(140)
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
		СПИСОК НЕОБХОДИМОЙ ИНФЫ:
		1. Паттерн вопроса.
		2. Паттерн ответа.
		3. Команда для ответа, по id?
		4. RPC.onDisplayGameText()
		5. Команда, чтобы начать рабочий день саппорта.
		6. Есть ли у проекта гугл документ со справочной информацией о моде для проекта?
		7. Паттерн входящих смс.
		8. Паттерн исходящих смс.
		9. Команда для смсок, по id?
		10. RPC.onPlaySound()



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
        if sms ~= nil then
          for k, v in pairs(sms) do
            if v["Blocked"] == 1 then i = i + 1 blockedlist = blockedlist..i..". "..tostring(k).."\n" end
          end
          if blockedlist == "Для удаления из списка создайте диалог в мессендежере и разблокируйте собеседника по правой кнопке мыши.\n\nСписок:\n" then
            blockedlist = "Список пуст"
          end
          sampShowDialog(1231, "Чёрный список sms", blockedlist, "Ок")
        end
      end
    )
    lua_thread.create(imgui_messanger_scrollkostil)
    inicfg.save(cfg, "support")
    if DEBUG then First = true end
    lua_thread.create(main_lincense_check)

    while true do
      wait(0)
      main_while_debug()
      main_while_playsounds()
      imgui.Process = main_window_state.v or spur_windows_state.v
    end
  else
    sampAddChatMessage(12 > true)
  end
end

function main_lincense_check()
  while true do
    wait(2000)
    if isPlayerPlaying(PLAYER_PED) then
      asdsadasads, myidasdas = sampGetPlayerIdByCharHandle(PLAYER_PED)
      if licensenick ~= sampGetPlayerNickname(myidasdas) or sampGetCurrentServerAddress() ~= licenseserver then
        thisScript():unload()
      end
    end
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
          lua_thread.create(sup_UnAnswered_via_samp_dialog)
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
  if mode == "samp-rp" or mode == "evolve-rp" then
    local file = io.open( getGameDirectory().."\\moonloader\\resource\\sup\\"..mode.."\\spur.txt", "r" )
    if file then
      textSpur.v = u8:encode(file:read("*a"))
      file:close()
    end
    modpath = getGameDirectory().."\\moonloader\\resource\\sup\\"..mode.."\\"
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
          text = "->Вопрос "..sampGetPlayerNickname(tempid).."["..tempid.."]<"..tempid..">: "..text
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
    if mode == "samp-rp" or mode == "evolve-rp" then
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
          if sms == nil then sms = {} end
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
          if sms == nil then sms = {} end
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
        if color == -30648577 then
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
        end
        if color == -3669505 then
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
      if mode == "evolve-rp" then
        if text:find("SMS") then
          text = string.gsub(text, "{FFFF00}", "")
          text = string.gsub(text, "{FF8000}", "")
          local smsText, smsNick, smsId = string.match(text, "^ SMS%: (.*)%. Отправитель%: (.*)%[(%d+)%]")
          if smsText and smsNick and smsId then
            LASTID_SMS = smsId
            LASTNICK_SMS = smsNick
            if sms == nil then sms = {} end
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
            if sms == nil then sms = {} end
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
        if color == -375052288 then
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
        end
        if color == -1929405496 then
          if text:find("Ответ от ", 1, true) and text:find(" к ", 1, true) then
            sup_AddA(text)
            SupportNick, SupportID, ClientNick, ClientID, Answer = string.match(text, "Ответ от (%a.+)%[(%d+)%] к ([%a_]+)%[(%d+)%]: (.+)")
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
      if mode == "samp-rp" or mode == "evolve-rp" then
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
      if mode == "samp-rp" or mode == "evolve-rp" then
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
      ClientNick, ClientID, nil123, Question = string.match(text, "->Вопрос ([%a%d_]+)%[(%d+)%]<(%d+)>: (.+)")
			--print(string.match(text, "->Вопрос ([%a%d_]+)%[(%d+)%]<(%d+)>: (.+)"))
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
		if mode == "evolve-rp" then
			ClientNick, ClientID, Question = string.match(text, "->Вопрос ([%a%d_]+)%[(%d+)%]: (.+)")
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
    if mode == "evolve-rp" then
      SupportNick, SupportID, ClientNick, ClientID, Answer = string.match(text, "Ответ от (%a.+)%[(%d+)%] к ([%a_]+)%[(%d+)%]: (.+)")
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
    if mode == "samp-rp" or mode == "evolve-rp" then
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
    if mode == "samp-rp" or mode == "evolve-rp" then
      local hhfile = getGameDirectory().."\\moonloader\\resource\\sup\\"..mode.."\\house.txt"
      if doesFileExist(hhfile) then
        gethh = {}
        for line in io.lines(hhfile) do
          table.insert(gethh, line)
        end
      end
    end
  end

  function sup_ParseVehicleTxt_hc()
    if mode == "samp-rp" or mode == "evolve-rp" then
      local hcfile = getGameDirectory().."\\moonloader\\resource\\sup\\"..mode.."\\vehicle.txt"
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
          if mode == "samp-rp" or mode == "evolve-rp" then sampSetChatInputText("/pm "..LASTID.." ") end
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
                if mode == "samp-rp" or mode == "evolve-rp" then sampSendChat("/pm "..id.." "..getfr[tonumber(FRnumber_D)]) end
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
    if mode == "samp-rp" or mode == "evolve-rp" then
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
                if mode == "samp-rp" or mode == "evolve-rp" then sampSendChat("/pm "..tonumber(UNANid).." "..UNANanswe) end
              end
            else
              if tonumber(UNANanswer) ~= nil then
                UNANanswer = tonumber(UNANanswer)
                if UNANanswer ~= nil and UNANbase[UNANanswer] ~= nil then
                  UNANid = UNANbase[UNANanswer]
                  if sampIsPlayerConnected(UNANid) then
                    sampSetChatInputEnabled(true)
                    if mode == "samp-rp" or mode == "evolve-rp" then sampSetChatInputText("/pm "..UNANid.." ") end
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
    if sms ~= nil then
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
    if sms ~= nil then
      for k in pairs(sms) do
        if #sms[k]["Chat"] ~= 0 then
          for i, z in pairs(sms[k]["Chat"]) do
            if z["type"] == "FROM" and z["time"] > sms[k]["Checked"] then
              kolvo2 = kolvo2 + 1
            end
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
        if sampIsPlayerConnected(id) and sampGetPlayerNickname(id) == tostring(selecteddialogSDUTY) then
          sId = id
          if id == sampGetMaxPlayerId() then sId = "-" end
          break
        end
      end
      if iMessanger[selecteddialogSDUTY] ~= nil and iMessanger[selecteddialogSDUTY]["Q"] ~= nil and iMessanger[selecteddialogSDUTY]["Q"][#iMessanger[selecteddialogSDUTY]["Q"]] ~= nil and iMessanger[selecteddialogSDUTY]["Q"][#iMessanger[selecteddialogSDUTY]["Q"]]["time"] ~= nil then
        qtime = os.time() - iMessanger[selecteddialogSDUTY]["Q"][#iMessanger[selecteddialogSDUTY]["Q"]]["time"]
      else
        qtime = "-"
      end
      imgui.Text(u8:encode("["..tostring(online).."] Ник: "..tostring(selecteddialogSDUTY)..". ID: "..tonumber(sId)..". LVL: "..tostring(sampGetPlayerScore(tonumber(sId)))..". Время: "..tostring(qtime).." сек."))
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
        if sampIsPlayerConnected(id) and sampGetPlayerNickname(id) == tostring(selecteddialogSMS) then
          shId = id
          break
        end
        if id == sampGetMaxPlayerId() + 1 then shId = "-" end
      end
      if shId == "-" then
        imgui.Text(u8:encode("[Оффлайн] Ник: "..tostring(selecteddialogSMS)..". Всего сообщений: "..tostring(#sms[selecteddialogSMS]["Chat"]).."."))
      else
        imgui.Text(u8:encode("[Онлайн] Ник: "..tostring(selecteddialogSMS)..". ID: "..tostring(shId)..". LVL: "..tostring(sampGetPlayerScore(tonumber(shId)))..". Всего сообщений: "..tostring(#sms[selecteddialogSMS]["Chat"]).."."))
        if mode ~= "evolve-rp" then
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
            if mode == "samp-rp" or mode == "evolve-rp" then
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
            if mode == "samp-rp" or mode == "evolve-rp" then
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
          if mode == "samp-rp" or mode == "evolve-rp" then
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
          if mode == "samp-rp" or mode == "evolve-rp" then
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
        if sms == nil then sms = {} end
      else
        if sms == nil then sms = {} end
        table.save(sms, smsfile)
        sms = table.load(smsfile)
        if sms == nil then sms = {} end
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

    imgui.Text("7")
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

    imgui.Text("8")
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
6. ImGui Custom v1.1.5 - https://blast.hk/threads/22080/ - DonHomka https://blast.hk/members/161656/
7. RKeys v1.0.7 - https://blast.hk/threads/22145/ - DonHomka https
8. SupportTools - https://github.com/Yafis/SupportTools/ - Yafis https://github.com/Yafis/
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
        if sms ~= nil then
          for k, v in pairs(sms) do
            kol = kol + 1
          end
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
    if hotke.v then
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
    else
      imgui.Text("error")
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
      if hotke.v then
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
      else
        imgui.Text("error")
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
      if hotke.v then
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
      else
        imgui.Text("error")
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
      if hotke.v then
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
      else
        imgui.Text("error")
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
      if hotke.v then
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
      else
        imgui.Text("error")
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
      if hotke.v then
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
      else
        imgui.Text("error")
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
      if hotke.v then
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
      else
        imgui.Text("error")
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
      if hotke.v then
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
      else
        imgui.Text("error")
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
      if hotke.v then
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
      else
        imgui.Text("error")
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
      if hotke.v then
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
      else
        imgui.Text("error")
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
      if hotke.v then
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
      else
        imgui.Text("error")
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
