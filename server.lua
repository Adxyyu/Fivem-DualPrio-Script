local priorityIndexLosSantos = 1
local priorityIndexBlaineCounty = 1
local priorityStates = { "N/A", "~r~HOLD", "Cooldown" }
local cooldownDuration = 594000
local cooldownEndTimeLosSantos = 0
local cooldownEndTimeBlaineCounty = 0

RegisterCommand('priorityls', function(source, args, rawCommand)
    local src = source
    if IsPlayerAceAllowed(src, "dual.prio") then
        priorityIndexLosSantos = priorityIndexLosSantos + 1
        if priorityIndexLosSantos > #priorityStates then
            priorityIndexLosSantos = 1
        end

        if priorityIndexLosSantos == 3 then
            cooldownEndTimeLosSantos = GetGameTimer() + cooldownDuration

            Citizen.CreateThread(function()
                Citizen.Wait(cooldownDuration)
                cooldownEndTimeLosSantos = 0
                priorityIndexLosSantos = 1 
                TriggerClientEvent('updatePriorityHUD', -1, priorityIndexLosSantos, priorityIndexBlaineCounty, cooldownEndTimeLosSantos, cooldownEndTimeBlaineCounty)
            end)
        else
            cooldownEndTimeLosSantos = 0  
        end

        TriggerClientEvent('updatePriorityHUD', -1, priorityIndexLosSantos, priorityIndexBlaineCounty, cooldownEndTimeLosSantos, cooldownEndTimeBlaineCounty)
        TriggerClientEvent('playSoundEffect', -1)
    else
        TriggerClientEvent('chat:addMessage', src, { args = { '^1Error:', 'You do not have permission to use this command!' } })
    end
end, false)

RegisterCommand('prioritybc', function(source, args, rawCommand)
    local src = source
    if IsPlayerAceAllowed(src, "dual.prio") then
        priorityIndexBlaineCounty = priorityIndexBlaineCounty + 1
        if priorityIndexBlaineCounty > #priorityStates then
            priorityIndexBlaineCounty = 1
        end

        if priorityIndexBlaineCounty == 3 then
            cooldownEndTimeBlaineCounty = GetGameTimer() + cooldownDuration

            Citizen.CreateThread(function()
                Citizen.Wait(cooldownDuration)
                cooldownEndTimeBlaineCounty = 0
                priorityIndexBlaineCounty = 1 
                TriggerClientEvent('updatePriorityHUD', -1, priorityIndexLosSantos, priorityIndexBlaineCounty, cooldownEndTimeLosSantos, cooldownEndTimeBlaineCounty)
            end)
        else
            cooldownEndTimeBlaineCounty = 0  
        end

        TriggerClientEvent('updatePriorityHUD', -1, priorityIndexLosSantos, priorityIndexBlaineCounty, cooldownEndTimeLosSantos, cooldownEndTimeBlaineCounty)
        TriggerClientEvent('playSoundEffect', -1)
    else
        TriggerClientEvent('chat:addMessage', src, { args = { '^1Error:', 'You do not have permission to use this command!' } })
    end
end, false)

function InitializeHUD(playerId)
    TriggerClientEvent('updatePriorityHUD', playerId, priorityIndexLosSantos, priorityIndexBlaineCounty, cooldownEndTimeLosSantos, cooldownEndTimeBlaineCounty)
end

AddEventHandler('playerConnecting', function(playerName, setKickReason)
    local playerId = source
    InitializeHUD(playerId)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) 

        if cooldownEndTimeLosSantos > 0 and GetGameTimer() >= cooldownEndTimeLosSantos then
            cooldownEndTimeLosSantos = 0
            priorityIndexLosSantos = 1 
            TriggerClientEvent('updatePriorityHUD', -1, priorityIndexLosSantos, priorityIndexBlaineCounty, cooldownEndTimeLosSantos, cooldownEndTimeBlaineCounty)
        end

        if cooldownEndTimeBlaineCounty > 0 and GetGameTimer() >= cooldownEndTimeBlaineCounty then
            cooldownEndTimeBlaineCounty = 0
            priorityIndexBlaineCounty = 1 
            TriggerClientEvent('updatePriorityHUD', -1, priorityIndexLosSantos, priorityIndexBlaineCounty, cooldownEndTimeLosSantos, cooldownEndTimeBlaineCounty)
        end
    end
end)
