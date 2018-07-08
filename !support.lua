--meta
script_name("Support's Heaven")
script_author("rubbishman")
script_version('0.01')
script_dependencies('SAMPFUNCS', 'Dear imgui', 'SAMP.Lua')
--------------------------------------VAR---------------------------------------
function var_require()
  imgui = require 'imgui'
  inicfg = require "inicfg"
  dlstatus = require('moonloader').download_status
  as_action = require('moonloader').audiostream_state
  RPC = require 'lib.samp.events'
  inspect = require 'inspect'
  key = require 'vkeys'
  hk = require 'rkeys'
  ihk = require 'lib.imcustom.hotkey'
  encoding = require 'encoding'
  encoding.default = 'CP1251'
  u8 = encoding.UTF8
  ihk._SETTINGS.noKeysMessage = u8("-")
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
      settingstab = 1,
      debug = false,
    },
    only = {
      messanger = false,
      notepad = false,
      logviewer = false,
      histogram = false,
      settings = false,
    },
    supfuncs = {
      fastrespondviachat = true,
      fastrespondviadialog = true,
      unanswereddialog = true,
      fastrespondviadialoglastid = true,
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
      iSetKeyboard = true,
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
  iHideOtherAnswers = imgui.ImBool(cfg.messanger.HideOthersAnswers)
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
  fr = imgui.ImBuffer(65536)
  fr.v = string.gsub(string.gsub(u8:encode(cfg.notepad.fr), "\\n", "\n"), "\\t", "\t")
end

function var_main()
  hotkeys = {}
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
  file = getGameDirectory()..'\\moonloader\\support.csv'
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
hotk = {}
hotke = {}
-------------------------------------MAIN---------------------------------------
function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do wait(100) end
  main_checksounds()
  main_init_sms()
  main_init_supfuncs()
  main_init_debug()
  main_init_hotkeys()
  main_ImColorToHEX()
  main_copyright()
  inicfg.save(cfg, "support")
  if DEBUG then First = true end
  while true do
    wait(0)
    main_while_debug()
    main_while_playsounds()
    imgui.Process = main_window_state.v
  end
end

function main_checksounds()
  if not doesDirectoryExist(getGameDirectory().."\\moonloader\\resource\\sup") then
    createDirectory(getGameDirectory().."\\moonloader\\resource\\sup")
  end
  for i = 1, 100 do
    local file = getGameDirectory().."\\moonloader\\resource\\sup\\"..i..".mp3"
    if not doesFileExist(file) then
      downloadUrlToFile("http://rubbishman.ru/dev/moonloader/support's%20heaven/resource/sup/"..i..".mp3", file)
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
end

function main_copyright()
  sampAddChatMessage(("SUPPORT v"..thisScript().version.." successfully loaded! Команды: /supstats и /supcolor! Author: rubbishman.ru"), color)
end

function main_while_debug()
  if SSDB_trigger == true then if DEBUG then sampAddChatMessage("сохраняем", color) end imgui_messanger_sms_saveDB() SSDB_trigger = false end
end

function main_while_playsounds()
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
end

--симулируем саппорта
function DEBUG_simulateSupport(text)
  if not string.find(text, "недос") then
    tempid = math.random(1, 10)
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

function DEBUG_simulateSupportAnswer(text)
  sampAddChatMessage(text, Acolor_HEX)
  sup_AddA(text)
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

function RPC.onPlaySound(sound)
  if sound == 1052 and iSoundSmsOut.v then
    return false
  end
end
--говно
function RPC.onServerMessage(color, text)
  if DEBUG then DEBUG_simulateSupport(text) end
  if text:find("SMS") then
    text = string.gsub(text, "{FFFF00}", "")
    text = string.gsub(text, "{FF8000}", "")
    local smsText, smsNick, smsId = string.match(text, "^ SMS%: (.*)%. Отправитель%: (.*)%[(%d+)%]")
    if smsText and smsNick and smsId then
      LASTID_SMS = smsId
      LASTNICK_SMS = smsNick
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
      sup_AddQ(text)
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
  if DEBUG then return false end -- исправить
end
--считаем активность саппорта
function RPC.onSendCommand(text)
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

function sup_AddQ(text)
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

function sup_AddA(text)
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

function sup_logger_HostAnswer(text)
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
  local hhfile = getGameDirectory().."\\moonloader\\resource\\sup\\house.txt"
  if doesFileExist(hhfile) then
    gethh = {}
    for line in io.lines(hhfile) do
      table.insert(gethh, line)
    end
  end
end

function sup_ParseVehicleTxt_hc()
  local hcfile = getGameDirectory().."\\moonloader\\resource\\sup\\vehicle.txt"
  if doesFileExist(hcfile) then
    gethc = {}
    for line in io.lines(hcfile) do
      table.insert(gethc, line)
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
        sampSetChatInputText("/pm "..LASTID.." ")
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
              sampSendChat("/pm "..id.." "..getfr[tonumber(FRnumber_D)])
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
  if cfg.supfuncs.unanswereddialog then
    if main_window_state.v then main_window_state.v = false end
    local UNANindex = {}
    for k in pairs(iMessanger) do
      if #iMessanger[k]["A"] == 0 then table.insert(UNANindex, k) end
    end
    table.sort(UNANindex, function(a, b) return iMessanger[a]["Chat"][#iMessanger[a]["Chat"]]["time"] < iMessanger[b]["Chat"][#iMessanger[b]["Chat"]]["time"] end)
    UNANi = 1
    UNANtext = ""
    for k, v in pairs(UNANindex) do
      for i = 1, sampGetMaxPlayerId() + 1 do
        if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == v then
          UNANsec = math.fmod(os.time() - iMessanger[v]["Chat"][#iMessanger[v]["Chat"]]["time"], 60)
          if UNANsec < 10 then UNANsec = "0"..UNANsec end
          UNANmin = math.floor((os.time() - iMessanger[v]["Chat"][#iMessanger[v]["Chat"]]["time"]) / 60)
          UNANtext = UNANtext..string.format("{FFD700}%s {40E0D0}- {ADD8E6}[%s:%s] %s[%s]: {FF9D00}%s", UNANi, UNANmin, UNANsec, v, i, iMessanger[v]["Chat"][#iMessanger[v]["Chat"]]["text"]).."\n"
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
            sampSendChat("/pm "..tonumber(UNANid).." "..UNANanswe)
          end
        else
          if tonumber(UNANanswer) ~= nil then
            UNANid = string.match(string.gsub(UNANtext, "{......}", ""), "%[(%d+)%]")
            UNANid = string.match(UNANtext, tonumber(UNANanswer).." - .+%[(%d+)%].+\n")
            if sampIsPlayerConnected(UNANid) then
              sampSetChatInputEnabled(true)
              sampSetChatInputText("/pm "..tonumber(UNANanswer).." ")
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

function imgui.OnDrawFrame()

  if main_window_state.v then
    imgui.SetNextWindowPos(imgui.ImVec2(cfg.menuwindow.PosX, cfg.menuwindow.PosY), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(cfg.menuwindow.Width, cfg.menuwindow.Height))
    if cfg.only.messanger or cfg.only.notepad or cfg.only.logviewer or cfg.only.histogram or cfg.only.settings then
      beginflags = imgui.WindowFlags.NoCollapse + imgui.WindowFlags.MenuBar
    else
      beginflags = imgui.WindowFlags.NoCollapse
    end
    imgui.Begin(u8:encode(thisScript().name.." v"..thisScript().version), main_window_state, beginflags)
    imgui_saveposandsize()
    if not cfg.only.messanger and not cfg.only.notepad and not cfg.only.logviewer and not cfg.only.histogram and not cfg.only.settings then
      if cfg.messanger.activesduty or cfg.messanger.activesms then imgui_messanger() end
      if cfg.notepad.active then imgui_notepad() end
      if cfg.log.active then imgui_log() end
      if cfg.stats.active then imgui_histogram() end
      imgui_settings()
    else
      if cfg.only.messanger then if cfg.messanger.activesduty or cfg.messanger.activesms then imgui_messanger() end end
      if cfg.only.notepad then if cfg.notepad.active then imgui_notepad() end end
      if cfg.only.logviewer then if cfg.log.active then imgui_log() end end
      if cfg.only.histogram then if cfg.stats.active then imgui_histogram() end end
      if cfg.only.settings then imgui_settings() end
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
      keyboard = true
      cfg.messanger.mode = 1
      cfg.only.notepad = false
      cfg.only.logviewer = false
      cfg.only.histogram = false
      cfg.only.settings = false
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
				sampAddChatMessage("text", color)
        cfg.only.messanger = true
        if sampIsPlayerConnected(LASTID_SMS) and sampGetPlayerNickname(LASTID_SMS) == LASTNICK_SMS then
          online = "Онлайн"
        else
          online = "Оффлайн"
        end
        selecteddialogSMS = LASTNICK_SMS
        keyboard = true
        cfg.messanger.mode = 2
        cfg.only.notepad = false
        cfg.only.logviewer = false
        cfg.only.histogram = false
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
			KeyboardFocusResetForNewDialog = true
			cfg.messanger.mode = 2
			cfg.only.notepad = false
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
    if KeyboardFocusResetForNewDialog then imgui.SetKeyboardFocusHere() KeyboardFocusResetForNewDialog = false end
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
      playerlistY = imgui.GetContentRegionAvail().y - 74
    else
      playerlistY = iMessangerHeight.v - 74
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
      playerlistY = imgui.GetContentRegionAvail().y - 74
    else
      playerlistY = iMessangerHeight.v - 74
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
      lockPlayerControl(true)
      imgui_messanger_sup_keyboard_gethh(2)
      imgui_messanger_sup_keyboard_gethc(2)
    else
      lockPlayerControl(false)
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
  imgui.SliderInt(u8"##выбор вкладки настроек", iSettingsTab, 1, 12)
  if iSettingsTab.v ~= cfg.options.settingstab then
    cfg.options.settingstab = iSettingsTab.v
    inicfg.save(cfg, "support")
  end
  imgui.Separator()
  if iSettingsTab.v == 1 then imgui_settings_1_sup_hideandcol() end
  if iSettingsTab.v == 2 then imgui_settings_2_sms_hideandcol() end
  if iSettingsTab.v == 3 then imgui_settings_3_sup_funcs() end
  if iSettingsTab.v == 4 then imgui_settings_4_sup_messanger() end
  if iSettingsTab.v == 5 then imgui_settings_5_sms_messanger() end
  if iSettingsTab.v == 6 then imgui_settings_6_notepad() end
  if iSettingsTab.v == 7 then imgui_settings_7_logger() end
  if iSettingsTab.v == 8 then imgui_settings_8_logviewer() end
  if iSettingsTab.v == 9 then imgui_settings_9_histogram() end
  if iSettingsTab.v == 10 then imgui_settings_10_sup_sounds() end
  if iSettingsTab.v == 11 then imgui_settings_11_sms_sounds() end
  if iSettingsTab.v == 12 then imgui_settings_12_hotkeys() end
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
      imgui.SameLine(295)
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
      imgui.SameLine(295)
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
      imgui.SameLine(295)
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

function imgui_settings_3_sup_funcs()
  if imgui.Checkbox("##ifastrespondviachat", ifastrespondviachat) then
    cfg.supfuncs.fastrespondviachat = ifastrespondviachat.v
    inicfg.save(cfg, "support")
  end
  imgui.SameLine()
  if ifastrespondviachat.v then
    imgui.Text(u8("Быстрый ответ включен"))
  else
    imgui.TextDisabled(u8"Включить быстрый ответ?")
  end
  imgui.SameLine()
  imgui.TextDisabled("(?)")
  if imgui.IsItemHovered() then
    imgui.SetTooltip(u8"По нажатию хоткея открывается чат с /pm id последнего вопроса.")
  end



  if imgui.Checkbox("##iunanswereddialog", iunanswereddialog) then
    cfg.supfuncs.unanswereddialog = iunanswereddialog.v
    inicfg.save(cfg, "support")
  end
  imgui.SameLine()
  if iunanswereddialog.v then
    imgui.Text(u8("Список проигнорированных вопросов включен")) else
    imgui.TextDisabled(u8"Включить список проигнорированных вопросов?")
  end
  imgui.SameLine()
  imgui.TextDisabled("(?)")
  if imgui.IsItemHovered() then
    imgui.SetTooltip(u8"По нажатию хоткея открывается список с проигнорированными саппортами вопросами.\nВ поле можно ввести порядковый номер вопроса, либо порядковый номер, пробел, ответ.")
  end

  if imgui.Checkbox("##fastrespondviadialoglastid", ifastrespondviadialoglastid) then
    cfg.supfuncs.fastrespondviadialoglastid = ifastrespondviadialoglastid.v
    inicfg.save(cfg, "support")
  end
  imgui.SameLine()
  if ifastrespondviadialoglastid.v then
    imgui.Text(u8("Быстрый ответ по базе на последний вопрос по базе ответов включен"))
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
    imgui.Text(u8("Быстрый ответ по базе ответов включен"))
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

function imgui_settings_4_sup_messanger()
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

    if imgui.Checkbox("##imhk1", imhk1) then
      cfg.messanger.hotkey1 = imhk1.v
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

function imgui_settings_5_sms_messanger()
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

    if imgui.Checkbox("##imhk3", imhk3) then
      cfg.messanger.hotkey3 = imhk3.v
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
  end
end

function imgui_settings_6_notepad()
  if imgui.Checkbox("##включить блокнот", iNotepadActive) then
    cfg.notepad.active = iNotepadActive.v
    inicfg.save(cfg, "support")
  end

  if iNotepadActive.v then
    imgui.SameLine()
    imgui.Text(u8"Блокнот активирован!")

    if imgui.Checkbox("##inotepadhk", inotepadhk) then
      cfg.notepad.hotkey = inotepadhk.v
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

function imgui_settings_7_logger()
  if imgui.Checkbox("##включить логгер", iLogBool) then
    if cfg.log.logger == false then sup_updateStats() end
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

function imgui_settings_8_logviewer()

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

function imgui_settings_9_histogram()
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

function imgui_settings_10_sup_sounds()
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

function imgui_settings_11_sms_sounds()
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

function imgui_settings_12_hotkeys()
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

apply_custom_style()
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
end
