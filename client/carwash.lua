local QBCore = exports['qb-core']:GetCoreObject()

-------------------------------------
----------- Configuration -----------
-------------------------------------

local use3Dtext = false -- set to TRUE to use the built in 3D text function
local use2Dtext = false -- set to TRUE to use qb-core's built in drawtext
local usePoly = Config.CarWash[1].poly and BoxZone and true or false -- this detects polyzones or coords in the config and if polyzone is imported in the manifest, DO NOT TOUCH if you do not know what you are doing 

if not BoxZone then 
    print('You are using polyzones for the car wash script but do not have polyzones included in your fxmanifest.)')
    print('Please use your F8 console and run "stop qb-smallreources", then "refresh", update your fxmanifest, and then in F8 run "start qb-smallresources"')
    print('I will not offer support on this, please upload the correct fxmanifest or check the polyzone documentation on how to include it in your manifest')
end

if usePoly and not exports['qb-core'].DrawText then
    print('You are attemtping to use the qb-core DrawText function but it does not exist.')
    print('It seems you have updated qb-smallresources but are using an outdated build of qb-core')
    print('3D text will be used instead, I will not offer support on upgrading')
end

---------------------------------
----------- Variables -----------
---------------------------------

local curselection = false
local washingVehicle = false
local ped, pos, veh = nil
local listen = false
local washPoly = {}
local curtxt = nil
local curcoords = nil

---------------------------------
----------- Functions -----------
---------------------------------

local function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end


function WashLoop()
    CreateThread(function()
        while listen do
            local PlayerPed = PlayerPedId()
            local PedVehicle = GetVehiclePedIsIn(PlayerPed, false)
            local Driver = GetPedInVehicleSeat(PedVehicle, -1)

            if not washingVehicle then
                if curtxt then DrawText3Ds(curcoords.x, curcoords.y, curcoords.z, curtxt) end

                if IsControlJustReleased(0, 38) then
                    if Driver == PlayerPed then
                        TriggerEvent('qb-carwash:client:CarWashMenu')
                        listen = false
                        break
                    else
                        QBCore.Functions.Notify("This is a car wash not a shower, friend...", "error")
                    end
                end
            end
            Wait(0)
        end
    end)
end

----------------------------------------------
----------- Network Event Handlers -----------
----------------------------------------------

RegisterNetEvent('qb-carwash:client:CarWashMenu', function()
    exports['qb-menu']:openMenu({
        {
            header = "Car Wash Options",
            isMenuHeader = true
        },
        {
            header = "Vehicle Cleaning",
            txt = "Get a wash and wax!",
            params = {
                event = "qb-carwash:client:setselection",
                args = {
                    selection = 'exterior',
                }
            }
        },
        {
            header = "Vehicle Detailing",
            txt = "Get a suck and buff!",
            params = {
                event = "qb-carwash:client:setselection",
                args = {
                    selection = 'interior',
                }
            }
        },
        {
            header = "Close (ESC)",
            params = {
                event = exports['qb-menu']:closeMenu(),
            }
        },
    })
end)

RegisterNetEvent('qb-carwash:client:setselection', function(data)
    curselection = data.selection
    TriggerServerEvent('qb-carwash:server:washCar')
end)


RegisterNetEvent('qb-carwash:client:washCar', function()
    washingVehicle = true

    local progtext = 'Keepin\' those machines humming...'
    local progtime = math.random(4000, 8000)

    if curselection == 'interior' then
        progtext = 'Vacuuming out bugershot wrappers...'
        progtime = math.random(12000, 20000)
    end

    QBCore.Functions.Progressbar("search_cabin", progtext, progtime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        if curselection == 'exterior' then
            SetVehicleDirtLevel(veh)
            SetVehicleUndriveable(veh, false)
            WashDecalsFromVehicle(veh, 1.0)
        elseif curselection == 'interior' then 
            local plate = QBCore.Functions.GetPlate(veh) 
            TriggerServerEvent('evidence:server:RemoveCarEvidence', plate) 
        end
        QBCore.Functions.Notify("Car's clean! You're good to go!", "success")
        washingVehicle = false
    end, function() -- Cancel
        QBCore.Functions.Notify("Washing canceled ..", "error")
        washingVehicle = false
    end)
end)

