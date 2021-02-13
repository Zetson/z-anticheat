

local zetsonac = true
RegisterNetEvent("zetsonac:setCheat")
AddEventHandler("zetsonac:setCheat", function(bool) zetsonac = bool end)

local availableExplosions = {
	0, --EXPLOSION_GRENADE
    1, --EXPLOSION_GRENADELAUNCHER
    2, --EXPLOSION_STICKYBOMB 
    --3, --EXPLOSION_MOLOTOV
    4, --EXPLOSION_ROCKET
    5, --EXPLOSION_TANKSHELL
    6, --EXPLOSION_HI_OCTANE
    7, --EXPLOSION_CAR
    8, --EXPLOSION_PLANE
    9, --EXPLOSION_PETROL_PUMP
    10, --EXPLOSION_BIKE
    11, --EXPLOSION_DIR_STEAM
    12, --EXPLOSION_DIR_FLAME
    13, --EXPLOSION_DIR_WATER_HYDRANT
    14, --EXPLOSION_DIR_GAS_CANISTER
    15, --EXPLOSION_BOAT
    16, --EXPLOSION_SHIP_DESTROY
    17, --EXPLOSION_TRUCK
    18, --EXPLOSION_BULLET
    19, --EXPLOSION_SMOKEGRENADELAUNCHER
    20, --EXPLOSION_SMOKEGRENADE
    21, --EXPLOSION_BZGAS
    22, --EXPLOSION_FLARE
    23, --EXPLOSION_GAS_CANISTER
    --24, --EXPLOSION_EXTINGUISHER
    25, --EXPLOSION_PROGRAMMABLEAR
    26, --EXPLOSION_TRAIN
    27, --EXPLOSION_BARREL
    28, --EXPLOSION_PROPANE
    29, --EXPLOSION_BLIMP
    30, --EXPLOSION_DIR_FLAME_EXPLODE
    31, --EXPLOSION_TANKER
    32, --EXPLOSION_PLANE_ROCKET
    33, --EXPLOSION_VEHICLE_BULLET
    34, --EXPLOSION_GAS_TANK
    --35, --EXPLOSION_BIRD_CRAP
}

local function dealWithExplosion(ped)
	repeat
		SetEntityHealth(ped, 200)
		Citizen.Wait(2000)
	until GetEntityHealth(ped) >= 190

	ClearPedWetness(ped)
	ClearPedBloodDamage(ped)

	Citizen.Wait(3000)

	if GetEntityHealth(ped) <= 190 then
		dealWithExplosion(ped)
	else
		sendMsg("Problema remediata cu ^2succes")
	end
end

Citizen.CreateThread(function()
	local x, y, z = table.unpack(GetEntityCoords(ped, true))
	local ped = GetPlayerPed(-1)

	local count = 0

	local function updateCoords()
		if count >= 20 then
			ped = GetPlayerPed(-1)
			x, y, z = table.unpack(GetEntityCoords(ped, true))

			count = 0
		end
	end

	while true do
		Citizen.Wait(100)
		if zetsonac then
			count = count + 1
			updateCoords()

			StopFireInRange(x, y, z, 10.0)
			StopEntityFire(ped)

			for _, expl in pairs(availableExplosions) do
				if IsExplosionInSphere(expl, x, y, z, 10.0) then
					sendMsg("A fost detectata o explozie !")
					dealWithExplosion(ped)
					break
				end
			end
		end
	end
end)

function sendMsg(msg)
	TriggerEvent("chatMessage", "^8Anti-Cheat^7: "..msg)
end




Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        for theveh in EnumerateVehicles() do
            if GetEntityHealth(theveh) == 0 then 
                SetEntityAsMissionEntity(theveh, false, false)
                DeleteEntity(theveh)
            end
        end
    end
end)


local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
      
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
      
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
      
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end 