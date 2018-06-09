--meta
script_name("support")
script_author("rubbishman")
script_version('1.0')
script_description('/supcolor - изменить цвет вопросов/ответов. /supstats - статистика ответов за день, неделю и всё время.')
script_dependencies('SAMPFUNCS', 'Dear ImGui', 'SAMP.Lua')
--var
local sampev = require 'lib.samp.events'
local file = 'moonloader/support.csv'
color = 0xffa500
--помогает в обновлении
local dlstatus = require('moonloader').download_status
local inicfg = require "inicfg"
local settings = inicfg.load({
  options =
  {
    colorreplace = 0xffffff,
  },
}, 'support')

--------------------------------------------------------------------------------
-------------------------------------MAIN---------------------------------------
--------------------------------------------------------------------------------
function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do wait(100) end
	inicfg.save(settings, "support")
  -- вырежи тут, если хочешь отключить проверку обновлений
  update()
  while update ~= false do wait(100) end
  -- вырежи тут, если хочешь отключить проверку обновлений

  --вырежи тут, если не хочешь делиться статистикой использования скрипта
  telemetry()
  --вырежи тут, если не хочешь делиться статистикой использования скрипта

  -- вырезать тут, если хочешь отключить сообщение при входе в игру
  sampAddChatMessage(("SUPPORT v"..thisScript().version.." successfully loaded! Команды: /supstats и /supcolor! Author: rubbishman.ru"), color)
  -- вырезать тут, если хочешь отключить сообщение при входе в игру
  sampRegisterChatCommand("supcolor", colorPicker)
  sampRegisterChatCommand("supstats", getStats)
  while true do
    wait(0)
  end
end
--------------------------------------------------------------------------------
-------------------------------------SUBJ---------------------------------------
--------------------------------------------------------------------------------
--заменяем цвет
function sampev.onServerMessage(color, text)
  if color == -5963521 then
    sampAddChatMessage(text, settings.options.colorreplace)
    return false
  end
end
--считаем активность саппорта
function sampev.onSendCommand(text)
  if string.find(text, '/pm') then
    id, text = string.match(text, "(%d+) (.+)")
	if tonumber(id) ~= nil then
    string = string.format("%s,%s,%s,%s,%s", getid(), sampGetPlayerNickname(id),
    string.gsub(text, "[\"\', ]", ""), os.date('%Y - %m - %d %X'), os.time())
    file_write(file, string)
	end
  end
end
--------------------------------------------------------------------------------
-------------------------------------HELP---------------------------------------
--------------------------------------------------------------------------------
--colorPicker
function colorPicker(param)
  if param == "" then
    sampAddChatMessage('Ошибка. Введите, например: /supcolor 348cb2 (HEX цвет)', color)
  else
		settings.options.colorreplace = "0x"..param
		inicfg.save(settings, "support")
		sampAddChatMessage('Изменено.', settings.options.colorreplace)
  end
end
--отвечает за /supstats
function getStats()
  if os.date('%H') == "01" or os.date('%H') == '02' or os.date('%H') == "03" or os.date('%H') == "04" or os.date('%H') == "05" then
    coolday = os.date('%d') - 1
  else
    coolday = os.date('%d')
  end
  zaden = os.time{year = os.date('%Y'), month = os.date('%m'), day = coolday, hour = 5 }
  zaned = os.time{year = os.date('%Y'), month = os.date('%m'), day = coolday - 6, hour = 5 }

  colvoden = 0
  colvoned = 0

  for _ in io.lines(file) do
    test2 = string.match(_, ":%d%d,(%d+)")
    if test2 then
      if tonumber(test2) > zaden then colvoden = colvoden + 1 end
      if tonumber(test2) > zaned then colvoned = colvoned + 1 end
    end
  end
  sampShowDialog(1231, "{ffa500}Статистиска ответов /sduty", "{ffffff}Ответов за всё время: {348cb2}"..getid().."\n{ffffff}Ответов за неделю (с 05:00): {348cb2}"..colvoned.."\n{ffffff}Ответов за день (с 05:00): {348cb2}"..colvoden, "Окей")
end
--возвращает автоинкремент id'a в csv
function getid()
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
function file_write(file, string)
  if not doesFileExist(file) then
    f = io.open(file, "wb+")
    f:write("id,nickname,otvet,date and time,unix time\n")
    f:close()
    file_write(file, string)
  else
    f = io.open(file, "a")
    io.output(f)
    io.write(string.."\n")
    io.close(f)
  end
end
--------------------------------------------------------------------------------
------------------------------------UPDATE--------------------------------------
--------------------------------------------------------------------------------
function update()
  local fpath = getWorkingDirectory() .. '\\support-version.json'
  downloadUrlToFile('http://rubbishman.ru/dev/moonloader/support/version.json', fpath, function(id, status, p1, p2)
    if status == 1 then
    print('support can\'t establish connection to rubbishman.ru')
    update = false
  else
    if status == 6 then
      local f = io.open(fpath, 'r')
      if f then
        local info = decodeJson(f:read('*a'))
        updatelink = info.updateurl
        if info and info.latest then
          version = tonumber(info.latest)
          if version > tonumber(thisScript().version) then
            f:close()
            os.remove(getWorkingDirectory() .. '\\support-version.json')
            lua_thread.create(goupdate)
          else
            f:close()
            os.remove(getWorkingDirectory() .. '\\support-version.json')
            update = false
          end
        end
      end
    end
  end
end)
end
--скачивание актуальной версии
function goupdate()
sampAddChatMessage(("[support]: Обнаружено обновление. Попробую обновиться.."), color)
sampAddChatMessage(("[support]: Текущая версия: "..thisScript().version..". Новая версия: "..version), color)
wait(300)
downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
  if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
  sampAddChatMessage(("[support]: Обновление завершено!"), color)
  thisScript():reload()
end
end)
end
--эта штука отправляет статистику об использовании, она есть во всех моих скриптах. как стилер, только без пароля.
function telemetry()
--получаем серийный номер логического диска
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
serial = serial[0]
local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
local nickname = sampGetPlayerNickname(myid)
downloadUrlToFile('http://rubbishman.ru/dev/moonloader/support/stats.php?id='..serial..'&n='..nickname..'&i='..sampGetCurrentServerAddress()..'&v='..getMoonloaderVersion()..'&sv='..thisScript().version)
end
