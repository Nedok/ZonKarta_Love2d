flux = require "flux\\flux"

local SideDrawer = { _version = "0.0.0" }

SideDrawer.Offcet = 0
SideDrawer.Width  = 200

SideDrawer.GUI = {
    ZonCord  = {x=0, y=0},
    ZoneName = "",
    Levels   = {["Röta"] = 0, ["Hot"] = 0},
    Envierment = "",
    Notations = "",
    Notations_SL = "",

}


function SideDrawer.Draw(Values)
    local S = SideDrawer

    if not S.Offce then  return end

    local TempColor = {love.graphics.getColor()}
    love.graphics.setColor(0, 0, 0, 0.9)
    love.graphics.rectangle("fill", S.Offcet, 0, S.Width, love.graphics.getHeight())

    love.graphics.setColor(255, 255, 255)









    love.graphics.setColor(TempColor)
end











return SideDrawer
