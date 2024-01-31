-- @description   Send Wwise triggers from Reaper to Wwise
-- @author        Michael Gary Dean <contact@michaelgarydean.com>
-- @see           https://michaelgarydean.itch.io/

-- Replace "YourWwiseTriggerEventName" with the actual Wwise Trigger Event name
local wwiseTriggerEvent = "YourWwiseTriggerEventName"
local lastPlayheadPosition = reaper.GetPlayPosition()

function SendWwiseTriggerFromMarker(markerIndex)
    local _, _, position, _, _, _, _, isRegion, _ = reaper.EnumProjectMarkers(markerIndex)

    -- Check if the playhead has passed the marker since the last check
    if reaper.GetPlayPosition() >= position and lastPlayheadPosition <= position then
        reaper.ShowConsoleMsg("Sending Wwise trigger from marker index: " .. markerIndex .. "\n")

        -- Replace the following line with the code to send a trigger to Wwise
        -- You may need to use Wwise API calls or integration scripts
        -- Example: wwise.SendTrigger(wwiseTriggerEvent)

        -- Print a message to the Reaper console for testing
        reaper.ShowConsoleMsg("Wwise trigger sent for marker index: " .. markerIndex .. "\n")
    end
end

function CheckMarkersOnPlayheadMove()
    local playheadPosition = reaper.GetPlayPosition()

    if playheadPosition ~= lastPlayheadPosition then
        local numMarkers = reaper.CountProjectMarkers(0)
        
        for i = 0, numMarkers - 1 do
            local _, _, _, _, _, _, _, isRegion, _ = reaper.EnumProjectMarkers(i)
            if not isRegion then
                -- Process only regular markers (not regions)
                SendWwiseTriggerFromMarker(i)
            end
        end

        lastPlayheadPosition = playheadPosition
    end

    reaper.defer(CheckMarkersOnPlayheadMove)
end

-- Run the script
CheckMarkersOnPlayheadMove()

