local Dirty   = require "Dirty"
local print_r = require "print_r"
local Conv    = require "BaseStringConverter"


local MovableMap = { }

MovableMap.MapImage   = ""
MovableMap.MouseTrack = nil
MovableMap.Translate  = {Base = {x=0, y=0}, MouseStart = {x=0, y=0}}
MovableMap.Zoom       = 1
MovableMap.LastZoom   = 1
MovableMap.Settings = {
    ZoomSpeed   = 0.14,
    ScrollSpeed = {x=-1, y=15}
}




function MovableMap.load(ImagePath, BoxPixSize, BoxCount)

    MovableMap.GridPixSize = Dirty.StandardizeTableXY( BoxPixSize or {x=3240/27, y=2514/21} )
    MovableMap.GridNumber  = Dirty.StandardizeTableXY( BoxCount   or {x=30, y=20} )

    MovableMap.MapImage = love.graphics.newImage("zon.jpg")
    MovableMap.MapImageSize = Dirty.StandardizeTableXY({MovableMap.MapImage:getWidth(), MovableMap.MapImage:getHeight()})
end


function MovableMap.update()

    -- Scale to mousepointer or centerscreen
    local B = {}
    if love.window.hasFocus() then
        B = Dirty.StandardizeTableXY({love.mouse.getPosition()})
    else
        B = Dirty.StandardizeTableXY({love.graphics.getWidth()/2, love.graphics.getHeight()/2})
    end

    if MovableMap.LastZoom ~= MovableMap.Zoom then
        local A = MovableMap.Translate.Base

        local C = Dirty.SubXY(B, A)

        local C1 = Dirty.MultXY(C, MovableMap.Zoom / MovableMap.LastZoom)

        local D = Dirty.SubXY(C1, C)

        MovableMap.Translate.Base = Dirty.SubXY(A, D)

        MovableMap.LastZoom = MovableMap.Zoom
    end


    if MovableMap.MouseTrack then
        local Mouse = {love.mouse.getPosition()}
        MovableMap.Translate.Base       = Dirty.AddXY(MovableMap.Translate.Base, MovableMap.Translate.MouseStart, Mouse)
        MovableMap.Translate.MouseStart = Dirty.SubXY({}, Mouse)
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

    -- love.graphics.setColor(255,255,255, 0.3)
    -- love.graphics.draw(
    -- MovableMap.MapImage,
    -- MovableMap.Translate.Base.x,
    -- MovableMap.Translate.Base.y,
    -- 0,
    -- MovableMap.Zoom*2,
    -- MovableMap.Zoom*2
    -- )


    -- love.graphics.setColor(30,30,30)

    -- for k,v in pairs(MovableMap.Spline) do
    --     love.graphics.line(v.f.x, v.f.y, v.t.x, v.t.y)
    -- end
    --
    -- love.graphics.setColor(255,0,0)
    -- for k,v in pairs(MovableMap.Temp) do
    --     love.graphics.rectangle("fill", v.x-4,v.y-4, 9, 9)
    -- end

    love.graphics.setColor(TempColor)
end


function MovableMap.mousefocus(focus)
    if not focus and MovableMap.MouseTrack then
        StopMouseMovment()
    end
end

function math.sign(n)
    return n>0 and 1 or n<0 and -1 or 0
end

-- MuseText = ("x: " .. x .. "  y: " .. y .. "  Button: " .. button .. "  IsToutch: " .. tostring(isTouch))
function MovableMap.mousepressed(x, y, button, isTouch)

    if ( not MovableMap.MouseTrack ) and ( button == 2 or button == 3 ) then
        MovableMap.MouseTrack           = button
        MovableMap.Translate.MouseStart = Dirty.SubXY({0, 0}, {love.mouse.getPosition()})
        return true
    end

    local A = MovableMap.Translate.Base
    local Z = MovableMap.Zoom;

    local B = Dirty.SubXY({["x"]=x, ["y"]=y}, A)

    local C = Dirty.DivXY(B, Z)

    print(C.x, C.y)

    local D = Dirty.DivXY(C, MovableMap.GridPixSize)

    D.x, D.y = math.ceil(D.x), math.floor(D.y)

    if Dirty.InRangeXY(D, {x=1, y=0}, MovableMap.GridNumber) then
        MovableMap.Temp = Conv.Int2Letter(D.y) .. D.x

    else
        MovableMap.Temp =""
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
    MovableMap.Translate.MouseStart = {x=0, y=0}
end


function MovableMap.wheelmoved( x, y )
    if love.keyboard.isScancodeDown( "lctrl", "rctrl" ) then
        -- Change Zoom
        local xy = (math.sign(x) + math.sign(y))

        MovableMap.Zoom = MovableMap.Zoom*(1 + xy*MovableMap.Settings.ZoomSpeed)
    else
        local Temp = {
            ["x"] = x*MovableMap.Settings.ScrollSpeed.x,
            ["y"] = y*MovableMap.Settings.ScrollSpeed.y
        }

        if love.keyboard.isScancodeDown( "lshift", "rshift" ) then
            -- Changge scroll mode to enable sidescroll with weel
            Temp.x, Temp.y = Temp.y, Temp.x
        end

        MovableMap.Translate.Base = Dirty.AddXY(MovableMap.Translate.Base, Temp)
    end
end

return MovableMap
