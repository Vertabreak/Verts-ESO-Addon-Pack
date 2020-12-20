



local function IsAcquired(object)
    return (object.itemId == DailyAlchemy.acquiredItemId) and (object.stack <= DailyAlchemy.acquiredItemCurrent)
end




local function PatternSortByManual(a, b)

    -- [traitPriority]
    local traitPriorityA = a[2]
    local traitPriorityB = b[2]
    if traitPriorityA ~= traitPriorityB then
        return traitPriorityA < traitPriorityB
    end


    local reagentA1 = a[3]
    local reagentA2 = a[4]
    local reagentA3 = (a[5].itemId ~= 0 and a[5]) or reagentA2
    local reagentB1 = b[3]
    local reagentB2 = b[4]
    local reagentB3 = (b[5].itemId ~= 0 and b[5]) or reagentB2


    -- [Locked]
    local isLockedA = DailyAlchemy:IsLocked(reagentA1.itemLink)
                      or DailyAlchemy:IsLocked(reagentA2.itemLink)
                      or DailyAlchemy:IsLocked(reagentA3.itemLink)

    local isLockedB = DailyAlchemy:IsLocked(reagentB1.itemLink)
                      or DailyAlchemy:IsLocked(reagentB2.itemLink)
                      or DailyAlchemy:IsLocked(reagentB3.itemLink)
    if isLockedA ~= isLockedB then
        return isLockedB
    end


    -- [minPriority]
    local lowest = DailyAlchemy.MAX_ITEM_INDEX
    local priorityA1 = (IsAcquired(reagentA1) and lowest) or reagentA1.priority
    local priorityA2 = (IsAcquired(reagentA2) and lowest) or reagentA2.priority
    local priorityA3 = (IsAcquired(reagentA3) and lowest) or reagentA3.priority

    local priorityB1 = (IsAcquired(reagentB1) and lowest) or reagentB1.priority
    local priorityB2 = (IsAcquired(reagentB2) and lowest) or reagentB2.priority
    local priorityB3 = (IsAcquired(reagentB3) and lowest) or reagentB3.priority

    local minA = math.min(priorityA1, priorityA2, priorityA3)
    local minB = math.min(priorityB1, priorityB2, priorityB3)
    if minA ~= minB then
        return minA < minB
    end


    -- [maxPriority]
    local maxA = math.max(priorityA1, priorityA2, priorityA3)
    local maxB = math.max(priorityB1, priorityB2, priorityB3)
    if maxA ~= maxB then
        return maxA < maxB
    end


    -- [inStack]
    local inStackA1 = (IsAcquired(reagentA1) and lowest) or math.ceil(math.sin(reagentA1.stack))
    local inStackA2 = (IsAcquired(reagentA2) and lowest) or math.ceil(math.sin(reagentA2.stack))
    local inStackA3 = (IsAcquired(reagentA3) and lowest) or math.ceil(math.sin(reagentA3.stack))

    local inStackB1 = (IsAcquired(reagentB1) and lowest) or math.ceil(math.sin(reagentB1.stack))
    local inStackB2 = (IsAcquired(reagentB2) and lowest) or math.ceil(math.sin(reagentB2.stack))
    local inStackB3 = (IsAcquired(reagentB3) and lowest) or math.ceil(math.sin(reagentB3.stack))

    local inStackA = inStackA1 + inStackA2 + inStackA3
    local inStackB = inStackB1 + inStackB2 + inStackB3
    if inStackA ~= inStackB then
        return inStackA > inStackB
    end


    -- [itemId(reagent1)]
    local itemIdA = reagentA1.itemId
    local itemIdB = reagentB1.itemId
    if itemIdA ~= itemIdB then
        return itemIdA < itemIdB
    end


    -- [itemId(reagent2)]
    itemIdA = reagentA2.itemId
    itemIdB = reagentB2.itemId
    if itemIdA ~= itemIdB then
        return itemIdA < itemIdB
    end


    -- [itemId(reagent3)]
    itemIdA = reagentA3.itemId
    itemIdB = reagentB3.itemId
    return itemIdA < itemIdB
end




local function PatternSortByPrice(a, b)

    -- [traitPriority]
    local traitPriorityA = a[2]
    local traitPriorityB = b[2]
    if traitPriorityA ~= traitPriorityB then
        return traitPriorityA < traitPriorityB
    end


    local reagentA1 = a[3]
    local reagentA2 = a[4]
    local reagentA3 = (a[5].itemId ~= 0 and a[5]) or reagentA2
    local reagentB1 = b[3]
    local reagentB2 = b[4]
    local reagentB3 = (b[5].itemId ~= 0 and b[5]) or reagentB2


    -- [Locked]
    local isLockedA = DailyAlchemy:IsLocked(reagentA1.itemLink)
                      or DailyAlchemy:IsLocked(reagentA2.itemLink)
                      or DailyAlchemy:IsLocked(reagentA3.itemLink)

    local isLockedB = DailyAlchemy:IsLocked(reagentB1.itemLink)
                      or DailyAlchemy:IsLocked(reagentB2.itemLink)
                      or DailyAlchemy:IsLocked(reagentB3.itemLink)
    if isLockedA ~= isLockedB then
        return isLockedB
    end


    local lowest = 1000 -- 1000Gold
    local priceA1 = (IsAcquired(reagentA1) and lowest) or reagentA1.price
    local priceA2 = (IsAcquired(reagentA2) and lowest) or reagentA2.price
    local priceA3 = (IsAcquired(reagentA3) and lowest) or reagentA3.price
    priceA1 = (priceA1 == 0 and 99999) or priceA1
    priceA2 = (priceA2 == 0 and 99999) or priceA2
    priceA3 = (priceA3 == 0 and 99999) or priceA3

    local priceB1 = (IsAcquired(reagentB1) and lowest) or reagentB1.price
    local priceB2 = (IsAcquired(reagentB2) and lowest) or reagentB2.price
    local priceB3 = (IsAcquired(reagentB3) and lowest) or reagentB3.price
    priceB1 = (priceB1 == 0 and 99999) or priceB1
    priceB2 = (priceB2 == 0 and 99999) or priceB2
    priceB3 = (priceB3 == 0 and 99999) or priceB3


    -- [maxPrice]
    local maxA = math.max(priceA1, priceA2, priceA3)
    local maxB = math.max(priceB1, priceB2, priceB3)
    if maxA ~= maxB then
        return maxA < maxB
    end


    -- [minPrice]
    local minA = math.min(priceA1, priceA2, priceA3)
    local minB = math.min(priceB1, priceB2, priceB3)
    if minA ~= minB then
        return minA < minB
    end


    -- [inStack]
    lowest = 0 -- 0Stack
    local inStackA1 = (IsAcquired(reagentA1) and lowest) or math.ceil(math.sin(reagentA1.stack))
    local inStackA2 = (IsAcquired(reagentA2) and lowest) or math.ceil(math.sin(reagentA2.stack))
    local inStackA3 = (IsAcquired(reagentA3) and lowest) or math.ceil(math.sin(reagentA3.stack))

    local inStackB1 = (IsAcquired(reagentB1) and lowest) or math.ceil(math.sin(reagentB1.stack))
    local inStackB2 = (IsAcquired(reagentB2) and lowest) or math.ceil(math.sin(reagentB2.stack))
    local inStackB3 = (IsAcquired(reagentB3) and lowest) or math.ceil(math.sin(reagentB3.stack))

    local inStackA = inStackA1 + inStackA2 + inStackA3
    local inStackB = inStackB1 + inStackB2 + inStackB3
    if inStackA ~= inStackB then
        return inStackA > inStackB
    end


    -- [itemId(reagent1)]
    local itemIdA = reagentA1.itemId
    local itemIdB = reagentB1.itemId
    if itemIdA ~= itemIdB then
        return itemIdA < itemIdB
    end


    -- [itemId(reagent2)]
    itemIdA = reagentA2.itemId
    itemIdB = reagentB2.itemId
    if itemIdA ~= itemIdB then
        return itemIdA < itemIdB
    end


    -- [itemId(reagent3)]
    itemIdA = reagentA3.itemId
    itemIdB = reagentB3.itemId
    return itemIdA < itemIdB
