--meta
script_name("support")
script_author("rubbishman")
script_version('0.01')
script_dependencies('SAMPFUNCS', 'Dear imgui', 'SAMP.Lua')
--------------------------------------VAR---------------------------------------
function var_require()
  imgui = require 'imgui'
  inicfg = require "inicfg"
  dlstatus = require('moonloader').download_status
  as_action = require('moonloader').audiostream_state
  sampev = require 'lib.samp.events'
  inspect = require 'inspect'
  key = require 'vkeys'
  encoding = require 'encoding'
  encoding.default = 'CP1251'
  u8 = encoding.UTF8
end

function var_cfg()
	cfg = inicfg.load({
	  options =
	  {
	    ReplaceQuestionColor = true,
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
	    HideSmsReceived = false,
	    SoundQuestion = true,
	    SoundQuestionNumber = 1,
	    SoundAnswerOthers = true,
	    SoundAnswerOthersNumber = 22,
	    SoundAnswer = true,
	    SoundAnswerNumber = 15,
	    SoundSmsIn = true,
	    SoundSmsInNumber = 22,
	    SoundSmsOut = true,
	    SoundSmsOutNumber = 15,
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
	  colors =
	  {
	    QuestionColor = imgui.ImColor(255, 255, 255):GetU32(),
	    AnswerColor = imgui.ImColor(255, 255, 255):GetU32(),
	    AnswerColorOthers = imgui.ImColor(255, 255, 255):GetU32(),
	    SmsInColor = imgui.ImColor(255, 255, 255):GetU32(),
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
	  messanger =
	  {
	    storesms = true,
	    activesduty = true,
	    iSMSfilterBool = false,
	    activesms = true,
	    mode = 1,
	    Height = 300,
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
	    iSetKeyboard = true,
	    iShowSHOWOFFLINESDUTY = true,
	    iShowSHOWOFFLINESMS = true,
	  },
	  notepad =
	  {
	    active = true,
	    text = "Тут можно писать.\\nEnter - новая строка.\\nCtrl + Enter - сохранить текст.\\nESC - отменить изменения.\\nTAB - табуляция.",
	    lines = 10,
	  }
	}, 'support')
end

function var_imgui_ImBool()
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
  iChangeScroll = imgui.ImBool(cfg.messanger.iChangeScroll)
  iSetKeyboard = imgui.ImBool(cfg.messanger.iSetKeyboard)
  iNotepadActive = imgui.ImBool(cfg.notepad.active)
  iMessangerActiveSDUTY = imgui.ImBool(cfg.messanger.activesduty)
  iMessangerActiveSMS = imgui.ImBool(cfg.messanger.activesms)
  iLogBool = imgui.ImBool(cfg.log.logger)
  iLogActive = imgui.ImBool(cfg.log.active)
  iStatsActive = imgui.ImBool(cfg.stats.active)
  iShowSHOWOFFLINESDUTY = imgui.ImBool(cfg.messanger.iShowSHOWOFFLINESDUTY)
  iShowSHOWOFFLINESMS = imgui.ImBool(cfg.messanger.iShowSHOWOFFLINESMS)
  iShowTimeToUpdateCSV = imgui.ImBool(cfg.options.ShowTimeToUpdateCSV)
  iSoundQuestion = imgui.ImBool(cfg.options.SoundQuestion)
  iSoundAnswerOthers = imgui.ImBool(cfg.options.SoundAnswerOthers)
  iSoundAnswer = imgui.ImBool(cfg.options.SoundAnswer)
  iSoundSmsIn = imgui.ImBool(cfg.options.SoundSmsIn)
  iSoundSmsOut = imgui.ImBool(cfg.options.SoundSmsOut)
  iStoreSMS = imgui.ImBool(cfg.messanger.storesms)
  iSMSfilterBool = imgui.ImBool(cfg.messanger.iSMSfilterBool)
  main_window_state = imgui.ImBool(false)
  iStats = imgui.ImBool(true)
end

function var_imgui_ImFloat4_ImColor()
  iQcolor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.QuestionColor):GetFloat4())
  iAcolor = imgui.ImFloat4(imgui.ImColor(cfg.messanger.AnswerColor):GetFloat4())
  iAcolor1 = imgui.ImFloat4(imgui.ImColor(cfg.messanger.AnswerColorOthers):GetFloat4())

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
  iYear = imgui.ImInt(0)
  iDay = imgui.ImInt(tonumber(os.date("%d")))
  iMonth = imgui.ImInt(tonumber(os.date("%m")))
end

function var_imgui_ImBuffer()
  toAnswerSDUTY = imgui.ImBuffer(150)
  toAnswerSMS = imgui.ImBuffer(150)
  iSMSfilter = imgui.ImBuffer(64)
  iSMSAddDialog = imgui.ImBuffer(64)
  textNotepad = imgui.ImBuffer(65536)
  textNotepad.v = string.gsub(string.gsub(u8:encode(cfg.notepad.text), "\\n", "\n"), "\\t", "\t")
end

