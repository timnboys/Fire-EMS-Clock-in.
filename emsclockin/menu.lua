local table = {
    {x=1691.78, y=3585.9, z=34.52}, -- Sandy Shores
    {x=-379.71, y=6118.47, z=30.85}, -- Paleto Bay
    {x=1150.89, y=-1529.93, z=34.37}, -- St Fiancre
    {x=-448.4, y=-340.28, z=33.5}, -- St Fiancre
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k in pairs(table) do
            -- Draw Marker Here --
            DrawMarker(1, table[k].x, table[k].y, table[k].z, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 255, 255, 255, 200, 0, 0, 0, 0)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(table) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, table[k].x, table[k].y, table[k].z)

            if dist <= 3 then
				DrawTxt("~r~Press E to open menu.")
				_menuPool:ProcessMenus()
				if IsControlJustPressed(1,51) then
					mainMenu:Visible(not mainMenu:Visible())
				end
            end
        end
    end
end)

function DrawTxt(text)
  SetTextFont(0)
  SetTextProportional(1)
  SetTextScale(0.0, 0.45)
  SetTextDropshadow(1, 0, 0, 0, 255)
  SetTextEdge(1, 0, 0, 0, 255)

  SetTextDropShadow()
  SetTextOutline()
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(0.174, 0.855)
end
		
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Medical Services.", "Second Life Network", 1320, 0)
_menuPool:Add(mainMenu)
_menuPool:MouseControlsEnabled(false)
_menuPool:ControlDisablingEnabled(false)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function AddMenuVehicle(menu)
    for i = 1, 1, 1 do
    	local Item = NativeUI.CreateItem("Clock in as a Paramedic - Male", "")
    	Item.Activated = function(ParentMenu, SelectedItem)
    		--Do stuff
    		givePara()
			drawNotification(text)
    	end
        menu:AddItem(Item)
    end
	for i = 1, 1, 1 do
    	local Item = NativeUI.CreateItem("Clock in as a Fireman - Male", "")
    	Item.Activated = function(ParentMenu, SelectedItem)
    		--Do stuff
    		giveFire()
			drawNotification(text)
    	end
        menu:AddItem(Item)
    end
end

AddMenuVehicle(mainMenu)
_menuPool:RefreshIndex()

--Functions

function givePara()
			local model = GetHashKey("S_M_M_Paramedic_01")

			RequestModel(model)
			while not HasModelLoaded(model) do
				RequestModel(model)
				Citizen.Wait(0)
			end
		 
			SetPlayerModel(PlayerId(), model)
			SetModelAsNoLongerNeeded(model)
			GiveLoadout()
              
end

function giveFire()
			local model = GetHashKey("s_m_y_fireman_01")

			RequestModel(model)
			while not HasModelLoaded(model) do
				RequestModel(model)
				Citizen.Wait(0)
			end
		 
			SetPlayerModel(PlayerId(), model)
			SetModelAsNoLongerNeeded(model)
			GiveLoadout()
end

local spawnLoadoutList = {  
    {0x34A67B97, 1},    -- Jerry Can
    {0x8BB05FD7, 1},    -- Flashlight
    {0xF9DCBF2D, 1},    -- Nightstick
    {0x060EC506, 9000},    -- Fire Extinguisher
    {0x3656C8C1, 1},    -- Stun Gun
}

-- https://wiki.fivem.net/wiki/Weapon_Components
-- {weaponHashToApplyComponentTo, weaponComponentHash} Any extras/components that need to be attached to certain weapons? Enter them below


function GiveLoadout()
    local ped = GetPlayerPed(-1)
    for k, w in pairs(spawnLoadoutList) do
        GiveWeaponToPed(GetPlayerPed(-1), w[1], w[2], false, false)
		SetEntityHealth(ped, 200)
		ClearPedBloodDamage(ped)
		ClearPedWetness(ped)
		SetPedArmour(ped, 100)
    end
end

function drawNotification(text)
	myname = NetworkPlayerGetName(PlayerId())
	SetNotificationTextEntry("STRING");
	SetNotificationMessage("CHAR_CALL911", "CHAR_CALL911", true, 1, "~r~Welcome Back", myname .. ".");
	DrawNotification(false, false)
end

function drawNotification2(text)
	SetNotificationTextEntry("STRING");
	SetNotificationMessage("CHAR_CALL911", "CHAR_CALL911", true, 1, "~r~Welcome Back", text .. "");
	DrawNotification(false, false)
end

local blips = {
    {x=1691.78, y=3585.9, z=34.52}, -- Sandy Shores
    {x=-379.71, y=6118.47, z=30.85}, -- Paleto Bay
    {x=1150.89, y=-1529.93, z=34.37}, -- St Fiancre
    {x=-448.4, y=-340.28, z=33.5}, -- St Fiancre
  }
      
Citizen.CreateThread(function()
    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, 61)
	  SetBlipAsShortRange(blip, true)
      SetBlipDisplay(info.blip, 2)
      SetBlipScale(info.blip, 1.0)
      SetBlipColour(info.blip, 3)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString("Medical Services")
      EndTextCommandSetBlipName(info.blip)
    end
end)
