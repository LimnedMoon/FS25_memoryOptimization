-- ===========================================================================
--
-- memoryOptimization.lua
--
-- Autor: LimnedMoonlight
-- Version: 1.0.0.2
-- ===========================================================================
-- Changelog:
--   1.0.0.0 - Initial Release
--
--   1.0.0.1 - Changed the Prints and comments to en language
--
--   1.0.0.2 - changed to one Intervall every 5 Minutes.
--
-- ===========================================================================

memoryOptimization = {}

local timer = 0
local MEDIUM_INTERVAL = 300000 -- 5 Minutes in Milliseconds
local nextMedium = MEDIUM_INTERVAL
local dbg = true

function memoryOptimization:update(dt)
    timer = timer + dt

    -- Cleaning-Routine
    if timer >= nextMedium then
        local ramBefore = collectgarbage("count")

        collectgarbage("collect")

        local ramAfter = collectgarbage("count")
        local cleaned = ramBefore - ramAfter

        if dbg then print(string.format("[FS25_memoryOptimization] interim cleanup: %.2f KB freed | Current available memory: %.2f KB", cleaned, ramAfter)) end
        nextMedium = nextMedium + MEDIUM_INTERVAL -- Count to next interim
    end
end

function memoryOptimization:loadMap(name)
    if dbg then print("[FS25_memoryOptimization] Mod active - Intervalls: 5 Minutes") end
    timer = 0
    nextMedium = MEDIUM_INTERVAL
end

addModEventListener(memoryOptimization)