function var_main()
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
	file = getGameDirectory()..'\\moonloader\\support.csv'
	color = 0xffa500
	selected = 1
	selecteddialogSDUTY = ""
	month_histogram = {}
	players = {}
	iYears = {}
	iMessanger = {}
  LASTID = 0
  countall = 0
  ScrollToDialogSDUTY = false
  ScrollToDialogSMS = false
  LASTNICK = " "
  PLAYA = false
  iAddSMS = false
  PLAYQ = false
  PLAYA1 = false
  PLAYSMSIN = false
  PLAYSMSOUT = false
  SSDB_trigger = false
  DEV = false
  math.randomseed(os.time())
end
--varload
var_require()
var_cfg()
var_imgui_ImBool()
var_imgui_ImFloat4_ImColor()
var_imgui_ImInt()
var_imgui_ImBuffer()
var_main()
-------------------------------------MAIN---------------------------------------
function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do wait(100) end
  if not doesDirectoryExist(getGameDirectory().."\\moonloader\\resource\\sup") then
    createDirectory(getGameDirectory().."\\moonloader\\resource\\sup")
  end
  for i = 1, 100 do
    local file = getGameDirectory().."\\moonloader\\resource\\sup\\"..i..".mp3"
    if not doesFileExist(file) then
      downloadUrlToFile("http://rubbishman.ru/dev/moonloader/support's%20heaven/resource/sup/"..i..".mp3", file)
    end
  end
  if not doesDirectoryExist(getGameDirectory().."\\moonloader\\config\\smsmessanger\\") then
    createDirectory(getGameDirectory().."\\moonloader\\config\\smsmessanger\\")
  end
  smsfile = getGameDirectory()..'\\moonloader\\config\\smsmessanger\\'..sampGetCurrentServerAddress().."-"..sampGetPlayerNickname(myid)..'.sms'
  imgui_messanger_sms_loadDB()
  inicfg.save(cfg, "support")
  _213, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
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

  -- вырезать тут, если хочешь отключить сообщение при входе в игру
  sampAddChatMessage(("SUPPORT v"..thisScript().version.." successfully loaded! Команды: /supstats и /supcolor! Author: rubbishman.ru"), color)
  -- вырезать тут, если хочешь отключить сообщение при входе в игру
  First = true
  while true do
    wait(0)
    if SSDB_trigger == true then if DEV then sampAddChatMessage("сохраняем", color) end imgui_messanger_sms_saveDB() SSDB_trigger = false end
    if wasKeyPressed(key.VK_B) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
      FastChatRespond()
    end
    if wasKeyPressed(key.VK_C) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
      print(inspect(sms))
      table.save(sms, getGameDirectory()..'\\moonloader\\config\\smsmessanger\\'..sampGetCurrentServerAddress().."-"..sampGetPlayerNickname(myid)..'.sms')
    end
    if wasKeyPressed(key.VK_Z) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() or First then
      First = false
      if not main_window_state.v and cfg.log.logger then
        local a = os.clock()
        updateStats()
        if iShowTimeToUpdateCSV.v then
          printStringNow(os.clock() - a.." sec.", 2000)
        end
      end
      main_window_state.v = not main_window_state.v
    end
    if PLAYQ then
      PLAYQ = false
      a1 = loadAudioStream(getGameDirectory()..[[\moonloader\resource\sup\]]..iSoundQuestionNumber.v..[[.mp3]])
      if getAudioStreamState(a1) ~= as_action.PLAY then
        setAudioStreamState(a1, as_action.PLAY)
      end
    end
    if PLAYA1 then
      PLAYA1 = false
      a2 = loadAudioStream(getGameDirectory()..[[\moonloader\resource\sup\]]..iSoundAnswerOthersNumber.v..[[.mp3]])
      if getAudioStreamState(a2) ~= as_action.PLAY then
        setAudioStreamState(a2, as_action.PLAY)
      end
    end
    if PLAYA then
      PLAYA = false
      a3 = loadAudioStream(getGameDirectory()..[[\moonloader\resource\sup\]]..iSoundAnswerNumber.v..[[.mp3]])
      if getAudioStreamState(a3) ~= as_action.PLAY then
        setAudioStreamState(a3, as_action.PLAY)
      end
    end
    if PLAYSMSIN then
      PLAYSMSIN = false
      a4 = loadAudioStream(getGameDirectory()..[[\moonloader\resource\sup\]]..iSoundSmsInNumber.v..[[.mp3]])
      if getAudioStreamState(a4) ~= as_action.PLAY then
        setAudioStreamState(a4, as_action.PLAY)
      end
    end
    if PLAYSMSOUT then
      PLAYSMSOUT = false
      a5 = loadAudioStream(getGameDirectory()..[[\moonloader\resource\sup\]]..iSoundSmsOutNumber.v..[[.mp3]])
      if getAudioStreamState(a5) ~= as_action.PLAY then
        setAudioStreamState(a5, as_action.PLAY)
      end
    end
    imgui.Process = main_window_state.v
  end
end
-------------------------------------SUBJ---------------------------------------
--симулируем саппорта
function simulateSupport(text)
  if not string.find(text, "недос") then
    tempid = math.random(1, 10)
    if sampIsPlayerConnected(tempid) then
      if math.random(1, 10) ~= 1 then
        if iSoundQuestion.v then PLAYQ = true end
        text = "->Вопрос "..sampGetPlayerNickname(tempid).."["..tempid.."]: "..text
        sampAddChatMessage(text, Qcolor_HEX)
        AddQ(text)
      else
        if iSoundAnswerOthers.v then PLAYA1 = true end
        text = "<-FutureAdmin[228] to "..LASTNICK.."["..LASTID.."]: "..text
        sampAddChatMessage(text, Acolor1_HEX)
        AddA(text)
      end
      if selecteddialogSDUTY == LASTNICK or selecteddialogSDUTY == sampGetPlayerNickname(tempid) then ScrollToDialogSDUTY = true end
    end
  end
