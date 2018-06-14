
local A =  {OutSet = {}}

-- Package to convert dec to other bases. This is ment as a visula thing.
-- It will return a string with the other base as an output

function Convert(Number, ConvertionTable)
    local Str = Number > 0 and "" or ConvertionTable[0]

    while(Number > 0) do
        Str    = ConvertionTable[Number % #ConvertionTable] .. Str
        Number = math.floor(Number / #ConvertionTable)
    end

    return Str
end


A.OutSet.Letters = {
    [0]  = "A", [1]  = "B", [2]  = "C", [3]  = "D",
    [4]  = "E", [5]  = "F", [6]  = "G", [7]  = "H",
    [8]  = "I", [9]  = "J", [10] = "K", [11] = "L",
    [12] = "M", [13] = "N", [14] = "O", [15] = "P",
    [16] = "Q", [17] = "R", [18] = "S", [19] = "T",
    [20] = "U", [21] = "V", [22] = "W", [23] = "X",
    [24] = "Y", [25] = "Z"
}

A.OutSet.Hex = {
    [0]  = "0", [1]  = "1", [2]  = "2", [3]  = "3",
    [4]  = "4", [5]  = "5", [6]  = "6", [7]  = "7",
    [8]  = "8", [9]  = "9", [10] = "A", [11] = "B",
    [12] = "C", [13] = "D", [14] = "E", [15] = "F"
}

A.OutSet.Oct = {
    [0]  = "0", [1]  = "1", [2]  = "2", [3]  = "3",
    [4]  = "4", [5]  = "5", [6]  = "6", [7]  = "7",
    [8]  = "8"
}

A.OutSet.Bin = {
    [0]  = "0", [1]  = "1"
}




function A.Int2Letter(Index)
    return Convert(Index, A.OutSet.Letters)
end

function A.Int2Hex(Index)
    return Convert(Index, A.OutSet.Hex)
end

function A.Int2Oct(Index)
    return Convert(Index, A.OutSet.Oct)
end

function A.Int2Bin(Index)
    return Convert(Index, A.OutSet.Bin)
end


return A
