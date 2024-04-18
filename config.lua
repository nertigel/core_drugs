--[[
    credits to og core_drugs (I yoinked this from a leaks website)
    highly edited by Nertigel, this script is used to mainly provide a custom weed system with ox
]]

Config = {

OnlyZones = false, -- Allow drug growth only in defined zones
GlobalGrowthRate = 10, -- In how many seconds it takes to update the plant (At 100% rate plant will grow 1% every update)
DefaultRate = 10, -- Plants planted outside zone default growth rate percentage
WeightSystem = true, -- Using ESX Weight System

Zones = {
	{
		Coords = vector3(1854.1574707031,4907.66015625,44.745887756348),
		Radius = 100.0,
		GrowthRate = 20.0,
		Display = true,
		DisplayBlip = 469, -- Select blip from (https://docs.fivem.net/docs/game-references/blips/)
		DisplayColor = 2, -- Select blip color from (https://docs.fivem.net/docs/game-references/blips/)
		DisplayText = 'Weed Zone',
		Exclusive = { -- Types of drugs that will be affected in this area.
            'weed_bk_seed', 
            'weed_lh_seed', 
            'weed_wc_seed', 
            'weed_ww_seed', 
            'weed_mc_seed', 
            'weed_hk_seed', 
            'weed_do_seed', 
            'weed_gg_seed', 
            'weed_gmo_seed'
        }
	}
},

PlantWater = {
    ['watering_can'] = math.random(20, 30), -- Item and percent it adds to overall plant water
    ['water'] = math.random(5, 10),
},

PlantFood = {
    ['fertilizer'] = math.random(20, 30) -- Item and percent it adds to overall plant food  
},


Plants = { -- Create seeds for drugs
    ['weed_bk_seed'] = {
        Label = 'Bubba Kush',
        Type = 'weed', -- Type of drug
        Image = 'weed.png', -- Image of plant
        PlantType = 'plant1', -- Choose plant types from (plant1, plant2, small_plant) also you can change plants yourself in main/client.lua line: 2
        Color = '155, 0, 0', -- Main color of the plant rgb
        Produce = 'weed_bk', -- Item the plant is going to produce when harvested
        Amount = 168, -- The max amount you can harvest from the plant
        SeedChance = 40, -- Percent of getting back the seed
        Levels = { -- custom thc/cbd by nertigel
            THC = {min = 15, max = 22},
            CBD = {min = 1, max = 3}
        },
        Time = 15800 -- Time it takes to harvest in miliseconds
    },
    ['weed_lh_seed'] = {
        Label = 'Lemon Haze',
        Type = 'weed',
        Image = 'weed.png',
        PlantType = 'plant2',
        Color = '240, 240, 0',
        Produce = 'weed_lh',
        Amount = 150,
        SeedChance = 70,
        Levels = {
            THC = {min = 16, max = 20},
            CBD = {min = 0, max = 1}
        },
        Time = 14000
    },
    ['weed_wc_seed'] = {
        Label = 'Wedding Cake',
        Type = 'weed',
        Image = 'weed.png',
        PlantType = 'small_plant',
        Color = '230, 0, 255',
        Produce = 'weed_wc',
        Amount = 156,
        SeedChance = 60,
        Levels = {
            THC = {min = 20, max = 24},
            CBD = {min = 0, max = 2}
        },
        Time = 14500
    },
    ['weed_ww_seed'] = {
        Label = 'White Widow',
        Type = 'weed',
        Image = 'weed.png',
        PlantType = 'small_plant',
        Color = '240, 240, 240',
        Produce = 'weed_ww',
        Amount = 177,
        SeedChance = 40,
        Levels = {
            THC = {min = 16, max = 25},
            CBD = {min = 1, max = 3}
        },
        Time = 16600
    },
    ['weed_mc_seed'] = {
        Label = 'Miracle Cookies',
        Type = 'weed',
        Image = 'weed.png',
        PlantType = 'small_plant',
        Color = '85, 55, 115',
        Produce = 'weed_mc',
        Amount = 165,
        SeedChance = 30,
        Levels = {
            THC = {min = 23, max = 25},
            CBD = {min = 1, max = 3}
        },
        Time = 15000
    },
    ['weed_hk_seed'] = {
        Label = 'Hindu Kush',
        Type = 'weed',
        Image = 'weed.png',
        PlantType = 'small_plant',
        Color = '75, 25, 25',
        Produce = 'weed_hk',
        Amount = 174,
        SeedChance = 25,
        Levels = {
            THC = {min = 18, max = 25},
            CBD = {min = 0, max = 2}
        },
        Time = 16000
    },
    ['weed_do_seed'] = {
    	Label = 'Do Si Dos',
        Type = 'weed',
        Image = 'weed.png',
        PlantType = 'small_plant',
        Color = '235, 235, 45',
        Produce = 'weed_do',
        Amount = 180,
        SeedChance = 25,
        Levels = {
            THC = {min = 20, max = 27},
            CBD = {min = 0, max = 3}
        },
        Time = 17000
    },
    ['weed_gg_seed'] = {
    	Label = 'Gorilla Glue 4',
        Type = 'weed',
        Image = 'weed.png',
        PlantType = 'small_plant',
        Color = '85, 25, 5',
        Produce = 'weed_gg',
        Amount = 150,
        SeedChance = 25,
        Levels = {
            THC = {min = 22, max = 27},
            CBD = {min = 1, max = 4}
        },
        Time = 14000
    },
    ['weed_gmo_seed'] = {
    	Label = 'GMO Cookies',
        Type = 'weed',
        Image = 'weed.png',
        PlantType = 'small_plant',
        Color = '5, 95, 5',
        Produce = 'weed_gmo',
        Amount = 186,
        SeedChance = 25,
        Levels = {
            THC = {min = 18, max = 28},
            CBD = {min = 1, max = 4}
        },
        Time = 17500
    },
    --[[
    ['coca_seed'] = {
        Label = 'Coca Plant',
        Type = 'cocaine', 
        Image = 'coca.png',
        PlantType = 'plant2',
        Color = '255, 255, 255', 
        Produce = 'coca',
        Amount = 3,
        SeedChance = 50,
        Time = 10000
    },]]
},

Drugs = { -- Create you own drugs
    ['weed_bk'] = {
    	Label = 'Bubba Kush',
    	Animation = 'blunt', -- Animations: blunt, sniff, pill
        Time = 30, -- Time is added on top of 30 seconds
    	Effects = { -- Effects: dryMouth, runningSpeedIncrease, infinateStamina, moreStrength, healthRegen, munchies, drunkWalk, psycoWalk, outOfBody, cameraShake, fogEffect, confusionEffect, whiteoutEffect, intenseEffect, focusEffect
            'intenseEffect',
            'infinateStamina',
            'dryMouth',
            'drunkWalk',
    	}
    },
    ['weed_lh'] = {
    	Label = 'Lemon Haze',
    	Animation = 'blunt',
        Time = 30,
    	Effects = {
            'intenseEffect',
            'dryMouth',
            'munchies',
            'focusEffect',
            'moreStrength',
            'psycoWalk',
    	}
    },
    ['weed_wc'] = {
    	Label = 'Wedding Cake',
    	Animation = 'blunt',
        Time = 30,
    	Effects = {
            'healthRegen',
            'munchies',
            'outOfBody',
            'psycoWalk',
    	}
    },
    ['weed_ww'] = {
    	Label = 'White Widow',
    	Animation = 'blunt',
        Time = 30,
    	Effects = {
            'confusionEffect',
            'dryMouth',
            'focusEffect',
            'runningSpeedIncrease'
    	}
    },
    ['weed_mc'] = {
    	Label = 'Miracle Cookies',
    	Animation = 'blunt',
        Time = 30,
    	Effects = {
            'intenseEffect',
            'confusionEffect',
            'dryMouth',
            'munchies',
            'focusEffect',
    	}
    },
    ['weed_hk'] = {
    	Label = 'Hindu Kush',
    	Animation = 'blunt',
        Time = 30,
    	Effects = {
            'intenseEffect',
            'munchies',
            'focusEffect',
            'healthRegen',
            'drunkWalk',
    	}
    },
    ['weed_do'] = {
    	Label = 'Do Si Dos',
    	Animation = 'blunt',
        Time = 30,
    	Effects = {
            'dryMouth',
            'healthRegen',
            'outOfBody',
    	}
    },
    ['weed_gg'] = {
    	Label = 'Gorilla Glue 4',
    	Animation = 'blunt',
        Time = 30,
    	Effects = {
            'dryMouth',
            'munchies',
            'focusEffect',
            'infinateStamina',
    	}
    },
    ['weed_gmo'] = {
    	Label = 'GMO Cookies',
    	Animation = 'blunt',
        Time = 30,
    	Effects = {
            'munchies',
            'intenseEffect',
            'runningSpeedIncrease',
            'psycoWalk',
            
    	}
    },
    --[[
    ['cocaine'] = {
        Label = 'Cocaine',
        Animation = 'sniff', -- Animations: blunt, sniff, pill
        Time = 60, -- Time is added on top of 30 seconds
        Effects = { -- Effects: dryMouth, runningSpeedIncrease, infinateStamina, moreStrength, healthRegen, munchies, drunkWalk, psycoWalk, outOfBody, cameraShake, fogEffect, confusionEffect, whiteoutEffect, intenseEffect, focusEffect
            'runningSpeedIncrease',
            'infinateStamina',
            'fogEffect',
            'psycoWalk'
        }
    }]]
},

Dealers = {
    ["weed_bulk"] = {
        Ped = 'g_m_importexport_01',
        Coords = vector3(167.51689147949,6631.5473632813,30.527015686035),
        Heading = 200.0,
        Prices = {
            ['weed_bk'] = 4, -- Item name and price for 1
            ['weed_lh'] = 7,
            ['weed_wc'] = 5,
            ['weed_ww'] = 6,
            ['weed_mc'] = 6,
            ['weed_hk'] = 5,
        }
    }
},



Text = { 
    ['planted'] = 'Seed was planted!',
    ['feed'] = 'Plant was fed!',
    ['water'] = 'Plant was watered!',
    ['destroy'] = 'Plant was destroyed!',
    ['harvest'] = 'You harvested the plant!',
    ['cant_plant'] = 'You cant plant here!',
    ['cant_hold'] = 'You dont have space for this item!',
    ['missing_ingrediants'] = 'You dont have these ingrediants',
    ['dealer_holo'] = '~g~E~w~  Sell drugs',
    ['sold_dealer'] = 'You sold drugs to dealer! +$',
    ['no_drugs'] = 'You dont have enough drugs'
}

}
