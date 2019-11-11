Config = {}
Config.Locale = 'en'

Config.Marker = {
	r = 250, g = 0, b = 0, a = 100,  -- red color
	x = 1.0, y = 1.0, z = 1.5,       -- tiny, cylinder formed circle
	DrawDistance = 15.0, Type = 72    -- default circle type, low draw distance due to indoors area
}

Config.PoliceNumberRequired = 0
Config.TimerBeforeNewRob    = 0 -- The cooldown timer on a store after robbery was completed / canceled, in seconds

Config.MaxDistance    = 20   -- max distance from the robbary, going any longer away from it will to cancel the robbary
Config.GiveBlackMoney = true -- give black money? If disabled it will give cash instead

Stores = {
	
	["key_mainBank"] = {
		position = { x = 248.12, y = 222.35, z = 106.29  },
		reward = math.random(1, 1000),
		nameOfStore = "Pacific Bank",
		secondsRemaining = 30, -- seconds
		lastRobbed = 10000
	}
}
Vaults = {
	
	["vault_mainBank"] = {
		position = { x = 253.95, y = 225.19, z =101.88  },
		reward = math.random(5000, 100000),
		nameOfVault = "Pacific Bank Vault",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0
	}
}
