Citizen.CreateThread(function() 
    TriggerServerEvent('playerLoaded_battlepass')
end)

RegisterNetEvent('tickBattlepasstime')
AddEventHandler('tickBattlepasstime', function(premiumState)
    Citizen.CreateThread(function() 
        if premiumState == 1 then
            while true do
                Citizen.Wait((Config.PremiumUserTimer)*1000)
                TriggerServerEvent('earnPoints')
            end
        else
            while true do
                Citizen.Wait((Config.nonPremiumUserTimer)*1000)
                TriggerServerEvent('earnPoints')
            end
        end       
    end)
end)

RegisterCommand("asd", function(src)
    TriggerServerEvent("getDBPassData")
end)

RegisterNetEvent('battlepassMenu')
AddEventHandler('battlepassMenu', function(sql, player)
    SetNuiFocus(true, true);
    SendNUIMessage({
        event = "show",
        data = Config.Slots,
        sql = sql,
        player = player
    })        
    TriggerScreenblurFadeIn(
		1000
	)
end)

RegisterCommand("getveh", function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsUsing(ped)
    local variables = GetVehicleSuspensionHeight(veh)
    PlayVehicleDoorOpenSound(veh, 1)
    SetReduceDriftVehicleSuspension(veh, true)
    SetVehicleCanLeakOil(veh, true)
    SetVehicleJetEngineOn(veh, true)
    print(json.encode(veh))

end)

RegisterNetEvent('notifyUser')
AddEventHandler('notifyUser', function(types, msg)
    if types == 'success' then
        if Config.Notification == 'okok' then
            exports['okokNotify']:Alert(msg.title, msg.msg, msg.time, types)
        elseif Config.Notification == 'esxdefault' then
            ESX.ShowNotification(msg.msg)
        elseif Config.Notification == 'tNotify' then
            exports['t-notify']:Alert({
                style  =  'success',
                message  =  msg.msg
            })
        elseif Config.Notification == 'codem' then
            TriggerEvent('codem-notification', msg.msg, msg.time, "info")
        elseif Config.Notification == 'mythic' then

        end
    elseif types == 'failed' then
        exports['okokNotify']:Alert(msg.title, msg.msg, msg.time, 'error')
    end
end)

RegisterNetEvent('updateNUI')
AddEventHandler('updateNUI', function(sql, player)
    SendNUIMessage({
        event = "fetchData",
        data = Config.Slots,
        sql = sql,
        player = player
    })
end)
       
RegisterNUICallback('buyBattlePass', function(battlePassID)
    TriggerServerEvent('claimItem', battlePassID.id)
end)

RegisterNUICallback('onClosing', function()
    TriggerScreenblurFadeOut(
		1000
	)
    SendNUIMessage({
        event = "hide"
    })
    SetNuiFocus(false, false);
end)