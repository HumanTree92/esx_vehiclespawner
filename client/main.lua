ESX = nil

local PlayerData              = {}
local BlipList                = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local spawnedVehicles         = {}
local this_Spawner            = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	refreshBlips()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	refreshBlips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	deleteBlips()
	refreshBlips()
end)

-- Open Menu Spawner
function OpenMenuSpawner(PointType)
	ESX.UI.Menu.CloseAll()

	local elements = {}

	if PointType == 'spawner_point' then
		table.insert(elements, {label = _U('list_spawners'), value = 'list_spawners'})
	elseif PointType == 'deleter_point' then
		table.insert(elements, {label = _U('return_spawners'), value = 'return_spawners'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawner_menu', {
		title    = _U('spawner'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()
		local action = data.current.value

		if action == 'list_spawners' then
			ListMenuSpawner()
		elseif action == 'return_spawners' then
			ListMenuReturn()
		end
	end, function (data, menu)
		menu.close()
	end)
end

-- List Vehicles
function ListMenuSpawner()
	local elements = {
		{label = _U('dont_abuse')}
	}

	for i=1, #Config.Vehicles, 1 do
		table.insert(elements, {
			label = Config.Vehicles[i].label,
			model = Config.Vehicles[i].model
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
		title    = _U('vehicle_spawner'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()
		SpawnVehicle(data.current.model)
	end, function(data, menu)
		menu.close()
	end)
end

function ListMenuReturn()
	local playerCoords = GetEntityCoords(PlayerPedId())

	vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 5.0)
	if #vehicles > 0 then
		for k,v in ipairs(vehicles) do
			ESX.Game.DeleteVehicle(v)
		end
	end
end

function SpawnVehicle(model)
	ESX.Game.SpawnVehicle(model, {
		x = this_Spawner.Spawner.x,
		y = this_Spawner.Spawner.y,
		z = this_Spawner.Spawner.z + 1
	}, this_Spawner.Spawner.h)
end

-- Entered Marker
AddEventHandler('esx_vehiclespawner:hasEnteredMarker', function(zone)
	if zone == 'spawner_point' then
		CurrentAction     = 'spawner_point'
		CurrentActionMsg  = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'deleter_point' then
		CurrentAction     = 'deleter_point'
		CurrentActionMsg  = _U('press_to_enter2')
		CurrentActionData = {}
	end
end)

-- Exited Marker
AddEventHandler('esx_vehiclespawner:hasExitedMarker', function()
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Draw Markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)
		local canSleep  = true

		for k,v in pairs(Config.SpawnerLocations) do
			if (GetDistanceBetweenCoords(coords, v.Marker.x, v.Marker.y, v.Marker.z, true) < Config.DrawDistance) then
				canSleep = false
				DrawMarker(Config.MarkerType, v.Marker.x, v.Marker.y, v.Marker.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerInfo.x, Config.MarkerInfo.y, Config.MarkerInfo.z, Config.MarkerInfo.r, Config.MarkerInfo.g, Config.MarkerInfo.b, 100, false, true, 2, false, false, false, false)	
				DrawMarker(Config.MarkerType, v.Deleter.x, v.Deleter.y, v.Deleter.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerInfo2.x, Config.MarkerInfo2.y, Config.MarkerInfo2.z, Config.MarkerInfo2.r, Config.MarkerInfo2.g, Config.MarkerInfo2.b, 100, false, true, 2, false, false, false, false)	
			end
		end

		if canSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Activate Menu when in Markers
Citizen.CreateThread(function()
	local currentZone = ''
	while true do
		Citizen.Wait(1)

		local playerPed  = PlayerPedId()
		local coords     = GetEntityCoords(playerPed)
		local isInMarker = false

		for k,v in pairs(Config.SpawnerLocations) do
			if (GetDistanceBetweenCoords(coords, v.Marker.x, v.Marker.y, v.Marker.z, true) < Config.MarkerInfo.x) then
				isInMarker   = true
				this_Spawner = v
				currentZone  = 'spawner_point'
			end

			if(GetDistanceBetweenCoords(coords, v.Deleter.x, v.Deleter.y, v.Deleter.z, true) < Config.MarkerInfo2.x) then
				isInMarker   = true
				this_Spawner = v
				currentZone  = 'deleter_point'
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_vehiclespawner:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_vehiclespawner:hasExitedMarker', LastZone)
		end

		if not isInMarker then
			Citizen.Wait(500)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'spawner_point' then
					OpenMenuSpawner('spawner_point')
				elseif CurrentAction == 'deleter_point' then
					OpenMenuSpawner('deleter_point')
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Blips
function deleteBlips()
	if BlipList[1] ~= nil then
		for i=1, #BlipList, 1 do
			RemoveBlip(BlipList[i])
			BlipList[i] = nil
		end
	end
end

function refreshBlips()
	if Config.EnableBlips then
		if Config.EnableSpecificOnly then
			if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'unemployed' or ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'gang' or ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'fisherman' or ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'fueler' or ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'lumberjack' or ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'miner' or ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'butcher' then
				for k,v in pairs(Config.SpawnerLocations) do
					local blip = AddBlipForCoord(v.Marker.x, v.Marker.y)

					SetBlipSprite (blip, Config.BlipSpawner.Sprite)
					SetBlipDisplay(blip, Config.BlipSpawner.Display)
					SetBlipScale  (blip, Config.BlipSpawner.Scale)
					SetBlipColour (blip, Config.BlipSpawner.Color)
					SetBlipAsShortRange(blip, true)

					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(_U('blip_spawner'))
					EndTextCommandSetBlipName(blip)
					table.insert(BlipList, blip)
				end
			end
		else
			for k,v in pairs(Config.SpawnerLocations) do
				local blip = AddBlipForCoord(v.Marker.x, v.Marker.y)

				SetBlipSprite (blip, Config.BlipSpawner.Sprite)
				SetBlipDisplay(blip, Config.BlipSpawner.Display)
				SetBlipScale  (blip, Config.BlipSpawner.Scale)
				SetBlipColour (blip, Config.BlipSpawner.Color)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(_U('blip_spawner'))
				EndTextCommandSetBlipName(blip)
				table.insert(BlipList, blip)
			end
		end
	end
end