end

function simulateSupportAnswer(text)
  sampAddChatMessage(text, Acolor_HEX)
end

function sampev.onPlaySound(sound)
  if sound == 1052 and iSoundSmsOut.v then
    return false
  end
end
--говно
function sampev.onServerMessage(color, text)
  if DEV then simulateSupport(text) end

  if text:find("SMS") then
    text = string.gsub(text, "{FFFF00}", "")
    text = string.gsub(text, "{FF8000}", "")
    local smsText, smsNick, smsId = string.match(text, "^ SMS%: (.*)%. Отправитель%: (.*)%[(%d+)%]")
    if smsText and smsNick and smsId then
      if iSoundSmsIn.v then PLAYSMSIN = true end
      if sms[smsNick] and sms[smsNick].Chat then

      else
        sms[smsNick] = {}
        sms[smsNick]["Chat"] = {}
        sms[smsNick]["Checked"] = 0
        sms[smsNick]["Pinned"] = 0
      end
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
    if text:find("->Вопрос", true) then
      AddQ(text)
      if iSoundQuestion.v then PLAYQ = true end
      if not iHideSmsReceived.v then
        if iReplaceSmsReceivedColor.v then
          sampAddChatMessage(text, SmsReceivedColor_HEX)
          return false -- ИСПРАВИТЬ
        else
          --do nothing
        end
      else
        return false
      end
    end
    if text:find("<-", true) and text:find("to", true) then
      AddA(text)
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
  if DEV then return false end -- исправить
end
--считаем активность саппорта
function sampev.onSendCommand(text)
  if string.find(text, '/pm') then
    parseHostAnswer(text)
    if iSoundAnswer.v then PLAYA = true end
    id, text = string.match(text, "(%d+) (.+)")
    if sampIsPlayerConnected(id) then
      local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
      if selecteddialogSDUTY == sampGetPlayerNickname(id) then ScrollToDialogSDUTY = true end
      text = "<-"..sampGetPlayerNickname(myid).."["..myid.."]".." to "..sampGetPlayerNickname(id).."["..id.."]: "..text
      if DEV then simulateSupportAnswer(text) end
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

function AddA(text)
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

function parseHostAnswer(text)
  if iLogBool.v then
    id, text = string.match(text, "(%d+) (.+)")
    if id ~= nil and tonumber(id) ~= nil and tonumber(id) <= sampGetMaxPlayerId() and sampIsPlayerConnected(id) and sampGetPlayerNickname(id) ~= nil then
      string = string.format("%s,%s,%s,%s,%s,%s,%s", getid(), sampGetPlayerNickname(id), getLastQuestion(sampGetPlayerNickname(id)),
      string.gsub(text, "[\"\', ]", ""), getRespondTime(sampGetPlayerNickname(id), os.time()), os.date('%Y - %m - %d %X'), os.time())
      file_write(file, string)
    end
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
-------------------------------------HELP---------------------------------------
function join_argb(a, r, g, b)
  local argb = b -- b
  argb = bit.bor(argb, bit.lshift(g, 8)) -- g
  argb = bit.bor(argb, bit.lshift(r, 16)) -- r
  argb = bit.bor(argb, bit.lshift(a, 24)) -- a
  return argb
end
------------------------------------STATS---------------------------------------
function updateStats()
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
    f:write("")
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
    if cfg.messanger.activesduty or cfg.messanger.activesms then imgui_messanger() end
    if cfg.notepad.active then imgui_notepad() end
    if cfg.log.active then imgui_log() end
    if cfg.stats.active then imgui_stats() end
    imgui_settings()
    imgui.End()
  end
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

function imgui_messanger()
  if imgui.CollapsingHeader(u8"Мессенджер") then
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
  end
  imgui.Columns(1)
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
      else
        iSMSAddDialog.v = ""
        for i = 0, sampGetMaxPlayerId() + 1 do
          if sampIsPlayerConnected(i) and i == tonumber(createnewdialognick) or sampIsPlayerConnected(i) and string.find(string.lower(sampGetPlayerNickname(i)), string.lower(createnewdialognick)) then
            if sms[sampGetPlayerNickname(i)] == nil then
              sms[sampGetPlayerNickname(i)] = {}
              sms[sampGetPlayerNickname(i)]["Chat"] = {}
              sms[sampGetPlayerNickname(i)]["Checked"] = 0
              sms[sampGetPlayerNickname(i)]["Pinned"] = 0
              iAddSMS = false
              table.insert(sms[sampGetPlayerNickname(i)]["Chat"], {text = "Вы создали диалог", Nick = "мессенджер", type = "TO", time = os.time()})
              selecteddialogSMS = sampGetPlayerNickname(i)
              SSDB_trigger = true
              break
            else
              selecteddialogSMS = sampGetPlayerNickname(i)
              iAddSMS = false
              break
            end
          end
        end
      end
    end
    if KeyboardFocusResetForNewDialog then imgui.SetKeyboardFocusHere() KeyboardFocusResetForNewDialog = false end
    if iSMSAddDialog.v ~= "" then
      for i = 0, sampGetMaxPlayerId() do
        if sampIsPlayerConnected(i) and i == tonumber(iSMSAddDialog.v) or sampIsPlayerConnected(i) and string.find(string.lower(sampGetPlayerNickname(i)), string.lower(iSMSAddDialog.v)) then
          imgui.SetTooltip(u8:encode(sampGetPlayerNickname(i).."["..i.."]"))
          break
        end
      end
    end
    imgui.SameLine()
    if imgui.Button(u8"close", imgui.ImVec2(imgui.GetContentRegionAvailWidth(), 20)) then
      iSMSAddDialog.v = ""
      iAddSMS = false
    end
  end
  imgui.PopStyleColor()
  --if imgui.InputText("##keyboardSMSKA", toAnswerSMS, imgui.InputTextFlags.EnterReturnsTrue) then end
  imgui.EndChild()
