accZet = {}
Tunnel.bindInterface("zetsonac",accZet)
Proxy.addInterface("zetsonac",accZet)
acsZet = Tunnel.getInterface("zetsonac","zetsonac")
Zet = Proxy.getInterface("vRP")



local obiecte = {}

Citizen.CreateThread(function()
    for i,v in pairs(Config.objBl) do
        obiecte[GetHashKey(v)] = {bl = true}
    end
end)


-----------------------------------------------------------------------------SUPERJUMP


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if(IsPedJumping(PlayerPedId())) then
            local lungime = 0

            repeat
                Wait(0)
                lungime=lungime+1
            until not IsPedJumping(PlayerPedId())

            if(lungime > 250) then
                acsZet.detected({"Superjump a fost detectat",true,Config.admgr})
            end
        end
    end
end)
-----------------------------------------------------------------------------SUPERJUMP
-----------------------------------------------------------------------------ANTIEXPLOZIE


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
        count = count + 1
        updateCoords()

        StopFireInRange(x, y, z, 10.0)
        StopEntityFire(ped)

        for _, expl in pairs(Config.availableExplosions) do
            if IsExplosionInSphere(expl, x, y, z, 10.0) then
                -- acsZet.detected({"A fost detectata o explozie",false,Config.admgr})
                dealWithExplosion(ped)
                break
            end
        end
	end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        for theveh in numaravehs() do
            if(iscarbl(GetEntityModel(theveh))) then
                DeleteEntity(theveh)
            end
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

function numaravehs()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end 

-----------------------------------------------------------------------------ANTIEXPLOZIE
-----------------------------------------------------------------------------ANTIWEP

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        for _,arma in pairs(Config.wepBl) do
            if(HasPedGotWeapon(PlayerPedId(),GetHashKey(arma),false)) then
                RemoveAllPedWeapons(PlayerPedId(),false)
                acsZet.detected({"Jucatorul a avut arme interzise",true,Config.admgr})
            end
        end
    end
end)

-----------------------------------------------------------------------------ANTIWEP
-----------------------------------------------------------------------------ANTIKEY
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if (IsDisabledControlPressed(0, 47) and IsDisabledControlPressed(0, 21)) then
            acsZet.detected({"A fost detectat `Ruby Mod Menu`",true,Config.admgr})
            Citizen.Wait(200)
        elseif (IsDisabledControlPressed(0, 117)) then
            acsZet.detected({"A fost detectat `Lynx Evo Menu`",true,Config.admgr})
            Citizen.Wait(200)
        elseif (IsDisabledControlPressed(0, 121)) then
            acsZet.detected({"A fost detectat `Lynx R3 Menu`",true,Config.admgr})
            Citizen.Wait(200)
        elseif (IsDisabledControlPressed(0, 37) and IsDisabledControlPressed(0, 44)) then
            acsZet.detected({"A fost detectat `Lynx R4 Menub`",true,Config.admgr})
            Citizen.Wait(200)
        elseif (IsDisabledControlPressed(0, 214)) then
            acsZet.detected({"A fost detectat `DELETE MENU`",true,Config.admgr})
            Citizen.Wait(200)
        end
    end
end)
-----------------------------------------------------------------------------ANTIKEY
-----------------------------------------------------------------------------ANTIOBJ
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)

        local handle, object = FindFirstObject()
        local finished = false

        while not finished do
            Citizen.Wait(0)

            if (IsEntityAttached(object) and DoesEntityExist(object)) then
                if (GetEntityModel(object) == GetHashKey('prop_acc_guitar_01')) then
                    DeleteObjects(object, true)
                end
            end
            if(obiecte[GetEntityModel(object)]) then  
                DeleteObjects(object, false)
            end
            raf, object = FindNextObject(handle)
            if(object == -1)then break end
        end

        EndFindObject(handle)
    end
