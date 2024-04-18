-- SEED USABLE ITEM REGISTER
-- Register every seed only changing the name of it between ''
--[[for key, value in pairs(Config.Plants) do 
	ESX.RegisterUsableItem(key, function(playerId)
		TriggerClientEvent('nert_drugs_plant', playerId, key)
	end)
end

-- DRUGS USABLE ITEM REGISTER
-- Register every drug only changing the name of it between ''
for key, value in pairs(Config.Drugs) do 
	ESX.RegisterUsableItem(key, function(playerId)
		TriggerClientEvent('nert_drugs_use', playerId, key)
	end)
end]]