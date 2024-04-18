PlantTypes = {
    -- small is growth 0-30%, medium is 30-80%, large is 80-100%
    ["plant1"] = {
        small = {"bkr_prop_weed_01_small_01a", -1.65},
        medium = {"bkr_prop_weed_med_01a", -4.2},
        large = {"bkr_prop_weed_lrg_01a", -4.0}
    },
    ["plant2"] = {
        small = {"bkr_prop_weed_01_small_01b", -1.65},
        medium = {"bkr_prop_weed_med_01b", -4.2},
        large = {"bkr_prop_weed_lrg_01b", -4.0}
    },
    ["small_plant"] = {
        small = {"bkr_prop_weed_bud_pruned_01a", -1.05},
        medium = {"bkr_prop_weed_bud_02b", -1.05},
        large = {"bkr_prop_weed_bud_02a", -1.05}
    }
}

ESX = exports.es_extended:getSharedObject()

local drugs_token = nil

Plants = {}
SpawnedPlants = {}
Dealers = {}
CurrentPlant = nil
CurrentPlantInfo = nil

local shown = false
local action = false

local high_level = 0
local infinateStamina = false
local healthRegen = false
local munchies = false
local dryMouth = false
local drunkWalk = false
local cameraShake = false
local moreStrength = false
local psycoWalk = false
local outOfBody = false
local playerPedId = PlayerPedId()
local last_done = {}

Citizen.CreateThread(
    function()
        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end

        ESX.TriggerServerCallback(
            "core_drugs:getInfo",
            function(plants)
                Plants = plants

                for k, v in pairs(Plants) do

                    spawnPlant(v.type, v.coords, v.info.growth, k)
                end
            end
        )

        RegisterNetEvent(string.format("_nert_heartbeat_%s", "drugs_token"))
        AddEventHandler(string.format("_nert_heartbeat_%s", "drugs_token"), function(args)
            drugs_token = args
        end)

        TriggerServerEvent("_nert_heartbeat", "drugs_token")
    end
)

function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(500)
    end
end

function addEntityZone(id, labele)
    if (DoesEntityExist(SpawnedPlants[id])) then 
        --[[exports.ox_target:addEntity(ped, {
            {
                event = "nert_drugs:interactDealer",
                icon = "fa-solid fa-comment-dollar",
                label = "Sell bulk",
                canInteract = function()
                    local x1, y1, z1 = table.unpack(v.Coords)
                    local x2, y2, z2 = table.unpack(GetEntityCoords(playerPedId))
                    return (GetDistanceBetweenCoords(x1, y1, z1, x2, y2, z2, true))
                end,
            },
        })]]
        exports.ox_target:addLocalEntity(SpawnedPlants[id], {
            {
                debugPoly=false, useZ = true, distance = 3.0,
                event = "water_weed_nert",
                icon = "fas fa-hand-holding-water",
                label = "Water",
            },
            {
                debugPoly=false, useZ = true, distance = 3.0,
                event = "feed_weed_nert",
                icon = "fa-solid fa-seedling",
                label = "Feed",
            },
            {
                debugPoly=false, useZ = true, distance = 3.0,
                event = "harvest_weed_nert",
                icon = "fa-solid fa-hand",
                label = "Harvest",
            },
        })
    end
end

function spawnPlant(plant, coords, percent, id)
    if (Config.Plants[plant]) then 
        local plantType = Config.Plants[plant].PlantType

        if percent < 30 then
            SpawnedPlants[id] =
                CreateObject(GetHashKey(PlantTypes[plantType].small[1]),
                coords[1], coords[2], coords[3] + PlantTypes[plantType].small[2],
                false, true, 1)
        elseif percent < 80 then
            SpawnedPlants[id] =
                CreateObject(GetHashKey(PlantTypes[plantType].medium[1]),
                coords[1], coords[2], coords[3] + PlantTypes[plantType].medium[2],
                false, true, 1)
        elseif percent <= 100 then
            SpawnedPlants[id] =
                CreateObject(GetHashKey(PlantTypes[plantType].large[1]),
                coords[1], coords[2], coords[3] + PlantTypes[plantType].large[2],
                false, true, 1)
        end

        addEntityZone(id, Config.Plants[plant].label)

        SetEntityAsMissionEntity(SpawnedPlants[id], true, true)
    else
        print("could not find "..plant.." in table")
    end
end

