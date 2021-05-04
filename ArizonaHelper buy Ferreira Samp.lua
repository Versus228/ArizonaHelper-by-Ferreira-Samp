script_name('ArizonaHelper')
script_author('Ferreira Samp')
script_description('Helper')



require "lib.moonloader"
local keys = require "vkeys"
local sampev = require 'lib.samp.events'
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
cp1251 = encoding.CP1251
local memory = require "memory"
local inicfg = require 'inicfg'
--local directIni = 'moonloader\\config\\settingshelper.ini'
local mainIni = inicfg.load({
	config = {
		lock = 1,
        fill = 1,
        bind = " ",
        armour = 1,
        key = 1,
        repcar = 1,
        phone = 1,
        narko = 1,
        kolnar = 1,
        time = 1,
        timebind = 1,
        timer = 1,
        flood = " ",
        taiming = 1,
        jlock = 1,
        olock = 1,
        trade = 1,
        lic = 1,
        mask = 1,
        eda = 1,
        fish = 0,
        miaso = 1,
        cheeps = 0,
        rec = 0,
        rectime = 1,
        vipt = 0,
        vipp = 0,
        vipqq = 0,
        vipqqq = "",
        style = 1
	}
}, 'settingshelper.ini')

--local status = inicfg.load(mainIni, directIni)
if not doesFileExist('moonloader/config/settingshelper.ini') then inicfg.save(mainIni, 'settingshelper.ini') end
--local stateIni = inicfg.save(mainIni, directIni)
local tag = '[my first]'
local main_color = 0x5A90CE
local main_color_text = "{FF0000}"
local white_color = "{FFFFFF}"

autoupdate("https://raw.githubusercontent.com/Versus228/ArizonaHelper/main/autoupdate.json", '['..string.upper(thisScript().name)..']: ', "тут ссылка на ваш сайт/url вашего скрипта на форуме (если нет, оставьте как в json)")

local vipqqq_buffer = imgui.ImBuffer(256)
local taxi_buffer = imgui.ImBuffer(256)
local flood_buffer = imgui.ImBuffer(256)
local timer_buffer = imgui.ImBuffer(256)
local time_buffer = imgui.ImBuffer(256)
local kol_buffer = imgui.ImBuffer(256)
local text_buffer = imgui.ImBuffer(256)
local rectime_buffer = imgui.ImBuffer(256)
local main_window_state = imgui.ImBool(false)
local seda_window_state = imgui.ImBool(false)
local taxi_window_state = imgui.ImBool(false)
local vip_window_state = imgui.ImBool(false)

--CheckBox
local checked1 = imgui.ImBool(false)
local checked2 = imgui.ImBool(false)
local checked3 = imgui.ImBool(false)
local checked4 = imgui.ImBool(false)
local sw, sh = getScreenResolution()
--Временные Настройки
repka = 0
sbiv = 0
gotp = 0
ZZ = 0
taxi = 0
rec = 0
rect = 0

