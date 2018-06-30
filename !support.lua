--meta
script_name("support")
script_author("rubbishman")
script_version('0.01')
script_description('/supcolor - изменить цвет вопросов/ответов. /supstats - статистика ответов за день, неделю и всё время.')
script_dependencies('SAMPFUNCS', 'Dear imgui', 'SAMP.Lua')
--------------------------------------------------------------------------------
--------------------------------------VAR---------------------------------------
--------------------------------------------------------------------------------
local sampev = require 'lib.samp.events'
local file = getGameDirectory()..'\\moonloader\\support.csv'
color = 0xffa500
local imgui = require 'imgui'
local inspect = require 'inspect'
local month_histogram = {}
local key = require 'vkeys'
local selected = 1
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local dlstatus = require('moonloader').download_status
local inicfg = require "inicfg"
local cfg = inicfg.load({
  options =
  {
    ReplaceQuestionColor = true,
    ReplaceAnswerColor = false,
  },
  colors =
  {
    QuestionColor = imgui.ImColor(255, 255, 255):GetU32(),
    AnswerColor = imgui.ImColor(255, 255, 255):GetU32()
  }
}, 'support')
local iYear = imgui.ImInt(0)
local iReplaceQuestionColor = imgui.ImBool(cfg.options.ReplaceQuestionColor)
local iReplaceAnswerColor = imgui.ImBool(cfg.options.ReplaceAnswerColor)
local iYears = {}
local Qcolor = imgui.ImFloat4(imgui.ImColor(cfg.colors.QuestionColor):GetFloat4())
local Acolor = imgui.ImFloat4(imgui.ImColor(cfg.colors.AnswerColor):GetFloat4())
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
local main_window_state = imgui.ImBool(false)
local iStats = imgui.ImBool(true)
--------------------------------------------------------------------------------
-------------------------------------MAIN---------------------------------------
--------------------------------------------------------------------------------
function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do wait(100) end
  inicfg.save(cfg, "support")

  local r, g, b, a = imgui.ImColor.FromFloat4(Qcolor.v[1], Qcolor.v[2], Qcolor.v[3], Qcolor.v[4]):GetRGBA()
  Qcolor_HEX = "0x"..string.sub(bit.tohex(join_argb(a, r, g, b)), 3, 8)

  local r, g, b, a = imgui.ImColor.FromFloat4(Acolor.v[1], Acolor.v[2], Acolor.v[3], Acolor.v[4]):GetRGBA()
  Acolor_HEX = "0x"..string.sub(bit.tohex(join_argb(a, r, g, b)), 3, 8)

  -- вырезать тут, если хочешь отключить сообщение при входе в игру
  sampAddChatMessage(("SUPPORT v"..thisScript().version.." successfully loaded! Команды: /supstats и /supcolor! Author: rubbishman.ru"), color)
  -- вырезать тут, если хочешь отключить сообщение при входе в игру

  sampRegisterChatCommand("supcolor", colorPicker)
  sampRegisterChatCommand("supstats", getStats)
  while true do
    wait(0)
    if wasKeyPressed(key.VK_Z) then
      if not main_window_state.v then
        updateStats()
      end
      main_window_state.v = not main_window_state.v
    end
    imgui.Process = main_window_state.v
  end
end
--------------------------------------------------------------------------------
-------------------------------------SUBJ---------------------------------------
--------------------------------------------------------------------------------
--заменяем цвет
function sampev.onServerMessage(color, text)
  if color == -5963521 then
    sampAddChatMessage(text, cfg.colors.QuestionColor)
    return false
  end
end
--считаем активность саппорта
function sampev.onSendCommand(text)
  if string.find(text, '/pm') then
    id, text = string.match(text, "(%d+) (.+)")
    if id ~= nil and tonumber(id) ~= nil and tonumber(id) <= sampGetMaxPlayerId() and sampIsPlayerConnected(id) and sampGetPlayerNickname(id) ~= nil then
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
    cfg.colors.QuestionColor = "0x"..param
    inicfg.save(cfg, "support")
    sampAddChatMessage('Изменено.', cfg.colors.QuestionColor)
  end
end
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
    table.insert(csvall, _)
    CSV_id, CSV_nickname, CSV_otvet, CSV_dateandtime, CSV_unix = string.match(_, "(.+),(.+),(.+),(.+),(.+)")
    if tonumber(CSV_unix) ~= nil then
      CSV_unix = tonumber(CSV_unix)
      CSV_year = os.date("%Y", CSV_unix)
      if os.date('%H', CSV_unix) == "01" or os.date('%H', CSV_unix) == '02' or os.date('%H', CSV_unix) == "03" or os.date('%H', CSV_unix) == "04" then
        date = os.date("%x", CSV_unix - (tonumber(os.date("%H", CSV_unix) + 1) * 3600))
      else
        date = os.date("%x", CSV_unix)
      end
      if csv[date] == nil then csv[date] = 0 end
      csv[date] = csv[date] + 1
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
    print('хуй')
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
-------------------------------------imgui--------------------------------------
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
  colors[clr.ButtonHovered] = ImVec4(0.26, 0.59, 0.98, 1.00)
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
--main_window
function imgui.OnDrawFrame()
  if main_window_state.v then
    --imgui.SetNextWindowSize(imgui.ImVec2(520, 400))
    imgui.Begin("Support Assistant v"..thisScript().version, main_window_state, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize)
    if imgui.CollapsingHeader(u8"Последние 100 ответов", imgui.TreeNodeFlags.DefaultOpen) then
      imgui.Columns(4, "mycolumns")
      imgui.Separator()
      imgui.Text("ID")
      imgui.NextColumn()
      imgui.Text("Name")
      imgui.NextColumn()
      imgui.Text("Path")
      imgui.NextColumn()
      imgui.Text("Hovered")
      imgui.NextColumn()
      imgui.Separator()
      for _ = #csvall, #csvall - 100, - 1 do
        if _ > 0 then
          _ = csvall[_]
          CSV_id, CSV_nickname, CSV_otvet, CSV_dateandtime, CSV_unix = string.match(_, "(.+),(.+),(.+),(.+),(.+)")
          imgui.Selectable(CSV_id)
          imgui.NextColumn()
          imgui.Selectable(CSV_nickname)
          imgui.NextColumn()
          imgui.Selectable(CSV_dateandtime)
          imgui.NextColumn()
          imgui.Selectable(CSV_unix)
          imgui.NextColumn()
        end
      end
      imgui.Columns(1)
    end
    if imgui.CollapsingHeader(u8"Статистика", imgui.TreeNodeFlags.DefaultOpen) then
      imgui.PushItemWidth(100)
      imgui.Combo(u8"Год", iYear, iYears)
      imgui.PopItemWidth()
      imgui.SameLine()
      imgui.SliderInt(u8"Месяц", iMonth, 1, 12)
      getMonthStats(iMonth.v, string.sub(iYears[iYear.v + 1], 3, 4))
      imgui.PlotHistogram("##Статистика", month_histogram, 0, u8:encode(iMonths[iMonth.v].." "..iYears[iYear.v + 1]), 0, math.max(unpack(month_histogram)) + math.max(unpack(month_histogram)) * 0.15, imgui.ImVec2(500, 160))
    end
    if imgui.CollapsingHeader(u8"Настройки") then
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
    end
    imgui.End()
  end
end