CreateThread(function()
	while true do
        if LocalPlayer.state.isLoggedIn then
	        ped = PlayerPedId()   
            veh = GetVehiclePedIsIn(ped)
        end
        Wait(1000)
	end
end)

-------------------------------
----------- Threads -----------
-------------------------------

if usePoly then -- uses new refactored qb-smallresources carwash code to support polyzones
    CreateThread(function()
        for k,v in pairs(Config.CarWash) do
            if Config.UseTarget then
                exports["qb-target"]:AddBoxZone('carwash_'..k, v['poly'].coords, v['poly'].length, v['poly'].width, {
                    name = 'carwash_'..k,
                    debugPoly = false,
                    heading = v['poly'].heading,
                    minZ = v['poly'].coords.z - 5,
                    maxZ = v['poly'].coords.z + 5,
                }, {
                        options = {
                            {
                                action = function()
                                    local PlayerPed = PlayerPedId()
                                    local PedVehicle = GetVehiclePedIsIn(PlayerPed, false)
                                    local Driver = GetPedInVehicleSeat(PedVehicle, -1)
                                    local dirtLevel = GetVehicleDirtLevel(PedVehicle)
                                    if Driver == PlayerPed and not washingVehicle then
                                        TriggerEvent('qb-carwash:client:CarWashMenu')
                                    end
                                end,
                                icon = "fa-car-wash",
                                label = Lang and Lang:t('wash.wash_vehicle_target') or 'Wash Vehicle',
                            }
                        },
                    distance = 3
                })
            else
                washPoly[#washPoly+1] = BoxZone:Create(vector3(v['poly'].coords.x, v['poly'].coords.y, v['poly'].coords.z), v['poly'].length, v['poly'].width, {
                    heading = v['poly'].heading,
                    name = 'carwash',
                    debugPoly = false,
                    minZ = v['poly'].coords.z - 5,
                    maxZ = v['poly'].coords.z + 5,
                })
                local washCombo = ComboZone:Create(washPoly, {name = "washPoly"})
                washCombo:onPlayerInOut(function(isPointInside)
                    if isPointInside then
                        local displayText = Lang and Lang:t('wash.wash_vehicle') or '[E] - Wash Vehicle'
                        if not use3Dtext and (usePoly or use2Dtext) then exports['qb-core']:DrawText(displayText, 'left') else curtxt = displayText curcoords = v.poly.coords end
                        if not listen then
                            listen = true
                            WashLoop(vector3(v['poly'].coords.x, v['poly'].coords.y, v['poly'].coords.z))
                        end
                    else
                        listen = false
                        if not use3Dtext and (usePoly or use2Dtext) then exports['qb-core']:HideText() else curtxt = false end
                    end
                end)
            end
        end
    end)
else -- creates thread running older distance check/coords
    CreateThread(function()
        while true do
            local inRange = false

            if IsPedInAnyVehicle(ped) then
                pos = GetEntityCoords(ped)
                for k, v in pairs(Config.CarWash) do
                    local coords = Config.CarWash[k].poly and Config.CarWash[k].poly.coords or Config.CarWash[k].coords
                    local dist = #(pos - vector3(coords.x, coords.y, coords.z))
                    if dist <= 10 then
                        inRange = true
                        if dist <= 7.5 then
                            if GetPedInVehicleSeat(veh, -1) == ped then
                                if not washingVehicle then
                                    DrawText3Ds(coords.x, coords.y, coords.z, ('E - Use Carwash ($%s)'):format(Config.DefaultPrice))
                                    if IsControlJustReleased(0, 38) then
                                        TriggerEvent('qb-carwash:client:CarWashMenu')
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if not inRange then
                Wait(5000)
            end
            Wait(0)
        end
    end)
end

CreateThread(function()
    for k in pairs(Config.CarWash) do
        local coords = Config.CarWash[k].poly and Config.CarWash[k].poly.coords or Config.CarWash[k].coords
        local carWash = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite (carWash, 100)
        SetBlipDisplay(carWash, 4)
        SetBlipScale  (carWash, 0.75)
        SetBlipAsShortRange(carWash, true)
        SetBlipColour(carWash, 37)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.CarWash[k]["label"])
        EndTextCommandSetBlipName(carWash)
    end
end)
