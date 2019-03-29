Config = {}
Config.Locale = 'en'

Config.MarkerType   = 1
Config.DrawDistance = 100.0

Config.BlipSpawner = {
	Sprite = 479,
	Color = 2,
	Display = 2,
	Scale = 1.0
}

Config.MarkerInfo = {
	r = 0, g = 255, b = 0,     -- Green Color
	x = 1.5, y = 1.5, z = 1.0  -- Standard Size Circle
}

Config.MarkerInfo2 = {
	r = 255, g = 0, b = 0,     -- Red Color
	x = 5.0, y = 5.0, z = 1.0  -- Standard Size Circle
}

Config.EnableSpecificOnly = true -- If true it will only show Blips to Job Specific Players | false shows it to Everyone.
Config.EnableBlips = true -- If true then it will show blips | false does the Opposite.

Config.SpawnerLocations = {
	Spawner_Docks = {
		Marker =  { x = 1246.31, y = -3256.8, z = 5.03 },
		Spawner = { x = 1274.09, y = -3238.27, z = 5.9, h = 93.17 },
		Deleter = { x = 1274.09, y = -3238.27, z = 4.9 }
	},
	
	Spawner_SandyShores_UTool = {
		Marker =  { x = 2691.19, y = 3461.67, z = 55.23 },
		Spawner = { x = 2683.34, y = 3456.76, z = 55.76, h = 248.53 },
		Deleter = { x = 2683.34, y = 3456.76, z = 54.76 }
	},
	
	Spawner_PaletoBay_Reds = {
		Marker =  { x = -185.06, y = 6271.84, z = 30.49 },
		Spawner = { x = -196.67, y = 6274.14, z = 31.49, h = 337.68 },
		Deleter = { x = -196.67, y = 6274.14, z = 30.49 }
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
		label = 'White Container Trailer'
	}
}
