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

ESX    = nil

local PlayerData = {}
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
end)

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
		
		--local playerPed = GetPlayerPed(-1)
		--SpawnVehicle(data.current.value)
		
	end, function (data, menu)
		menu.close()
	end)
end

function ListMenuSpawner()
	--local elements = Config.Vehicles
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
		
		for k,v in pairs(Config.SpawnerLocations) do
			if (GetDistanceBetweenCoords(coords, v.Marker.x, v.Marker.y, v.Marker.z, true) < Config.DrawDistance) then
				DrawMarker(Config.MarkerType, v.Marker.x, v.Marker.y, v.Marker.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerInfo.x, Config.MarkerInfo.y, Config.MarkerInfo.z, Config.MarkerInfo.r, Config.MarkerInfo.g, Config.MarkerInfo.b, 100, false, true, 2, false, false, false, false)	
				DrawMarker(Config.MarkerType, v.Deleter.x, v.Deleter.y, v.Deleter.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerInfo2.x, Config.MarkerInfo2.y, Config.MarkerInfo2.z, Config.MarkerInfo2.r, Config.MarkerInfo2.g, Config.MarkerInfo2.b, 100, false, true, 2, false, false, false, false)	
			end
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
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)
			
			if IsControlJustReleased(0, Keys['E']) then
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
Citizen.CreateThread(function()
	local blipList = {}
	
	for k,v in pairs(Config.SpawnerLocations) do
		table.insert(blipList, {
			coords = { v.Marker.x, v.Marker.y },
			text   = _U('blip_spawner'),
			sprite = Config.BlipSpawner.Sprite,
			color  = Config.BlipSpawner.Color,
			scale  = Config.BlipSpawner.Scale
		})
	end
	
	for i=1, #blipList, 1 do
		CreateBlip(blipList[i].coords, blipList[i].text, blipList[i].sprite, blipList[i].color, blipList[i].scale)
	end
end)

function CreateBlip(coords, text, sprite, color, scale)
	local blip = AddBlipForCoord( table.unpack(coords) )

	SetBlipSprite(blip, sprite)
	SetBlipScale(blip, scale)
	SetBlipColour(blip, color)

	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandSetBlipName(blip)
end