Citizen.CreateThread(function()
    while (true) do
        if (healthRegen) then
            local ped = playerPedId
            local health = GetEntityHealth(ped)
            if (health <= GetPedMaxHealth(ped)-5) then
                SetEntityHealth(ped, health + 5)
            end

            if ((GetGameTimer() - last_done["healthRegen"]) / high_level*60000 * 100) then
                addEffect("healthRegen", false)
            end
            Citizen.Wait(3000)
        else
            Citizen.Wait(3000)
        end
    end
end)

Citizen.CreateThread(function()
    while (true) do
        if (munchies) then
            TriggerEvent('esx_status:remove', 'hunger', 2500)
            
            if ((GetGameTimer() - last_done["munchies"]) / high_level*60000 * 100) then
                addEffect("munchies", false)
            end
            Citizen.Wait(3000)
        else
            Citizen.Wait(3000)
        end
    end
end)

Citizen.CreateThread(function()
    while (true) do
        if (dryMouth) then
            TriggerEvent('esx_status:remove', 'thirst', 2500)
            
            if ((GetGameTimer() - last_done["dryMouth"]) / high_level*60000 * 100) then
                addEffect("dryMouth", false)
            end
            Citizen.Wait(3000)
        else
            Citizen.Wait(3000)
        end
    end
end)
Citizen.CreateThread(function()
    while (true) do
        if (drunkWalk) then
            RequestAnimSet("MOVE_M@DRUNK@VERYDRUNK")
            while not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") do
                Citizen.Wait(0)
            end

            SetPedMovementClipset(ped, "MOVE_M@DRUNK@VERYDRUNK", true)

            if ((GetGameTimer() - last_done["drunkWalk"]) / high_level*60000 * 100) then
                addEffect("drunkWalk", false)
            end
            Citizen.Wait(2000)
        else
            Citizen.Wait(3000)
        end
    end
end)

Citizen.CreateThread(function()
    while (true) do
        if (psycoWalk) then
            RequestAnimSet("MOVE_M@QUICK")
            while not HasAnimSetLoaded("MOVE_M@QUICK") do
                Citizen.Wait(0)
            end

            SetPedMovementClipset(ped, "MOVE_M@QUICK", true)

            if ((GetGameTimer() - last_done["psycoWalk"]) / high_level*60000 * 100) then
                addEffect("", false)
            end

            if ((GetGameTimer() - last_done["psycoWalk"]) / high_level*60000 * 100) then
                addEffect("", false)
            end
            Citizen.Wait(1000)
        else
            Citizen.Wait(3000)
        end
    end
end)

Citizen.CreateThread(function()
    while (true) do
        if (outOfBody) then
            local pid = PlayerId()
            ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 3.2)

            if ((GetGameTimer() - last_done["outOfBody"]) / high_level*60000 * 100) then
                addEffect("outOfBody", false)
            end
            Citizen.Wait(10000)
        else
            Citizen.Wait(3000)
        end
    end
end)

Citizen.CreateThread(function()
    while (true) do
        if (cameraShake) then
            local pid = PlayerId()
            ShakeGameplayCam("MEDIUM_EXPLOSION_SHAKE", 0.2)

            if ((GetGameTimer() - last_done["cameraShake"]) / high_level*60000 * 100) then
                addEffect("cameraShake", false)
            end
            Citizen.Wait(1100)
        else
            Citizen.Wait(3000)
        end
    end
end)

Citizen.CreateThread(function()
    while (true) do
        if (infinateStamina) then
            local pid = PlayerId()
            RestorePlayerStamina(pid, 1.0)

            if ((GetGameTimer() - last_done["infinateStamina"]) / high_level*60000 * 100) then
                addEffect("infinateStamina", false)
            end
            Citizen.Wait(500)
        else
            Citizen.Wait(3000)
        end
    end
end)

Citizen.CreateThread(function()
    while (true) do
        if (moreStrength) then
            local pid = PlayerId()
            local ped = playerPedId
            if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_UNARMED") then
                SetPlayerMeleeWeaponDamageModifier(pid, 2.0)
            end

            if ((GetGameTimer() - last_done["moreStrength"]) / high_level*60000 * 100) then
                addEffect("moreStrength", false)
            end
            Citizen.Wait(5)
        else
            Citizen.Wait(1000)
        end
    end
end)

