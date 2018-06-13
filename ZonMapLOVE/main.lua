-- local flux = require "flux\\flux"
local SideDrawer = require "SideDrawer"
-- local Dirty = require "Dirty"
local MovableMap = require "MovableMap"
local print_r = require "print_r"


ButtonRegistration   = {}
MapZoomLevelTarget   = 1
MapTranslationScroll = {x=0, y=0}
MapTrans             = {x=0, y=0}

-- Configs --
SidbarWidth = 200
ScrollSpeed = {x=20, y=20}




function love.load()

    love.window.setMode(800, 600, {resizable=true, vsync=true, minwidth=SidbarSize, minheight=300})


   -- ZonMapImg = love.graphics.newImage("zon.jpg")
   MovableMap.load("zon.jpg")

   love.graphics.setNewFont(32)
   love.graphics.setColor(255,255,255)
   love.graphics.setBackgroundColor(0,0,0)

   Zoom = 1

end



Scroll = {x = 0, y = 0}
MuseText = ""

function love.update(dt)
--    flux.update(dt)

    MovableMap.update()



    -- if MouseTrack.tracking then
    --     MapTrans = Dirty.AddXY(MapTranslationScroll, MouseTrack.Start, {love.mouse.getPosition()})
    -- else
    --     MapTrans = MapTranslationScroll
    -- end


end

function love.draw()

    --love.graphics.draw(image)

    -- DrawZonImage()
    MovableMap.draw()

    love.graphics.print("Hello World  " .. Scroll.x .. "  " .. Scroll.y, 400, 300)
    love.graphics.print(MuseText, 400, 400)


    -- Sidebar --
    --SideDrawer.Draw({})
    --SidebarDrawer({})

end

function DrawZonImage()
    local TempColor = {love.graphics.getColor()}
    love.graphics.setColor(255,255,255)

    love.graphics.draw(ZonMapImg, MapTrans.x, MapTrans.y, 0, Zoom, Zoom)


    love.graphics.setColor(TempColor)
end



function love.keypressed(key, scancode, isrepeat)
    MuseText = (key.. "  " .. scancode)
end


-- MouseTrack = { tracking = nil }
function love.mousepressed(x, y, button, isTouch)
    MovableMap.mousepressed(x, y, button, isTouch)

    MuseText = ("x: " .. x .. "  y: " .. y .. "  Button: " .. button .. "  IsToutch: " .. tostring(isTouch))

    -- if ( not MouseTrack.tracking ) and ( button == 2 or button == 3 ) then
    --     MouseTrack.tracking = button
    --     MouseTrack.Start    = Dirty.SubXY({0, 0}, {love.mouse.getPosition()})
    -- end
end

function love.mousereleased(x, y, button, isTouch)
    MovableMap.mousereleased(x, y, button, isTouch)

    -- if MouseTrack.tracking and MouseTrack.tracking == button then
    --     StopMouseMovment()
    -- end
end

-- function StopMouseMovment()
--     MouseTrack.tracking = nil
--     MapTranslationScroll = MapTrans
-- end

function love.mousefocus(focus)
    MovableMap.mousefocus(focus)
    -- if not focus and MouseTrack.tracking then
    --     StopMouseMovment()
    -- end

end

function love.wheelmoved( x, y )
    MovableMap.wheelmoved( x, y )

    --
    -- if love.keyboard.isScancodeDown( "lctrl", "rctrl" ) then
    --     -- Change Zoom
    --     Zoom = Zoom+0.1*(math.sign(x) + math.sign(y))
    -- elseif  love.keyboard.isScancodeDown( "lshift", "rshift" ) then
    --     -- Changge scroll mode to enable sidescroll with weel
    --     MapTranslationScroll = Dirty.AddXY(MapTranslationScroll, { x = y, y = -x })
    -- else
    --     MapTranslationScroll = Dirty.AddXY(MapTranslationScroll, { x = -x, y = y })
    -- end
end