end)
-----------------------------------------------------------------------------ANTIOBJ
-----------------------------------------------------------------------------ANTILYNX
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)

        local config = Config or {}
        local blcmds = config.blcmd or {}
        local regcmds = GetRegisteredCommands()

        for _, command in ipairs(regcmds) do
            for _, blcmd in pairs(blcmds) do
                if (string.lower(command.name) == string.lower(blcmd) or
                    string.lower(command.name) == string.lower('+' .. blcmd) or
                    string.lower(command.name) == string.lower('_' .. blcmd) or
                    string.lower(command.name) == string.lower('-' .. blcmd) or
                    string.lower(command.name) == string.lower('/' .. blcmd)) then
                        acsZet.detected({"LYNX CHEAT",true,Config.admgr})
                end
            end
        end

        acsZet.getRegCmd({}, function(cmds)
            for _, command in ipairs(cmds) do
                for _, blcmd in pairs(blcmds) do
                    if (string.lower(command.name) == string.lower(blcmd) or
                        string.lower(command.name) == string.lower('+' .. blcmd) or
                        string.lower(command.name) == string.lower('_' .. blcmd) or
                        string.lower(command.name) == string.lower('-' .. blcmd) or
                        string.lower(command.name) == string.lower('/' .. blcmd)) then
                            acsZet.detected({"LYNX CHEAT",true,Config.admgr})
                    end
                end
            end
        end)
    end
end)
-----------------------------------------------------------------------------ANTILYNX

-----------------------------------------------------------------------------ANTIGODMODE
Citizen.CreateThread(function()
    local detectatdexori = 0

    while true do
        Citizen.Wait(0)
        if (detectatdexori >= 10) then
            acsZet.detected({"GODMODE",true,Config.admgr})
            detectatdexori = 0
        end
        if(Config.godmode) then
            local playerId      = PlayerId()
            local playerPed     = GetPlayerPed(-1)
            local health        = GetEntityHealth(playerPed)

            if (health > 200) then
                acsZet.detected({"GODMODE",true,Config.admgr})
                detectatdexori = 0
            end

            SetPlayerHealthRechargeMultiplier(playerId, 0.0)
            SetEntityHealth(playerPed, health - 2)

            Citizen.Wait(50)

            if (GetEntityHealth(playerPed) > (health - 2)) then
                detectatdexori = detectatdexori + 1
            elseif(detectatdexori > 0) then
                detectatdexori = detectatdexori - 1
            end

            SetEntityHealth(playerPed, GetEntityHealth(playerPed) + 2)
        end
        if(Config.invisibility) then
            if (not IsEntityVisible(playedPed)) then
                acsZet.detected({"Invisibilitate",true,Config.admgr})
            end
        end
    end
end)

-----------------------------------------------------------------------------ANTIGODMODE
-----------------------------------------------------------------------------ANTIINV
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if(Config.invisibility) then
            if (not IsEntityVisible(playedPed)) then
                acsZet.detected({"Invisibilitate",true,Config.admgr})
                Citizen.Wait(1000)
            end
        end
    end
end)
-----------------------------------------------------------------------------ANTIINV


function isobjbl(obj)
   if(obiecte[obj]) then
    return true
   else
    return false
   end
end

function iscarbl(car)
    for i,v in pairs(Config.vehBl) do
        if(car == GetHashKey(v)) then
            return true
        end
    end
    return false
end

function DeleteObjects(object, detach)
    if DoesEntityExist(object) then
        NetworkRequestControlOfEntity(object)
        while not NetworkHasControlOfEntity(object) do
            Citizen.Wait(1)
        end
        if detach then
            DetachEntity(object, 0, false)
        end
        
        SetEntityCollision(object, false, false)
        SetEntityAlpha(object, 0.0, true)
        SetEntityAsMissionEntity(object, true, true)
        SetEntityAsNoLongerNeeded(object)
        DeleteEntity(object)
	end
end