function addEffect(effect, status)
    local ped = playerPedId

    if effect == "runningSpeedIncrease" then
        if status then
            Citizen.CreateThread(
                function()
                    Citizen.Wait(30000)
                    SetPedMoveRateOverride(PlayerId(), 10.0)
                    SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
                end
            )
        else
            SetPedMoveRateOverride(PlayerId(), 0.0)
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
        end
    elseif effect == "infinateStamina" then
        if status then
            Citizen.CreateThread(
                function()
                    Citizen.Wait(30000)
                    infinateStamina = true
                end
            )
        else
            infinateStamina = false
        end
    elseif effect == "moreStrength" then
        if status then
            Citizen.CreateThread(
                function()
                    Citizen.Wait(30000)
                    moreStrength = true
                end
            )
        else
            moreStrength = false
        end
    elseif effect == "healthRegen" then
        if status then
            Citizen.CreateThread(
                function()
                    Citizen.Wait(30000)
                    healthRegen = true
                end
            )
        else
            healthRegen = false
        end
    elseif effect == "munchies" then
        if status then
            Citizen.CreateThread(
                function()
                    Citizen.Wait(30000)
                    munchies = true
                end
            )
        else
            munchies = false
        end
    elseif effect == "dryMouth" then
        if status then
            dryMouth = true
        else
            dryMouth = false
        end
    elseif effect == "drunkWalk" then
        if status then
            drunkWalk = true
        else
            ResetPedMovementClipset(ped, 0)
            drunkWalk = false
        end
    elseif effect == "psycoWalk" then
        if status then
            psycoWalk = true
        else
            ResetPedMovementClipset(ped, 0)
            psycoWalk = false
        end
    elseif effect == "outOfBody" then
        if status then
            outOfBody = true
        else
            ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 0.0)
            outOfBody = false
        end
    elseif effect == "cameraShake" then
        if status then
            Citizen.CreateThread(
                function()
                    Citizen.Wait(30000)
                    cameraShake = true
                end
            )
        else
            ShakeGameplayCam("MEDIUM_EXPLOSION_SHAKE", 0.0)
            cameraShake = false
        end
    elseif effect == "fogEffect" then
        Citizen.CreateThread(function()
            AnimpostfxPlay("DrugsDrivingIn", 30000, true)
            Citizen.Wait(30000)

            AnimpostfxPlay("DrugsMichaelAliensFightIn", 100000, true)

            Citizen.Wait(30000)

            AnimpostfxStop("DrugsDrivingIn")
            AnimpostfxPlay("DrugsDrivingOut", 20000, true)
            AnimpostfxStop("DrugsMichaelAliensFightIn")
            Citizen.Wait(20000)
            AnimpostfxStop("DrugsDrivingOut")
        end)
    elseif effect == "confusionEffect" then
        Citizen.CreateThread(function()
            AnimpostfxPlay("Rampage", 30000, true)
            Citizen.Wait(30000)
            AnimpostfxPlay("Dont_tazeme_bro", 30000, true)
            Citizen.Wait(30000)
            AnimpostfxStop("Rampage")
            AnimpostfxStop("Dont_tazeme_bro")
            AnimpostfxPlay("RampageOut", 20000, true)
            Citizen.Wait(20000)
            AnimpostfxStop("RampageOut")
        end)
    elseif effect == "whiteoutEffect" then
        Citizen.CreateThread(function()
            AnimpostfxPlay("DrugsDrivingIn", 30000, true)
            Citizen.Wait(30000)
            AnimpostfxPlay("PeyoteIn", 100000, true)
            Citizen.Wait(30000)
            AnimpostfxPlay("DrugsDrivingOut", 20000, true)
            AnimpostfxPlay("PeyoteOut", 20000, true)
            AnimpostfxStop("PeyoteIn")
            AnimpostfxStop("DrugsDrivingIn")
            Citizen.Wait(20000)
            AnimpostfxStop("DrugsDrivingOut")
            AnimpostfxStop("PeyoteOut")
        end)
    elseif effect == "intenseEffect" then
        Citizen.CreateThread(function()
            AnimpostfxPlay("DrugsDrivingIn", 30000, true)
            Citizen.Wait(30000)
            AnimpostfxPlay("DMT_flight_intro", 100000, true)
            Citizen.Wait(30000)
            AnimpostfxPlay("DrugsDrivingOut", 20000, true)
            AnimpostfxStop("DMT_flight_intro")
            AnimpostfxStop("DrugsDrivingIn")
            Citizen.Wait(20000)
            AnimpostfxStop("DrugsDrivingOut")
        end)
    elseif effect == "focusEffect" then
        Citizen.CreateThread(function()
            AnimpostfxPlay("FocusIn", 100000, true)
            Citizen.Wait(30000)
            AnimpostfxStop("FocusIn")
            AnimpostfxPlay("FocusOut", 10000, false)
        end)
    end
