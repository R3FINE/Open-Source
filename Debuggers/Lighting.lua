local lighting = game:GetService'Lighting'

local GLOBAL_PRO = { "Brightness", "Ambient", "OutdoorAmbient", "ColorShift_Bottom", "ColorShift_Top", "FogColor", "FogEnd", "FogStart", "GeographicLatitude", "TimeOfDay", "ExposureCompensation", "ShadowSoftness", "EnvironmentDiffuseScale", "EnvironmentSpecularScale" }
local PPE_PRO = { BlurEffect = { "Size" }, BloomEffect = { "Intensity", "Size", "Threshold" }, ColorCorrectionEffect = { "Brightness", "Contrast", "Saturation", "TintColor" }, DepthOfFieldEffect = { "FarIntensity", "NearIntensity", "FocusDistance", "InFocusRadius" }, SunRaysEffect = { "Intensity", "Spread" }, Atmosphere = { "Density", "Offset", "Color", "Glare", "Haze" }, Sky = { "CelestialBodiesShown", "StarCount", "SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp" } }

local function Convert(color) return math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255) end
local function Log(message) print("[Lighting Update] " .. message) end
local function Monitor(instance) local TYPE_INSTANCE = instance.ClassName local TYPE_EFFECT = PPE_PRO[TYPE_INSTANCE]
if not TYPE_EFFECT then return end
for _, TYPE_PROPERTY in ipairs(TYPE_EFFECT) do
    if not instance[TYPE_PROPERTY] then continue end
    local PREV_VALUE = instance[TYPE_PROPERTY]
    if instance:GetPropertyChangedSignal(TYPE_PROPERTY) then
        instance:GetPropertyChangedSignal(TYPE_PROPERTY):Connect(function()
            local NEW_VALUE = instance[TYPE_PROPERTY]
            if typeof(PREV_VALUE) == "Color3" and typeof(NEW_VALUE) == "Color3" then
                local RED_1, GREEN_1, BLUE_1 = Convert(PREV_VALUE)
                local RED_2, GREEN_2, BLUE_2 = Convert(NEW_VALUE)
                Log(string.format(
                    "Property Changed: %s changed from %s | %d,%d,%d > %d,%d,%d",
                    TYPE_PROPERTY, instance:GetFullName(), RED_1, GREEN_1, BLUE_1, RED_2, GREEN_2, BLUE_2
                ))
            else
                Log(string.format(
                    "Property Changed: %s changed from %s | %s > %s",
                    TYPE_PROPERTY, instance:GetFullName(), tostring(PREV_VALUE), tostring(NEW_VALUE)
                ))
            end
            PREV_VALUE = NEW_VALUE
        end)
    end
end
end

for _, TYPE_PROPERTY in ipairs(GLOBAL_PRO) do if not lighting[TYPE_PROPERTY] then continue end
local PREV_VALUE = lighting[TYPE_PROPERTY]
if lighting:GetPropertyChangedSignal(TYPE_PROPERTY) then
    lighting:GetPropertyChangedSignal(TYPE_PROPERTY):Connect(function()
        local NEW_VALUE = lighting[TYPE_PROPERTY]
        if typeof(PREV_VALUE) == "Color3" and typeof(NEW_VALUE) == "Color3" then
            local RED_1, GREEN_1, BLUE_1 = Convert(PREV_VALUE)
            local RED_2, GREEN_2, BLUE_2 = Convert(NEW_VALUE)
            Log(string.format(
                "Lighting Property Changed: %s | %d,%d,%d > %d,%d,%d",
                TYPE_PROPERTY, RED_1, GREEN_1, BLUE_1, RED_2, GREEN_2, BLUE_2
            ))
        else
            Log(string.format(
                "Lighting Property Changed: %s | %s > %s",
                TYPE_PROPERTY, tostring(PREV_VALUE), tostring(NEW_VALUE)
            ))
        end
        PREV_VALUE = NEW_VALUE
    end)
end
end

lighting.ChildAdded:Connect(function(child) Log("New Instance: " .. child:GetFullName()) Monitor(child) end)
for _, child in pairs(lighting:GetChildren()) do Monitor(child) end

Log("Init")
