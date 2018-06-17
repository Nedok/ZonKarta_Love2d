--[[
A small packaet to trick SUIT (GUI packat) to not interact with mouse button

This is a hack and there probely exist a better solution for this.
]]



suitTrick = {}

function suitTrick.SupressInteraction(suit)
    suit._instance.mouse_x=-math.huge
    suit._instance.mouse_y=-math.huge
end


return suitTrick