end

function drug(typee)
    local info = Config.Drugs[typee]
    if (info) then 
        local ped = playerPedId

        Citizen.CreateThread(function()
            if info.Animation == "pill" then
                loadAnimDict("mp_suicide")
                TaskPlayAnim(ped, "mp_suicide", "pill", 3.0, 3.0, 2000, 48, 0, false, false, false)
            elseif info.Animation == "sniff" then
                loadAnimDict("anim@mp_player_intcelebrationmale@face_palm")
                TaskPlayAnim(
                    ped,
                    "anim@mp_player_intcelebrationmale@face_palm",
                    "face_palm",
                    3.0,
                    3.0,
                    3000,
                    48,
                    0,
                    false,
                    false,
                    false
                )
            elseif info.Animation == "blunt" then
                TaskStartScenarioInPlace(ped, "WORLD_HUMAN_SMOKING_POT", 0, 1)
                Citizen.Wait(20000)
                ClearPedTasks(ped)
            end
            high_level = high_level + math.random(1,3)
            for _, effect in ipairs(info.Effects) do
                Citizen.CreateThread(function()
                    addEffect(effect, true)
                    last_done[effect] = GetGameTimer()
                    Citizen.Wait(high_level*60000+math.random(15000, 30000))
                end)
            end
            high_level = high_level - 1

            --Citizen.Wait(31000 + (info.Time * 1000))
        end)
    end
end

RegisterNetEvent("nert_drugs_use")
AddEventHandler("nert_drugs_use", drug)

for key, value in pairs(Config.Drugs) do 
    exports('_n_use_'..key, (function()
        drug(key)
        TriggerServerEvent("core_drugs:removeItem", key, 1)
        CreateThread(function() 
            Wait(5000)
            TriggerEvent("notification", "You start feeling relaxed", "info", "Weed", 5000)
            TriggerEvent("nertigel_base:stress_relief_state", true)
            Wait(3*60000)
            TriggerEvent("notification", "The weed effect seems to fade away", "info", "Weed", 5000)
            TriggerEvent("nertigel_base:stress_relief_state", false)
        end)
    end))
end

--[[adapt growing drugs with just_apartments -nertigel]]
local is_indoors = false
RegisterNetEvent("nertigel_drugs:is_player_indoor")
AddEventHandler("nertigel_drugs:is_player_indoor", function(data)
    is_indoors = (data ~= nil) and true or false
end)

function plant(plant)
    local ped = playerPedId
    local coords = GetEntityCoords(ped)
    local ground_hash = GetGroundHash(ped)
    --print(ground_hash)
    if is_indoors or (ground_hash == -1286696947 or ground_hash == -1885547121 or ground_hash == 223086562 or ground_hash == -461750719) then
        local canPlant = true
        for k, v in pairs(Plants) do
            if #(coords - v.coords) < 2.5 then
                canPlant = false
            end
        end

        if canPlant and not action then
            TriggerServerEvent("core_drugs:addPlant", plant, coords)
            action = true
        else
            TriggerEvent("notification", Config.Text["cant_plant"], "error", "Weed")
        end
    else
        TriggerEvent("notification", Config.Text["cant_plant"], "error", "Weed")
    end
end

RegisterNetEvent("nert_drugs_plant")
AddEventHandler("nert_drugs_plant", plant)

for key, value in pairs(Config.Plants) do 
    exports('_n_plant_'..key, (function()
        plant(key)
    end))
end

local incubus_lua_delete_entity = (function(entity)
    if (DoesEntityExist(entity)) then
        if (IsEntityAttached(entity)) then
            DetachEntity(entity, 0, false)
        end
        SetEntityCollision(entity, false, false)
        SetEntityAlpha(entity, 0, true)
        SetEntityAsMissionEntity(entity, true, true)
        SetEntityAsNoLongerNeeded(entity)
        DeleteEntity(entity)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    
    for key, value in pairs(SpawnedPlants) do 
        exports.ox_target:removeEntity(key)
        incubus_lua_delete_entity(value)
    end
end)  

