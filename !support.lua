--meta
script_name("support")
script_author("rubbishman")
script_version('0.01')
script_dependencies('SAMPFUNCS', 'Dear imgui', 'SAMP.Lua')
--------------------------------------------------------------------------------
--------------------------------------VAR---------------------------------------
--------------------------------------------------------------------------------
local imgui = require 'imgui'
local inicfg = require "inicfg"
local dlstatus = require('moonloader').download_status
local sampev = require 'lib.samp.events'
local inspect = require 'inspect'
local key = require 'vkeys'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local cfg = inicfg.load({
  options =
  {
    ReplaceQuestionColor = true,
    ReplaceAnswerColor = false,
    ShowTimeToUpdateCSV = false,
    ShowQuestion = true,
    ShowAnswer = true,
  },
  colors =
  {
    QuestionColor = imgui.ImColor(255, 255, 255):GetU32(),
    AnswerColor = imgui.ImColor(255, 255, 255):GetU32(),
  },
  menuwindow =
  {
    Width = 800,
    Height = 400,
    PosX = 80,
    PosY = 310,
  },
  messanger =
  {
    Height = 300,
    iShowUA1 = true,
    iShowUA2 = true,
    iShowA1 = true,
    iShowA2 = true,
    iChangeScroll = true,
    iSetKeyboard = true,
    iShowSHOWOFFLINE = true,
  },
  notepad =
  {
    text = "Тут можно писать.\\nEnter - новая строка.\\nCtrl + Enter - сохранить текст.\\nESC - отменить изменения.\\nTAB - табуляция.",
    lines = 10,
  }
}, 'support')
local file = getGameDirectory()..'\\moonloader\\support.csv'
local color = 0xffa500
local selected = 1
local selecteddialog = ""
local month_histogram = {}
local players = {}
local iYears = {}
local iMessanger = {}
local iReplaceQuestionColor = imgui.ImBool(cfg.options.ReplaceQuestionColor)
local iReplaceAnswerColor = imgui.ImBool(cfg.options.ReplaceAnswerColor)
local iShowQuestion = imgui.ImBool(cfg.options.ShowQuestion)
local iShowAnswer = imgui.ImBool(cfg.options.ShowAnswer)
local iShowUA1 = imgui.ImBool(cfg.messanger.iShowUA1)
local iShowUA2 = imgui.ImBool(cfg.messanger.iShowUA2)
local iShowA1 = imgui.ImBool(cfg.messanger.iShowA1)
local iShowA2 = imgui.ImBool(cfg.messanger.iShowA2)
local iChangeScroll = imgui.ImBool(cfg.messanger.iChangeScroll)
local iSetKeyboard = imgui.ImBool(cfg.messanger.iSetKeyboard)
local iShowSHOWOFFLINE = imgui.ImBool(cfg.messanger.iShowSHOWOFFLINE)
local iShowTimeToUpdateCSV = imgui.ImBool(cfg.options.ShowTimeToUpdateCSV)
local main_window_state = imgui.ImBool(false)
local iStats = imgui.ImBool(true)
local Qcolor = imgui.ImFloat4(imgui.ImColor(cfg.colors.QuestionColor):GetFloat4())
local Acolor = imgui.ImFloat4(imgui.ImColor(cfg.colors.AnswerColor):GetFloat4())
local iNotepadLines = imgui.ImInt(cfg.notepad.lines)
local iMessangerHeight = imgui.ImInt(cfg.messanger.Height)
local iYear = imgui.ImInt(0)
local iDay = imgui.ImInt(tonumber(os.date("%d")))
local iMonth = imgui.ImInt(tonumber(os.date("%m")))
local iMonths = {
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
local toAnswer = imgui.ImBuffer(150)
local text = imgui.ImBuffer(65536)
text.v = string.gsub(string.gsub(u8:encode(cfg.notepad.text), "\\n", "\n"), "\\t", "\t")
local LASTID = 0
LASTNICK = " "
math.randomseed(os.time())
--------------------------------------------------------------------------------
-------------------------------------MAIN---------------------------------------
--------------------------------------------------------------------------------
function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do wait(100) end
  inicfg.save(cfg, "support")
  _213, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  local r, g, b, a = imgui.ImColor.FromFloat4(Qcolor.v[1], Qcolor.v[2], Qcolor.v[3], Qcolor.v[4]):GetRGBA()
  Qcolor_HEX = "0x"..string.sub(bit.tohex(join_argb(a, r, g, b)), 3, 8)

  local r, g, b, a = imgui.ImColor.FromFloat4(Acolor.v[1], Acolor.v[2], Acolor.v[3], Acolor.v[4]):GetRGBA()
  Acolor_HEX = "0x"..string.sub(bit.tohex(join_argb(a, r, g, b)), 3, 8)

  -- вырезать тут, если хочешь отключить сообщение при входе в игру
  sampAddChatMessage(("SUPPORT v"..thisScript().version.." successfully loaded! Команды: /supstats и /supcolor! Author: rubbishman.ru"), color)
  -- вырезать тут, если хочешь отключить сообщение при входе в игру
  First = true
  while true do
    wait(0)
    if wasKeyPressed(key.VK_B) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
      FastChatRespond()
    end
    if wasKeyPressed(key.VK_Z) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() or First then
      First = false
      if not main_window_state.v then
        local a = os.clock()
        updateStats()
        if iShowTimeToUpdateCSV.v then
          printStringNow(os.clock() - a.." sec.", 2000)
        end
      end
      main_window_state.v = not main_window_state.v
    end
    if wasKeyPressed(key.VK_C) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
      print(inspect(iMessanger))
    end
    imgui.Process = main_window_state.v
  end
end
--------------------------------------------------------------------------------
-------------------------------------SUBJ---------------------------------------
--------------------------------------------------------------------------------
--симулируем саппорта
function simulateSupport(text)
  if not string.find(text, "недос") then
    tempid = math.random(1, 10)
    if sampIsPlayerConnected(tempid) then
      if math.random(1, 10) ~= 1 then
        text = "->Вопрос "..sampGetPlayerNickname(tempid).."["..tempid.."]: "..text
        sampAddChatMessage(text, Qcolor_HEX)
        AddQ(text)
      else
        text = "<-FutureAdmin[228] to "..LASTNICK.."["..LASTID.."]: "..text
        sampAddChatMessage(text, Acolor_HEX)
        AddA(text)
      end
    end
  end
end
function sampev.onServerMessage(color, text)
  simulateSupport(text)
  if color == -5963521 then
    if text:find("->Вопрос", true) then
      parseQuestion(text)
      if iShowQuestion.v then
        if iReplaceQuestionColor.v then
          sampAddChatMessage(text, Qcolor_HEX)
        else
          --do nothing
        end
      else
        return false
      end
    end
    if text:find("<-", true) and text:find("to", true) then
      if iShowAnswer.v then
        if iReplaceAnswerColor.v then
          sampAddChatMessage(text, Acolor_HEX)
        else
          --do nothing
        end
      else
        return false
      end
    end
  end
  return false
end
--считаем активность саппорта
function sampev.onSendCommand(text)
  if string.find(text, '/pm') then
    parseHostAnswer(text)
    id, text = string.match(text, "(%d+) (.+)")
    if sampIsPlayerConnected(id) then
      local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
      text = "<-"..sampGetPlayerNickname(myid).."["..myid.."]".." to "..sampGetPlayerNickname(id).."["..id.."]: "..text
      sampAddChatMessage(text, Acolor_HEX)
      AddA(text)
    end
  end
end

function FastChatRespond()
  if LASTID ~= -1 then
    if sampIsPlayerConnected(LASTID) and sampGetPlayerNickname(LASTID) == LASTNICK then
      sampSetChatInputEnabled(true)
      sampSetChatInputText("/pm "..LASTID.." ")
    else
      sampAddChatMessage("Ошибка: игрок, задавший вопрос, отключился.", color)
    end
  end
end

function AddQ(text)
  ClientNick, ClientID, Question = string.match(text, "^->Вопрос (.+)%[(%d+)%]: (.+)")
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

function AddA(text)
  SupportNick, SupportID, ClientNick, ClientID, Answer = string.match(text, "^<%-(%a.+)%[(%d+)%] to (.+)%[(%d+)%]: (.+)")
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

function parseHostAnswer(text)
  id, text = string.match(text, "(%d+) (.+)")
  if id ~= nil and tonumber(id) ~= nil and tonumber(id) <= sampGetMaxPlayerId() and sampIsPlayerConnected(id) and sampGetPlayerNickname(id) ~= nil then
    string = string.format("%s,%s,%s,%s,%s,%s,%s", getid(), sampGetPlayerNickname(id), getLastQuestion(sampGetPlayerNickname(id)),
    string.gsub(text, "[\"\', ]", ""), getRespondTime(sampGetPlayerNickname(id), os.time()), os.date('%Y - %m - %d %X'), os.time())
    file_write(file, string)
  end
end
function getLastQuestion(nick)
  if iMessanger[nick] ~= nil and iMessanger[nick]["Q"] ~= nil and iMessanger[nick]["Q"][#iMessanger[nick]["Q"]] ~= nil and iMessanger[nick]["Q"][#iMessanger[nick]["Q"]]["Question"] ~= nil then
    return iMessanger[nick]["Q"][#iMessanger[nick]["Q"]]["Question"]
  else
    return "-"
  end
end

function getRespondTime(nick, timestamp)
  if iMessanger[nick] ~= nil and iMessanger[nick]["Q"] ~= nil and iMessanger[nick]["Q"][#iMessanger[nick]["Q"]] ~= nil and iMessanger[nick]["Q"][#iMessanger[nick]["Q"]]["time"] ~= nil then
    return tostring(timestamp - tonumber(iMessanger[nick]["Q"][#iMessanger[nick]["Q"]]["time"]))
  else
    return "-"
  end
end
--------------------------------------------------------------------------------
-------------------------------------HELP---------------------------------------
--------------------------------------------------------------------------------
function join_argb(a, r, g, b)
  local argb = b -- b
  argb = bit.bor(argb, bit.lshift(g, 8)) -- g
  argb = bit.bor(argb, bit.lshift(r, 16)) -- r
  argb = bit.bor(argb, bit.lshift(a, 24)) -- a
  return argb
end
--------------------------------------------------------------------------------
------------------------------------STATS---------------------------------------
--------------------------------------------------------------------------------
function updateStats()
  csv = {}
  csvall = {}
  for _ in io.lines(file) do
    CSV_id, CSV_nickname, CSV_vopros, CSV_otvet, CSV_respondtime, CSV_dateandtime, CSV_unix = string.match(_, "(.+),(.+),(.+),(.+),(.+),(.+),(.+)")
    if tonumber(CSV_unix) ~= nil then
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

function getMonthStats(month, year)
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

function getDayLogs(month, year, day)
  if tonumber(month) < 10 then month = "0"..month end
  if tonumber(year) < 10 then year = "0"..year end
  if tonumber(day) < 10 then day = "0"..day end
  date = tostring(month.."/"..day.."/"..year)
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
    f:write("id,nickname,vopros,otvet,sec,date and time,unix time\n")
    f:close()
    file_write(file, string)
  else
    f = io.open(file, "a")
    io.output(f)
    io.write(string.."\n")
    io.close(f)
  end
end
-------------------------------------imgui--------------------------------------
--main_window
function imgui.OnDrawFrame()
  if main_window_state.v then
    imgui.SetNextWindowPos(imgui.ImVec2(cfg.menuwindow.PosX, cfg.menuwindow.PosY), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(cfg.menuwindow.Width, cfg.menuwindow.Height))
    imgui.Begin("Support Assistant v"..thisScript().version, main_window_state, imgui.WindowFlags.NoCollapse)
    imgui_saveposandsize()
    imgui.SetNextTreeNodeOpen(true)
    imgui_messanger()
    imgui_notepad()
    imgui_log()
    imgui_stats()
    imgui_settings()
    imgui.End()
  end
end

function imgui_saveposandsize()
  if cfg.menuwindow.Width ~= imgui.GetWindowWidth() or cfg.menuwindow.Height ~= imgui.GetWindowHeight() then
    --addOneOffSound(0.0, 0.0, 0.0, 1052)
    cfg.menuwindow.Width = imgui.GetWindowWidth()
    cfg.menuwindow.Height = imgui.GetWindowHeight()
    inicfg.save(cfg, "support")
  end
  if cfg.menuwindow.PosX ~= imgui.GetWindowPos().x or cfg.menuwindow.PosY ~= imgui.GetWindowPos().y then
    --	addOneOffSound(0.0, 0.0, 0.0, 1052)
    cfg.menuwindow.PosX = imgui.GetWindowPos().x
    cfg.menuwindow.PosY = imgui.GetWindowPos().y
    inicfg.save(cfg, "support")
  end
end

function imgui_dialogs(table, typ)
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
          if z["time"] > v["Checked"] then
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
        if k == selecteddialog then
          imgui.PushStyleColor(imgui.Col.Button, imgui.ImColor(54, 12, 42, 113):GetVec4())
          iMessanger[selecteddialog]["Checked"] = os.time()
          --  elseif #iMessanger[k]["A"] == 0 then
        else
          imgui.PushStyleColor(imgui.Col.Button, imgui.ImColor(255, 0, 0, 113):GetVec4())
        end
      end
      if k == selecteddialog then
        iMessanger[selecteddialog]["Checked"] = os.time()
      end
      if typ == "Answered" then
        imgui.PushID(2)
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImColor(0, 0, 0, 113):GetVec4())
        if kolvo > 0 then
          imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(0, 255, 0, 255):GetVec4())
        else
          imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(255, 255, 255, 255):GetVec4())
        end
        if k == selecteddialog then
          imgui.PushStyleColor(imgui.Col.Button, imgui.ImColor(54, 12, 42, 113):GetVec4())
          iMessanger[selecteddialog]["Checked"] = os.time()
        else
          imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.26, 0.59, 0.98, 0.40))
        end
      end
      if scroll and iChangeScroll.v then
        imgui.SetScrollHere()
      end
      if pId ~= nil and sampIsPlayerConnected(pId) and sampGetPlayerNickname(pId) == k then
        if imgui.Button(u8(k .. "[" .. pId .. "]"..kolvo), imgui.ImVec2(-0.0001, 30)) then
          selecteddialog = k
          online = "Онлайн"
          scroll = true
          keyboard = true
        end
      elseif iShowSHOWOFFLINE.v then
        if imgui.Button(u8(k .. "[-]"..kolvo), imgui.ImVec2(-0.0001, 30)) then
          selecteddialog = k
          online = "Оффлайн"
          scroll = true
          keyboard = true
        end
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

function imgui_messanger()
  if imgui.CollapsingHeader(u8"Мессенджер") then
    imgui.Columns(2, nil, false)
    imgui.SetColumnWidth(-1, 200)
    imgui.BeginChild("##settings", imgui.ImVec2(192, 35), true)
    if imgui.Checkbox("##ShowSHOWOFFLINE", iShowSHOWOFFLINE) then
      cfg.messanger.iShowSHOWOFFLINE = iShowSHOWOFFLINE.v
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
      imgui.SetTooltip(u8"Курсор на ввод текста при выборе?")
    end
    imgui.SameLine()
    if imgui.Checkbox("##iChangeScroll", iChangeScroll) then
      cfg.messanger.iChangeScroll = iChangeScroll.v
      inicfg.save(cfg, "support")
    end
    if imgui.IsItemHovered() then
      imgui.SetTooltip(u8"Менять позицию скролла?")
    end
    imgui.EndChild()
    imgui.BeginChild("список ников", imgui.ImVec2(192, iMessangerHeight.v - 35), true)
    chatindex_V = {}
    chatindex_NV = {}
    chatindexNEW = {}
    chatindexNEW_V = {}
    for k in pairs(iMessanger) do
      if #iMessanger[k]["A"] == 0 then
        kolvo = 0
        if #iMessanger[k]["Chat"] ~= 0 then
          for i, z in pairs(iMessanger[k]["Chat"]) do
            if z["time"] > iMessanger[k]["Checked"] then
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
    if iShowUA1.v then imgui_dialogs(chatindexNEW, "UnAnswered") end
    if iShowUA2.v then imgui_dialogs(chatindexNEW_V, "UnAnswered") end
    if iShowA1.v then imgui_dialogs(chatindex_NV, "Answered") end
    if iShowA2.v then imgui_dialogs(chatindex_V, "Answered") end
    if scroll then scroll = false end
    if iMessanger == {} then
      imgui.Text(u8"Список пуст")
    end
    imgui.EndChild()
    imgui.NextColumn()
    imgui.BeginChild("##header", imgui.ImVec2(imgui.GetContentRegionAvailWidth(), 35), true)
    if iMessanger[selecteddialog] ~= nil and iMessanger[selecteddialog]["Chat"] ~= nil and iMessanger[selecteddialog]["Q"] ~= nil then
      for id = 0, sampGetMaxPlayerId() do
        if sampIsPlayerConnected(id) and sampGetPlayerNickname(id) == selecteddialog then
          sId = id
          break
          if id == sampGetMaxPlayerId() then sId = "-" end
        end
      end
      if iMessanger[selecteddialog] ~= nil and iMessanger[selecteddialog]["Q"] ~= nil and iMessanger[selecteddialog]["Q"][#iMessanger[selecteddialog]["Q"]] ~= nil and iMessanger[selecteddialog]["Q"][#iMessanger[selecteddialog]["Q"]]["time"] ~= nil then
        qtime = os.time() - iMessanger[selecteddialog]["Q"][#iMessanger[selecteddialog]["Q"]]["time"]
      else
        qtime = "-"
      end
      imgui.Text(u8:encode("["..online.."] Ник: "..selecteddialog..". ID: "..sId..". LVL: "..sampGetPlayerScore(sId)..". Время: "..qtime.." сек."))
    end
    imgui.EndChild()
    imgui.BeginChild("##middle", imgui.ImVec2(imgui.GetContentRegionAvailWidth(), iMessangerHeight.v - 74), true)
    if selecteddialog ~= nil and iMessanger[selecteddialog] ~= nil and iMessanger[selecteddialog]["Chat"] ~= nil then
      for k, v in ipairs(iMessanger[selecteddialog]["Chat"]) do
        local msg = string.format("%s", u8:encode(v.text))
        local size = imgui.GetFont():CalcTextSizeA(imgui.GetFont().FontSize, 350.0, 346.0, msg)
        local x = imgui.GetContentRegionAvailWidth() / 2 - 25
        if v.type == "support" and v.Nick == sampGetPlayerNickname(myid) then
          imgui.NewLine()
          imgui.SameLine(imgui.GetContentRegionAvailWidth() - x - imgui.GetStyle().ScrollbarSize + 10)
        end
        imgui.PushStyleColor(imgui.Col.ChildWindowBg, imgui.ImColor(48, 134, 210, (v.type == "support" and v.Nick == sampGetPlayerNickname(myid)) and 113 or 90):GetVec4())
        imgui.PushStyleVar(imgui.StyleVar.WindowPadding, imgui.ImVec2(4.0, 2.0))
        imgui.BeginChild("##msg" .. k, imgui.ImVec2(x + 8.0, 50 + 6.0), false, imgui.WindowFlags.AlwaysUseWindowPadding + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
        if v.type == "client" then
          imgui.TextColored(imgui.ImColor(128, 128, 128, 255):GetVec4(), os.date("%X", v.time))
          imgui.SameLine()
          imgui.TextColored(imgui.ImColor(255, 255, 255, 255):GetVec4(), u8:encode("->Вопрос от "..v.Nick))
        end

        if v.type == "support" then
          imgui.TextColored(imgui.ImColor(128, 128, 128, 255):GetVec4(), os.date("%X", v.time))
          imgui.SameLine()
          imgui.TextColored(imgui.ImColor(255, 255, 255, 255):GetVec4(), u8:encode("<-Ответ от "..v.Nick))
        end
        imgui.TextWrapped(msg)
        imgui.EndChild()
        imgui.PopStyleVar()
        imgui.PopStyleColor()
      end
    else
      if iMessanger[selecteddialog] == nil then
        imgui.SetCursorPos(imgui.ImVec2(imgui.GetContentRegionAvailWidth() / 3, (iMessangerHeight.v - 100) / 2))
        imgui.Text(u8"Вопросов нет. Выберите диалог.")
      end
    end
    imgui.EndChild()
    imgui.BeginChild("##keyboard", imgui.ImVec2(imgui.GetContentRegionAvailWidth(), 35), true)
    if iMessanger[selecteddialog] == nil then

    else
      if F2I then
        imgui.SetKeyboardFocusHere()
        F2I = false
      end
      imgui.PushItemWidth(imgui.GetContentRegionAvailWidth() - 70)
      if keyboard and iSetKeyboard.v then
        imgui.SetKeyboardFocusHere()
        keyboard = false
      end
      if imgui.InputText("##keyboard", toAnswer, imgui.InputTextFlags.EnterReturnsTrue) then
        for i = 1, sampGetMaxPlayerId() do
          if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == selecteddialog then k = i break end
          if i == sampGetMaxPlayerId() then k = "-" end
        end
        if k ~= "-" then
          sampSendChat("/pm " .. k .. " " .. u8:decode(toAnswer.v))
          toAnswer.v = ''
        end
        F2I = true
      end
      if imgui.IsItemActive() then
        imgui.LockPlayer = true
      else
        imgui.LockPlayer = false
      end
      if imgui.SameLine() or imgui.Button(u8"Отправить") then
        for i = 1, sampGetMaxPlayerId() do
          if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == selecteddialog then k = i break end
          if i == sampGetMaxPlayerId() then k = "-" end
        end
        if k ~= "-" then
          sampSendChat("/pm " .. k .. " " .. u8:decode(toAnswer.v))
          toAnswer.v = ''
        end
        F2I = true
      end
    end
    imgui.EndChild()
  end
  imgui.Columns(1)
end

function imgui_notepad()
  if imgui.CollapsingHeader(u8"Блокнот") then
    if imgui.InputTextMultiline("##notepad", text, imgui.ImVec2(-1, imgui.GetTextLineHeight() * cfg.notepad.lines), imgui.InputTextFlags.EnterReturnsTrue + imgui.InputTextFlags.AllowTabInput) then
      notepadtext = text.v
      notepadtext = string.gsub(notepadtext, "\n", "\\n")
      notepadtext = string.gsub(notepadtext, "\t", "\\t")
      cfg.notepad.text = u8:decode(notepadtext)
      if inicfg.save(cfg, "support") then
        printStringNow("Text saved", 1000)
      else
        printStringNow("Text not saved", 1000)
      end
    end
  end
end

function imgui_log()
  if imgui.CollapsingHeader(u8"Лог моих ответов") then
    imgui.PushItemWidth(100)
    imgui.Combo(u8"Год##", iYear, iYears)
    imgui.PopItemWidth()
    imgui.SameLine()
    imgui.PushItemWidth(100)
    imgui.SliderInt(u8"Месяц##", iMonth, 1, 12)
    imgui.SameLine()
    imgui.SliderInt(u8"День", iDay, 1, 31)
    getDayLogs(iMonth.v, string.sub(iYears[iYear.v + 1], 3, 4), iDay.v)
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
    imgui.SetColumnWidth(-1, 145)
    imgui.Text(u8"Дата")
    imgui.NextColumn()
    imgui.Columns(1)
    if csvall[date] ~= nil then
      imgui.BeginChild("##scrollingregion", imgui.ImVec2(0, 120))
      imgui.Columns(6)
      imgui.Separator()
      for _ = #csvall[date], 1, - 1 do
        if _ > 0 then
          _ = csvall[date][_]
          CSV_id, CSV_nickname, CSV_vopros, CSV_otvet, CSV_respondtime, CSV_dateandtime, CSV_unix = string.match(_, "(.+),(.+),(.+),(.+),(.+),(.+),(.+)")
          imgui.Selectable(CSV_id)
          imgui.SetColumnWidth(-1, 50)
          imgui.NextColumn()
          imgui.SetColumnWidth(-1, 135)
          imgui.Selectable(CSV_nickname)
          imgui.NextColumn()
          imgui.SetColumnWidth(-1, AQWidth)
          imgui.TextWrapped(u8:encode(CSV_vopros))
          imgui.NextColumn()
          imgui.SetColumnWidth(-1, AQWidth)
          imgui.TextWrapped(u8:encode(CSV_otvet))
          imgui.NextColumn()
          imgui.SetColumnWidth(-1, 40)
          imgui.Selectable(CSV_respondtime)
          imgui.NextColumn()
          imgui.SetColumnWidth(-1, 140)
          imgui.Selectable(CSV_dateandtime)
          imgui.NextColumn()
          imgui.Separator()
        end
      end
      imgui.Columns(1)
      imgui.EndChild()
    end
  end
end

function imgui_stats()
  if imgui.CollapsingHeader(u8"Статистика ответов") then
    imgui.PushItemWidth(100)
    imgui.Combo(u8"Год", iYear, iYears)
    imgui.PopItemWidth()
    imgui.PushItemWidth(200)
    imgui.SameLine()
    imgui.SliderInt(u8"Месяц", iMonth, 1, 12)
    getMonthStats(iMonth.v, string.sub(iYears[iYear.v + 1], 3, 4))
    imgui.PlotHistogram("##Статистика", month_histogram, 0, u8:encode(iMonths[iMonth.v].." "..iYears[iYear.v + 1]), 0, math.max(unpack(month_histogram)) + math.max(unpack(month_histogram)) * 0.15, imgui.ImVec2(imgui.GetWindowContentRegionWidth(), 160))
  end
end

function imgui_settings()
  if imgui.CollapsingHeader(u8"Настройки") then
    if imgui.Checkbox("##HideQuestionCheck", iShowTimeToUpdateCSV) then
      cfg.options.ShowTimeToUpdateCSV = iShowTimeToUpdateCSV.v
      inicfg.save(cfg, "support")
    end
    imgui.SameLine()
    if iShowQuestion.v then imgui.Text(u8("Показывать время обработки csv?")) else imgui.TextDisabled(u8"Показывать время обработки csv?") end
    if imgui.Checkbox("##HideQuestionCheck", iShowQuestion) then
      cfg.options.ShowQuestion = iShowQuestion.v
      inicfg.save(cfg, "support")
    end
    imgui.SameLine()
    if iShowQuestion.v then imgui.Text(u8("Показывать вопросы в чате?")) else imgui.TextDisabled(u8"Показывать вопросы в чате?") end
    if imgui.Checkbox("##HideAnswerCheck", iShowAnswer) then
      cfg.options.ShowAnswer = iShowAnswer.v
      inicfg.save(cfg, "support")
    end
    imgui.SameLine()
    if iShowAnswer.v then imgui.Text(u8("Показывать ответы в чате?")) else imgui.TextDisabled(u8"Показывать ответы в чате?") end
    if imgui.Checkbox("##ReplaceQuestionColorCheck", iReplaceQuestionColor) then
      cfg.options.ReplaceQuestionColor = iReplaceQuestionColor.v
      inicfg.save(cfg, "support")
    end
    imgui.SameLine()
    if iReplaceQuestionColor.v then imgui.Text(u8("Изменять цвет вопросов?")) else imgui.TextDisabled(u8"Изменять цвет вопросов?") end
    imgui.SameLine(190)
    if imgui.ColorEdit4("##Qcolor", Qcolor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha + imgui.ColorEditFlags.NoOptions) then
      cfg.colors.QuestionColor = imgui.ImColor.FromFloat4(Qcolor.v[1], Qcolor.v[2], Qcolor.v[3], Qcolor.v[4]):GetU32()
      local r, g, b, a = imgui.ImColor.FromFloat4(Qcolor.v[1], Qcolor.v[2], Qcolor.v[3], Qcolor.v[4]):GetRGBA()
      Qcolor_HEX = "0x"..string.sub(bit.tohex(join_argb(a, r, g, b)), 3, 8)
      inicfg.save(cfg, "support")
    end
    imgui.AlignTextToFramePadding()
    if imgui.Checkbox("##ReplaceAnswerColorCheck", iReplaceAnswerColor) then
      cfg.options.ReplaceAnswerColor = iReplaceAnswerColor.v
      inicfg.save(cfg, "support")
    end
    imgui.SameLine()
    if iReplaceAnswerColor.v then imgui.Text(u8("Изменять цвет ответов?")) else imgui.TextDisabled(u8"Изменять цвет ответов?") end
    imgui.SameLine(190)
    if imgui.ColorEdit4("##Acolor", Acolor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha + imgui.ColorEditFlags.NoOptions) then
      cfg.colors.AnswerColor = imgui.ImColor.FromFloat4(Acolor.v[1], Acolor.v[2], Acolor.v[3], Acolor.v[4]):GetU32()
      local r, g, b, a = imgui.ImColor.FromFloat4(Acolor.v[1], Acolor.v[2], Acolor.v[3], Acolor.v[4]):GetRGBA()
      Acolor_HEX = "0x"..string.sub(bit.tohex(join_argb(a, r, g, b)), 3, 8)
      inicfg.save(cfg, "support")
    end
    imgui.PushItemWidth(80)
    if imgui.InputInt(u8"Количество строк блокнота", iNotepadLines) then
      cfg.notepad.lines = iNotepadLines.v
      inicfg.save(cfg, "support")
    end
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
apply_custom_style()
