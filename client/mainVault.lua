local holdingUp = false
local vault = ""
local blipRobbery = nil

ESX = nil

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function drawTxt(x,y, width, height, scale, text, r,g,b,a, outline)
	SetTextFont(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropshadow(0, 0, 0, 0,255)
	SetTextDropShadow()
	if outline then SetTextOutline() end

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x - width/2, y - height/2 + 0.005)
end

RegisterNetEvent('esx_holdup:currentlyRobbingVault')
AddEventHandler('esx_holdup:currentlyRobbingVault', function(currentVault)
	holdingUp, vault = true, currentVault
end)

RegisterNetEvent('esx_holdup:killBlipVault')
AddEventHandler('esx_holdup:killBlipVault', function()
	RemoveBlip(blipRobberyVault)
end)

RegisterNetEvent('esx_holdup:setBlipVault')
AddEventHandler('esx_holdup:setBlipVault', function(position)
	blipRobberyVault = AddBlipForCoord(position.x, position.y, position.z)

	SetBlipSprite(blipRobberyVault, 161)
	SetBlipScale(blipRobberyVault, 2.0)
	SetBlipColour(blipRobberyVault, 3)

	PulseBlip(blipRobberyVault)
end)

RegisterNetEvent('esx_holdup:tooFarVault')
AddEventHandler('esx_holdup:tooFarVault', function()
	holdingUp, vault = false, ''
	ESX.ShowNotification(_U('robbery_cancelledVault'))
end)
RegisterNetEvent('esx_holdup:nokeyVault')
AddEventHandler('esx_holdup:nokeyVault', function()
	local inventoryNumber = 0
	for i=1, #xPlayer.inventory, 1 do
		inventoryNumber = inventoryNumber + 1
	end
	print(xPlayer.playerName .. " has " .. inventoryNumber .. " items in their inventory.")
	ESX.ShowNotification(_U('robbery_nokey'))
end)

RegisterNetEvent('esx_holdup:robberyCompleteVault')
AddEventHandler('esx_holdup:robberyCompleteVault', function(award)
	holdingUp, vault = false, ''
	ESX.ShowNotification(_U('robbery_complete_vault', award))
end)

RegisterNetEvent('esx_holdup:startTimerVault')
AddEventHandler('esx_holdup:startTimerVault', function()
	local timer = Vaults[vault].secondsRemaining

	Citizen.CreateThread(function()
		while timer > 0 and holdingUp do
			Citizen.Wait(1000)

			if timer > 0 then
				timer = timer - 1
			end
		end
	end)

	Citizen.CreateThread(function()
		while holdingUp do
			Citizen.Wait(0)
			drawTxt(0.66, 1.44, 1.0, 1.0, 0.4, _U('robbery_timer_vault', timer), 255, 255, 255, 255)
		end
	end)
end)

Citizen.CreateThread(function()
	for k,v in pairs(Vaults) do
		local blip = AddBlipForCoord(v.position.x, v.position.y, v.position.z)
		SetBlipSprite(blip, 156)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('vault_robbery'))
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local playerPos = GetEntityCoords(PlayerPedId(), true)

		for k,v in pairs(Vaults) do
			local vaultPos = v.position
			local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, vaultPos.x, vaultPos.y, vaultPos.z)
			

			if distance < Config.Marker.DrawDistance then
				if not holdingUp then
					DrawMarker(Config.Marker.Type, vaultPos.x, vaultPos.y, vaultPos.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, false, false, false, false)

					if distance < 0.5 then
						ESX.ShowHelpNotification(_U('press_to_rob_vault', v.nameOfVault))


						if IsControlJustReleased(0, Keys['E']) then
							if IsPedArmed(PlayerPedId(), 4) then
						
								TriggerServerEvent('esx_holdup:robberyStartedVault', k)
							else
								ESX.ShowNotification(_U('robbery_nokey'))
							end
						end
					end
				end
			end
		end

		if holdingUp then
			local vaultPos = Vaults[vault].position
			if Vdist(playerPos.x, playerPos.y, playerPos.z, vaultPos.x, vaultPos.y, vaultPos.z) > Config.MaxDistance then
				TriggerServerEvent('esx_holdup:tooFarVault', vault)
			end
		end
	end
end)