function setPlant(id, percent)
    local plant = Plants[id].type
    local plantType = Config.Plants[plant].PlantType

    if SpawnedPlants[id] ~= nil then
        local coords = Plants[id].coords
        incubus_lua_delete_entity(SpawnedPlants[id])

        if percent < 30 then
            SpawnedPlants[id] =
                CreateObject(
                GetHashKey(PlantTypes[plantType].small[1]),
                coords[1],
                coords[2],
                coords[3] + PlantTypes[plantType].small[2],
                false,
                true,
                1
            )
        elseif percent < 80 then
            SpawnedPlants[id] =
                CreateObject(
                GetHashKey(PlantTypes[plantType].medium[1]),
                coords[1],
                coords[2],
                coords[3] + PlantTypes[plantType].medium[2],
                false,
                true,
                1
            )
        elseif percent <= 100 then
            SpawnedPlants[id] =
                CreateObject(
                GetHashKey(PlantTypes[plantType].large[1]),
                coords[1],
                coords[2],
                coords[3] + PlantTypes[plantType].large[2],
                false,
                true,
                1
            )
        end

        SetEntityAsMissionEntity(SpawnedPlants[id], true, true)
    else
        Citizen.Trace("Plant not found!")
    end
end

RegisterNetEvent("feed_weed_nert")
AddEventHandler("feed_weed_nert", function(data)
    if (CurrentPlantInfo) then 
        local percent = 0
        local item = nil

        for k, v in pairs(Config.PlantFood) do
            local count = exports.ox_inventory:Search('count', k)
            if (count > 0) then
                percent = v
                item = k
                break
            end
        end

        if percent > 0 then
            CurrentPlantInfo.food = CurrentPlantInfo.food + percent
            if CurrentPlantInfo.food > 100 then
                CurrentPlantInfo.food = 100
            end
            TriggerServerEvent("core_drugs:updatePlant", CurrentPlant, CurrentPlantInfo)
            TriggerServerEvent("core_drugs:removeItem", item, 1)

            SendNUIMessage(
                {
                    type = "updatePlant",
                    info = CurrentPlantInfo
                }
            )
        else
            TriggerEvent("notification", "You don't have a fertilizer", "error", "Weed", 5000)
        end
    else
        TriggerEvent("notification", "could not find weed plant", "error", "Weed", 5000)
    end
end)

RegisterNetEvent("water_weed_nert")
AddEventHandler("water_weed_nert", function(data)
    if (CurrentPlantInfo) then 
        local percent = 0
        local item = nil

        for k, v in pairs(Config.PlantWater) do
            local count = exports.ox_inventory:Search('count', k)
            if (count > 0) then
                percent = v
                item = k
                break
            end
        end

        if percent > 0 then
            CurrentPlantInfo.water = CurrentPlantInfo.water + percent
            if CurrentPlantInfo.water > 100 then
                CurrentPlantInfo.water = 100
            end
            TriggerServerEvent("core_drugs:updatePlant", CurrentPlant, CurrentPlantInfo)
            TriggerServerEvent("core_drugs:removeItem", item, 1)

            SendNUIMessage(
                {
                    type = "updatePlant",
                    info = CurrentPlantInfo
                }
            )
        end
    else
        TriggerEvent("notification", "could not find weed plant", "error", "Weed", 5000)
    end
end)

RegisterNetEvent("harvest_weed_nert")
AddEventHandler("harvest_weed_nert", function(data)
    if (CurrentPlantInfo) then 
        if action then
            return
        end

        action = true
        local ped = playerPedId
        TaskStartScenarioInPlace(ped, "world_human_gardener_plant", 0, false)

        SendNUIMessage(
            {
                type = "hidePlant"
            }
        )

        Citizen.Wait(Config.Plants[Plants[CurrentPlant].type].Time)

        if SpawnedPlants[CurrentPlant] ~= nil then
            exports.ox_target:removeEntity(CurrentPlant)
            incubus_lua_delete_entity(SpawnedPlants[CurrentPlant])
        end

        TriggerServerEvent("core_drugs:deletePlant", CurrentPlant)
        TriggerServerEvent("core_drugs:harvest", drugs_token, Plants[CurrentPlant].type, CurrentPlantInfo)
        Plants[CurrentPlant] = nil
        SpawnedPlants[CurrentPlant] = nil
        CurrentPlant = nil
        CurrentPlantInfo = nil

        ClearPedTasks(ped)
        Citizen.Wait(4000)
        action = false
        ClearPedTasksImmediately(ped)
    else
        TriggerEvent("notification", "could not find weed plant", "error", "Weed", 5000)
    end
end)

