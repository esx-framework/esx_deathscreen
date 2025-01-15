isDead = false
local firstSpawn = true

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
  ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout', function()
  ESX.PlayerLoaded = false
  firstSpawn = true
end)

AddEventHandler('esx:onPlayerSpawn', function()
    if firstSpawn then
      firstSpawn = false
      return
    end
    isDead = false
    ClearTimecycleModifier()
    SetPedMotionBlur(PlayerPedId(), false)
    ClearExtraTimecycleModifier()
    EndDeathCam()
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    OnPlayerDeath()
end)

function DrawGenericTextThisFrame()
  SetTextFont(4)
  SetTextScale(0.0, 0.5)
  SetTextColour(255, 255, 255, 255)
  SetTextDropshadow(0, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(true)
end

function OnPlayerDeath()
    ESX.CloseContext()
    ClearTimecycleModifier()
    SetTimecycleModifier("REDMIST_blend")
    SetTimecycleModifierStrength(0.7)
    SetExtraTimecycleModifier("fp_vig_red")
    SetExtraTimecycleModifierStrength(1.0)
    SetPedMotionBlur(PlayerPedId(), true)
    TriggerServerEvent('esx_ambulancejob:setDeathStatus', true)
    StartDeathTimer()
    StartDeathCam()
    isDead = true
    StartDeathLoop() 
    StartDistressSignal()
end

function StartDeathLoop() 
    CreateThread(function()
        while isDead do
            DisableAllControlActions(0)
            EnableControlAction(0, 47, true) -- G 
            EnableControlAction(0, 245, true) -- T
            EnableControlAction(0, 38, true) -- E
    
            ProcessCamControls() 
            if isSearched then
            local playerPed = PlayerPedId()
            local ped = GetPlayerPed(GetPlayerFromServerId(medic))
            isSearched = false
    
            AttachEntityToEntity(playerPed, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            Wait(1000)
            DetachEntity(playerPed, true, false)
            ClearPedTasksImmediately(playerPed)
            end
            Wait(0)
        end
    end)
end

function StartDistressSignal()
    CreateThread(function()
      local timer = Config.BleedoutTimer
  
      while not isOver do
        Wait(0)
        if IsControlJustReleased(0, 47) then
          SendDistressSignal()
          break
        end
      end
    end)
end
  
function SendDistressSignal()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    ESX.ShowNotification(TranslateCap('distress_sent'))
    TriggerServerEvent('esx_ambulancejob:onPlayerDistress')
end

function secondsToClock(seconds)
  local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

  if seconds <= 0 then
    return 0, 0
  else
    local hours = string.format('%02.f', math.floor(seconds / 3600))
    local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
    local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

    return mins, secs
  end
end
  
function StartDeathTimer()
  local canPayFine = false

  if Config.EarlyRespawnFine then
    ESX.TriggerServerCallback('esx_ambulancejob:checkBalance', function(canPay)
      canPayFine = canPay
    end)
  end

  local earlySpawnTimer = ESX.Math.Round(Config.EarlyRespawnTimer / 1000)
  local bleedoutTimer = ESX.Math.Round(Config.BleedoutTimer / 1000)

  local availableSent = false
  local bleedoutSent = false

  CreateThread(function()
    -- early respawn timer
    while earlySpawnTimer > 0 and isDead do
      Wait(1000)

      if earlySpawnTimer > 0 then
        earlySpawnTimer = earlySpawnTimer - 1
      end
    end

    -- bleedout timer
    while bleedoutTimer > 0 and isDead do
      Wait(1000)

      if bleedoutTimer > 0 then
        bleedoutTimer = bleedoutTimer - 1
      end
    end
  end)
  
  CreateThread(function()
    local text, timeHeld

    -- early respawn timer
    while earlySpawnTimer > 0 and isDead do
      Wait(0)
      text = TranslateCap('respawn_available_in', secondsToClock(earlySpawnTimer))

      if not availableSent then
        SendNUIMessage({type = 'showMessageAvailable'})
        availableSent = true
      end

      if Config.Interface == 'legacy' then
        DrawGenericTextThisFrame()
        BeginTextCommandDisplayText('STRING')
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(0.5, 0.8)
      else
        SendNUIMessage({type='updateAvailableTime', availableMessage = text})
      end
    end

    if earlySpawnTimer < 1 and isDead and Config.Interface ~= 'legacy' then
      SendNUIMessage({type = 'closeAvailable'})
    end

    -- bleedout timer
    while bleedoutTimer > 0 and isDead do
      Wait(0)
      text = TranslateCap('respawn_bleedout_in', secondsToClock(bleedoutTimer))

      if not Config.EarlyRespawnFine then
        text = text .. TranslateCap('respawn_bleedout_prompt')

        if IsControlPressed(0, 38) and timeHeld > 120 then
          TriggerEvent('esx_ambulancejob:RemoveItemsAfterRPDeath')
          break
        end
      elseif Config.EarlyRespawnFine and canPayFine then
        text = text .. TranslateCap('respawn_bleedout_fine', ESX.Math.GroupDigits(Config.EarlyRespawnFineAmount))

        if IsControlPressed(0, 38) and timeHeld > 120 then
          TriggerServerEvent('esx_ambulancejob:payFine')
          TriggerEvent('esx_ambulancejob:RemoveItemsAfterRPDeath')
          break
        end
      end

      if IsControlPressed(0, 38) then
        timeHeld += 1
      else
        timeHeld = 0
      end

      if not bleedoutSent then
        SendNUIMessage({type = 'showMessageBleedout'})
        bleedoutSent = true
      end

      if Config.Interface == 'legacy' then
        DrawGenericTextThisFrame()
        BeginTextCommandDisplayText('STRING')
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(0.5, 0.8)
      else
        SendNUIMessage({type='updateBleedoutTime', bleedoutMessage = text})
      end
    end

    if bleedoutTimer < 1 and isDead and Config.Interface ~= 'legacy' then
      SendNUIMessage({type = 'closeBleedout'})
    end

    if bleedoutTimer < 1 and isDead then
      TriggerEvent('esx_ambulancejob:RemoveItemsAfterRPDeath')
    end
  end)
end