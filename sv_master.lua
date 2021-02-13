local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

Zet = Proxy.getInterface("vRP")
cAlex = Tunnel.getInterface("vRP","zetsonac")

disAlex = Proxy.getInterface("alex_discord")

accZet = Tunnel.getInterface("zetsonac","zetsonac")

acsZet = {}
Tunnel.bindInterface("zetsonac",acsZet)
Proxy.addInterface("zetsonac",acsZet)

-- local data = [[
--     ALTER TABLE vrp_users ADD IF NOT EXISTS hwarns INTEGER DEFAULT 0;
-- ]]

-- MySQL.ready(function ()
--     MySQL.Async.execute(data,{}, function(data)end)
-- end)

local hwarns = {}

function acsZet.detected(msg,kicks,admlist)
    disAlex.addmsg({"anticheat","35839","ANTICHEAT",msg.."\n**User id : "..Zet.getUserId({source}).."**"})
end

function acsZet.isUserAdmin(user_id,lista)
    for i,v in pairs(lista) do
        if(Zet.hasGroup({user_id,v})) then
            return true
        end
    end
    return false
end

function acsZet.getRegCmd()
    return GetRegisteredCommands()
end