RegisterNUICallback(
    "destroy",
    function(data)
        if action then
            return
        end

        local ped = playerPedId
        action = true
        TaskStartScenarioInPlace(ped, "world_human_gardener_plant", 0, false)

        SendNUIMessage(
            {
                type = "hidePlant"
            }
        )

        Citizen.Wait(2000)

        if SpawnedPlants[CurrentPlant] ~= nil then
            exports.ox_target:removeEntity(CurrentPlant)
            incubus_lua_delete_entity(SpawnedPlants[CurrentPlant])
        end
        Plants[CurrentPlant] = nil
        SpawnedPlants[CurrentPlant] = nil

        TriggerServerEvent("core_drugs:deletePlant", CurrentPlant)
        CurrentPlant = nil
        CurrentPlantInfo = nil

        ClearPedTasks(ped)
        Citizen.Wait(4000)
        action = false
        ClearPedTasksImmediately(ped)
    end
)

function GetGroundHash(ped)
    local posped = GetEntityCoords(ped)
    local num =
        StartShapeTestCapsule(posped.x, posped.y, posped.z + 4, posped.x, posped.y, posped.z - 2.0, 2, 1, ped, 7)
    local arg1, arg2, arg3, arg4, arg5 = GetShapeTestResultEx(num)
    return arg5
end

local function nearPlant(ped)
    for k, v in pairs(Plants) do
        if #(v.coords - GetEntityCoords(ped)) < 1.3 then
            return k
        end
    end

    return false
end

RegisterNetEvent("core_drugs:growPlant")
AddEventHandler(
    "core_drugs:growPlant",
    function(id, percent)
        if Plants[id] ~= nil and SpawnedPlants[id] ~= nil then
            setPlant(id, percent)
        end
    end
)

RegisterNetEvent("core_drugs:growthUpdate")
AddEventHandler(
    "core_drugs:growthUpdate",
    function()
        if CurrentPlantInfo ~= nil then
            CurrentPlantInfo.water = CurrentPlantInfo.water - (0.02 * CurrentPlantInfo.rate)
            CurrentPlantInfo.food = CurrentPlantInfo.food - (0.02 * CurrentPlantInfo.rate)
            CurrentPlantInfo.growth = CurrentPlantInfo.growth + (0.01 * CurrentPlantInfo.rate)

            SendNUIMessage(
                {
                    type = "updatePlant",
                    info = CurrentPlantInfo
                }
            )
        end
    end
)

RegisterNetEvent("core_drugs:addPlant")
AddEventHandler(
    "core_drugs:addPlant",
    function(typee, coords, id)
        local plantType = Config.Plants[typee].PlantType

        local ped = playerPedId
        Plants[id] = {type = typee, coords = coords}
        TaskStartScenarioInPlace(ped, "world_human_gardener_plant", 0, false)

        Citizen.Wait(2000)

        ClearPedTasks(ped)

        SpawnedPlants[id] =
            CreateObject(
            GetHashKey(PlantTypes[plantType].small[1]),
            coords[1],
            coords[2],
            coords[3] + PlantTypes[plantType].small[2],
            false,
            true,
            1
        )

        addEntityZone(id, Config.Plants[typee].label)

        SetEntityAsMissionEntity(SpawnedPlants[id], true, true)  
        action = false
    end
)

RegisterNetEvent("core_drugs:drug")
AddEventHandler(
    "core_drugs:drug",
    function(typee)
        drug(typee)
    end
)

RegisterNetEvent("core_drugs:plant")
AddEventHandler(
    "core_drugs:plant",
    function(typee)
        plant(typee)
    end
)

Citizen.CreateThread(
    function()
        for _, v in ipairs(Config.Zones) do
            if v.Display then
                local radius = AddBlipForRadius(v.Coords, v.Radius)

                SetBlipSprite(radius, 9)
                SetBlipColour(radius, v.DisplayColor)
                SetBlipAlpha(radius, 75)

                local blip = AddBlipForCoord(v.Coords)

                SetBlipSprite(blip, v.DisplayBlip)
                SetBlipColour(blip, v.DisplayColor)
                SetBlipAsShortRange(blip, true)
                SetBlipScale(blip, 0.9)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(v.DisplayText)
                EndTextCommandSetBlipName(blip)
            end
        end
    end
)