end

function imgui_messanger_sms_player_list()
  if cfg.messanger.activesduty and cfg.messanger.activesms then
    playerlistY = iMessangerHeight.v - 74
  else
    playerlistY = iMessangerHeight.v - 35
  end
  imgui.BeginChild("список ников", imgui.ImVec2(192, playerlistY), true)

  smsindex_PINNED = {}
  smsindex_PINNEDVIEWED = {}
  smsindex_NEW = {}
  smsindex_NEWVIEWED = {}
  for k in pairs(sms) do
    if cfg.messanger.iSMSfilterBool and cfg.messanger.smsfiltertext ~= nil then
      if cfg.messanger.smsfiltertext ~= "" then
        if string.find(string.lower(k), string.lower(cfg.messanger.smsfiltertext)) ~= nil then
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
  if iShowUA1.v then imgui_messanger_sms_showdialogs(smsindex_PINNED, "Pinned") end
  if iShowUA2.v then imgui_messanger_sms_showdialogs(smsindex_PINNEDVIEWED, "Pinned") end
  if iShowA1.v then imgui_messanger_sms_showdialogs(smsindex_NEW, "NotPinned") end
  if iShowA2.v then imgui_messanger_sms_showdialogs(smsindex_NEWVIEWED, "NotPinned") end
  if scroll then scroll = false end
  imgui.EndChild()
end

function imgui_messanger_sms_player_list_filter(k)
  if sms[k]["Pinned"] ~= nil and sms[k]["Chat"] ~= nil and sms[k]["Checked"] then
    if sms[k]["Pinned"] == 1 then
      kolvo = 0
      if #sms[k]["Chat"] ~= 0 then
        for i, z in pairs(sms[k]["Chat"]) do
          if z["type"] ~= "TO" and z["time"] > sms[k]["Checked"] then
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
    playerlistY = iMessangerHeight.v - 74
  else
    playerlistY = iMessangerHeight.v - 35
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
  if scroll then scroll = false end
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
          if z["type"] ~= "TO" and z["time"] > v["Checked"] then
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
      if scroll and iChangeScroll.v then
        imgui.SetScrollHere()
      end
      if kolvo > 0 then
        if pId ~= nil and sampIsPlayerConnected(pId) and sampGetPlayerNickname(pId) == k then
          if imgui.Button(u8(k .. "[" .. pId .. "] - "..kolvo), imgui.ImVec2(-0.0001, 30)) then
            selecteddialogSMS = k
            ScrollToDialogSMS = true
            online = "Онлайн"
            scroll = true
            keyboard = true
            SSDB_trigger = true
          end
        elseif iShowSHOWOFFLINESMS.v then
          if imgui.Button(u8(k .. "[-] - "..kolvo), imgui.ImVec2(-0.0001, 30)) then
            selecteddialogSMS = k
            ScrollToDialogSMS = true
            online = "Оффлайн"
            scroll = true
            keyboard = true
            SSDB_trigger = true
          end
        end
      else
        if pId ~= nil and sampIsPlayerConnected(pId) and sampGetPlayerNickname(pId) == k then
          if imgui.Button(u8(k .. "[" .. pId .. "]"), imgui.ImVec2(-0.0001, 30)) then
            selecteddialogSMS = k
            ScrollToDialogSMS = true
            online = "Онлайн"
            scroll = true
            keyboard = true
            SSDB_trigger = true
          end
        elseif iShowSHOWOFFLINESMS.v then
          if imgui.Button(u8(k .. "[-]"), imgui.ImVec2(-0.0001, 30)) then
            selecteddialogSMS = k
            ScrollToDialogSMS = true
            online = "Оффлайн"
            scroll = true
            keyboard = true
            SSDB_trigger = true
          end
        end
      end
      imgui_messanger_sms_player_list_contextmenu(k, typ)
      if typ == "Pinned" then
        imgui.PopStyleColor(3)
        imgui.PopID()
      end
      if typ == "NotPinned" then
        imgui.PopStyleColor(3)
        imgui.PopID()
      end
    end
  end
end

