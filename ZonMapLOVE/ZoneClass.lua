

local Zon = {}


function Zon.getNewSectorEnvierment()
    local Sec = {
        { C = 0.22, RL = 0, Data = {Des = "Skog eller helt övervuxna ruiner.", Hot = true,  Artifakt = false}},
        { C = 0.18, RL = 0, Data = {Des = "Totalt raserade ruiner, grusöken.", Hot = true,  Artifakt = false}},
        { C = 0.18, RL = 0, Data = {Des = "Delvis raserade ruiner.",           Hot = true,  Artifakt = true }},
        { C = 0.22, RL = 0, Data = {Des = "Välbevarade ruiner.",               Hot = true,  Artifakt = true }},
        { C = 0.18, RL = 1, Data = {Des = "Öde industrilandskap.",             Hot = true,  Artifakt = true }},
        { C = 0.02, RL = 0, Data = {Des = "Bosättning",                        Hot = false, Artifakt = false}}
    }

    local SR = math.random()

    local i = 1
    while(SR > 0) do
        SR = SR-Sec[i].C
        i = i + 1
    end

    return {table.unpack(Sec[i].Data)}, Sec[i].RL
end

function getRandomElement(TableOfElements)
    local Key = {}
    for k in pairs(TableOfElements) do
        table.insert(Key, k)
    end

    Key = Keys[math.random(#Key)]

    return TableOfElements[Key]
end

function Zon.getNewRuinEnvierment(RuinType)
    local Ruiner = {}
    Ruiner[0] = {
        "Affärsgalleria",    "Badhus",             "Bensinstation",     "Biograf",
        "Bostadsområde",     "Busstation",         "Flygplansvrak",     "Förvildad park",
        "Höghusruin",        "Jaktaffär",          "Kontorskomplex",    "Krater",
        "Kråkslott",         "Kyrka",              "Lekplats",          "Miljonprogram",
        "Motorväg",          "Museum",             "Nöjesfält",         "Parkeringshus",
        "Polisstation",      "Radiostation",       "Raserad bro",       "Skyddsrum",
        "Slagfält",          "Snabbmatsresturang", "Sporthall",         "Sjukhus",
        "Stridsvagn",        "Teater",             "Tunnelbana",        "Tågstation",
        "Snabbköp",          "Vägtunnel",          "Övergiven skola",   "Ödelagd marina"
    }

    Ruiner[1] = {
        "Fabrik",   "Fartygsvrak", "Kraftledning",  "Militärbas",
        "Pipline",  "Radiomast",   "Raffinaderi",   "Reningsverk",
        "Skutbana", "Soptipp",     "Vindkraftverk", "Oljecistern"
    }

    return getRandomElement(Ruiner[RuinType])

end


function Zon:new()

    -- Sektormiljö

    local RL = 0
    self["Sektormiljö"], RL = Zon.getNewSectorEnvierment()


    -- Dominerande ruin

    self["DominantRuin"] = getNewRuinEnvierment(RL)

    -- Bestäm rötnivå

    self["Rötnivå"] = (  { 0, 1, 1, 1, 1, 2 }  )[math.random(1, 6)]


    -- Bestäm Hotnivå
end










setmetatable(Zon, {})

return Zon