function autoupdate(json_url, prefix, url)
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  downloadUrlToFile(json_url, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(prefix)
                local dlstatus = require('moonloader').download_status
                local color = -1
                sampAddChatMessage((prefix..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('Загрузка обновления завершена.')
                      sampAddChatMessage((prefix..'Обновление завершено!'), color)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..thisScript().version..': Обновление не требуется.')
            end
          end
        else
          print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
    sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] ArizonaHelper by Ferreira Samp (Активация 'End + PgDn')")
    imgui.Process = false
    thread = lua_thread.create_suspended(thread_function)
    trec = lua_thread.create_suspended(trec_function)
    local veh, ped = storeClosestEntities(PLAYER_PED)
    local _, id = sampGetPlayerIdByCharHandle(ped)


	while true do
		wait(0)
        if memory.getuint8(0x748C2B) == 0xE8 then
            memory.fill(0x748C2B, 0x90, 5, true)
        elseif memory.getuint8(0x748C7B) == 0xE8 then
            memory.fill(0x748C7B, 0x90, 5, true)
        end
        if memory.getuint8(0x5909AA) == 0xBE then
            memory.write(0x5909AB, 1, 1, true)
        end
        if memory.getuint8(0x590A1D) == 0xBE then
            memory.write(0x590A1D, 0xE9, 1, true)
            memory.write(0x590A1E, 0x8D, 4, true)
        end
        if memory.getuint8(0x748C6B) == 0xC6 then
            memory.fill(0x748C6B, 0x90, 7, true)
        elseif memory.getuint8(0x748CBB) == 0xC6 then
            memory.fill(0x748CBB, 0x90, 7, true)
        end
        if memory.getuint8(0x590AF0) == 0xA1 then
            memory.write(0x590AF0, 0xE9, 1, true)
            memory.write(0x590AF1, 0x140, 4, true)
        end

        
        
        if main_window_state.v == false then
        	imgui.Process = false
        end 
        if isKeyJustPressed(VK_OEM_1) and not sampIsCursorActive() and mainIni.config.style == 1 then
            sampSendChat("/style")
        end
        if isKeyDown(VK_Z) and isKeyJustPressed(VK_X) and mainIni.config.time == 1 then
            sampSendChat(u8:decode(mainIni.config.timebind))
            sampSendChat("/time")
            wait(1000)
            sampSendChat("/do На часах: "..os.date("%H:%M:%S"))
        end
        if isKeyDown(VK_MENU) and isKeyJustPressed(VK_X) and mainIni.config.narko == 1 then
            inicfg.load(mainIni, 'settingshelper.ini')
            sampSendChat("/usedrugs  "..mainIni.config.kolnar)
        end
        if isKeyDown(VK_L) and isKeyJustPressed(VK_J) and not sampIsCursorActive() and mainIni.config.jlock == 1 then
            sampSendChat("/jlock")
        end
        if isKeyDown(VK_L) and isKeyJustPressed(VK_O) and not sampIsCursorActive() and mainIni.config.olock == 1 then
            sampSendChat("/olock")
        end
        if isKeyJustPressed(VK_P) and not sampIsCursorActive() and mainIni.config.phone == 1 then
            sampSendChat("/phone")
        end
        if isKeyDown(VK_MENU) and isKeyJustPressed(VK_3) and not sampIsCursorActive() and mainIni.config.repcar == 1 then
        	sampSendChat("/repcar")
        end
        if isKeyJustPressed(VK_E) and not sampIsCursorActive() and mainIni.config.fill == 1 then
        	sampSendChat("/fillcar")
        end 
        if isKeyJustPressed(VK_ESCAPE) and not sampIsCursorActive() then
        	imgui.Process = false
        end

		if isKeyJustPressed(VK_OEM_6) and not sampIsCursorActive() then
			sampSendChat("/anims 3")
		end

		if isKeyJustPressed(VK_K) and not sampIsCursorActive() and mainIni.config.key == 1 then
			sampSendChat("/key")
		end

		if isKeyJustPressed(VK_L) and not sampIsCursorActive() and mainIni.config.lock == 1 then
			sampSendChat("/lock")
		end

		if isKeyJustPressed(VK_HOME) then
			inicfg.load(mainIni, 'settingshelper.ini')            
			sampSendChat(u8:decode(mainIni.config.bind))
		end
		if sbiv == 1 then
			if isKeyJustPressed(VK_Q) and not sampIsCursorActive() then
			    sampSendChat(" ")			    
		    end
		end
        if isKeyDown(VK_MENU) and isKeyJustPressed(VK_Z) and not sampIsCursorActive() and mainIni.config.mask == 1 then
            sampSendChat("/mask")
        end
		if isKeyJustPressed(VK_B) and not sampIsCursorActive() and mainIni.config.armour == 1 then
			sampSendChat("/armour")
		end
		if isKeyDown(VK_NEXT) and isKeyJustPressed(VK_END) then
			main_window_state.v = not main_window_state.v
	        imgui.Process = main_window_state.v
		end

        if isKeyDown(VK_MENU) and isKeyJustPressed(VK_1) and not sampIsCursorActive() and mainIni.config.trade == 1 then
            local veh, ped = storeClosestEntities(PLAYER_PED)
            local _, id = sampGetPlayerIdByCharHandle(ped)
            if _ then
                    sampSendChat('/trade '..id)
            end
        end
        if isKeyDown(VK_MENU) and isKeyJustPressed(VK_2) and not sampIsCursorActive() and mainIni.config.lic == 1 then 
            local veh, ped = storeClosestEntities(PLAYER_PED)
            local _, id = sampGetPlayerIdByCharHandle(ped)
            if id then
                    sampSendChat('/showskill '..id)
            end
        end
        if isKeyDown(VK_MENU) and isKeyJustPressed(VK_4) and not sampIsCursorActive() and repka == 1 then 
            local veh, ped = storeClosestEntities(PLAYER_PED)
            local _, id = sampGetPlayerIdByCharHandle(ped)
            if id then
                    sampSendChat("/repare "..id.." 1")
            end
        end
        if mainIni.config.rec == 1 then
            sampRegisterChatCommand("rec", cmd_reconnect)
        end
	end
end


function sampev.onShowDialog(dialogId, dialogStyle, dialogTitle, okButtonText, cancelButtonText, dialogText)
    if mainIni.config.phone == 1 then
        if dialogId == 1000 then
            sampSendDialogResponse(1000, 1, 0, "")
            return false
        end
    end
    

    if ZZ == 1 then
        if dialogId == 0 then
            sampSendDialogResponse(0,1,0, "")
            return false
        end
    end
end





function thread_function()
    if timer then
        inicfg.load(mainIni, 'settingshelper.ini')
        wait(mainIni.config.taiming*1000)
        sampSendChat(u8:decode(mainIni.config.flood))
        return true
    end
end


function sampev.onDisplayGameText(style, time, text)
	if mainIni.config.eda == 1 then
        if mainIni.config.fish == 1 then
            if text == "You are hungry!" then
                sampSendChat("/jfish")
            end
        end
        if mainIni.config.miaso == 1 then
            if text == "You are hungry!" then
                sampSendChat("/jmeat")
            end
        end
        if mainIni.config.cheeps == 1 then
            if text == "You are hungry!" then
                sampSendChat("/cheeps")
            end
        end
    end
end

function sampev.onServerMessage(color, text)
    if mainIni.config.vip == 1 then
        if mainIni.config.vipqq == 1 then
            if text:find 'Игрок (.-) приобрел Titan VIP' and not text:find('говорит') and not text:find('- |') then
                sampSendChat(u8:decode("/vr "..mainIni.config.vipqqq.v))
            end
        end
        if mainIni.config.vipt == 1 then
            if string.find(text, "[VIP]", 1, true) and not text:find('говорит') then
                return false
            end
        end
        if mainIni.config.vipp == 1 then
            if string.find(text, "[PREMIUM]", 1, true) and not text:find('говорит') then
                return false
            end
        end
    end
    if string.find(text, "В городе ЛВ начал", 1, true) and not text:find('говорит') then
        return false
    end
    if string.find(text, "Убив его,", 1, true) and not text:find('говорит') then
        return false
    end
    if string.find(text, "В городе ЛС начал", 1, true) and not text:find('говорит') then
        return false
    end
    if string.find(text, "В городе СФ начал", 1, true) and not text:find('говорит') then
        return false
    end
    if taxi == 1 then
        if text:find '>> (.-) сел к вам в такси.' and not text:find('говорит') then
            sampSendChat(u8:decode(mainIni.config.taxi))
        end
    end
	if gotp == 1 then
		if text:find '[Начало Мероприятия]'  then
		   sampSendChat("/gotp")
	    end
        if text:find 'МП'  then
            sampSendChat("/gotp")
        end
        if text:find 'Быстрая рука'  then
            sampSendChat("/gotp")
        end
        
	end
    
end
function trec_function()
    if rect == 1 then
        sampDisconnectWithReason(quit)
        wait(mainIni.config.rectime*1000)
        sampSetGamestate(1)
        rect = 0        
    end
end





function imgui.OnDrawFrame()
	imgui.LockPlayer = false
	if main_window_state.v then
	    imgui.SetNextWindowSize(imgui.ImVec2(900, 600), imgui.Cond.FirstUseEver)
	    imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8"ArizonaHelper by Ferreira Samp (Активация 'End + PgDn')", main_window_state)
        imgui.Text(u8"VK создателя: mihailferreira. Создатель: Ferreira Samp.")
        imgui.Separator()
        imgui.BeginChild("Settings##1", imgui.ImVec2(300, 250), true)
        imgui.SetCursorPosX(95)
        imgui.Text(u8"Настройка АХК")
        imgui.Separator()
        imgui.Text(u8"Закрытие/Открытие авто на клавишу 'L'")
        if imgui.Button(u8'Вкл.##1') then
            mainIni.config.lock = 1
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if imgui.Button(u8'Выкл.##1') then
            mainIni.config.lock = 0
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if mainIni.config.lock == 1 then
            imgui.Text("On")
        end
        if mainIni.config.lock == 0 then
            imgui.Text("Off")
        end
        imgui.Separator()
        imgui.Text(u8"Достать/Вставить ключи на кнопку 'K'")
        imgui.PushItemWidth(60)
        if imgui.Button(u8'Bкл.##2') then
            mainIni.config.key = 1
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if imgui.Button(u8'Bыкл.##2') then
            mainIni.config.key = 0
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if mainIni.config.key == 1 then
            imgui.Text("On")
        end
        if mainIni.config.key == 0 then
            imgui.Text("Off")
        end
        imgui.Separator()
        imgui.Text(u8"Одеть/Снять броню на кнопку 'B'")
        imgui.PushItemWidth(60)
        if imgui.Button(u8"Вкл.##3") then
            mainIni.config.armour = 1
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##3") then
            mainIni.config.armour = 0
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if mainIni.config.armour == 1 then
            imgui.Text("On")
        end
        if mainIni.config.armour == 0 then
            imgui.Text("Off")
        end
        imgui.Separator()
        imgui.Text(u8"Отремонтировать авто на кнопку 'Alt'+'3'")
        imgui.PushItemWidth(60)
        if imgui.Button(u8"Вкл.##4") then
            mainIni.config.repcar = 1
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##4") then
            mainIni.config.repcar = 0
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if mainIni.config.repcar == 1 then
            imgui.Text("On")
        end
        if mainIni.config.repcar == 0 then
            imgui.Text("Off")
        end
        imgui.Separator()
        imgui.Text(u8"Заправка авто на кнопку 'E'")
        imgui.PushItemWidth(60)
        if imgui.Button(u8"Вкл.##5") then
            mainIni.config.fill = 1
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##5") then
            mainIni.config.fill = 0
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if mainIni.config.fill == 1 then
            imgui.Text("On")
        end
        if mainIni.config.fill == 0 then
            imgui.Text("Off")
        end
        imgui.Separator()
        imgui.Text(u8"Достать телефон на кнопку 'P'")
        imgui.PushItemWidth(60)
        if imgui.Button(u8"Вкл.##6") then
            mainIni.config.phone = 1
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##6") then
            mainIni.config.phone = 0
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if mainIni.config.phone == 1 then
            imgui.Text("On")
        end
        if mainIni.config.phone == 0 then
            imgui.Text("Off")
        end
        imgui.Separator()
        imgui.Text(u8"Закрыть/Открыть аренду на кнопки 'J' + 'L'")
        imgui.PushItemWidth(60)
        if imgui.Button(u8"Вкл.##9") then
            mainIni.config.jlock = 1
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##9") then
            mainIni.config.jlock = 0
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if mainIni.config.jlock == 1 then
            imgui.Text("On")
        end
        if mainIni.config.jlock == 0 then
            imgui.Text("Off")
        end  
        imgui.Separator()
        imgui.Text(u8"Закрыть/Открыть орг. авто на кнопки 'O'+'L'")
        imgui.PushItemWidth(60)
        if imgui.Button(u8"Вкл.##11") then
            mainIni.config.olock = 1
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##11") then
            mainIni.config.olock = 0
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if mainIni.config.olock == 1 then
            imgui.Text("On")
        end
        if mainIni.config.olock == 0 then
            imgui.Text("Off")
        end
        imgui.Separator()
        imgui.Text(u8"Кинуть трейд ближайшему игроку 'Alt'+'1'")
        imgui.PushItemWidth(60)
        if imgui.Button(u8"Вкл.##12") then
            mainIni.config.trade = 1
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##12") then
            mainIni.config.trade = 0
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if mainIni.config.trade == 1 then
            imgui.Text("On")
        end
        if mainIni.config.trade == 0 then
            imgui.Text("Off")
        end
        imgui.Separator()
        imgui.Text(u8"Показать Скиллы ближайшему игроку 'Alt'+'2'")
        imgui.PushItemWidth(60)
        if imgui.Button(u8"Вкл.##13") then
            mainIni.config.lic = 1
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##13") then
            mainIni.config.lic = 0
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if mainIni.config.lic == 1 then
            imgui.Text("On")
        end
        if mainIni.config.lic == 0 then
            imgui.Text("Off")
        end
        imgui.Separator()
        imgui.Text(u8"Одеть/Снять маску на кнопки 'Alt'+'Z'")
        imgui.PushItemWidth(60)
        if imgui.Button(u8"Вкл.##14") then
            mainIni.config.mask = 1
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##14") then
            mainIni.config.mask = 0
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if mainIni.config.mask == 1 then
            imgui.Text("On")
        end
        if mainIni.config.mask == 0 then
            imgui.Text("Off")
        end
        imgui.Separator()
        imgui.Text(u8"Включить/Выключить TwinTurbo на кнопку 'Ж' или ';'")
        imgui.PushItemWidth(60)
        if imgui.Button(u8"Вкл.##30") then
            mainIni.config.style = 1
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##30") then
            mainIni.config.style = 0
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if mainIni.config.style == 1 then
            imgui.Text("On")
        end
        if mainIni.config.style == 0 then
            imgui.Text("Off")
        end
        imgui.EndChild()
        ----------------------------------------------------------------------------------------child1_zak
        imgui.SameLine()
        imgui.BeginChild("Settings##2", imgui.ImVec2(320, 250), true)
        imgui.SetCursorPosX(85)
        imgui.Text(u8"Настройка Флудеров")
        imgui.Separator()
        imgui.Text(u8"Использовать бинд на кнопку 'HOME'")
        imgui.PushItemWidth(230)
        imgui.InputText(u8'Текст', text_buffer)
        if imgui.Button('Save##1') then     
            mainIni.config.bind = cp1251:decode(text_buffer.v)
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] {ff0000}Bind {008000}Saved")
            end
        end
        imgui.SameLine()
        if imgui.Checkbox(u8"Зафиксировать игрока##1", checked1) then
            imgui.LockPlayer = true
        end
        --flooder
        imgui.Separator()
        imgui.Text(u8"Флудер")
        imgui.PushItemWidth(230)
        imgui.InputText(u8'Текст##1', flood_buffer)
        if imgui.Button('Save##2') then     
            mainIni.config.flood = cp1251:decode(flood_buffer.v)
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] {ff0000}Bind {008000}Saved")
            end
        end
        imgui.SameLine()
        if imgui.Checkbox(u8"Зафиксировать игрока##4", checked1) then
            imgui.LockPlayer = true
        end
        imgui.PushItemWidth(100)
        imgui.InputText(u8"Тайминги (Вводить в секундах)", timer_buffer)
        if imgui.Button(u8'Вкл.##7') then
            timer = true
            mainIni.config.taiming = cp1251:decode(timer_buffer.v)
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] On")
            end
            if mainIni.config.taiming == "" then
                mainIni.config.taiming = 1
                inicfg.save(mainIni, 'settingshelper.ini')
            end
            thread:run()
        end
        imgui.SameLine()
        if imgui.Button(u8'Выкл.##8') then
            timer = false
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Off")
            end
        end

        --narko
        imgui.Separator()
        imgui.Text(u8"Использовать наркоту на кнопки 'Alt'+'X'")
        imgui.PushItemWidth(100)
        imgui.InputText(u8'Количество', kol_buffer)
        if imgui.Button('Save##2') then     
            mainIni.config.kolnar = (kol_buffer.v)
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] {ff0000}Bind {008000}Saved")
            end
        end
        imgui.SameLine()
        if imgui.Checkbox(u8"Зафиксировать игрока##2", checked1) then
            imgui.LockPlayer = true
        end
        --time
        imgui.Separator()
        imgui.Text(u8"/time на кнопки 'Z'+'X'")
        imgui.PushItemWidth(230)
        imgui.InputText(u8'Через /me', time_buffer)
        if imgui.Button('Save##3') then     
            mainIni.config.timebind = (time_buffer.v)
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] {ff0000}Bind {008000}Saved")
            end
        end
        imgui.SameLine()
        if imgui.Checkbox(u8"Зафиксировать игрока##3", checked1) then
            imgui.LockPlayer = true
        end
        imgui.EndChild()
        ---------------------------------------------------------------------------child2zak
        imgui.SameLine()
        imgui.BeginChild("Settings##3", imgui.ImVec2(255, 250), true)
        imgui.SetCursorPosX(88)
        imgui.Text(u8"Доп. Функции")
        imgui.Separator()
        imgui.Text(u8"Настройка 'Авто-Хавки'")
        if imgui.Button(u8"Вкл.##15") then
            mainIni.config.eda = 1
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##15") then
            mainIni.config.eda = 0
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if mainIni.config.eda == 1 then
            imgui.Text("On")
        end
        if mainIni.config.eda == 0 then
            imgui.Text("Off")
        end
        imgui.SameLine()
        if imgui.Button(u8"Настройка##228") then
            seda_window_state.v = not seda_window_state.v
            imgui.Process = seda_window_state.v
        end
        imgui.Separator()
        imgui.Text(u8"(Мех.)Ченить ближ. игрока 'Alt'+'4'")
        if imgui.Button(u8"Вкл.##19") then
            repka = 1
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##19") then
            repka = 0
        end
        imgui.SameLine()
        if repka == 1 then
            imgui.Text(u8"On")
        end
        
        if repka == 0 then
            imgui.Text(u8"Off")
        end
        imgui.Separator()
        imgui.Text(u8"Сбив анимации на 'Q'")
        if imgui.Button(u8"Вкл.##20") then
            sbiv = 1
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##20") then
            sbiv = 0
        end
        imgui.SameLine()
        if sbiv == 1 then
            imgui.Text(u8"On")
        end
        
        if sbiv == 0 then
            imgui.Text(u8"Off")
        end
        imgui.Separator()
        imgui.Text(u8"/gotp Если в чате есть МП")
        if imgui.Button(u8"Вкл.##21") then
            gotp = 1
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##21") then
            gotp = 0
        end
        imgui.SameLine()
        if gotp == 1 then
            imgui.Text(u8"On")
        end
        
        if gotp == 0 then
            imgui.Text(u8"Off")
        end
        imgui.Separator()
        imgui.Text(u8"Убирать окно ЗЗ")
        if imgui.Button(u8"Вкл.##22") then
            ZZ = 1
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##22") then
            ZZ = 0
        end
        imgui.SameLine()
        if ZZ == 1 then
            imgui.Text(u8"On")
        end
        
        if ZZ == 0 then
            imgui.Text(u8"Off")
        end
        imgui.Separator()
        imgui.Text(u8"Авто-Ответчик для Таксистов")
        if imgui.Button(u8"Вкл.##23") then
            taxi = 1
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##23") then
            taxi = 0
        end
        imgui.SameLine()
        if taxi == 1 then
            imgui.Text(u8"On")
        end
        
        if taxi == 0 then
            imgui.Text(u8"Off")
        end
        imgui.SameLine()
        if imgui.Button(u8"Настройка##7") then
            taxi_window_state.v = not taxi_window_state.v
            imgui.Process = taxi_window_state.v
        end
        imgui.Separator()
        imgui.Text(u8"Реконнект '/rec'")
        imgui.PushItemWidth(100)
        imgui.InputText(u8"Введите задержку", rectime_buffer)
        if imgui.Button(u8"Вкл.##24") then
            mainIni.config.rec = 1
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] On")
            end
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##24") then
            mainIni.config.rec = 0
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Off")
            end
        end
        imgui.SameLine()
        if mainIni.config.rec == 1 then
            imgui.Text(u8"On")
            
        end
        
        if mainIni.config.rec == 0 then
            imgui.Text(u8"Off") 
        end
        imgui.SameLine()
        if imgui.Button('Save##5') then     
            mainIni.config.rectime = (rectime_buffer.v)
            if rectime_buffer.v == "" then
                mainIni.config.rectime = 1
            end 
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] {ff0000}Bind {008000}Saved")
            end
        end
        imgui.Separator() 
        imgui.Text(u8"Настройка вип чата")
        if imgui.Button(u8"Вкл.##25") then
            mainIni.config.vip = 1
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] On")
            end
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##25") then
            mainIni.config.vip = 0
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Off")
            end
        end
        imgui.SameLine()
        if mainIni.config.vip == 1 then
            imgui.Text(u8"On")
        end
        
        if mainIni.config.vip == 0 then
            imgui.Text(u8"Off")
        end
        imgui.SameLine()
        if imgui.Button(u8"Настройка##8") then
            vip_window_state.v = not vip_window_state.v
            imgui.Process = vip_window_state.v
        end
       
       


        imgui.EndChild()
        imgui.Separator()
        imgui.BeginChild("Settings##4", imgui.ImVec2(626, 280), true)
        imgui.Text(u8"На стадии Бетта тестирования")
        imgui.EndChild()
       
        
        imgui.End()
    end
    ------------------------------------------------------------------vip
    if vip_window_state.v then
        imgui.SetNextWindowSize(imgui.ImVec2(300, 200), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8"Настройка 'Vip-Chat'", vip_window_state)
        imgui.Separator()
        imgui.SetCursorPosX(80)
        imgui.Text(u8"Выключение Вип Чата")
        imgui.Text(u8"Вкл/Выкл TITAN.")
        if imgui.Button(u8"Вкл.##26") then
            mainIni.config.vipt = 1
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] On")
            end
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##26") then
            mainIni.config.vipt = 0
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Off")
            end
        end
        imgui.SameLine()
        if mainIni.config.vipt == 1 then
            imgui.Text(u8"On")
        end
        
        if mainIni.config.vipt == 0 then
            imgui.Text(u8"Off")
        end
        imgui.Text(u8"Вкл/Выкл PREMIUM.")
        if imgui.Button(u8"Вкл.##27") then
            mainIni.config.vipp = 1
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] On")
            end
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##27") then
            mainIni.config.vipp = 0
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Off")
            end
        end
        imgui.SameLine()
        if mainIni.config.vipp == 1 then
            imgui.Text(u8"On")
        end
        
        if mainIni.config.vipp == 0 then
            imgui.Text(u8"Off")
        end
        imgui.Separator()
        imgui.SetCursorPosX(60)
        imgui.Text(u8"Приветствие купивших Випку")
        imgui.InputText(u8"Привецтвие", vipqqq_buffer)
        if imgui.Button(u8"Вкл.##28") then
            mainIni.config.vipqq = 1
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] On")
            end
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##28") then
            mainIni.config.vipqq = 0
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Off")
            end
        end
        imgui.SameLine()
        if mainIni.config.vipqq == 1 then
            imgui.Text(u8"On")
        end
        
        if mainIni.config.vipqq == 0 then
            imgui.Text(u8"Off")
        end
        imgui.SameLine()
        if imgui.Button(u8"Save.##13") then
            mainIni.config.vipqqq = (vipqqq_buffer.v)
            if vipqqq_buffer.v == "" then
                mainIni.config.vipqqq = " "
            end 
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] {ff0000}Bind {008000}Saved")
            end
        end
        imgui.SameLine()
        if imgui.Checkbox(u8"Зафиксировать игрока##1", checked1) then
            imgui.LockPlayer = true
        end
        imgui.Separator()

        imgui.End()
    end
    ------------------------------------------------------------------------taxi
    if taxi_window_state.v then
        imgui.SetNextWindowSize(imgui.ImVec2(300, 200), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8"Настройка 'Авто-Ответчика' для Таксистов", taxi_window_state)
        imgui.Separator()
        imgui.Text(u8"Введите текст который будет написан..")
        imgui.Text(u8"..когда человек сядет к вам в авто.")
        imgui.InputText(u8'Введите текст##10', taxi_buffer)
        if imgui.Button('Save##7') then     
            mainIni.config.taxi = cp1251:decode(taxi_buffer.v)
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] {ff0000}Bind {008000}Saved")
            end
        end
        imgui.SameLine()
        if imgui.Checkbox(u8"Зафиксировать игрока##4", checked1) then
            imgui.LockPlayer = true
        end
        imgui.Separator()
        imgui.End()
    end
    -----------------------------------------------------------------------------EDA.EPTA
    if seda_window_state.v then
        imgui.SetNextWindowSize(imgui.ImVec2(300, 200), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8"Настройка 'Авто-Хавки'", seda_window_state)
        imgui.Text(u8"Есть Оленину когда появиться голод.")
        imgui.PushItemWidth(60)
        if imgui.Button(u8"Вкл.##16") then
            mainIni.config.miaso = 1
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##16") then
            mainIni.config.miaso = 0
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if mainIni.config.miaso == 1 then
            imgui.Text("On")
        end
        if mainIni.config.miaso == 0 then
            imgui.Text("Off")
        end
        imgui.Text(u8"Есть Чипсы когда появиться голод.")
        imgui.PushItemWidth(60)
        if imgui.Button(u8"Вкл.##17") then
            mainIni.config.cheeps = 1
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##17") then
            mainIni.config.cheeps = 0
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if mainIni.config.cheeps == 1 then
            imgui.Text("On")
        end
        if mainIni.config.cheeps == 0 then
            imgui.Text("Off")
        end
        imgui.Text(u8"Есть Рыбу когда появиться голод.")
        imgui.PushItemWidth(60)
        if imgui.Button(u8"Вкл.##18") then
            mainIni.config.fish = 1
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if imgui.Button(u8"Выкл.##18") then
            mainIni.config.fish = 0
            if inicfg.save(mainIni, 'settingshelper.ini') then
                sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}] Saved")
            end
        end
        imgui.SameLine()
        if mainIni.config.fish == 1 then
            imgui.Text("On")
        end
        if mainIni.config.fish == 0 then
            imgui.Text("Off")
        end
        imgui.End()
    end