function imgui_messanger_sms_player_list_contextmenu(k, typ)
  if imgui.BeginPopupContextItem("item context menu"..k) then
    if typ == "NotPinned" then
      if imgui.Selectable(u8"Закрепить") then sms[k]["Pinned"] = 1 SSDB_trigger = true end
    else
      if imgui.Selectable(u8"Открепить") then sms[k]["Pinned"] = 0 SSDB_trigger = true end
    end
    if sms[k]["Blocked"] ~= nil then
      if imgui.Selectable(u8"Разблокировать") then sms[k]["Blocked"] = nil SSDB_trigger = true end
    else
      if imgui.Selectable(u8"Заблокировать") then sms[k]["Blocked"] = 1 SSDB_trigger = true end
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
      sms[k]["Chat"][1] = {text = "Вы очистили диалог", Nick = "мессенджер", type = "TO", time = os.time()}
      selecteddialogSMS = k
      SSDB_trigger = true
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
      if scroll and iChangeScroll.v then
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
  if cfg.messanger.mode == 1 then
    imgui.PushStyleColor(imgui.Col.Button, imgui.ImColor(0, 0, 0, 200):GetVec4())
  else
    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.26, 0.59, 0.98, 0.40))
  end
  if imgui.Button(u8("SDUTY"), imgui.ImVec2(85, 20)) then
    cfg.messanger.mode = 1
    inicfg.save(cfg, "support")
  end
  imgui.PopStyleColor()
  if cfg.messanger.mode == 2 then
    imgui.PushStyleColor(imgui.Col.Button, imgui.ImColor(0, 0, 0, 200):GetVec4())
  else
    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.26, 0.59, 0.98, 0.40))
  end
  imgui.SameLine()
  if imgui.Button(u8("SMS"), imgui.ImVec2(85, 20)) then
    cfg.messanger.mode = 2
    inicfg.save(cfg, "support")
  end
  imgui.PopStyleColor()
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
    imgui.Text(u8:encode("["..online.."] Ник: "..selecteddialogSDUTY..". ID: "..tonumber(sId)..". LVL: "..sampGetPlayerScore(tonumber(sId))..". Время: "..qtime.." сек."))
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
    end
  end
  imgui.EndChild()
end

function imgui_messanger_sup_dialog()
  imgui.BeginChild("##middle", imgui.ImVec2(imgui.GetContentRegionAvailWidth(), iMessangerHeight.v - 74), true)
  if selecteddialogSDUTY ~= nil and iMessanger[selecteddialogSDUTY] ~= nil and iMessanger[selecteddialogSDUTY]["Chat"] ~= nil then
    for k, v in ipairs(iMessanger[selecteddialogSDUTY]["Chat"]) do
      local msg = string.format("%s", u8:encode(v.text))
      local size = imgui.GetFont():CalcTextSizeA(imgui.GetFont().FontSize, 350.0, 346.0, msg)
      local x = imgui.GetContentRegionAvailWidth() / 2 - 25
      if v.type == "support" and v.Nick == sampGetPlayerNickname(myid) then
        imgui.NewLine()
        imgui.SameLine(imgui.GetContentRegionAvailWidth() - x - imgui.GetStyle().ScrollbarSize + 10)
      end
      if v.type == "client" then
        local r, g, b, a = imgui.ImColor(cfg.messanger.QuestionColor):GetRGBA()
        imgui.PushStyleColor(imgui.Col.ChildWindowBg, imgui.ImColor(r, g, b, a):GetVec4())
      end
      if v.type == "support" then
        if v.Nick == sampGetPlayerNickname(myid) then
          local r, g, b, a = imgui.ImColor(cfg.messanger.AnswerColor):GetRGBA()
          imgui.PushStyleColor(imgui.Col.ChildWindowBg, imgui.ImColor(r, g, b, a):GetVec4())
        else
          local r, g, b, a = imgui.ImColor(cfg.messanger.AnswerColorOthers):GetRGBA()
          imgui.PushStyleColor(imgui.Col.ChildWindowBg, imgui.ImColor(r, g, b, a):GetVec4())
        end
      end
      imgui.PushStyleVar(imgui.StyleVar.WindowPadding, imgui.ImVec2(4.0, 2.0))
      imgui.BeginChild("##msg" .. k, imgui.ImVec2(x + 8.0, 50 + 6.0), false, imgui.WindowFlags.AlwaysUseWindowPadding + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
      if v.type == "client" then
        local r, g, b, a = imgui.ImColor(cfg.messanger.QuestionTextColor):GetRGBA()
        imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(r, g, b, a):GetVec4())
        local r, g, b, a = imgui.ImColor(cfg.messanger.QuestionTimeColor):GetRGBA()
        imgui.TextColored(imgui.ImColor(r, g, b, a):GetVec4(), os.date("%X", v.time))
        imgui.SameLine()
        local r, g, b, a = imgui.ImColor(cfg.messanger.QuestionHeaderColor):GetRGBA()
        imgui.TextColored(imgui.ImColor(r, g, b, a):GetVec4(), u8:encode("->Вопрос от "..v.Nick))
      end
      if v.type == "support" then
        if v.Nick == sampGetPlayerNickname(myid) then
          local r, g, b, a = imgui.ImColor(cfg.messanger.AnswerTextColor):GetRGBA()
          imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(r, g, b, a):GetVec4())
          local r, g, b, a = imgui.ImColor(cfg.messanger.AnswerTimeColor):GetRGBA()
          imgui.TextColored(imgui.ImColor(r, g, b, a):GetVec4(), os.date("%X", v.time))
          imgui.SameLine()
          local r, g, b, a = imgui.ImColor(cfg.messanger.AnswerHeaderColor):GetRGBA()
          imgui.TextColored(imgui.ImColor(r, g, b, a):GetVec4(), u8:encode("<-Отвеsт от "..v.Nick))
        else
          local r, g, b, a = imgui.ImColor(cfg.messanger.AnswerTextOthersColor):GetRGBA()
          imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(r, g, b, a):GetVec4())
          local r, g, b, a = imgui.ImColor(cfg.messanger.AnswerTimeOthersColor):GetRGBA()
          imgui.TextColored(imgui.ImColor(r, g, b, a):GetVec4(), os.date("%X", v.time))
          imgui.SameLine()
          local r, g, b, a = imgui.ImColor(cfg.messanger.AnswerHeaderOthersColor):GetRGBA()
          imgui.TextColored(imgui.ImColor(r, g, b, a):GetVec4(), u8:encode("<-Ответ от "..v.Nick))
        end
      end
      imgui.TextWrapped(msg)
      imgui.PopStyleColor()
      imgui.EndChild()
      imgui.PopStyleVar()
      imgui.PopStyleColor()
    end
    if ScrollToDialogSDUTY then
      imgui.SetScrollHere()
      ScrollToDialogSDUTY = false
    end
  else
    if iMessanger[selecteddialogSDUTY] == nil then
      imgui.SetCursorPos(imgui.ImVec2(imgui.GetContentRegionAvailWidth() / 3, (iMessangerHeight.v - 100) / 2))
      imgui.Text(u8"Выберите диалог.")
    end
  end
  imgui.EndChild()
