local menuIsShowed, TextUIdrawing = false, false

function ShowJobListingMenu()
  menuIsShowed = true
  ESX.TriggerServerCallback('esx_joblisting:getJobsList', function(jobs)
    local elements = {{unselectable = "true", title = TranslateCap('job_center'), icon = "fas fa-briefcase"}}

    for i = 1, #(jobs) do
      elements[#elements + 1] = {title = jobs[i].label, name = jobs[i].name}
    end

    ESX.OpenContext("right", elements, function(menu, SelectJob)
      TriggerServerEvent('esx_joblisting:setJob', SelectJob.name)
      ESX.CloseContext()
      lib.notify({
        title = 'Práce',
        description = 'Získal si novou práci',
        type = 'success'
    })
      menuIsShowed = false
      TextUIdrawing = false
    end, function()
      menuIsShowed = false
      TextUIdrawing = false
    end)
  end)
end

-- Activate menu when player is inside marker, and draw markers
CreateThread(function()
  while true do
    local Sleep = 1500
    local coords = GetEntityCoords(ESX.PlayerData.ped)
    local isInMarker = false
    lib.hideTextUI()

    for i = 1, #Config.Zones, 1 do
      local distance = #(coords - Config.Zones[i])

      if distance < Config.DrawDistance then
        Sleep = 0
        lib.showTextUI('[E] - Otevřít menu')
      end

      if distance < (Config.ZoneSize.x / 2) then
        isInMarker = true
        if not TextUIdrawing then
          TextUIdrawing = true
        end
        if IsControlJustReleased(0, 38) and not menuIsShowed then
          ShowJobListingMenu()
          lib.hideTextUI()
        end
      end
    end
  if not isInMarker and TextUIdrawing then
    lib.hideTextUI()
      TextUIdrawing = false
    end
   Wait(Sleep)
  end
end)

-- Blip brasko
local blips = {
  {title = "Urad práce", colour = 64, id = 498, x = -234.65, y = -920.47, z = 4.6101}
}

Citizen.CreateThread(function()
  for _, informationcenter in pairs(blips) do
      informationcenter.blip = AddBlipForCoord(informationcenter.x, informationcenter.y, informationcenter.z)
      SetBlipSprite(informationcenter.blip, informationcenter.id)
      SetBlipDisplay(informationcenter.blip, 4)
      SetBlipScale(informationcenter.blip, 0.7)
      SetBlipColour(informationcenter.blip, informationcenter.colour)
      SetBlipAsShortRange(informationcenter.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(informationcenter.title)
      EndTextCommandSetBlipName(informationcenter.blip)
  end
end)