end




local function PatternSortByStock(a, b)

    -- [traitPriority]
    local traitPriorityA = a[2]
    local traitPriorityB = b[2]
    if traitPriorityA ~= traitPriorityB then
        return traitPriorityA < traitPriorityB
    end


    local reagentA1 = a[3]
    local reagentA2 = a[4]
    local reagentA3 = (a[5].itemId ~= 0 and a[5]) or reagentA2
    local reagentB1 = b[3]
    local reagentB2 = b[4]
    local reagentB3 = (b[5].itemId ~= 0 and b[5]) or reagentB2


    -- [Locked]
    local isLockedA = DailyAlchemy:IsLocked(reagentA1.itemLink)
                      or DailyAlchemy:IsLocked(reagentA2.itemLink)
                      or DailyAlchemy:IsLocked(reagentA3.itemLink)

    local isLockedB = DailyAlchemy:IsLocked(reagentB1.itemLink)
                      or DailyAlchemy:IsLocked(reagentB2.itemLink)
                      or DailyAlchemy:IsLocked(reagentB3.itemLink)
    if isLockedA ~= isLockedB then
        return isLockedB
    end


    -- [minStack]
    local lowest = 0 -- 0Stack
    local stackA1 = (IsAcquired(reagentA1) and lowest) or reagentA1.totalStack
    local stackA2 = (IsAcquired(reagentA2) and lowest) or reagentA2.totalStack
    local stackA3 = (IsAcquired(reagentA3) and lowest) or reagentA3.totalStack

    local stackB1 = (IsAcquired(reagentB1) and lowest) or reagentB1.totalStack
    local stackB2 = (IsAcquired(reagentB2) and lowest) or reagentB2.totalStack
    local stackB3 = (IsAcquired(reagentB3) and lowest) or reagentB3.totalStack

    local minA = math.min(stackA1, stackA2, stackA3)
    local minB = math.min(stackB1, stackB2, stackB3)
    if minA ~= minB then
        return minA > minB
    end


    -- [maxStack]
    local maxA = math.max(stackA1, stackA2, stackA3)
    local maxB = math.max(stackB1, stackB2, stackB3)
    if maxA ~= maxB then
        return maxA > maxB
    end


    -- [itemId(reagent1)]
    local itemIdA = reagentA1.itemId
    local itemIdB = reagentB1.itemId
    if itemIdA ~= itemIdB then
        return itemIdA < itemIdB
    end


    -- [itemId(reagent2)]
    itemIdA = reagentA2.itemId
    itemIdB = reagentB2.itemId
    if itemIdA ~= itemIdB then
        return itemIdA < itemIdB
    end


    -- [itemId(reagent3)]
    itemIdA = reagentA3.itemId
    itemIdB = reagentB3.itemId
    return itemIdA < itemIdB
end




local function ReagentSortByManual(a, b)

    local priorityA = (a.priority == 0 and DailyAlchemy.MAX_ITEM_INDEX) or a.priority
    local priorityB = (b.priority == 0 and DailyAlchemy.MAX_ITEM_INDEX) or b.priority
    if priorityA ~= priorityB then
        return priorityA < priorityB
    end

    return a.itemId < b.itemId
end




local function ReagentSortByPrice(a, b)

    local priceA = (a.price == 0 and 99999) or a.price
    local priceB = (b.price == 0 and 99999) or b.price
    if priceA ~= priceB then
        return priceA < priceB
    end

    return a.itemId < b.itemId
end




local function ReagentSortByStock(a, b)

    local stackA = a.totalStack
    local stackB = b.totalStack
    if stackA ~= stackB then
        return stackA > stackB
    end

    return a.itemId < b.itemId
end