end

function imgui_messanger_sms_dialog()
  imgui.BeginChild("##middle", imgui.ImVec2(imgui.GetContentRegionAvailWidth(), iMessangerHeight.v - 74), true)
  if selecteddialogSMS ~= nil and sms[selecteddialogSMS] ~= nil and sms[selecteddialogSMS]["Chat"] ~= nil then
    for k, v in ipairs(sms[selecteddialogSMS]["Chat"]) do
      local msg = string.format("%s", u8:encode(v.text))
      local size = imgui.GetFont():CalcTextSizeA(imgui.GetFont().FontSize, 350.0, 346.0, msg)
      local x = imgui.GetContentRegionAvailWidth() / 2 - 25
      if v.type == "TO" then
        imgui.NewLine()
        imgui.SameLine(imgui.GetContentRegionAvailWidth() - x - imgui.GetStyle().ScrollbarSize + 10)
      end
      if v.type == "FROM" then
        local r, g, b, a = imgui.ImColor(cfg.messanger.QuestionColor):GetRGBA()
        imgui.PushStyleColor(imgui.Col.ChildWindowBg, imgui.ImColor(r, g, b, a):GetVec4())
      end
      if v.type == "TO" then
        local r, g, b, a = imgui.ImColor(cfg.messanger.AnswerColor):GetRGBA()
        imgui.PushStyleColor(imgui.Col.ChildWindowBg, imgui.ImColor(r, g, b, a):GetVec4())
      end
      imgui.PushStyleVar(imgui.StyleVar.WindowPadding, imgui.ImVec2(4.0, 2.0))
      imgui.BeginChild("##msg" .. k, imgui.ImVec2(x + 8.0, 50 + 6.0), false, imgui.WindowFlags.AlwaysUseWindowPadding + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
      if v.type == "FROM" then
        local r, g, b, a = imgui.ImColor(cfg.messanger.QuestionTextColor):GetRGBA()
        imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(r, g, b, a):GetVec4())
        local r, g, b, a = imgui.ImColor(cfg.messanger.QuestionTimeColor):GetRGBA()
        imgui.TextColored(imgui.ImColor(r, g, b, a):GetVec4(), os.date("%X", v.time))
        imgui.SameLine()
        local r, g, b, a = imgui.ImColor(cfg.messanger.QuestionHeaderColor):GetRGBA()
        imgui.TextColored(imgui.ImColor(r, g, b, a):GetVec4(), u8:encode("->SMS от "..v.Nick))
      end
      if v.type == "TO" then
        local r, g, b, a = imgui.ImColor(cfg.messanger.AnswerTextColor):GetRGBA()
        imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(r, g, b, a):GetVec4())
        local r, g, b, a = imgui.ImColor(cfg.messanger.AnswerTimeColor):GetRGBA()
        imgui.TextColored(imgui.ImColor(r, g, b, a):GetVec4(), os.date("%X", v.time))
        imgui.SameLine()
        local r, g, b, a = imgui.ImColor(cfg.messanger.AnswerHeaderColor):GetRGBA()
        imgui.TextColored(imgui.ImColor(r, g, b, a):GetVec4(), u8:encode("<-SMS от "..v.Nick))
      end
      imgui.TextWrapped(msg)
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
      imgui.SetCursorPos(imgui.ImVec2(imgui.GetContentRegionAvailWidth() / 3, (iMessangerHeight.v - 100) / 2))
      imgui.Text(u8"Выберите диалог.")
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
      for i = 1, sampGetMaxPlayerId() do
        if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == selecteddialogSDUTY then k = i break end
        if i == sampGetMaxPlayerId() then k = "-" end
      end
      if k ~= "-" then
        sampSendChat("/pm " .. k .. " " .. u8:decode(toAnswerSDUTY.v))
        toAnswerSDUTY.v = ''
      end
      KeyboardFocusReset = true
    end
    if imgui.IsItemActive() then
      imgui.LockPlayer = true
    else
      imgui.LockPlayer = false
    end
    if imgui.SameLine() or imgui.Button(u8"Отправить") then
      for i = 1, sampGetMaxPlayerId() do
        if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == selecteddialogSDUTY then k = i break end
        if i == sampGetMaxPlayerId() then k = "-" end
      end
      if k ~= "-" then
        sampSendChat("/pm " .. k .. " " .. u8:decode(toAnswerSDUTY.v))
        toAnswerSDUTY.v = ''
      end
      KeyboardFocusReset = true
    end
  end
  imgui.EndChild()
