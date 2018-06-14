
local Vector = require "Lua2DVector\\Vector"


function Vector.ConvertSloppy(a)
    if type(a) == "table" then
        local NaN = math.nan
        local Temp = {x = NaN, y = NaN}

        Temp.x = a.x or a.X or a[1] or NaN
        Temp.y = a.y or a.Y or a[2] or NaN

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
    return Vector.new((self.x > 0 and 1 or self.x < 0 and -1 or 0), (self.y > 0 and 1 or self.y < 0 and -1 or 0))
end

return {}
