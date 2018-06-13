flux = require "flux\\flux"

local SideDrawer = { _version = "0.0.0" }

function SideDrawer.Draw(Values)

    local TempColor = {love.graphics.getColor()}
    love.graphics.setColor(0, 0, 0, 0.9)
    love.graphics.rectangle("fill", 0,0, SidbarWidth, love.graphics.getHeight())


    for k,v in pairs(Values) do

    end

    love.graphics.setColor(TempColor)
end











return SideDrawer