end

function imgui_messanger_sms_keyboard()
  imgui.BeginChild("##keyboardSMS", imgui.ImVec2(imgui.GetContentRegionAvailWidth(), 35), true)
  if sms[selecteddialogSMS] == nil then

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
    if imgui.InputText("##keyboardSMSKA", toAnswerSMS, imgui.InputTextFlags.EnterReturnsTrue) then
      for i = 1, sampGetMaxPlayerId() do
        if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == selecteddialogSMS then k = i break end
        if i == sampGetMaxPlayerId() then k = "-" end
      end
      if k ~= "-" then
        sampSendChat("/t " .. k .. " " .. u8:decode(toAnswerSMS.v))
        toAnswerSMS.v = ''
      end
      KeyboardFocusReset = true
    end
    if imgui.IsItemActive() then
      imgui.LockPlayer = true
    else
      imgui.LockPlayer = false
    end
    if imgui.SameLine() or imgui.Button(u8"Отправить") then
      for i = 1, sampGetMaxPlayerId() do
        if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == selecteddialogSMS then k = i break end
        if i == sampGetMaxPlayerId() then k = "-" end
      end
      if k ~= "-" then
        sampSendChat("/pm " .. k .. " " .. u8:decode(toAnswerSMS.v))
        toAnswerSMS.v = ''
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

function imgui_notepad()
  if imgui.CollapsingHeader(u8"Блокнот") then
    if imgui.InputTextMultiline("##notepad", textNotepad, imgui.ImVec2(-1, imgui.GetTextLineHeight() * cfg.notepad.lines), imgui.InputTextFlags.EnterReturnsTrue + imgui.InputTextFlags.AllowTabInput) then
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
  end
end

function imgui_log()
  if imgui.CollapsingHeader(u8"Лог моих ответов") then
    if #iYears ~= 0 then
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
        imgui.BeginChild("##scrollingregion", imgui.ImVec2(0, cfg.log.height))
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
    else
      imgui.Text(u8"Ошибка: лог пуст или невалиден.")
    end
  end
end

function imgui_stats()
  if imgui.CollapsingHeader(u8"Гистограмма") then
    if #iYears ~= 0 then
      imgui.PushItemWidth(100)
      imgui.Combo(u8"Год", iYear, iYears)
      imgui.PopItemWidth()
      imgui.PushItemWidth(200)
      imgui.SameLine()
      imgui.SliderInt(u8"Месяц", iMonth, 1, 12)
      getMonthStats(iMonth.v, string.sub(iYears[iYear.v + 1], 3, 4))
      imgui.PlotHistogram("##Статистика", month_histogram, 0, u8:encode(iMonths[iMonth.v].." "..iYears[iYear.v + 1]), 0, math.max(unpack(month_histogram)) + math.max(unpack(month_histogram)) * 0.15, imgui.ImVec2(imgui.GetWindowContentRegionWidth(), cfg.stats.height))
    else
      imgui.Text(u8"Ошибка: лог пуст или невалиден.")
    end
  end
end

function imgui_settings()
  if imgui.CollapsingHeader(u8"Настройки") then
    imgui_settings_1_sup_hideandcol()
    imgui_settings_2_sms_hideandcol()
    imgui_settings_3_sup_messanger()
    imgui_settings_4_sms_messanger()
    imgui_settings_5_notepad()
    imgui_settings_6_logger()
    imgui_settings_7_logviewer()
    imgui_settings_8_histogram()
    imgui_settings_9_sup_sounds()
    imgui_settings_10_sms_sounds()
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
      imgui.SameLine(287)
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
      imgui.SameLine(287)
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
      imgui.SameLine(287)
      imgui.Text("")
      imgui.SameLine()
      if imgui.ColorEdit4("##Acolor1", Acolor1, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha + imgui.ColorEditFlags.NoOptions) then
        cfg.colors.AnswerColor = imgui.ImColor.FromFloat4(Acolor1.v[1], Acolor1.v[2], Acolor1.v[3], Acolor1.v[4]):GetU32()
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
      imgui.SameLine(287)
      imgui.Text("")
      imgui.SameLine()
      if imgui.ColorEdit4("##SmsInColor", SmsInColor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha + imgui.ColorEditFlags.NoOptions) then
        cfg.colors.QuestionColor = imgui.ImColor.FromFloat4(SmsInColor.v[1], SmsInColor.v[2], SmsInColor.v[3], SmsInColor.v[4]):GetU32()
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
      imgui.SameLine(287)
      imgui.Text("")
      imgui.SameLine()
      if imgui.ColorEdit4("##SmsOutColor", SmsOutColor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha + imgui.ColorEditFlags.NoOptions) then
        cfg.colors.AnswerColor = imgui.ImColor.FromFloat4(SmsOutColor.v[1], SmsOutColor.v[2], SmsOutColor.v[3], SmsOutColor.v[4]):GetU32()
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
      imgui.SameLine(287)
      imgui.Text("")
      imgui.SameLine()
      if imgui.ColorEdit4("##SmsReceivedColor", SmsReceivedColor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha + imgui.ColorEditFlags.NoOptions) then
        cfg.colors.AnswerColor = imgui.ImColor.FromFloat4(SmsReceivedColor.v[1], SmsReceivedColor.v[2], SmsReceivedColor.v[3], SmsReceivedColor.v[4]):GetU32()
        local r, g, b, a = imgui.ImColor.FromFloat4(SmsReceivedColor.v[1], SmsReceivedColor.v[2], SmsReceivedColor.v[3], SmsReceivedColor.v[4]):GetRGBA()
        SmsReceivedColor_HEX = "0x"..string.sub(bit.tohex(join_argb(a, r, g, b)), 3, 8)
        inicfg.save(cfg, "support")
      end
    else
      imgui.TextDisabled(u8"Изменять \"Сообщение доставлено\" в чате?")
    end
  end
