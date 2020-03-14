Config = {}
Config.Locale = 'en'

Config.DrawDistance = 100
Config.MenuMarker  = {Type = 1, r = 0, g = 255, b = 0, x = 1.5, y = 1.5, z = 1.0} -- Menu Marker | Green w/Standard Size
Config.DelMarker  = {Type = 1, r = 255, g = 0, b = 0, x = 5.0, y = 5.0, z = 1.0} -- Delete Marker | Red w/Large Size
Config.BlipVehicleSpawner = {Sprite = 479, Color = 2, Display = 2, Scale = 1.0}

Config.Zones = {
	VehicleSpawner1 = { -- Los Santos Docks
		Pos = vector3(1246.3, -3256.8, 5.0), -- Enter Marker
		Loc = vector3(1274.1, -3238.2, 5.9), -- Spawn Location
		Del = vector3(1274.1, -3238.2, 4.9), -- Delete Location
		Heading = 93.17
	},
	VehicleSpawner2 = { -- Sandy Shores U-Tool
		Pos = vector3(2691.2, 3461.7, 55.2), -- Enter Marker
		Loc = vector3(2683.3, 3456.7, 55.7), -- Spawn Location
		Del = vector3(2683.3, 3456.7, 54.7), -- Delete Location
		Heading = 248.53
	},
	VehicleSpawner3 = { -- Paleto Bay Reds
		Pos = vector3(-185.1, 6271.8, 30.5), -- Enter Marker
		Loc = vector3(-196.7, 6274.1, 31.5), -- Spawn Location
		Del = vector3(-196.7, 6274.1, 30.5), -- Delete Location
		Heading = 337.68
	}
}

Config.Vehicles = {
	{
		model = 'boattrailer',
		label = 'Boat Trailer'
	},
	{
		model = 'trailersmall',
		label = 'Small Trailer'
	},
	{
		model = 'tanker',
		label = 'Tanker Trailer'
	},
	{
		model = 'docktrailer',
		label = 'Dock Trailer'
	},
	{
		model = 'trailerlogs',
		label = 'Logs Trailer'
	},
	{
		model = 'trailers',
		label = 'Curtain/Box Trailer'
	},
	{
		model = 'trailers2',
		label = 'Refrigeration Trailer'
	},
	{
		model = 'trailers3',
		label = 'Big G Goods Trailer'
	},
	{
		model = 'trailers4',
		label = 'Container Trailer'
	}
}
