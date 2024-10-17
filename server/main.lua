ESX = exports.es_extended:getSharedObject()
drugs_token = nil
CreateThread(function()
    Citizen.SetTimeout(Config.GlobalGrowthRate * 1000, function()
        updatePlants()
    end)

    repeat 
        drugs_token = exports.nertigel_base.get_heartbeat(0, "drugs_token")
        Wait(1500)
    until drugs_token ~= nil
end)

function updatePlants()
    --DEAD PLANTS
    MySQL.Async.fetchAll("SELECT id FROM plants WHERE (water < 2 OR food < 2) AND rate > 0",
        {},
        function(info)
            for _, v in ipairs(info) do
                MySQL.Async.execute(
                    "UPDATE `plants` SET `rate` = @rate, `food` = @food, `water` = @water WHERE id = @id",
                    {["@id"] = v.id, ["@rate"] = 0, ["@food"] = 0, ["@water"] = 0},
                    function() end)
            end
    end)

    -- ALIVE PLANT REDUCTION
    MySQL.Async.execute("UPDATE `plants` SET `growth`=`growth` + (0.01 * `rate`) , `food` = `food` - (0.02 * `rate`), `water` = `water` -  (0.02 * `rate`) WHERE water >= 2 OR food >= 2",
        {},
        function()
            TriggerClientEvent("core_drugs:growthUpdate", -1)
    end)

    -- GROW PLANTS | I still cant understand wtf is the purpose of this? -nertigel
    --[[MySQL.Async.fetchAll("SELECT id, growth FROM plants WHERE (growth >= 30 AND growth <= 31) OR (growth >= 80 AND growth <= 81)",
        {},
        function(info)
            for _, v in ipairs(info) do
                TriggerClientEvent("core_drugs:growPlant", -1, v.id, v.growth)
            end
        end
    )]]
end

function proccesing(player, type)
    TriggerClientEvent("core_drugs:process", player, type)
end

function plant(player, type)
    TriggerClientEvent("core_drugs:plant", player, type)
end

function drug(player, type)
    TriggerClientEvent("core_drugs:drug", player, type)
end

function addPlant(type, coords, id)
    local rate = Config.DefaultRate
    local zone = nil

    for _, v in ipairs(Config.Zones) do
        if #(v.Coords - coords) < v.Radius then
            local contains = false
            for _, g in ipairs(v.Exclusive) do
                if g == type then
                    contains = true
                end
            end

            if contains then
                rate = v.GrowthRate
                zone = v
            end
        end
    end

    if Config.OnlyZones then
        if zone == nil then
            TriggerClientEvent("notification", id, Config.Text["cant_plant"], "error")
            return
        end
    end

    MySQL.Async.insert(
        "INSERT INTO plants (coords, type, growth, rate,water,food) VALUES (@coords, @type, @growth, @rate, @water, @food)",
        {
            ["@coords"] = json.encode({x = coords[1], y = coords[2], z = coords[3]}),
            ["@type"] = type,
            ["@growth"] = 0,
            ["@rate"] = rate,
            ["@food"] = 10,
            ["@water"] = 10
        },
        function(id)
            TriggerClientEvent("core_drugs:addPlant", -1, type, coords, id)
        end
    )
end

RegisterServerEvent("core_drugs:addPlant")
AddEventHandler("core_drugs:addPlant", function(plant, coords)
    local Player = ESX.GetPlayerFromId(source)
    if (Config.Plants[plant]) then 
        addPlant(plant, coords, source)
        Player.removeInventoryItem(plant, 1)
    end
end)

RegisterServerEvent("core_drugs:removeItem")
AddEventHandler("core_drugs:removeItem", function(item, count)
    local Player = ESX.GetPlayerFromId(source)
    if (type(count) == 'number' and count > 0) then 
        Player.removeInventoryItem(item, count)
    else
        DropPlayer(source, "core_drugs - negative removeItem count")
    end
end)

