local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

local started = true
local displayValue = false
local sBuffer = {}
local vBuffer = {}
local cintoseg = false


Citizen.CreateThread(function()
  local seatbeltIsOn = false
	while true do
    local idle = 2500
    local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),false))

    if started then 
      if IsPauseMenuActive() or menu_celular then
        displayValue = false
      else
        displayValue = true
      end
    end

    if IsPedInAnyVehicle(PlayerPedId()) then
      idle = 250
      inCar = true
			pedcar = GetVehiclePedIsIn(PlayerPedId())
      DisplayRadar(true)
    else
			if on_gps then
			  DisplayRadar(true)
      else
        DisplayRadar(false)
      end
			inCar  = false
      cintoseg = nil
    end
		SendNUIMessage({
      incar = inCar,
      cinto = cintoseg,
		 	display = displayValue
    });
    Citizen.Wait(idle)
	end
end)

IsCar = function(veh)
  local vc = GetVehicleClass(veh)
  return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end

RegisterNetEvent("vrp_hud:belt")
AddEventHandler("vrp_hud:belt",function()
  local ped = PlayerPedId()
  local car = GetVehiclePedIsIn(ped)
  if car ~= 0 and (ExNoCarro or IsCar(car)) then
    TriggerEvent("cancelando",true)
    if cintoseg then
      TriggerEvent("vrp_sound:source",'unbelt',0.5)
      SetTimeout(2000,function()
        cintoseg = false
        TriggerEvent("cancelando",false)
      end)
    else
      TriggerEvent("vrp_sound:source",'belt',0.5)
      SetTimeout(3000,function()
        cintoseg = true
        TriggerEvent("cancelando",false)
      end)
    end
  end
end, false)

Citizen.CreateThread(function()
  while true do
    local idle = 10000
    if inCar then
      idle = 10
      local ped = PlayerPedId()
      local car = GetVehiclePedIsIn(ped)
      if car ~= 0 and (ExNoCarro or IsCar(car)) then
        ExNoCarro = true
        if cintoseg then
          DisableControlAction(0,75)
        end
        sBuffer[2] = sBuffer[1]
        sBuffer[1] = GetEntitySpeed(car)
        if sBuffer[2] ~= nil and not cintoseg and GetEntitySpeedVector(car,true).y > 1.0 and sBuffer[1] > 10.25 and (sBuffer[2] - sBuffer[1]) > (sBuffer[1] * 0.255) then
          local co = GetEntityCoords(ped)
          local fw = Fwv(ped)
          SetEntityHealth(ped,GetEntityHealth(ped)-150)
          SetEntityCoords(ped,co.x+fw.x,co.y+fw.y,co.z-0.47,true,true,true)
          SetEntityVelocity(ped,vBuffer[2].x,vBuffer[2].y,vBuffer[2].z)
          segundos = 20
        end
        vBuffer[2] = vBuffer[1]
        vBuffer[1] = GetEntityVelocity(car)
      elseif ExNoCarro then
        ExNoCarro = false
        cintoseg = false
        sBuffer[1],sBuffer[2] = 0.0,0.0
      end
    end
    Citizen.Wait(idle)
  end
end)

RegisterCommand('hud',function(source, args, rawCommand)
  if started then
    if not menu_celular then
      menu_celular = true
    else
      menu_celular = false
    end
  end
end)