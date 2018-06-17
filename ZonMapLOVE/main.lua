-- local flux = require "flux\\flux"
--local SideDrawer = require "SideDrawer"
local MovableMap = require "MovableMap"
local print_r    = require "print_r"
suit             = require "suit"
Trick            = require "suitTrickery"


--local lovebird = require "lovebird\\lovebird"


-- Configs --
SidbarWidth = 200


SideBar = {xExpansion = 200, Enabled = true}


function love.load()
    --if arg[#arg] == "-debug" then require("mobdebug").start() end

    love.window.setMode(800, 600, {resizable=true, vsync=true, minwidth=SidbarSize, minheight=300})

    MovableMap.load("zon.jpg")

    love.graphics.setNewFont(32)
    love.graphics.setColor(255,255,255)
    love.graphics.setBackgroundColor(0,0,0)

end

MuseText = ""
A ={}



function love.update(dt)
    --lovebird.update()
    --    flux.update(dt)

    MovableMap.update()

    if MovableMap.MouseTrack then
        Trick.SupressInteraction(suit)
    end

    suit.layout:reset(SidbarWidth-SideBar.xExpansion+10,100)

    A = suit.Button("Hello", 200,200,100,100)





    if A.hit then
        print("logging")
    end
    suit.hovered = nil

    --print(suit.anyActive(), suit.anyHovered(), suit.anyHit() )




end

function Disable()
    return false
end

function love.draw()
    MovableMap.draw()

    if SideBar.Enabled then
        love.graphics.setColor(0, 0, 0, 0.9)
        love.graphics.rectangle("fill", 0,0, SideBar.xExpansion, love.graphics.getHeight())
    end


    suit.draw()

    love.graphics.setColor(255,255,255)
    love.graphics.print("Hello World  ", 400, 300)
    love.graphics.print(MuseText, 400, 400)

end

function love.keypressed(key, scancode, isrepeat)
    MuseText = (key.. "  " .. scancode)
end

function love.mousepressed(x, y, button, isTouch)
    --suit.mousepressed
    print(suit.anyActive(), suit.anyHovered(), suit.anyHit() )
    if not (x <= SideBar.xExpansion or suit.anyActive()) then
        MovableMap.mousepressed(x, y, button, isTouch)
    end

    MuseText = ("x: " .. x .. "  y: " .. y .. "  Button: " .. button .. "  IsToutch: " .. tostring(isTouch))
end

function love.mousereleased(x, y, button, isTouch)
    MovableMap.mousereleased(x, y, button, isTouch)
end


function love.mousefocus(focus)
    MovableMap.mousefocus(focus)
end

function love.wheelmoved( x, y )
    if love.mouse.getX() > SideBar.xExpansion then
        MovableMap.wheelmoved( x, y )
    end
end






-- forward keyboard events
function love.textinput(t)
    suit.textinput(t)
end

function love.keypressed(key)
    suit.keypressed(key)
end