function string:split(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

RegisterServerEvent("core_drugs:sellDrugs")
AddEventHandler("core_drugs:sellDrugs", function(hash, _)
    local Player = ESX.GetPlayerFromId(source)
    local dealer = Config.Dealers[_]
    if (drugs_token ~= hash) then 
        print("nertigel_drugs: "..GetPlayerIdentifierByType(Player.source, 'license').." has entered an illegal hash: "..hash)
        return DropPlayer(Player.source, "exploit attempt, hash: "..hash)
    end
    if (dealer) then 
        local pay = 0
        
        for drug, price in pairs(dealer.Prices) do
            local ox_inventory = exports.ox_inventory
            local items = ox_inventory:Search(source, 1, drug)
            for k, v in pairs(items) do
                if (drug:sub(1, 4) == "weed") then 
                    local THC, CBD = 15, 1
                    if (v.metadata and v.metadata.type) then
                        THC, CBD = v.metadata.type:sub(2, 3), v.metadata.type:sub(6, 7)
                    end
                    pay = pay + (price * v.count * (THC - CBD)/10) 
                    ox_inventory:RemoveItem(source, drug, v.count, v.metadata, v.slot)
                    --[[print(v.name, 'slot: '..v.slot, 'metadata: '..v.metadata.type)]]
                end
            end
            --[[local item = Player.getInventoryItem(k)
            if item.count > 0 then
                pay = pay + (price * item.count)
                Player.removeInventoryItem(k, item.count)
            end]]
        end

        if pay > 0 then
            local bonus = math.random(199, 499)
            Player.addMoney(pay + bonus)
            TriggerClientEvent("notification", source, Config.Text["sold_dealer"] .. pay.."(+$"..bonus..")", "success")
        else
            TriggerClientEvent("notification", source, Config.Text["no_drugs"], "error")
        end
    else
        DropPlayer(Player.source, "exploit attempt, drug: ".._)
    end
    
end)

RegisterServerEvent("core_drugs:deletePlant")
AddEventHandler(
    "core_drugs:deletePlant",
    function(id)
        MySQL.Async.execute(
            "DELETE FROM plants WHERE id = @id",
            {["@id"] = id},
            function()
            end
        )
    end
)

RegisterServerEvent("core_drugs:updatePlant")
AddEventHandler(
    "core_drugs:updatePlant",
    function(id, info)
        MySQL.Async.execute(
            "UPDATE `plants` SET `growth`=@growth, `rate` = @rate, `food` = @food, `water` = @water WHERE id = @id",
            {
                ["@id"] = id,
                ["@growth"] = info.growth,
                ["@rate"] = info.rate,
                ["@food"] = info.food,
                ["@water"] = info.water
            },
            function()
            end
        )
    end
)

RegisterServerEvent("core_drugs:harvest")
AddEventHandler("core_drugs:harvest", function(hash, type, info)
    local src = source
    if (drugs_token ~= hash) then 
        print("nertigel_drugs: "..GetPlayerIdentifierByType(src, 'license').." has entered an illegal hash: "..hash)
        return DropPlayer(src, "exploit attempt, hash: "..hash)
    end
    local typeInfo = Config.Plants[type]
    if (typeInfo) then 
        local Player = ESX.GetPlayerFromId(src)

        local val = typeInfo.Amount * tonumber(info.growth) / 100
        val = math.floor(val + 0.5)

        if info.growth < 20 then
            val = 0
        end

        if (typeInfo.SeedChance >= math.random(1, 100)) then
            Player.addInventoryItem(type, 1)
        end
        if (val > 0) then 
            if exports.ox_inventory:CanCarryItem(1, typeInfo.Produce, val) then
                if (typeInfo.Type == 'weed') then 
                    exports.ox_inventory:AddItem(1, typeInfo.Produce, val, "T"..math.random(typeInfo.Levels.THC.min, typeInfo.Levels.THC.max).."/C0"..math.random(typeInfo.Levels.CBD.min, typeInfo.Levels.CBD.max))
                else
                    Player.addInventoryItem(typeInfo.Produce, val)
                end
            end
        end
    end
end)

ESX.RegisterServerCallback(
    "core_drugs:getInfo",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT * FROM plants WHERE 1",
            {},
            function(infoPlants)
                local plants = {}

                for _, v in ipairs(infoPlants) do
                    local coords = json.decode(v.coords) or {x = 0, y = 0, z = 0}
                    local data = {growth = v.growth, rate = v.rate, water = v.water, food = v.food}
                    coords = vector3(coords.x, coords.y, coords.z)

                    plants[v.id] = {type = v.type, coords = coords, info = data}
                end

                cb(plants)
            end
        )
    end
)

ESX.RegisterServerCallback(
    "core_drugs:getPlant",
    function(source, cb, id)
        MySQL.Async.fetchAll(
            "SELECT growth,rate,food,water FROM plants WHERE id = @id LIMIT 1",
            {["@id"] = id},
            function(info)
                local data = {growth = info[1].growth, rate = info[1].rate, water = info[1].water, food = info[1].food}

                cb(data)
            end
        )
    end
)
