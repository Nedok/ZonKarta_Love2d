-- local flux = require "flux\\flux"
local SideDrawer = require "SideDrawer"
local MovableMap = require "MovableMap"
local print_r    = require "print_r"

local lovebird = require "lovebird\\lovebird"


ButtonRegistration   = {}
MapZoomLevelTarget   = 1
MapTranslationScroll = {x=0, y=0}
MapTrans             = {x=0, y=0}

-- Configs --
SidbarWidth = 200

function love.load()

    love.window.setMode(800, 600, {resizable=true, vsync=true, minwidth=SidbarSize, minheight=300})

    MovableMap.load("zon.jpg")

    love.graphics.setNewFont(32)
    love.graphics.setColor(255,255,255)
    love.graphics.setBackgroundColor(0,0,0)

    Zoom = 1

end

MuseText = ""

function love.update(dt)
    lovebird.update()
    --    flux.update(dt)

    MovableMap.update()


end

function love.draw()

    --love.graphics.draw(image)

    MovableMap.draw()

    love.graphics.print("Hello World  ", 400, 300)
    love.graphics.print(MuseText, 400, 400)


    -- Sidebar --
    --SideDrawer.Draw({})
    --SidebarDrawer({})

end

function love.keypressed(key, scancode, isrepeat)
    MuseText = (key.. "  " .. scancode)
end

function love.mousepressed(x, y, button, isTouch)
    MovableMap.mousepressed(x, y, button, isTouch)

    MuseText = ("x: " .. x .. "  y: " .. y .. "  Button: " .. button .. "  IsToutch: " .. tostring(isTouch))
end

function love.mousereleased(x, y, button, isTouch)
    MovableMap.mousereleased(x, y, button, isTouch)
end


function love.mousefocus(focus)
    MovableMap.mousefocus(focus)
end

function love.wheelmoved( x, y )
    MovableMap.wheelmoved( x, y )
end