end

function imgui_settings_3_sup_messanger()
  if imgui.Checkbox("##включить мессенджер", iMessangerActiveSDUTY) then
    if iMessangerActiveSDUTY.v then
      cfg.messanger.mode = 1
    else
      if cfg.messanger.activesms then
        cfg.messanger.mode = 2
      end
    end
    cfg.messanger.activesduty = iMessangerActiveSDUTY.v
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
    imgui.Text(u8("Цвета вопросов в диалогах:"))
    imgui.SameLine(203)
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

    imgui.Text(u8("Цвета ваших ответов в диалогах:"))
    imgui.SameLine(203)
    imgui.Text("")
    imgui.SameLine()
    if imgui.ColorEdit4(u8"Цвет ваших ответов", iAcolor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.AlphaBar) then
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

    imgui.Text(u8("Цвета чужих ответов в диалогах:"))
    imgui.SameLine(203)
    imgui.Text("")
    imgui.SameLine()
    if imgui.ColorEdit4(u8"Цвет ответов других саппортов", iAcolor1, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoOptions + imgui.ColorEditFlags.AlphaBar) then
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
  else
    imgui.SameLine()
    imgui.TextDisabled(u8"Включить sduty мессенджер?")
  end
end

function imgui_settings_4_sms_messanger()
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
    inicfg.save(cfg, "support")
  end
  if iMessangerActiveSMS.v then
    imgui.SameLine()
    imgui.Text(u8("Мессенджер sms активирован!"))
    imgui.PushItemWidth(325)
    imgui.SliderInt(u8"Высота мессенджера##1", iMessangerHeight, 100, 1000)
    if iMessangerHeight.v ~= cfg.messanger.Height then
      cfg.messanger.Height = iMessangerHeight.v
      inicfg.save(cfg, "support")
    end
    if imgui.Checkbox("##включить сохранение бд смс", iStoreSMS) then
      if cfg.messanger.storesms == false then ingamelaunch = true imgui_messanger_sms_loadDB() end
      cfg.messanger.storesms = iStoreSMS.v
      inicfg.save(cfg, "support")
    end
    if iStoreSMS.v then
      imgui.SameLine()
      imgui.Text(u8:encode("Сохранение в БД активно. Количество диалогов: "..#sms.."."))
    else
      imgui.SameLine()
      imgui.TextDisabled(u8"Сохранять БД смс?")
      --imgui_messanger_sms_loadDB()
      if doesFileExist(smsfile) then
        imgui.SameLine()
        if imgui.Button(u8("Удалить БД")) then
          os.remove(smsfile)
        end
      end
    end
  else
    imgui.SameLine()
    imgui.TextDisabled(u8"Включить sms мессенджер?")
  end
end

function imgui_settings_5_notepad()
  if imgui.Checkbox("##включить блокнот", iNotepadActive) then
    cfg.notepad.active = iNotepadActive.v
    inicfg.save(cfg, "support")
  end
  if iNotepadActive.v then
    imgui.SameLine()
    imgui.Text(u8"Блокнот активирован!")
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

function imgui_settings_6_logger()
  if imgui.Checkbox("##включить логгер", iLogBool) then
    if cfg.log.logger == false then updateStats() end
    cfg.log.logger = iLogBool.v
    inicfg.save(cfg, "support")
  end
  if iLogBool.v then
    imgui.SameLine()
    imgui.Text(u8:encode("Ответы пишутся в support.csv! Записей в логе: "..countall.."."))
  else
    imgui.SameLine()
    imgui.TextDisabled(u8"Включить запись ответов в лог?")

    if doesFileExist(file) then
      imgui.SameLine()
      if imgui.Button(u8("Удалить лог")) then
        os.remove(file)
      end
    end
  end
end

function imgui_settings_7_logviewer()
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

function imgui_settings_8_histogram()
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

function imgui_settings_9_sup_sounds()
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

function imgui_settings_10_sms_sounds()
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

do
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
end
