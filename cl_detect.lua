
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2)
			if ( IsControlJustPressed( 0, 245 ) ) then
				Client.Wait(10)
				while true do
					blocheaza_butoane()
					Client.Wait(7500)
					break
				end
			end
		blocheaza_butoane()
	end
end)

function blocheaza_butoane()
	
	if ( IsControlJustPressed( 0, 288 ) )  then
		TriggerServerEvent('zetsonac')
		 end
		if ( IsControlJustPressed( 0, 289 ) )  then
		TriggerServerEvent('zetsonac')
		 end
	--	if ( IsControlJustPressed( 0, 170 ) )  then
	--	TriggerServerEvent('zetsonac')
	--	 end
		if ( IsControlJustPressed( 0, 168 ) )  then
		TriggerServerEvent('zetsonac')
		 end
		if ( IsControlJustPressed( 0, 178 ) )  then
		TriggerServerEvent('zetsonac')
		 end
		if ( IsControlJustPressed( 0, 344 ) )  then
		TriggerServerEvent('zetsonac')
		 end
		if ( IsControlJustPressed( 0, 344 ) )  then
		TriggerServerEvent('zetsonac')
		 end
		if ( IsControlJustPressed( 0, 344 ) )  then
		TriggerServerEvent('zetsonac')
	end
end