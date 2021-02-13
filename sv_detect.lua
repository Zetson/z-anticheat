local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","detect")


RegisterServerEvent('zetsonac')
AddEventHandler('zetsonac', function()
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	local name = GetPlayerName(source)
			TriggerClientEvent('chatMessage', -1, '^9[Cyrex]', {255, 0, 0}, "^1" ..name.. "[" ..user_id.. "] ^1ESTE SUSPECT!" )
			TriggerClientEvent('chatMessage', -1, '^9[Cyrex]', {255, 0, 0}, "^1" ..name.. "[" ..user_id.. "] ^1ESTE SUSPECT!" )
			DropPlayer(source, "[Cyrex] Ai fost banuit cu hack , data viitoare te rugam sa joci cinstit")
end)
