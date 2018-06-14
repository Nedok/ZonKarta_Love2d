
local print_r = require "print_r"
local Conv    = require "BaseStringConverter"

local Vector = require "Lua2DVector\\Vector"
local _ = require "VectorAddons"
local _ = require "mathAddons"


local MovableMap = { }

MovableMap_Debugg = MovableMap

MovableMap.MapImage   = ""
MovableMap.MouseTrack = nil
MovableMap.Translate  = {Base = Vector(0, 0), MouseStart = Vector(0, 0)}
MovableMap.Zoom       = 1
MovableMap.LastZoom   = 1
MovableMap.Settings = {
    ZoomSpeed   = 0.14,
    ScrollSpeed = Vector(-1, 15)
}


function MovableMap.load(ImagePath, BoxPixSize, BoxCount)
    MovableMap.GridPixSize = Vector.ConvertSloppy( BoxPixSize or {x=3240/27, y=2514/21} )
    MovableMap.GridNumber  = Vector.ConvertSloppy( BoxCount   or {x=30, y=20} )

    MovableMap.MapImage = love.graphics.newImage(ImagePath or "zon.jpg")
    --MovableMap.MapImageSize = Vector(MovableMap.MapImage:getDimensions())
end


function MovableMap.update()

    -- Scale to mousepointer or centerscreen

    if MovableMap.LastZoom ~= MovableMap.Zoom then
        local A = MovableMap.Translate.Base
        local B = nil
        local z = MovableMap.Zoom / MovableMap.LastZoom

        if love.window.hasFocus() then
            B = Vector(love.mouse.getPosition())
        else
            B = Vector(love.graphics.getDimensions()) / 2
        end

        MovableMap.Translate.Base = B - (B - A)*z

        MovableMap.LastZoom = MovableMap.Zoom
    end


    if MovableMap.MouseTrack then
        local M = Vector(love.mouse.getPosition())
        local T = MovableMap.Translate

        T.Base = T.Base - T.MouseStart + M
        T.MouseStart = M
    end

    -- print(love.timer.getFPS( ))
end

MovableMap.Temp = ""
function MovableMap.draw()
    local TempColor = {love.graphics.getColor()}
    love.graphics.setColor(255,255,255)

    love.graphics.draw(
        MovableMap.MapImage,
        MovableMap.Translate.Base.x,
        MovableMap.Translate.Base.y,
        0,
        MovableMap.Zoom,
        MovableMap.Zoom
    )

    love.graphics.print("Spot: " .. MovableMap.Temp , 100, 100)

    love.graphics.setColor(TempColor)
end


function MovableMap.mousefocus(focus)
    if not focus and MovableMap.MouseTrack then
        StopMouseMovment()
    end
end

function MovableMap.mousepressed(x, y, button, isTouch)

    local M = MovableMap
    local T = MovableMap.Translate

    if ( not M.MouseTrack ) and ( button == 2 or button == 3 ) then
        M.MouseTrack = button
        T.MouseStart = Vector(love.mouse.getPosition())
        return true
    end

    --TODO: Clean this when a feedback function exists for cordinates

    local A = T.Base
    local Z = M.Zoom;

    local B = (Vector(x, y) - A) / Z


    print(B.x, B.y)


    local D = (B / M.GridPixSize):floor()
    D.x = D.x +1
    --D.x, D.y = math.floor(D.x) + 1, math.floor(D.y)

    if D >= Vector(1, 0) and D <= M.GridNumber then
        M.Temp = Conv.Int2Letter(D.y) .. D.x
    else
        M.Temp = ""
    end


    print(D.x, Conv.Int2Letter(D.y), D.y)


    return false
end

function MovableMap.mousereleased(x, y, button, isTouch)

    if MovableMap.MouseTrack and MovableMap.MouseTrack == button then
        StopMouseMovment()
    end
end

function StopMouseMovment()
    MovableMap.MouseTrack = nil
    MovableMap.Translate.MouseStart = Vector(0, 0)
end


function MovableMap.wheelmoved( x, y )
    local C = MovableMap.Settings

    if love.keyboard.isScancodeDown( "lctrl", "rctrl" ) then
        -- Change Zoom

        MovableMap.Zoom = MovableMap.Zoom*(1 + math.sign(x + y)*C.ZoomSpeed)
    else

        --local Temp = Vector(math.sign(x), math.sign(y)) * C.ScrollSpeed
        local Temp = Vector(x, y):sign() * C.ScrollSpeed

        if love.keyboard.isScancodeDown( "lshift", "rshift" ) then
            -- Changge scroll mode to enable sidescroll with weel
            Temp.x, Temp.y = Temp.y, Temp.x
        end

        MovableMap.Translate.Base = MovableMap.Translate.Base + Temp
    end
end

return MovableMap
