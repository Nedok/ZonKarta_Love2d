local Dirty   = require "Dirty"
local print_r = require "print_r"
local Conv    = require "BaseStringConverter"

local Vector = require "Lua2DVector\\Vector"



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


function Vector.ConvertSloppy(a)
    if type(a) == "table" then
        local NaN = math.nan
        local Temp = {x = NaN, y = NaN}

        Temp.x = a.x or a.X or a.c or a.C or a[1] or NaN
        Temp.y = a.y or a.Y or a.r or a.R or a[2] or NaN

        local Err = (Temp.x == NaN and 1 or 0) + (Temp.y == NaN and 2 or 0)

        if Err == 1  then
            error("I can't convert! Can't find 'x' repressentation. \na = " .. tostring(a) .. "  b = " .. tostring(b))
        elseif Err == 2  then
            error("I can't convert! Can't find 'y' repressentation. \na = " .. tostring(a) .. "  b = " .. tostring(b))
        elseif Err == 3  then
            error("I can't convert! Can't find eather 'x' and 'y' repressentation. \na = " .. tostring(a) .. "  b = " .. tostring(b))
        end

        return Vector.new(Temp.x, Temp.y)
    end

    error("I'm sorry. I don't understand how to convert this. \na = " .. tostring(a) .. "  b = " .. tostring(b))
end

function Vector:sign()
    return Vector.new(math.sign(self.x), math.sign(self.y))
end


function MovableMap.load(ImagePath, BoxPixSize, BoxCount)
    MovableMap.GridPixSize = Vector.ConvertSloppy( BoxPixSize or {x=3240/27, y=2514/21} )
    MovableMap.GridNumber  = Vector.ConvertSloppy( BoxCount   or {x=30, y=20} )

    MovableMap.MapImage = love.graphics.newImage("zon.jpg")
    MovableMap.MapImageSize = Vector(MovableMap.MapImage:getDimensions())
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

        --local Mouse = {love.mouse.getPosition()}
        --MovableMap.Translate.Base       = Dirty.AddXY(MovableMap.Translate.Base, MovableMap.Translate.MouseStart, Mouse)
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

    local M = MovableMap
    local T = MovableMap.Translate

    if ( not M.MouseTrack ) and ( button == 2 or button == 3 ) then
        M.MouseTrack = button
        T.MouseStart = Vector(love.mouse.getPosition())
        return true
    end

    local A = T.Base
    local Z = M.Zoom;

    local B = Vector(x,y) - A
    --local B = Dirty.SubXY({["x"]=x, ["y"]=y}, A)

    --local C = Dirty.DivXY(B, Z)
    local C = B / Z


    print(C.x, C.y)

    --local D = Dirty.DivXY(C, MovableMap.GridPixSize)
    local D = C / M.GridPixSize

    D.x, D.y = math.ceil(D.x), math.floor(D.y)

    if D>= Vector(1,0) and D<= M.GridNumber then
        M.Temp = Conv.Int2Letter(D.y) .. D.x
    else
        M.Temp = ""
    end
    --
    -- if Dirty.InRangeXY(D, {x=1, y=0}, MovableMap.GridNumber) then
    --     MovableMap.Temp = Conv.Int2Letter(D.y) .. D.x
    --
    -- else
    --     MovableMap.Temp =""
    -- end


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

        local Temp = Vector(math.sign(x), math.sign(y)) * C.ScrollSpeed

        if love.keyboard.isScancodeDown( "lshift", "rshift" ) then
            -- Changge scroll mode to enable sidescroll with weel
            Temp.x, Temp.y = Temp.y, Temp.x
        end

        MovableMap.Translate.Base = MovableMap.Translate.Base + Temp
    end
end

return MovableMap
