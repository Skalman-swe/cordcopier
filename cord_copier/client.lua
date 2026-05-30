local viewerEnabled = false
local currentEntity
local lastCoords
local lastHeading = 0.0


local function Notify(description)
    lib.notify({
        title = 'Cord Copier',
        description = description,
        type = 'success'
    })
end

local function Copy(text)
    lib.setClipboard(text)
    Notify('Copied to clipboard')
end


local function FormatVec3(v)
    return ('vec3(%.2f, %.2f, %.2f)'):format(v.x, v.y, v.z)
end

local function FormatVec4(v, h)
    return ('vec4(%.2f, %.2f, %.2f, %.2f)'):format(v.x, v.y, v.z, h)
end

local function FormatTable(v, h)
    return ('{ x = %.2f, y = %.2f, z = %.2f, h = %.2f }'):format(v.x, v.y, v.z, h)
end

local function FormatJson(v, h)
    return json.encode({ x = v.x, y = v.y, z = v.z, h = h }, { indent = true })
end

local function FormatRawVec3(v)
    return ('%.2f, %.2f, %.2f'):format(v.x, v.y, v.z)
end

local function FormatRawVec4(v, h)
    return ('%.2f, %.2f, %.2f, %.2f'):format(v.x, v.y, v.z, h)
end

local function RaycastFromCamera(dist)
    local camPos = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(2)
    local rotX = math.rad(camRot.x)
    local rotZ = math.rad(camRot.z)
    local cosX = math.abs(math.cos(rotX))
    local sinX = math.sin(rotX)
    local cosZ = math.cos(rotZ)
    local sinZ = math.sin(rotZ)
    local direction = vec3(-sinZ * cosX, cosZ * cosX, sinX)
    local dest = camPos + direction * dist

    local _, hit, endCoords, _, entity = GetShapeTestResult(StartShapeTestRay(
        camPos.x, camPos.y, camPos.z,
        dest.x, dest.y, dest.z,
        -1,
        PlayerPedId(),
        0
    ))

    return hit == 1, endCoords, entity
end

local function DrawTargetBall(coords)
    DrawMarker(
        28,
        coords.x, coords.y, coords.z,
        0.0, 0.0, 0.0, -- Direction (set to 0 for no directional effect)
        0.0, 0.0, 0.0, -- Direction (set to 0 for no directional effect)
        0.10, 0.10, 0.10, -- Size of the marker
        0, 180, 255, 220, -- Color 
        false, false, 1, false, nil, nil, false -- 
    )
end

local menuOptions = {}
local menuContext = {
    id = 'cord_copier_menu',
    title = 'Cord Copier',
    options = menuOptions
}

local function BuildCopyOption(title, description, formatter)
    return {
        title = title,
        description = description,
        onSelect = function()
            Copy(formatter())
        end
    }
end

local function UpdateMenuOptions()
    menuOptions[1] = BuildCopyOption('Copy vec3', FormatVec3(lastCoords), function()
        return FormatVec3(lastCoords)
    end)
    menuOptions[2] = BuildCopyOption('Copy vec4', FormatVec4(lastCoords, lastHeading), function()
        return FormatVec4(lastCoords, lastHeading)
    end)
    menuOptions[3] = BuildCopyOption('Copy table', FormatTable(lastCoords, lastHeading), function()
        return FormatTable(lastCoords, lastHeading)
    end)
    menuOptions[4] = BuildCopyOption('Copy JSON', 'JSON-format', function()
        return FormatJson(lastCoords, lastHeading)
    end)
    menuOptions[5] = BuildCopyOption('Copy RAW vec3(only number)', FormatRawVec3(lastCoords), function()
        return FormatRawVec3(lastCoords)
    end)
    menuOptions[6] = BuildCopyOption('Copy RAW vec4 (Only number)', FormatRawVec4(lastCoords, lastHeading), function()
        return FormatRawVec4(lastCoords, lastHeading)
    end)
    
    menuOptions[7] = {
        title = 'Create ox_target (box)',
        onSelect = function()
            local input = lib.inputDialog('Create ox_target (Test target)', {
                { type = 'input', label = 'Label', required = true }
            })
            if not input then
                return
            end

            exports.ox_target:addBoxZone({
                coords = lastCoords,
                size = vec3(1.0, 1.0, 1.0),
                rotation = lastHeading,
                options = {
                    {
                        label = input[1],
                        icon = 'fa-solid fa-location-dot',
                        onSelect = function()
                            lib.notify({ description = input[1] })
                        end
                    }
                }
            })
        end
    }
    menuOptions[8] = {
        title = 'Close Cord Copier',
        onSelect = function()
            viewerEnabled = false
        end
    }
end

local function OpenMenu()
    if not lastCoords then
        return
    end

    UpdateMenuOptions()
    lib.registerContext(menuContext)
    lib.showContext('cord_copier_menu')
end

CreateThread(function()
    while true do
        if viewerEnabled then
            local hit, coords, entity = RaycastFromCamera(10.0)
            if hit then
                lastCoords = coords
                lastHeading = GetEntityHeading(PlayerPedId())
                currentEntity = entity ~= 0 and entity or nil

                DrawTargetBall(coords)

                if IsControlJustPressed(0, 25) then
                    OpenMenu()
                end
            end

            Wait(0)
        else
            Wait(500)
        end
    end
end)

local function ToggleCord()
    viewerEnabled = not viewerEnabled
    lib.notify({
        title = 'Cord Copier',
        description = viewerEnabled and 'Active' or 'Closed'
    })
end

RegisterCommand('cord', function()
    TriggerServerEvent('cord:checkPerms')
end)

RegisterNetEvent('cord:toggle', function()
    ToggleCord()
end)

RegisterKeyMapping(
    'cord',
    'Toggle Cord Copier',
    'keyboard',
    'F6'
)
