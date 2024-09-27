local hudX, hudY = 0.9, 0.9 -- Initial position of the HUD
local isMovingHud = false
local inVehicle = false

-- Function to draw the HUD (Speedometer)
function drawSpeedometer(speed)
    -- Draw the speed on the screen using the vehicle speed
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 255) -- White color
    SetTextEntry("STRING")
    AddTextComponentString(string.format("Speed: %d km/h", math.floor(speed)))
    DrawText(hudX, hudY)
end

-- Main thread to handle HUD movement
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        -- Check if player is in a vehicle
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            inVehicle = true
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local speed = GetEntitySpeed(vehicle) * 3.6 -- Convert m/s to km/h

            -- Draw speedometer HUD
            drawSpeedometer(speed)
        else
            inVehicle = false
        end

        -- Enable mouse controls if moving HUD
        if isMovingHud then
            DisableControlAction(0, 1, true) -- Disable look left-right
            DisableControlAction(0, 2, true) -- Disable look up-down

            -- Get mouse position and update HUD coordinates
            local mouseX, mouseY = GetControlNormal(0, 239), GetControlNormal(0, 240)
            hudX, hudY = mouseX, mouseY

            -- Exit HUD movement when Escape key is pressed
            if IsControlJustPressed(0, 244) then -- 322 is the ESC key
                isMovingHud = false
                print("HUD movement cancelled")
            end
        end
    end
end)

-- Command to enable HUD movement
RegisterCommand("movehud", function()
    if inVehicle then
        isMovingHud = true
        print("You can now move the HUD with your mouse. Press ESC to cancel.")
    else
        print("You must be in a vehicle to move the HUD.")
    end
end, false)