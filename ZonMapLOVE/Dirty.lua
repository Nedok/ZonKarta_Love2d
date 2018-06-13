local print_r = require "print_r"

local Me = { version = "0.0.0" }

function StandardizeTableXY(T)

    if type(T) == "number" then
        return {x = T, y = T}
    else
        return {x = (T.x and T.x) or T[1] or 0, y = (T.y and T.y) or T[2] or 0}
    end
end

function Me.AddXY (T1, T2, T3, T4, T5)
    if T3 then
        T2 = Me.AddXY(T2, T3, T4, T5)
    end

    local Temp1 = StandardizeTableXY(T1)
    local Temp2 = StandardizeTableXY(T2)

    return {x = Temp1.x + Temp2.x, y= Temp1.y + Temp2.y}
end

function Me.SubXY (T1, T2)
    local Temp1 = StandardizeTableXY(T1)
    local Temp2 = StandardizeTableXY(T2)

    return {x = Temp1.x - Temp2.x, y= Temp1.y - Temp2.y}
end

function Me.MultXY (T1, T2, T3, T4, T5)
    if T3 then
        T2 = Me.MultXY(T2, T3, T4, T5)
    end

    local Temp1 = StandardizeTableXY(T1)
    local Temp2 = StandardizeTableXY(T2)

    return {x = Temp1.x * Temp2.x, y= Temp1.y * Temp2.y}
end

function Me.DivXY (T1, T2)
    local Temp1 = StandardizeTableXY(T1)
    local Temp2 = StandardizeTableXY(T2)

    return {x = Temp1.x / Temp2.x, y = Temp1.y / Temp2.y}
end

Me.StandardizeTableXY = StandardizeTableXY

return Me