function DailyAlchemy:Advice(conditionText, current, max, isMaster)

    self:Debug("　　　　[Advice] current=" .. tostring(current)
                                 .. " max=" .. tostring(max)
                                 .. " isMaster=" .. tostring(isMaster))
    local ENTRAPMENT         = GetString(DA_ENTRAPMENT)
    local RVG_HEALTH         = GetString(DA_RVG_HEALTH)
    local RVG_MAGICKA        = GetString(DA_RVG_MAGICKA)
    local RVG_STAMINA        = GetString(DA_RVG_STAMINA)
    local HINDRANCE          = GetString(DA_HINDRANCE)
    local UNSTOP             = GetString(DA_UNSTOP)
    local DETECTION          = GetString(DA_DETECTION)
    local INVISIBLE          = GetString(DA_INVISIBLE)
    local COWARDICE          = GetString(DA_COWARDICE)
    local MAIM               = GetString(DA_MAIM)
    local UNCERTAINTY        = GetString(DA_UNCERTAINTY)
    local SPEED              = GetString(DA_SPEED)
    local VULNERABILITY      = GetString(DA_VULNERABILITY)
    local SPELL_POWER        = GetString(DA_SPELL_POWER)
    local WEAPON_POWER       = GetString(DA_WEAPON_POWER)
    local SPELL_CRIT         = GetString(DA_SPELL_CRIT)
    local WEAPON_CRIT        = GetString(DA_WEAPON_CRIT)
    local HEALTH             = GetString(DA_HEALTH)
    local MAGICKA            = GetString(DA_MAGICKA)
    local STAMINA            = GetString(DA_STAMINA)
    local ARMOR              = GetString(DA_ARMOR)
    local SPELL_RESIST       = GetString(DA_SPELL_RESIST)
    local FRACTURE           = GetString(DA_FRACTURE)
    local VITALITY           = GetString(DA_VITALITY)
    local ENERVATE           = GetString(DA_ENERVATE)
    local GR_RVG_HEALTH      = GetString(DA_GR_RVG_HEALTH)
    local LGR_HEALTH         = GetString(DA_LGR_HEALTH)
    local BREACH             = GetString(DA_BREACH)
    local DEFILE             = GetString(DA_DEFILE)
    local PROTECTION         = GetString(DA_PROTECTION)
    local HEROISM            = GetString(DA_HEROISM)    -- Add:Elsweyr
    local TIMIDITY           = GetString(DA_TIMIDITY)   -- Add:Greymoor

    local isPoison = self:isPoison(conditionText)
    local craftItemList
    if isPoison then
        craftItemList = {
            {"76845", ENTRAPMENT, 20},      -- [xx.lang.csv] "242841733","0","76845","xxxxxxxx"
            {"76827", RVG_HEALTH, 2},       -- [xx.lang.csv] "242841733","0","76827","xxxxxxxx"
            {"76829", RVG_MAGICKA, 4},      -- [xx.lang.csv] "242841733","0","76829","xxxxxxxx"
            {"76831", RVG_STAMINA, 6},      -- [xx.lang.csv] "242841733","0","76831","xxxxxxxx"
            {"76849", HINDRANCE, 24},       -- [xx.lang.csv] "242841733","0","76849","xxxxxxxx"
            {"76844", UNSTOP, 24},          -- [xx.lang.csv] "242841733","0","76844","xxxxxxxx"
            {"76846", DETECTION, 21},       -- [xx.lang.csv] "242841733","0","76846","xxxxxxxx"
            {"76847", INVISIBLE, 22},       -- [xx.lang.csv] "242841733","0","76847","xxxxxxxx"
            {"76837", COWARDICE, 12},       -- [xx.lang.csv] "242841733","0","76837","xxxxxxxx"
            {"76839", MAIM, 14},            -- [xx.lang.csv] "242841733","0","76839","xxxxxxxx"
            {"76841", UNCERTAINTY, 16},     -- [xx.lang.csv] "242841733","0","76841","xxxxxxxx"
            {"76848", SPEED, 23},           -- [xx.lang.csv] "242841733","0","76848","xxxxxxxx"
            {"77599", VULNERABILITY, 26},   -- [xx.lang.csv] "242841733","0","77599","xxxxxxxx"
            {"76836", SPELL_POWER, 11},     -- [xx.lang.csv] "242841733","0","76836","xxxxxxxx"
            {"76838", WEAPON_POWER, 13},    -- [xx.lang.csv] "242841733","0","76838","xxxxxxxx"
            {"76840", SPELL_CRIT, 15},      -- [xx.lang.csv] "242841733","0","76840","xxxxxxxx"
            {"76842", WEAPON_CRIT, 17},     -- [xx.lang.csv] "242841733","0","76842","xxxxxxxx"
            {"76826", HEALTH, 1},           -- [xx.lang.csv] "242841733","0","76826","xxxxxxxx"
            {"76828", MAGICKA, 3},          -- [xx.lang.csv] "242841733","0","76828","xxxxxxxx"
            {"76830", STAMINA, 5},          -- [xx.lang.csv] "242841733","0","76830","xxxxxxxx"
            {"76832", SPELL_RESIST, 7},     -- [xx.lang.csv] "242841733","0","76832","xxxxxxxx"
            {"76834", ARMOR, 9},            -- [xx.lang.csv] "242841733","0","76834","xxxxxxxx"
            {"76833", BREACH, 8},           -- [xx.lang.csv] "242841733","0","76833","xxxxxxxx"
            {"76835", FRACTURE, 10},        -- [xx.lang.csv] "242841733","0","76835","xxxxxxxx"
            {"76827", ENERVATE, 18},        -- [xx.lang.csv] "242841733","0","76827","xxxxxxxx"
            {"77593", LGR_HEALTH, 27},      -- [xx.lang.csv] "242841733","0","77593","xxxxxxxx"
            {"77601", VITALITY, 29},        -- [xx.lang.csv] "242841733","0","77601","xxxxxxxx"
            {"77595", GR_RVG_HEALTH, 28},   -- [xx.lang.csv] "242841733","0","77595","xxxxxxxx"
            {"77597", PROTECTION, 25},      -- [xx.lang.csv] "242841733","0","77597","xxxxxxxx"
            {"77603", DEFILE, 30},          -- [xx.lang.csv] "242841733","0","77603","xxxxxxxx"
            -- Add:Elsweyr
            {"152151", HEROISM, 31},        -- [xx.lang.csv] "242841733","0","152151","xxxxxxxx"
            -- Add:Greymoor
            {"158309", TIMIDITY, 32},       -- [xx.lang.csv] "242841733","0","158309","xxxxxxxx"
        }
    else
        craftItemList = {
            {"54333", ENTRAPMENT},          -- [xx.lang.csv] "242841733","0","54333","xxxxxxxx"
            {"44812", RVG_HEALTH},          -- [xx.lang.csv] "242841733","0","44812","xxxxxxxx"
            {"44815", RVG_MAGICKA},         -- [xx.lang.csv] "242841733","0","44815","xxxxxxxx"
            {"44809", RVG_STAMINA},         -- [xx.lang.csv] "242841733","0","44809","xxxxxxxx"
            {"54335", HINDRANCE},           -- [xx.lang.csv] "242841733","0","54335","xxxxxxxx"
            {"27039", UNSTOP},              -- [xx.lang.csv] "242841733","0","27039","xxxxxxxx"
            {"30142", DETECTION},           -- [xx.lang.csv] "242841733","0","30142","xxxxxxxx"
            {"44715", INVISIBLE},           -- [xx.lang.csv] "242841733","0","44715","xxxxxxxx"
            {"44813", COWARDICE},           -- [xx.lang.csv] "242841733","0","44813","xxxxxxxx"
            {"44810", MAIM},                -- [xx.lang.csv] "242841733","0","44810","xxxxxxxx"
            {"54336", UNCERTAINTY},         -- [xx.lang.csv] "242841733","0","54336","xxxxxxxx"
            {"27041", SPEED},               -- [xx.lang.csv] "242841733","0","27041","xxxxxxxx"
            {"77598", VULNERABILITY},       -- [xx.lang.csv] "242841733","0","77598","xxxxxxxx"
            {"30145", SPELL_POWER},         -- [xx.lang.csv] "242841733","0","30145","xxxxxxxx"
            {"44714", WEAPON_POWER},        -- [xx.lang.csv] "242841733","0","44714","xxxxxxxx"
            {"30141", SPELL_CRIT},          -- [xx.lang.csv] "242841733","0","30141","xxxxxxxx"
            {"30146", WEAPON_CRIT},         -- [xx.lang.csv] "242841733","0","30146","xxxxxxxx"
            {"54339", HEALTH},              -- [xx.lang.csv] "242841733","0","54339","xxxxxxxx"
            {"54340", MAGICKA},             -- [xx.lang.csv] "242841733","0","54340","xxxxxxxx"
            {"54341", STAMINA},             -- [xx.lang.csv] "242841733","0","54341","xxxxxxxx"
            {"44814", SPELL_RESIST},        -- [xx.lang.csv] "242841733","0","44814","xxxxxxxx"
            {"27042", ARMOR},               -- [xx.lang.csv] "242841733","0","27042","xxxxxxxx"
            {"44821", BREACH},              -- [xx.lang.csv] "242841733","0","44821","xxxxxxxx"
            {"27040", FRACTURE},            -- [xx.lang.csv] "242841733","0","27040","xxxxxxxx"
            {"54337", ENERVATE},            -- [xx.lang.csv] "242841733","0","54337","xxxxxxxx"
            {"77592", LGR_HEALTH},          -- [xx.lang.csv] "242841733","0","77592","xxxxxxxx"
            {"77600", VITALITY},            -- [xx.lang.csv] "242841733","0","77600","xxxxxxxx"
            {"77594", GR_RVG_HEALTH},       -- [xx.lang.csv] "242841733","0","77594","xxxxxxxx"
            {"77596", PROTECTION},          -- [xx.lang.csv] "242841733","0","77596","xxxxxxxx"
            {"77602", DEFILE},              -- [xx.lang.csv] "242841733","0","77602","xxxxxxxx"
            -- Add:Elsweyr
            {"151969", HEROISM},            -- [xx.lang.csv] "242841733","0","151969","xxxxxxxx"
            -- Add:Greymoor
            {"158308", TIMIDITY},           -- [xx.lang.csv] "242841733","0","158308","xxxxxxxx"
        }
    end
    local traitPiorityList = {}
    for i, value in ipairs(craftItemList) do
        traitPiorityList[value[2]] = i
    end

    if (not self.stackList) or (#self.stackList == 0) then
        self.stackList = self:GetStackList()
    end
    if (not self.houseStackList) or (#self.houseStackList == 0) then
        self.houseStackList = self:GetHouseStackList()
    end
    local itemLink, solventItemLink, includeTraits = self:GetSolventAndTraits(conditionText, craftItemList, isPoison, isMaster)
    if (not itemLink) then
        return {}
    end

    local reagentInfoList = {
        {30148,  {RVG_MAGICKA, MAGICKA},     {COWARDICE, SPELL_POWER},     {HEALTH, RVG_HEALTH},         {INVISIBLE, DETECTION}},
        {30149,  {FRACTURE, ARMOR},          {RVG_HEALTH, HEALTH},         {WEAPON_POWER, MAIM},         {RVG_STAMINA, STAMINA}},
        {30151,  {RVG_HEALTH, HEALTH},       {RVG_MAGICKA, MAGICKA},       {RVG_STAMINA, STAMINA},       {ENTRAPMENT, UNSTOP}},
        {30152,  {BREACH, SPELL_RESIST},     {RVG_HEALTH, HEALTH},         {SPELL_POWER, COWARDICE},     {RVG_MAGICKA, MAGICKA}},
        {30153,  {SPELL_CRIT, UNCERTAINTY},  {SPEED, HINDRANCE},           {INVISIBLE, DETECTION},       {UNSTOP, ENTRAPMENT}},
        {30154,  {COWARDICE, SPELL_POWER},   {RVG_MAGICKA, MAGICKA},       {SPELL_RESIST, BREACH},       {DETECTION, INVISIBLE}},
        {30155,  {RVG_STAMINA, STAMINA},     {MAIM, WEAPON_POWER},         {HEALTH, RVG_HEALTH},         {HINDRANCE, SPEED}},
        {30156,  {MAIM, WEAPON_POWER},       {RVG_STAMINA, STAMINA},       {ARMOR, FRACTURE},            {ENERVATE, WEAPON_CRIT}},
        {30157,  {STAMINA, RVG_STAMINA},     {WEAPON_POWER, MAIM},         {RVG_HEALTH, HEALTH},         {SPEED, HINDRANCE}},
        {30158,  {SPELL_POWER, COWARDICE},   {MAGICKA, RVG_MAGICKA},       {BREACH, SPELL_RESIST},       {SPELL_CRIT, UNCERTAINTY}},
        {30159,  {WEAPON_CRIT, ENERVATE},    {HINDRANCE, SPEED},           {DETECTION, INVISIBLE},       {UNSTOP, ENTRAPMENT}},
        {30160,  {SPELL_RESIST, BREACH},     {HEALTH, RVG_HEALTH},         {COWARDICE, SPELL_POWER},     {MAGICKA, RVG_MAGICKA}},
        {30161,  {MAGICKA, RVG_MAGICKA},     {SPELL_POWER, COWARDICE},     {RVG_HEALTH, HEALTH},         {DETECTION, INVISIBLE}},
        {30162,  {WEAPON_POWER, MAIM},       {STAMINA, RVG_STAMINA},       {FRACTURE, ARMOR},            {WEAPON_CRIT, ENERVATE}},
        {30163,  {ARMOR, FRACTURE},          {HEALTH, RVG_HEALTH},         {MAIM, WEAPON_POWER},         {STAMINA, RVG_STAMINA}},
        {30164,  {HEALTH, RVG_HEALTH},       {MAGICKA, RVG_MAGICKA},       {STAMINA, RVG_STAMINA},       {UNSTOP, ENTRAPMENT}},
        {30165,  {RVG_HEALTH, HEALTH},       {UNCERTAINTY, SPELL_CRIT},    {ENERVATE, WEAPON_CRIT},      {INVISIBLE, DETECTION}},
        {30166,  {HEALTH, RVG_HEALTH},       {SPELL_CRIT, UNCERTAINTY},    {WEAPON_CRIT, ENERVATE},      {ENTRAPMENT, UNSTOP}},
        {77581,  {FRACTURE, ARMOR},          {ENERVATE, WEAPON_CRIT},      {DETECTION, INVISIBLE},       {VITALITY, DEFILE}},
        {77583,  {BREACH, SPELL_RESIST},     {ARMOR, FRACTURE},            {PROTECTION, VULNERABILITY},  {VITALITY, DEFILE}},
        {77584,  {HINDRANCE, SPEED},         {INVISIBLE, DETECTION},       {LGR_HEALTH, GR_RVG_HEALTH},  {DEFILE, VITALITY}},
        {77585,  {HEALTH, RVG_HEALTH},       {UNCERTAINTY, SPELL_CRIT},    {LGR_HEALTH, GR_RVG_HEALTH},  {VITALITY, DEFILE}},
        {77587,  {RVG_STAMINA, STAMINA},     {VULNERABILITY, PROTECTION},  {GR_RVG_HEALTH, LGR_HEALTH},  {VITALITY, DEFILE}},
        {77589,  {RVG_MAGICKA, MAGICKA},     {SPEED, HINDRANCE},           {VULNERABILITY, PROTECTION},  {LGR_HEALTH, GR_RVG_HEALTH}},
        {77590,  {RVG_HEALTH, HEALTH},       {PROTECTION, VULNERABILITY},  {GR_RVG_HEALTH, LGR_HEALTH},  {DEFILE, VITALITY}},
        {77591,  {SPELL_RESIST, BREACH},     {ARMOR, FRACTURE},            {PROTECTION, VULNERABILITY},  {DEFILE, VITALITY}},
        -- Add:Somerset
        {139020, {SPELL_RESIST, BREACH},     {HINDRANCE, SPEED},           {VULNERABILITY, PROTECTION},  {DEFILE, VITALITY}},
        {139019, {LGR_HEALTH, GR_RVG_HEALTH},{SPEED, HINDRANCE},           {VITALITY, DEFILE},           {PROTECTION, VULNERABILITY}},
        -- Add:Elsweyr
        {150731, {LGR_HEALTH, GR_RVG_HEALTH},{STAMINA, RVG_STAMINA},       {HEROISM, COWARDICE},         {DEFILE, VITALITY}}, -- Dragon's Blood
        {150789, {HEROISM, COWARDICE},       {VULNERABILITY, PROTECTION},  {INVISIBLE, DETECTION},       {VITALITY, DEFILE}}, -- Dragon's Bile
        -- Add:Dragonhold
        {150671, {MAGICKA, RVG_MAGICKA},     {ENERVATE, WEAPON_CRIT},      {HEROISM, COWARDICE},         {SPEED, HINDRANCE}}, -- Dragon Rheum
        -- Add:Greymoor
        {150669, {TIMIDITY, HEROISM},        {RVG_MAGICKA, MAGICKA},       {STAMINA, RVG_STAMINA},       {DETECTION, INVISIBLE}},       -- Chaurus Egg
        {150670, {TIMIDITY, HEROISM},        {RVG_HEALTH, HEALTH},         {MAGICKA, RVG_MAGICKA},       {PROTECTION, VULNERABILITY}},  -- Vile Coagulant
        {150672, {TIMIDITY, HEROISM},        {SPELL_CRIT, UNCERTAINTY},    {GR_RVG_HEALTH, LGR_HEALTH},  {HEALTH, RVG_HEALTH}},         -- Crimson Nirnroot
    }
    local reagentList = self:CreatePatternReagentList(reagentInfoList, includeTraits, traitPiorityList)
    local patternList = self:CreatePatternList(reagentList, includeTraits)


    local shortList = {}
    local journalQuantity = (max - current)
    self:Debug("　　　　　　" .. tostring(itemLink) .. "(" .. journalQuantity .. ")")
    local itemType = self:Choice(isPoison, ITEMTYPE_POISON, ITEMTYPE_POTION)
    local materialQuantity = math.ceil(journalQuantity / self:GetAmountToMake(itemType))

    local solventItemId = GetItemLinkItemId(solventItemLink)
    local solventStack = self.stackList[solventItemId] or 0
    local solventQuantity = materialQuantity - math.min(materialQuantity, solventStack)
    local solventName = GetItemLinkName(solventItemLink):gsub("(\|)[%a%s%p]*", ""):gsub("(\^)%a*", "")
    local solventIcon = zo_iconFormat(GetItemLinkIcon(solventItemLink), 18, 18)
    self:Debug("　　　　　　solvent=" .. tostring(solventItemLink)
                            .. "(" .. solventStack .. "/" .. materialQuantity .. ")")
    if (solventQuantity > 0) then
        shortList[#shortList + 1] = solventIcon .. solventName .. " x" .. solventQuantity
    end


    local pattern = patternList[1]
    for i, reagent in ipairs({pattern[3], pattern[4], pattern[5]}) do
        if reagent.itemId ~= 0 then
            local reagentQuantity = materialQuantity - math.min(materialQuantity, reagent.stack)
            self:Debug("　　　　　　reagent" .. i .. "=" .. reagent.itemName
                                    .. "(" .. reagent.stack .. "/" .. materialQuantity .. ")")
            if reagentQuantity > 0 then
                shortList[#shortList + 1] = zo_iconFormat(GetItemLinkIcon(reagent.itemLink), 18, 18)
                                            .. reagent.itemName
                                            .. " x" .. reagentQuantity
                                            .. self:GetLockIcon(reagent.itemLink, true)
            end
        end
    end


    if GetInteractionType() == INTERACTION_CRAFT and #shortList > 0 then
        local msg = itemLink .. zo_strformat(GetString(DA_SHORT_OF), table.concat(shortList, ", "))
        self:Message(msg)
        self:Debug("　　　　　　return 0 advice")
        return {}
    end


    local adviceList = {}
    for _, pattern in ipairs(patternList) do
        local advice = {}
        advice.resultLink = itemLink
        advice.itemId     = GetItemLinkItemId(itemLink)
        advice.itemType   = GetItemLinkItemType(itemLink)
        advice.stack      = journalQuantity
        advice.solvent = {}
        advice.solvent.itemId = solventItemId
        advice.solvent.itemLink = solventItemLink
        advice.solvent.itemName = solventName
        advice.solvent.stack    = solventStack
        advice.solvent.quantity = materialQuantity
        advice.reagent1 = pattern[3]
        advice.reagent1.quantity = materialQuantity
        advice.reagent2 = pattern[4]
        advice.reagent2.quantity = materialQuantity
        advice.reagent3 = pattern[5]
        advice.reagent3.quantity = materialQuantity
        adviceList[#adviceList + 1] = advice
    end
    self:Debug("　　　　　　return " .. #adviceList .. " advice")
    return adviceList
end




function DailyAlchemy:CreatePatternReagentList(reagentInfoList, includeTraits, traitPiorityList)

    self:Debug("　　　　　[PatternReagent]")
    local formatText = "|H0:item:<<1>>:31:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"
    local reagentList = {}
    for _, reagentInfo in ipairs(reagentInfoList) do
        local itemId = tonumber(reagentInfo[1])
        local itemLink = zo_strformat(formatText, itemId)
        local itemName = GetItemLinkName(itemLink):gsub("(\|).*", ""):gsub("(\^)%a*", "")

        -- [PositiveCheck]
        local traits = {reagentInfo[2][1], reagentInfo[3][1], reagentInfo[4][1], reagentInfo[5][1]}
        local traitPrioritys = {}
        local isTarget = false

        local debugLine = {}
        for _, traitName in ipairs(traits) do
            if self:Equal(traitName, includeTraits) then
                isTarget = true
                debugLine[#debugLine + 1] = "　　　　　　　(O)" .. tostring(traitName)
            --else
            --    debugLine[#debugLine + 1] = "　　　　　　　( )" .. tostring(traitName)
            end
            traitPrioritys[#traitPrioritys + 1] = traitPiorityList[traitName]
        end


        -- [NegativeCheck]
        if isTarget then
            local cancelTraits = {reagentInfo[2][2], reagentInfo[3][2], reagentInfo[4][2], reagentInfo[5][2]}
            for _, cancelTraitName in ipairs(cancelTraits) do
                if self:Equal(cancelTraitName, includeTraits) then
                    isTarget = false
                    debugLine[#debugLine + 1] = "　　　　　　　|cffb6c1(X)" .. tostring(cancelTraitName) .. "|r"
                end
            end
        end

        if isTarget then
            --if self:IsDebug() then
            --    self:Debug("　　　　　　" .. itemId .. ":" .. itemLink
            --                              .. ":" .. GetItemLinkName(itemLink))
            --    for _, debugLine in ipairs(debugLine) do
            --        self:Debug(tostring(debugLine))
            --    end
            --end

            local reagent = {}
            reagent.itemId         = itemId
            reagent.itemName       = itemName
            reagent.itemLink       = itemLink
            reagent.traits         = traits
            reagent.traitPrioritys = traitPrioritys
            reagent.totalStack     = (self.stackList[itemId] or 0) + (self.houseStackList[itemId] or 0)
            reagent.stack          = self.stackList[itemId] or 0
            reagent.price          = self:GetAvgPrice(itemLink)
            reagent.priority       = self:GetPriority(itemId)
            reagentList[#reagentList + 1] = reagent
        end
    end
    return reagentList
end




function DailyAlchemy:Equal(text, keyList)
    if text == nil or text == "" or keyList == nil or #keyList == 0 then
        return nil
    end

    local lowerText = string.lower(text)

    local result
    for _, key in ipairs(keyList) do
        if key and key ~= "" then
            if text == key then
                return true
            end

            local lowerKey = string.lower(key)
            if lowerText == lowerKey then
                return true
            end
        end
    end
    return nil
end




function DailyAlchemy:EqualAll(textList, keyList)
    if textList == nil or #textList == 0 or keyList == nil or #keyList == 0 then
        return nil
    end

    for _, text in ipairs(textList) do
        if (not self:Equal(text, keyList)) then
            return nil
        end
    end
    return true
end




function DailyAlchemy:GetLockIcon(itemLink, enable)

    if self.lockedList[itemLink] then
        local icon = zo_iconFormat("esoui/art/miscellaneous/gamepad/gp_icon_locked32_disabled.dds", 18, 18)
        if enable then
            icon = zo_iconFormat("esoui/art/miscellaneous/gamepad/gp_icon_locked32.dds", 18, 18)
        end
        return icon
    else
        return ""
    end
end




function DailyAlchemy:CreatePatternList(reagentList, includeTraits)

    self:Debug("　　　　　[Pattern]" .. table.concat(includeTraits, ", "))
    local pattern
    local patternList = {}
    --local patternNgList = {}
    local validKeyCache = {}
    for _, reagent1 in ipairs(reagentList) do
        for _, reagent2 in ipairs(reagentList) do

            if #includeTraits > 1 then
                for _, reagent3 in ipairs(reagentList) do
                    local traits, traitPriority = self:IsValidParameter(validKeyCache, reagent1, reagent2, reagent3)
                    if traits then
                        if self:EqualAll(traits, includeTraits) then
                            pattern = {
                                traits[1],
                                traitPriority,
                                self:SortReagent({reagent1, reagent2, reagent3}),
                                }
                            patternList[#patternList + 1] = pattern
                        --elseif self:IsDebug() then
                        --    patternNgList[#patternNgList + 1] = {traits[1], traitPriority, reagent1, reagent2, reagent3}
                        end
                    end
                end
            else
                local traits, traitPriority = self:IsValidParameter(validKeyCache, reagent1, reagent2)
                if traits then
                    local reagent3 = {}
                    reagent3.itemId     = 0
                    reagent3.itemLink   = nil
                    reagent3.stack      = 0
                    reagent3.totalStack = 0
                    reagent3.price      = 0
                    reagent3.priority   = self:GetPriority(reagent3.itemId)
                    if traits[1] == includeTraits[1] then
                        pattern = {
                            traits[1],
                            traitPriority,
                            self:SortReagent({reagent1, reagent2}),
                            }
                        pattern[5] = reagent3
                        patternList[#patternList + 1] = pattern
                    --elseif self:IsDebug() then
                    --    patternNgList[#patternNgList + 1] = {traits[1], traitPriority, reagent1, reagent2, reagent3}
                    end
                end
            end
        end
    end
    self:SortPattern(patternList)
    --self:SortPattern(patternNgList)


    if self:IsDebug() then
        local icon = zo_iconFormat("EsoUI/Art/currency/currency_gold.dds", 16, 16)
        local isChecked = false
        for i, pattern in ipairs(patternList) do
            local mark = "|c5c5c5c(X)"
            if (not isChecked) and (pattern[1] == includeTraits[1]) then
                mark = "|cffff66(O)"
                isChecked = true
            end

            local reagent1 = pattern[3]
            local reagent2 = pattern[4]
            local reagent3 = pattern[5]
            local addInfo1 = ""
            local addInfo2 = ""
            local addInfo3 = ""
            if self.savedVariables.priorityBy == self.DA_PRIORITY_BY_STOCK then
                addInfo1 = "x" .. reagent1.totalStack .. self:GetLockIcon(reagent1.itemLink)
                addInfo2 = "x" .. reagent2.totalStack .. self:GetLockIcon(reagent2.itemLink)
                addInfo3 = "x" .. reagent3.totalStack .. self:GetLockIcon(reagent3.itemLink)

            elseif self:ContainsNumber(self.savedVariables.priorityBy, self.DA_PRIORITY_BY_MM,
                                                                       self.DA_PRIORITY_BY_TTC,
                                                                       self.DA_PRIORITY_BY_ATT) then
                local icon = zo_iconFormat("EsoUI/Art/currency/currency_gold.dds", 18, 18)
                addInfo1 = " " .. string.format('%.0f', reagent1.price) .. icon .. self:GetLockIcon(reagent1.itemLink)
                addInfo2 = " " .. string.format('%.0f', reagent2.price) .. icon .. self:GetLockIcon(reagent2.itemLink)
                addInfo3 = " " .. string.format('%.0f', reagent3.price) .. icon .. self:GetLockIcon(reagent3.itemLink)
                if string.format('%.0f', reagent1.price) == "0" then
                    addInfo1 = addInfo1 .. "x" .. reagent1.totalStack .. "(in" .. reagent1.stack .. ")"
                end
                if string.format('%.0f', reagent2.price) == "0" then
                    addInfo2 = addInfo2 .. "x" .. reagent2.totalStack .. "(in" .. reagent2.stack .. ")"
                end
                if string.format('%.0f', reagent3.price) == "0" then
                    addInfo3 = addInfo3 .. "x" .. reagent3.totalStack .. "(in" .. reagent3.stack .. ")"
                end

            elseif self.savedVariables.priorityBy == self.DA_PRIORITY_BY_MANUAL then
                local icon = zo_iconFormat("esoui/art/skillsadvisor/advisor_tabicon_settings_down.dds", 18, 18)
                addInfo1 = " " .. reagent1.priority .. icon .. self:GetLockIcon(reagent1.itemLink)
                addInfo2 = " " .. reagent2.priority .. icon .. self:GetLockIcon(reagent2.itemLink)
                addInfo3 = " " .. reagent3.priority .. icon .. self:GetLockIcon(reagent3.itemLink)
            end

            local itemInfo = {}
            if reagent1.itemId ~= 0 and reagent1.itemLink then
                table.insert(itemInfo, zo_iconFormat(GetItemLinkIcon(reagent1.itemLink), 20, 20) .. reagent1.itemLink .. tostring(addInfo1))
            end
            if reagent2.itemId ~= 0 and reagent2.itemLink then
                table.insert(itemInfo, zo_iconFormat(GetItemLinkIcon(reagent2.itemLink), 20, 20) .. reagent2.itemLink .. tostring(addInfo2))
            end
            if reagent3.itemId ~= 0 and reagent3.itemLink then
                table.insert(itemInfo, zo_iconFormat(GetItemLinkIcon(reagent3.itemLink), 20, 20) .. reagent3.itemLink .. tostring(addInfo3))
            end
            self:Debug("　　　　　　"
                       .. tostring(mark)
                       .. tostring(i) .. ":"
                       .. tostring(pattern[1])
                       .. " [" .. table.concat(itemInfo, ",") .. "]|r")
        end
        --self:Debug("　　　　　　|c5c5c5c------------------------|r")
        --for i, pattern in ipairs(patternNgList) do
        --    local mark = "|c5c5c5c(X)"
        --    local reagent1 = pattern[3]
        --    local reagent2 = pattern[4]
        --    local reagent3 = pattern[5]
        --    local addInfo1 = ""
        --    local addInfo2 = ""
        --    local addInfo3 = ""
        --    if self.savedVariables.priorityBy == self.DA_PRIORITY_BY_STOCK then
        --        addInfo1 = "x" .. reagent1.totalStack
        --        addInfo2 = "x" .. reagent2.totalStack
        --        addInfo3 = "x" .. reagent3.totalStack
        --    elseif self:ContainsNumber(self.savedVariables.priorityBy, self.DA_PRIORITY_BY_MM,
        --                                                               self.DA_PRIORITY_BY_TTC,
        --                                                               self.DA_PRIORITY_BY_ATT) then
        --        local icon = zo_iconFormat("EsoUI/Art/currency/currency_gold.dds", 18, 18)
        --        addInfo1 = " " .. string.format('%.0f', reagent1.price) .. icon
        --        addInfo2 = " " .. string.format('%.0f', reagent2.price) .. icon
        --        addInfo3 = " " .. string.format('%.0f', reagent3.price) .. icon
        --    elseif self.savedVariables.priorityBy == self.DA_PRIORITY_BY_MANUAL then
        --        local icon = zo_iconFormat("esoui/art/skillsadvisor/advisor_tabicon_settings_down.dds", 18, 18)
        --        addInfo1 = " " .. reagent1.priority .. icon
        --        addInfo2 = " " .. reagent2.priority .. icon
        --        addInfo3 = " " .. reagent3.priority .. icon
        --    end
        --    local minStack = math.min(reagent1.stack, reagent2.stack)
        --    local item3Info = ""
        --    if reagent3.itemId ~= 0 then
        --        minStack = math.min(reagent1.stack, reagent2.stack, reagent3.stack)
        --        item3Info = ", " .. reagent3.itemLink .. addInfo3
        --    end
        --    self:Debug("　　　　　　" .. mark .. (i + #patternList) .. ":"
        --                              .. pattern[1] .. "x" .. minStack
        --                              .. " [" .. reagent1.itemLink .. addInfo1
        --                              .. ", " .. reagent2.itemLink .. addInfo2
        --                              .. item3Info .. "]|r")
        --end
    end

    return patternList
end




function DailyAlchemy:GetSolventAndTraits(conditionText, craftItemList, isPoison, isMaster)

    self:Debug("　　　　　[SolventAndTraits]")
    local CP150 = "308:50"
    local CP100 = "134:50"
    local CP50  = "129:50"--
    local CP10  = "125:50"
    local LV40  = "30:40"
    local LV30  = "30:30"
    local LV20  = "30:20"
    local LV10  = "30:10"
    local LV3   = "30:3"
    local itemFormat = "|H0:item:<<1>>:<<2>>:0:0:0:0:0:0:0:0:0:0:0:0:<<3>>:0:0:0:0:0|h|h"


    local skillRank
    local rankList
    if isMaster then
        skillRank = 8
        rankList = {CP150}
    else
        skillRank = self.savedCharVariables.rankWhenReceived or self:GetSkillRank()
        rankList = {select(9 - skillRank, CP150, CP100, CP50, CP10, LV40, LV30, LV20, LV10, LV3)}
        self:Debug("　　　　　　rankWhenReceived=" .. tostring(self.savedCharVariables.rankWhenReceived))
        self:Debug("　　　　　　GetSkillRank=" .. tostring(self:GetSkillRank()))
        self:Debug("　　　　　　rankList=" .. table.concat(rankList, ", "))
    end

    local solventList
    if isPoison then
        solventList = {select(9 - skillRank, "75365", "75364", "75363", "75362", "75361", "75360", "75359", "75358", "75357")}
    else
        solventList = {select(9 - skillRank, "64501", "64500", "23268", "23267", "23266", "23265", "4570", "1187", "883")}
    end


    local itemLink
    local convertedItemNames
    local solventItemLink
    local includeTraits
    for i, rank in ipairs(rankList) do
        self:Debug("　　　　　　rank=" .. tostring(rank))
        for _, craftItem in ipairs(craftItemList) do

            itemLink = zo_strformat(itemFormat, craftItem[1], rank, "36")
            convertedItemNames = self:ConvertedItemNames(GetItemLinkName(itemLink))
            if self:Contains(conditionText, convertedItemNames) then
                solventItemLink = zo_strformat(itemFormat, solventList[i], rank, "0")
                includeTraits = {craftItem[2]}
                self:Debug("　　　　　　|cffff66(O)" .. table.concat(convertedItemNames, ",") .. "|r")
                break
            else
                self:Debug("　　　　　　|c5c5c5c(X)" .. table.concat(convertedItemNames, ",") .. "|r")
            end
        end
        if includeTraits then
            break
        end
    end
    if (not solventItemLink) then
        local msg = zo_strformat(GetString(DA_MISMATCH_ITEM), conditionText)
        self:Message(msg, "ff0000")
        return nil, nil, nil
    end
    if (not isMaster) then
        self:Debug("　　　　　　target=" .. itemLink
                   .. " [" .. solventItemLink .. ", " .. table.concat(includeTraits, ", ") .. "]")
        return itemLink, solventItemLink, includeTraits
    end


    --self:Debug("　　　　　　[Traits]")
    local convertedTraitNames
    includeTraits = {}
    for i, craftItem in ipairs(craftItemList) do
        convertedTraitNames = self:ConvertedItemNames(craftItem[2])
        if self:Contains(conditionText, convertedTraitNames) then
            includeTraits[#includeTraits + 1] = craftItem[2]
            --self:Debug("　　　　　　　|cffff66(O)" .. table.concat(convertedTraitNames, ",") .. "|r")
        else
            --self:Debug("　　　　　　　|c5c5c5c(X)" .. table.concat(convertedTraitNames, ",") .. "|r")
        end
    end
    if #includeTraits < 3 then
        self:Debug("　　　　　　|cFF0000 #includeTraits < 3 !!! |r")
        return nil, nil, nil
    end
    self:Debug("　　　　　　target=" .. itemLink
               .. " [" .. solventItemLink .. ", " .. table.concat(includeTraits, ", ") .. "]")
    return itemLink, solventItemLink, includeTraits
end




function DailyAlchemy:ShowReagentInfo(bagId, slotIndex)

    if GetItemType(bagId, slotIndex) ~= ITEMTYPE_REAGENT then
        return
    end

    local traitList = {GetItemId(bagId, slotIndex)}
    local numTraits = select("#", GetAlchemyItemTraits(bagId, slotIndex)) / ALCHEMY_TRAIT_STRIDE
    for i = 1, numTraits do
        local positiveTrait, _, _, negativeTrait = ZO_Alchemy_GetTraitInfo(i, GetAlchemyItemTraits(bagId, slotIndex))
        if positiveTrait and negativeTrait then
            traitList[#traitList + 1] = "{" .. positiveTrait .. ", " .. negativeTrait .. "}"
        end
    end

    self:Message(GetItemLink(bagId, slotIndex) .. " = {" .. table.concat(traitList, ", ") .. "},")
end




function DailyAlchemy:SortPattern(list)

    local sortFunctions = {
        [self.DA_PRIORITY_BY_STOCK] = PatternSortByStock,
        [self.DA_PRIORITY_BY_MM] = PatternSortByPrice,
        [self.DA_PRIORITY_BY_TTC] = PatternSortByPrice,
        [self.DA_PRIORITY_BY_ATT] = PatternSortByPrice,
        [self.DA_PRIORITY_BY_MANUAL] = PatternSortByManual,
    }
    table.sort(list, sortFunctions[self.savedVariables.priorityBy])
end




function DailyAlchemy:SortReagent(list)
    local sortFunctions = {
        [self.DA_PRIORITY_BY_STOCK] = ReagentSortByStock,
        [self.DA_PRIORITY_BY_MM] = ReagentSortByPrice,
        [self.DA_PRIORITY_BY_TTC] = ReagentSortByPrice,
        [self.DA_PRIORITY_BY_ATT] = ReagentSortByPrice,
        [self.DA_PRIORITY_BY_MANUAL] = ReagentSortByManual,
    }
    table.sort(list, sortFunctions[self.savedVariables.priorityBy])
    return unpack(list)
end

