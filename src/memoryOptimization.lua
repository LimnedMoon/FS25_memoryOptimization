-- ===========================================================================
-- memoryOptimization.lua
--
-- Autor: LimnedMoonlight
-- Version: 1.0.0.5
-- ===========================================================================
-- Changelog:
--   1.0.0.0 - Initial Release
--   1.0.0.5 - changed Intervalls to 3 / 12 Minutes
-- ===========================================================================

memoryOptimization = {}

local timer = 0
local MEDIUM_INTERVAL = 180000 -- 3 Minutes in Milliseconds
local FULL_INTERVAL = 720000   -- 12 Minutes in Milliseconds
local nextMedium = MEDIUM_INTERVAL 
local dbg = true

function memoryOptimization:update(dt)
    timer = timer + dt

    if timer >= FULL_INTERVAL then
        local ramBefore = collectgarbage("count")
        
        -- Double Cleanup
        collectgarbage("collect")
        collectgarbage("collect") 
        
        local ramAfter = collectgarbage("count")
        local cleaned = ramBefore - ramAfter
        
        if dbg then Logging.warning(string.format("[FS25_memoryOptimization] Thorough 12-minute cleanup: %.2f KB freed | Current available memory: %.2f KB", cleaned, ramAfter)) end
        
        timer = 0
        nextMedium = MEDIUM_INTERVAL -- Reset for 3-Minute interim

    -- 3-Minute Routine
    elseif timer >= nextMedium then
        local ramBefore = collectgarbage("count")
        
        collectgarbage("collect")
        
        local ramAfter = collectgarbage("count")
        local cleaned = ramBefore - ramAfter
        
        if dbg then print(string.format("[FS25_memoryOptimization] 3-minute interim cleanup: %.2f KB freed | Current available memory: %.2f KB", cleaned, ramAfter)) end
        nextMedium = nextMedium + MEDIUM_INTERVAL -- Schwellenwert um 3 Min erhöhen
    end
end

function memoryOptimization:loadMap(name)
    Logging.warning("[FS25_memoryOptimization] Mod aktiv - Intervalle: 3 Min / 12 Min")
    timer = 0
    nextMedium = MEDIUM_INTERVAL
end

addModEventListener(memoryOptimization)
