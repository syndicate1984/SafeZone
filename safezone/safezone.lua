
local zones = { -- there u can set safezones

	{ ['x'] = 418.28396606445, ['y'] = -980.11309814453, ['z'] = 29.425748825073},
	{ ['x'] = -1037.5372314453, ['y'] = -2737.2749023438, ['z'] = 20.169275283813 },
	{ ['x'] = -111.8458404541, ['y'] = -606.17639160156, ['z'] = 36.280754089355 },
	{ ['x'] = -2195.1352539063, ['y'] = 4288.7290039063, ['z'] = 49.173923492432 }
}


Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		local playerPed = GetPlayerPed(-1)
		local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
		local minDistance = 100000
		for i = 1, #zones, 1 do
			dist = Vdist(zones[i].x, zones[i].y, zones[i].z, x, y, z)
			if dist < minDistance then
				minDistance = dist
				closestZone = i
			end
		end
		Citizen.Wait(15000)
	end
end)


Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
	
		Citizen.Wait(0)
	end
	
	while true do
		Citizen.Wait(0)
		local player = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(player, true))
		local veh = GetVehiclePedIsUsing(ped)
		local dist = Vdist(zones[closestZone].x, zones[closestZone].y, zones[closestZone].z, x, y, z)
		     
	
		if dist <= 50.0 then  
			if not notifIn then					
				SetPlayerInvincible(GetPlayerIndex(),true)
				SetEntityCollision(veh,false,false)
				SetEntityInvincible(veh,true)
				SetVehicleDoorsLocked(veh,4)
				DrawTxt(1.160, 0.500, 1.0,1.0,0.55,"~b~You are in:~g~~h~SafeZone", 255,255,255,255)

			end
		else
			if not notifOut then
				NetworkSetFriendlyFireOption(true)

			end
		end
		if notifIn then
		DisableControlAction(2, 37, false) -- disable weapon wheel (Tab)
		DisablePlayerFiring(player,false) -- Disables firing all together if they somehow bypass inzone Mouse Disable
      	DisableControlAction(0, 106, false) -- Disable in-game mouse controls
			if IsDisabledControlJustPressed(2, 37) then --if Tab is pressed, send error message
				SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),false) -- if tab is pressed it will set them to unarmed (this is to cover the vehicle glitch until I sort that all out)

			end
			if IsDisabledControlJustPressed(0, 106) then --if LeftClick is pressed, send error message
				SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),false) -- If they click it will set them to unarmed

			end
		end
		-- Comment out lines 142 - 145 if you dont want a marker.
	 	if DoesEntityExist(player) then	      --The -1.0001 will place it on the ground flush		-- SIZING CIRCLE |  x    y    z | R   G    B   alpha| *more alpha more transparent*
	 		
	 		--DrawMarker(type, float posX, float posY, float posZ, float dirX, float dirY, float dirZ, float rotX, float rotY, float rotZ, float scaleX, float scaleY, float scaleZ, int red, int green, int blue, int alpha, BOOL bobUpAndDown, BOOL faceCamera, int p19(LEAVE AS 2), BOOL rotate, char* textureDict, char* textureName, BOOL drawOnEnts)
	 	end
	end
end)





function DrawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(6)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end