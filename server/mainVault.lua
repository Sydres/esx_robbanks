local rob = false
local robbers = {}
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_holdup:tooFarVault')
AddEventHandler('esx_holdup:tooFarVault', function(currentVault)
	local _source = source
	local xPlayers = ESX.GetPlayers()
	rob = false

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('esx:showNotification', xPlayers[i], _U('robbery_cancelled_at', Vaults[currentVault].nameOfVault))
			TriggerClientEvent('esx_holdup:killBlip', xPlayers[i])
		end
	end

	if robbers[_source] then
		TriggerClientEvent('esx_holdup:tooFarVault', _source)
		robbers[_source] = nil
		TriggerClientEvent('esx:showNotification', _source, _U('robbery_cancelled_at', Vaults[currentVault].nameOfVault))
	end
end)

RegisterServerEvent('esx_holdup:robberyStartedVault')
AddEventHandler('esx_holdup:robberyStartedVault', function(currentVault)
	local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	if Vaults[currentVault] then
		local vault = Vaults[currentVault]

		if (os.time() - vault.lastRobbed) < Config.TimerBeforeNewRob and vault.lastRobbed ~= 0 then
			TriggerClientEvent('esx:showNotification', _source, _U('recently_robbed', Config.TimerBeforeNewRob - (os.time() - vault.lastRobbed)))
			return
        end
        
        if xPlayer.getInventoryItem('keytovault').count < 1 then
            TriggerClientEvent('esx:showNotification', _source, _U('robbery_nokey')) 
            return
        else 
            xPlayer.removeInventoryItem('keytovault', 1) 
        end            

		local cops = 0
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				cops = cops + 1
			end
		end

		if not rob then
			if cops >= Config.PoliceNumberRequired then
				rob = true

				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
					if xPlayer.job.name == 'police' then
						TriggerClientEvent('esx:showNotification', xPlayers[i], _U('rob_in_prog', vault.nameOfVault))
                        TriggerClientEvent('esx_holdup:setBlipVault', xPlayers[i], Vaults[currentVault].position)
					end
				end

				TriggerClientEvent('esx:showNotification', _source, _U('started_to_rob', vault.nameOfVault))
				TriggerClientEvent('esx:showNotification', _source, _U('alarm_triggered'))
				
				TriggerClientEvent('esx_holdup:currentlyRobbingVault', _source, currentVault)
				TriggerClientEvent('esx_holdup:startTimerVault', _source)
				
				Vaults[currentVault].lastRobbed = os.time()
				robbers[_source] = currentVault

				SetTimeout(vault.secondsRemaining * 1000, function()
					if robbers[_source] then
						rob = false
						if xPlayer then
							TriggerClientEvent('esx_holdup:robberyCompleteVault', _source, vault.reward)

							if Config.GiveBlackMoney then
								xPlayer.addAccountMoney('black_money', vault.reward)
							else
								xPlayer.addMoney(vault.reward)
							end
							
							local xPlayers, xPlayer = ESX.GetPlayers(), nil
							for i=1, #xPlayers, 1 do
								xPlayer = ESX.GetPlayerFromId(xPlayers[i])

								if xPlayer.job.name == 'police' then
									TriggerClientEvent('esx:showNotification', xPlayers[i], _U('robbery_complete_at', vault.nameOfVault))
									TriggerClientEvent('esx_holdup:killBlipVault', xPlayers[i])
								end
							end
						end
					end
				end)
			else
				TriggerClientEvent('esx:showNotification', _source, _U('min_police', Config.PoliceNumberRequired))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('robbery_already'))
		end
	end
end)
