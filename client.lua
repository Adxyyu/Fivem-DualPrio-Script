local priorityIndexLosSantos = 1
local priorityIndexBlaineCounty = 1
local priorityStates = { "N/A", "~r~HOLD", "Cooldown" }
local cooldownEndTimeLosSantos = 0
local cooldownEndTimeBlaineCounty = 0

function DrawHUD()
    SetTextFont(4)
    SetTextScale(0.5, 0.4)
    SetTextColour(255, 255, 255, 255)
    SetTextCentre(false)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")

    -- Los Santos priority status text
    local timerTextLosSantos = ""
    if cooldownEndTimeLosSantos > 0 then
        local remainingTime = cooldownEndTimeLosSantos - GetGameTimer()
        local minutes = math.floor(remainingTime / 60000)
        timerTextLosSantos = string.format("~w~%d ~r~Min(s)", minutes)
    else
        timerTextLosSantos = priorityStates[priorityIndexLosSantos]
    end

    -- Blaine County priority status text
    local timerTextBlaineCounty = ""
    if cooldownEndTimeBlaineCounty > 0 then
        local remainingTime = cooldownEndTimeBlaineCounty - GetGameTimer()
        local minutes = math.floor(remainingTime / 60000)
        timerTextBlaineCounty = string.format("~w~%d ~r~Min(s)", minutes)
    else
        timerTextBlaineCounty = priorityStates[priorityIndexBlaineCounty]
    end

   
    AddTextComponentSubstringPlayerName("~b~Priority Status: ~g~Los Santos: " .. timerTextLosSantos .. " ~b~| ~g~Blaine County: " .. timerTextBlaineCounty)
    EndTextCommandDisplayText(0.16, 0.85)
end

RegisterNetEvent('updatePriorityHUD')
AddEventHandler('updatePriorityHUD', function(priorityIndexLS, priorityIndexBC, cooldownEndLS, cooldownEndBC)
    priorityIndexLosSantos = priorityIndexLS
    priorityIndexBlaineCounty = priorityIndexBC
    cooldownEndTimeLosSantos = cooldownEndLS
    cooldownEndTimeBlaineCounty = cooldownEndBC
    DrawHUD()
end)


RegisterNetEvent('playSoundEffect')
AddEventHandler('playSoundEffect', function()
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        DrawHUD()
    end
end)