end

function cmd_reconnect()
    if mainIni.config.rec == 1 then
        rect = 1
        trec:run()
        sampAddChatMessage("{FFFFFF}[{FF0000}Helper{FFFFFF}]Переподключение. Задержка "..mainIni.config.rectime.." секунд.")
    end
end


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

    colors[clr.FrameBg] = ImVec4(0.48, 0.16, 0.16, 0.54)
    colors[clr.FrameBgHovered] = ImVec4(0.98, 0.26, 0.26, 0.40)
    colors[clr.FrameBgActive] = ImVec4(0.98, 0.26, 0.26, 0.67)
    colors[clr.TitleBg] = ImVec4(0.04, 0.04, 0.04, 1.00)
    colors[clr.TitleBgActive] = ImVec4(0.48, 0.16, 0.16, 1.00)
    colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.CheckMark] = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.SliderGrab] = ImVec4(0.88, 0.26, 0.24, 1.00)
    colors[clr.SliderGrabActive] = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.Button] = ImVec4(0.98, 0.26, 0.26, 0.40)
    colors[clr.ButtonHovered] = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.ButtonActive] = ImVec4(0.98, 0.06, 0.06, 1.00)
    colors[clr.Header] = ImVec4(0.98, 0.26, 0.26, 0.31)
    colors[clr.HeaderHovered] = ImVec4(0.98, 0.26, 0.26, 0.80)
    colors[clr.HeaderActive] = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.Separator] = colors[clr.Border]
    colors[clr.SeparatorHovered] = ImVec4(0.75, 0.10, 0.10, 0.78)
    colors[clr.SeparatorActive] = ImVec4(0.75, 0.10, 0.10, 1.00)
    colors[clr.ResizeGrip] = ImVec4(0.98, 0.26, 0.26, 0.25)
    colors[clr.ResizeGripHovered] = ImVec4(0.98, 0.26, 0.26, 0.67)
    colors[clr.ResizeGripActive] = ImVec4(0.98, 0.26, 0.26, 0.95)
    colors[clr.TextSelectedBg] = ImVec4(0.98, 0.26, 0.26, 0.35)
    colors[clr.Text] = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled] = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg] = ImVec4(0.06, 0.06, 0.06, 0.94)
    colors[clr.ChildWindowBg] = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg] = colors[clr.PopupBg]
    colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.MenuBarBg] = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab] = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered] = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive] = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CloseButton] = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered] = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive] = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
    colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.ModalWindowDarkening] = ImVec4(0.80, 0.80, 0.80, 0.35)
end
apply_custom_style()
function patch()
    if memory.getuint8(0x748C2B) == 0xE8 then
        memory.fill(0x748C2B, 0x90, 5, true)
    elseif memory.getuint8(0x748C7B) == 0xE8 then
        memory.fill(0x748C7B, 0x90, 5, true)
    end
    if memory.getuint8(0x5909AA) == 0xBE then
        memory.write(0x5909AB, 1, 1, true)
    end
    if memory.getuint8(0x590A1D) == 0xBE then
        memory.write(0x590A1D, 0xE9, 1, true)
        memory.write(0x590A1E, 0x8D, 4, true)
    end
    if memory.getuint8(0x748C6B) == 0xC6 then
        memory.fill(0x748C6B, 0x90, 7, true)
    elseif memory.getuint8(0x748CBB) == 0xC6 then
        memory.fill(0x748CBB, 0x90, 7, true)
    end
    if memory.getuint8(0x590AF0) == 0xA1 then
        memory.write(0x590AF0, 0xE9, 1, true)
        memory.write(0x590AF1, 0x140, 4, true)
    end
end

patch()