RegisterNetEvent("nert_drugs:interactDealer")
AddEventHandler("nert_drugs:interactDealer", function()
    for _, v in pairs(Config.Dealers) do
        local coords = GetEntityCoords(playerPedId)
        if #(v.Coords - coords) < 2 then
            TriggerServerEvent("core_drugs:sellDrugs", drugs_token, _)
        end
    end
end)

Citizen.CreateThread(function()
    for _, v in pairs(Config.Dealers) do
        local Model = GetHashKey(v.Ped)
        if not HasModelLoaded(Model) then
            RequestModel(Model)
            while not HasModelLoaded(Model) do
                Citizen.Wait(5)
            end
        end

        local ped = CreatePed(4, v.Ped, v.Coords, v.Heading, false, true)

        TaskSetBlockingOfNonTemporaryEvents(ped, 1)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetPedRandomComponentVariation(ped)
        SetPedRandomProps(ped)
        SetPedCanRagdoll(ped, true)
        SetEntityCollision(ped, 1, 0)
        exports.ox_target:addLocalEntity(ped, {
            {
                event = "nert_drugs:interactDealer",
                icon = "fa-solid fa-comment-dollar",
                label = "Sell bulk",
                distance = 3.0,
            }
        })
        --[[exports.qtarget:AddEntityZone("drug-dealer-"..ped, ped, 
        {name="Drug Dealer", debugPoly=false, useZ = true }, 
        {
            options = {
                {
                    event = "nert_drugs:interactDealer",
                    icon = "fa-solid fa-comment-dollar",
                    label = "Sell bulk",
                },
            },
            distance = 2.0
        })
        ]]

        table.insert(Dealers, ped)
    end

    --[[while (true) do
        for _, v in ipairs(Config.Dealers) do
            local coords = GetEntityCoords(playerPedId)
            if #(v.Coords - coords) < 2 then
                Citizen.Wait(1)
                DrawText3D(v.Coords[1], v.Coords[2], v.Coords[3] + 1.2, Config.Text["dealer_holo"])

                if IsControlJustReleased(0, 51) then
                    TriggerServerEvent("core_drugs:sellDrugs", v.Prices)
                end
            else
                Citizen.Wait(1000)
            end
        end
    end]]
end)

Citizen.CreateThread(
    function()
        Citizen.Wait(5000)
        while (true) do
            local ped = playerPedId
            local nPlant = nearPlant(ped)

            if nPlant ~= false then
                if not shown then
                    shown = true

                    SendNUIMessage(
                        {
                            type = "showPlant",
                            plantType = Plants[nPlant].type,
                            plants = Config.Plants,
                            plant = nPlant
                        }
                    )

                    ESX.TriggerServerCallback(
                        "core_drugs:getPlant",
                        function(info)
                            CurrentPlant = nPlant

                            CurrentPlantInfo = info

                            SendNUIMessage(
                                {
                                    type = "updatePlant",
                                    info = info
                                }
                            )
                        end,
                        nPlant
                    )
                end
            else
                if shown then
                    CurrentPlant = nil
                    CurrentPlantInfo = nil

                    SendNUIMessage(
                        {
                            type = "hidePlant"
                        }
                    )
                    shown = false
                end
            end

            if nPlant == false then
                Citizen.Wait(1000)
                playerPedId = PlayerPedId()
            else
                Citizen.Wait(1)
            end
        end
    end
)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    local scale = ((1 / dist) * 2) * (1 / GetGameplayCamFov()) * 100

    if onScreen then
        SetTextColour(255, 255, 255, 255)
        SetTextScale(0.0 * scale, 0.45 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextCentre(true)

        SetTextDropshadow(1, 1, 1, 1, 255)

        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(0.55 * scale, 4)
        local width = EndTextCommandGetWidth(4)

        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
    end
end

local GetCurrentResourceName = GetCurrentResourceName()
AddEventHandler("onClientResourceStop", function(resource)
    if (resource == GetCurrentResourceName) then 
        print(resource.." has been stopped, removing entities")
        for key, value in pairs(Dealers) do 
            exports.ox_target:removeLocalEntity(value)
            incubus_lua_delete_entity(value)
        end
        for key, value in pairs(SpawnedPlants) do 
            exports.ox_target:removeEntity(key)
            incubus_lua_delete_entity(value)
        end
    end
end)

AddEventHandler(
    "playerDropped",
    function(reason)
        
    end
)
