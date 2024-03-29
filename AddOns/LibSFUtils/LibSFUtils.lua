-- LibSFUtils is already defined in prior loaded file

local sfutil = LibSFUtils or {}

---------------------
-- convenience color tables
-- These tables contain definitions for commonly used colors along with
-- names to easily indicate the color. 
--
-- Using these can somewhat reduce your addon's computational load as 
-- these are calculated once, when the library is loaded instead of 
-- whenever you go from hex to zo_colordef/rgb or from zo_colordef/rgb 
-- to hex again. It might be miniscule, but when you are doing the 
-- zo_colordef creations and conversions with a lot of colors many many 
-- times, it all adds up.
sfutil.colors = {
    gold        = {hex ="FFD700", rgb = {1, 215/255, 0}, },
    red         = {hex ="FF0000", rgb = {1, 0, 0}, },
    teal        = {hex ="00EFBB", rgb = {0, 239/255, 187/255}, },
    lime        = {hex ="00E600", rgb = {0, 230/255, 0}, },
    goldenrod   = {hex ="EECA00", rgb = {238/255, 202/255, 0}, },
    blue        = {hex ="0000FF", rgb = {0, 0, 1}, },
    purple      = {hex ="b000ff", rgb = {176/255, 0, 1}, },
    bronze      = {hex ="ff9900", rgb = {1, 153/255, 0}, },
	ltskyblue   = {hex ="87cefa", rgb = {135/255, 206/255, 250/255}, },
	lemon		= {hex ="FFFACD", rgb = {1, 250/255, 205/255}, },
	mocassin	= {hex ="FFE4B5", rgb = {1, 228/255, 181/255}, },
    aquamarine  = {hex ="7fffd4", rgb = {127/255, 1, 212/255}, },
    lightsalmon = {hex ="FFA07A", rgb = {1, 160/255, 122/255}, },

    junk        = {hex = "7f7f7f", rgb = {127/255, 127/255, 127/255}, },
    normal      = {hex = "FFFFFF", rgb = {1, 1, 1}, },
    fine        = {hex = "2dc50e", rgb = {45/255, 197/255, 14/255}, },
    superior    = {hex = "3a92ff", rgb = {58/255, 146/255, 1}, },
    epic        = {hex = "a02ef7", rgb = {160/255, 46/255, 247/255}, },
    legendary   = {hex = "EECA00", rgb = {238/255, 202/255, 0}, },
    mythic      = {hex = "ffaa00", rgb = {1, 170/255, 0}, },
}
sfutil.hex = { 
    gold = sfutil.colors.gold.hex, 
    red = sfutil.colors.red.hex,
    teal = sfutil.colors.teal.hex,
    lime = sfutil.colors.lime.hex,
    goldenrod = sfutil.colors.goldenrod.hex,
    blue = sfutil.colors.blue.hex,
    purple = sfutil.colors.purple.hex,
    bronze = sfutil.colors.bronze.hex,
	  ltskyblue = sfutil.colors.ltskyblue.hex,
	  lemon = sfutil.colors.lemon.hex,
	  mocassin = sfutil.colors.mocassin.hex,

    junk = sfutil.colors.junk.hex,
    normal = sfutil.colors.normal.hex,
    fine = sfutil.colors.fine.hex,
    superior = sfutil.colors.superior.hex,
    epic = sfutil.colors.epic.hex,
    legendary = sfutil.colors.legendary.hex,
    mythic = sfutil.colors.mythic.hex,
}
sfutil.rgb = { 
    gold = sfutil.colors.gold.rgb, 
    red = sfutil.colors.red.rgb,
    teal = sfutil.colors.teal.rgb,
    lime = sfutil.colors.lime.rgb,
    goldenrod = sfutil.colors.goldenrod.rgb,
    blue = sfutil.colors.blue.rgb,
    purple = sfutil.colors.purple.rgb,
    bronze = sfutil.colors.bronze.rgb,
	  ltskyblue = sfutil.colors.ltskyblue.rgb,
	  lemon = sfutil.colors.lemon.rgb,
	  mocassin = sfutil.colors.mocassin.rgb,

    junk = sfutil.colors.junk.rgb,
    normal = sfutil.colors.normal.rgb,
    fine = sfutil.colors.fine.rgb,
    superior = sfutil.colors.superior.rgb,
    epic = sfutil.colors.epic.rgb,
    legendary = sfutil.colors.legendary.rgb,
    mythic = sfutil.colors.mythic.rgb,
}


local function ZOS_addSystemMsg(msg)
	CHAT_ROUTER:AddSystemMessage(msg)
end


---------------------
--[[
    Color conversion functions
]]
function sfutil.colorRGBToHex(r, g, b)
  return string.format("%.2x%.2x%.2x", zo_floor(r * 255), zo_floor(g * 255), zo_floor(b * 255))
end

function sfutil.colorHexToRGBA(colourString)
  local r=tonumber(string.sub(colourString, 1, 2), 16) or 255
  local g=tonumber(string.sub(colourString, 3, 4), 16) or 255
  local b=tonumber(string.sub(colourString, 5, 6), 16) or 255
  return r/255, g/255, b/255, 1
end

-- Turn a ([0,1])^3 RGB colour to "|cABCDEF" form. We could use
-- ZO_ColorDef, but we use so many colors, we won't do it.
-- Note: This is NOT the same as the LibSFUtils.colorRGBToHex() function!
function sfutil.ConvertRGBToHex(r, g, b)
    return string.format("|c%.2x%.2x%.2x", zo_floor(r * 255), zo_floor(g * 255), zo_floor(b * 255))
end

-- Convert a colour from hexadecimal form to [0,1] RGB form.
-- Note: This is NOT the same as the LibSFUtils.colorHexToRGBA() function
--   as it can convert from a variety of hex string formats for colors:
--      |crrggbb, aarrggbb, and rrggbb
function sfutil.ConvertHexToRGBA(colourString)
    local r, g, b, a
    if string.sub(colourString,1,1) == "|" then
        -- format "|crrggbb"
        r=tonumber(string.sub(colourString, 3, 4), 16) or 255
        g=tonumber(string.sub(colourString, 5, 6), 16) or 255
        b=tonumber(string.sub(colourString, 7, 8), 16) or 255
        a = 255
    elseif #colourString == 8 then
        -- format "aarrggbb"
        a=tonumber(string.sub(colourString, 1, 2), 16) or 255
        r=tonumber(string.sub(colourString, 3, 4), 16) or 255
        g=tonumber(string.sub(colourString, 5, 6), 16) or 255
        b=tonumber(string.sub(colourString, 7, 8), 16) or 255
    elseif #colourString == 6 then
        -- format "rrggbb"
        r=tonumber(string.sub(colourString, 1, 2), 16) or 255
        g=tonumber(string.sub(colourString, 3, 4), 16) or 255
        b=tonumber(string.sub(colourString, 5, 6), 16) or 255
        a = 255
    else
        -- unidentified format
        r = 255
        g = 255
        b = 255
        a = 255
    end
    return r/255, g/255, b/255, a/255
end

-- Convert a colour from "|cABCDEF" form to [0,1] RGB form and return them in a table.
function sfutil.ConvertHexToRGBAPacked(colourString)
    local r, g, b, a = sfutil.ConvertHexToRGBA(colourString)
    return {r = r, g = g, b = b, a = a}
end



---------------------
--[[
    Concatenate varargs to a string
]]
function sfutil.str(...)
   local nargs = select('#',...)
   local arg = {}

   for i = 1,nargs do
      local v = select(i,...)
      local t = type(v)
      if(v == nil) then
         arg[#arg+1] = "(nil)"
      elseif(t == "table") then
         arg[#arg+1] = sfutil.str(v)
      else
         arg[#arg+1] = tostring(v)
      end
   end
   return table.concat(arg)
end

function sfutil.lstr(...)
   local nargs = select('#',...)
   local arg = {}

   for i = 1,nargs do
      local v = select(i,...)
      local t = type(v)
      if(v == nil) then
         arg[#arg+1] = "(nil)"
	  elseif t == "number" then
		 arg[#arg+1] = GetString(v)
      elseif(t == "table") then
         arg[#arg+1] = sfutil.str(v)
      else
         arg[#arg+1] = tostring(v)
      end
   end
   return table.concat(arg)
end

---------------------
--[[
    Concatenate varargs to a delimited string
]]
function sfutil.dstr(delim, ...)
    local nargs = select('#',...)
    local arg = {}

    for i = 1,nargs do
        local v = select(i,...)
        local t = type(v)
        if(v == nil) then
            arg[#arg+1] = "(nil)"
        elseif(t == "table") then
            arg[#arg+1] = sfutil.str(v)
        else
            arg[#arg+1] = tostring(v)
        end
    end
    return table.concat(arg,delim)
end

---------------------
-- Create a string containing an optional icon (of optional color) followed by a text
-- prompt (specified either as a string itself or as a localization string id)
-- (Without the  parameters, it simply prepares and optionally colorizes text.)
-- The color parameters are all hex colors.
function sfutil.GetIconized(prompt, promptcolor, texturefile, texturecolor)
    local strprompt

    -- get the prompt text
    if( prompt == nil ) then
        strprompt = ""
    elseif( type(prompt) == "string") then
        strprompt = prompt
    else
        strprompt = GetString(prompt)
    end

    -- color the prompt text if required
    if( promptcolor ) then
        strprompt = zo_strformat("|c<<1>> <<2>>|r", promptcolor, strprompt)
    end

    -- prepend the icon to the prepared prompt text
    if( texturefile ~= nil ) then
        if( texturecolor ~= nil ) then
			return zo_strformat("|c<<1>>|t24:24:<<2>>:inheritColor|t|r<<3>>", texturecolor, texturefile, strprompt)
        else
			return zo_strformat("|t24:24:<<1>>|t<<2>>", texturefile, strprompt)
        end
    end
    return strprompt
end

---------------------
-- Create a string containing a text prompt (specified either as a string itself 
-- or as a localization string id) and a text color. The text color is optional, but
-- if you do not provide it, you just get the same text back that you put in.
-- The color parameters are all hex colors.
function sfutil.ColorText(prompt, promptcolor)
    local strprompt

    -- get the prompt text
    if( prompt == nil ) then
        strprompt = ""
    elseif( type(prompt) == "string") then
        strprompt = prompt
    else
        strprompt = GetString(prompt)
    end

    -- color the prompt text if required
    if( promptcolor ~= nil ) then
        strprompt = zo_strformat("|c<<1>> <<2>>|r", promptcolor, strprompt)
    end

    return strprompt
end

---------------------
--[[
  Used to be able to wrap an existing function with another so that subsequent
  calls to the function will actually invoke the wrapping function.
  
  The wrapping function should accept a function as the first parameter, followed
  by the parameters expected by the original function. It will be passed in the
  original function so the wrapping function can call it (if it chooses).
  
  Can be called with or without the namespace parameter (which defines the namespace
  where the original function is defined). If the namespace parameter is not provided
  then assume the global namespace _G.
  
  The wrapped function cannot be local - I mean, what's the point?
  
  Parameters:
    namespace - (optional) when provided, this is a table where the function to be wrapped resides. If not provided, the global namespace _G is assumed.
    functionName - a string with the name of the function to be wrapped (used as a key to the namespace table)
    wrapper - a function which accepts a function, followed by the parameters that the original function expects to be provided. Therefore the wrapped function can call the original function if it wishes to.
  
  Examples:
    WrapFunction(myfunc, mywrapper)
      will wrap the global function myfunc to call mywrapper
    
    WrapFunction(TT, myfunc, mywrapper)
      will wrap TT.myfunc with a call to mywrapper
]]
function sfutil.WrapFunction(namespace, functionName, wrapper)
    if type(namespace) == "string"  then
        -- We did not get a namespace parameter,
        -- shift the values to their proper places.
        wrapper = functionName
        functionName = namespace
        namespace = _G
    elseif type(namespace) ~= "table" then
        -- invalid parameters
        return nil
    end
    local originalFunction = namespace[functionName]
    namespace[functionName] = function(...) 
			return wrapper(originalFunction, ...) 
		end
end

---------------------
-- Recursively initialize missing values in a table from
-- a defaults table. Existing values in the svtable will
-- remain unchanged.
function sfutil.defaultMissing(svtable, defaulttable)
    if svtable == nil then return sfutil.deepCopy(defaulttable) end
	if type(svtable) ~= 'table' then return end
	if type(defaulttable) ~= 'table' then return end
	
	for k,v in pairs(defaulttable) do
		if( svtable[k] == nil ) then 
			if( type( defaulttable[k] )=='table' ) then
				svtable[k] = {}
				sfutil.defaultMissing( svtable[k], defaulttable[k])
			else
				svtable[k] = defaulttable[k]
			end
		end
	end
end

---------------------
-- Recursively copy contents of a table into a new table
function sfutil.deepCopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[sfutil.deepCopy(orig_key)] = sfutil.deepCopy(orig_value)
		end
		setmetatable(copy, sfutil.deepCopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

---------------------
-- turn a boolean value into a string
-- suitable for display
function sfutil.bool2str(bool)
	if( sfutil.isTrue(bool) ) then
		return "true"
	end
	return "false"
end

---------------------
-- a non-lua default test for value is true where
-- the value true is only returned if val was some
-- value equivalent to true or 1
-- Any other value will return false
function sfutil.isTrue(val)
	-- must be a variety of true value
	if(val == 1 or val == "1" or val == true or val == "true") then
		return true
	end
	return false
end

---------------------
-- return the value of val; unless it is nil when we 
-- then will return defaultval instead of the nil.
--
-- The var = val or default does not do the same job,
-- because if val evaluates to false according to lua then
-- the default value would be assigned.
-- Here we specifically only want the default value if
-- val == nil.
function sfutil.nilDefault( val, defaultval )
	if( val == nil ) then
		return defaultval
	end
	return val
end

-- ------------------------------------------------------
-- Guild functions

-- SafeGetGuildName(index)
--    where index is 1..5
--
-- returns: guild name, guild Id
--     or  "Invalid guild x", nil if no such guild
--
-- does not return nil for name! - if bad then return nil guildId
function sfutil.SafeGetGuildName(index)

    -- Guildname
    local guildId = GetGuildId(index)
    if not guildId then 
        return ("Invalid guild " .. index),nil
    end
    local guildName = GetGuildName(guildId)

    -- Occurs sometimes
    if(not guildName or (guildName):len() < 1) then
        guildName = "Guild " .. guildId
    end
    return guildName, guildId
end

-- Get list of all active guild names in index order (1..5)
function sfutil.GetActiveGuildNames()
	local guildList = {}
	local numGuilds = GetNumGuilds()
	if numGuilds > 0 then
		local name, id
		for guild = 1, numGuilds do
			name, id = sfutil.SafeGetGuildName(guild)
			table.insert(guildList, name)
		end
	end	
	return guildList
end

-- Get list of all active guild ids in index order (1..5)
function sfutil.GetActiveGuildIds()
	local guildList = {}
	local numGuilds = GetNumGuilds()
	if numGuilds > 0 then
		local name, id
		for guild = 1, numGuilds do
			name, id = sfutil.SafeGetGuildName(guild)
			table.insert(guildList, id)
		end
	end	
	return guildList
end

---------------------
-- MESSAGE / DEBUG --
---------------------
function sfutil.initSystemMsgPrefix(addon_name, hexcolor)
	hexcolor = sfutil.nilDefault(hexcolor, sfutil.hex.goldenrod)
	local prefix = sfutil.ColorText(addon_name, hexcolor)
	return prefix
end

function sfutil.systemMsg(prefix, text, hexcolor)
	hexcolor = sfutil.nilDefault(hexcolor, sfutil.hex.normal)
	msg = prefix..sfutil.ColorText(text, hexcolor)
	ZOS_addSystemMsg(msg)
end


sfutil.addonChatter = {}

function sfutil.addonChatter:New(addon_name)
	o = {} 
	setmetatable(o, self)
	self.__index = self
    
	o.prefix = sfutil.ColorText(sfutil.str("[",addon_name,"] "), sfutil.hex.goldenrod)
    o.namecolor = sfutil.hex.goldenrod
	o.normalcolor = sfutil.hex.mocassin
	o.debugcolor = sfutil.hex.ltskyblue
    o.d = function(...) end    -- debug messages off by default
	o.isdbgon = false
    return o
end

function sfutil.addonChatter:disableDebug()
	self.isdbgon = false
    self.d = function(...)
        end
end
-- print normal messages to chat
function sfutil.addonChatter:systemMessage(...)
	local msg = self.prefix..sfutil.ColorText(sfutil.dstr(" ",...), self.normalcolor)
	ZOS_addSystemMsg(msg)
end

-- print debug messages to chat
function sfutil.addonChatter:debugMsg(...)
    if( self.isdbgon == true ) then
        local msg = sfutil.ColorText(sfutil.dstr(" ",...), self.debugcolor)
        ZOS_addSystemMsg(self.prefix..msg)
    end
end

function sfutil.addonChatter:enableDebug()
	self.isdbgon = true
    self.d = function(...)
			local msg = sfutil.ColorText(sfutil.dstr(" ",...), self.debugcolor)
			ZOS_addSystemMsg(self.prefix..msg)
        end
end

function sfutil.addonChatter:toggleDebug()
    if( self.isdbgon == true ) then
		self:disableDebug()
	else
		self:enableDebug()
	end
end

function sfutil.addonChatter:getDebugState()
	-- as a debug function, this returns a string
	return sfutil.bool2str(self.isdbgon)
end

-- -------------------------------------------------------
-- Slash utilities

-- display in chat a table of slash commands with descriptions
-- (using the addonChatter)
function sfutil.addonChatter:slashHelp(title, cmdstable)
	local sysmsg = function (cmd, desc) 
        cmd = sfutil.ColorText(cmd, sfutil.hex.teal)
        if( type(desc) == "number" ) then
        	desc = GetString(desc)
		end
        desc = sfutil.ColorText(" = "..sfutil.str(desc), self.normalcolor)
        local msg = sfutil.dstr( " ", self.prefix, cmd, desc )
        ZOS_addSystemMsg(msg);
	end
	
    self:systemMessage(title)
    for index, value in pairs(cmdstable) do
        sysmsg(value[1], value[2])
    end
end


-- -----------------------------------------------------------------------
-- sound choice utilities

-- initSounds() is the only function to modify these tables in any way,
-- and they are never nil.
local soundChoices = {}     -- contains [index] value=SOUNDS.xxx
local soundReverse = {}     -- contains [SOUNDS.xxx] index

-- This function loads a pair of "singleton" arrays of sounds
-- from the ZOS SOUNDS map
--
-- An addon may call this (on loading), or may rely on the
-- other sfutil sound functions to call it. If it has already
-- run once, it does not do so again.
--
function sfutil.initSounds(force)
    if force == true then soundChoices={} end
    -- load sound keys to table
    if next(soundChoices) == nil then  
        for k,_ in pairs(SOUNDS) do
            local ndx = #soundChoices+1
            soundChoices[ndx] = k
        end
        table.sort(soundChoices)
        for i,k in pairs(soundChoices) do
            soundReverse[k] = i
        end
    end
end

-- provide the max number of sounds provided by ZOS
-- that were loaded into the soundChoices array
--
function sfutil.numSounds()
    sfutil.initSounds()
    return #soundChoices
end

-- Get the soundChoices index number for a SOUNDS.xxx value.
--
-- Useful for setting a slider value from a saved (string) sound entry.
function sfutil.getSoundIndex(sound, fallback)
    if not fallback then fallback = SOUNDS.DEFAULT_CLICK end
    
    sfutil.initSounds()
    if not soundReverse[fallback] then fallback = SOUNDS.DEFAULT_CLICK end
    
    local ndx = soundReverse[sound]
    if not ndx then return soundReverse[fallback] end
    return ndx
end

-- Given an index number, get the sound entry out of the
-- soundChoices array
function sfutil.getSound(index)
    sfutil.initSounds()
    local sound = soundChoices[index]
    if not sound then return "nil" end
    return sound
end

-- Play a sound selected by index number into a list 
-- of all of the games sounds we have access to or SOUNDS.xxx entry.
-- If the index is out-of-bounds or SOUNDS.xxx is nil, do not play a sound.
--
-- Note that at present, the SOUNDS array has TWO entries
-- for "No_Sound", which will "play" silence.
--
function sfutil.PlaySound(index)
    if not index then return end
    
    if type(index) == "number" then
    	-- we have an index into our soundChoices array
    	-- so, make sure it exists (once).
    	sfutil.initSounds()
        if soundChoices[index] == nil then return end
        PlaySound(soundChoices[index])
        
    elseif type(index) == "string" then
        if SOUNDS[index] ~= nil then
        	-- we got a sound name (index into the SOUNDS array)
            PlaySound(SOUNDS[index])
            
        else
        	-- presume we have a string that was stored in a SOUNDS.xxx
            PlaySound(index)
        end
    end
end    

-- -----------------------------------------------------------------------
-- Utility for parsing delimited strings

-- Split a string into sections using a pattern as a delimiter
-- When delimiter starts or ends the string, an empty string is considered
-- to be before/after the delimiter. When two or more delimiters are together,
-- there is considered to be empty strings between them.
--   str = string
--   pat = delimiter pattern
--
-- Returns table of strings that were separated by delimiters
-- (The delimiters are NOT included in the table.)
function sfutil.gsplit(str, pat)
   local t1 = {}  
   if not str then return {} end
   
   if not pat or pat == '' then 
       -- special case - no delimiter
       return {str}
   end
   
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s1, e1, cap = str:find(fpat, 1)
   
   if not s1 then 
       -- special case - string does not contain delimiter
       table.insert(t1,str); 
       return t1
   end
   
   while s1 do
        if not cap then
           -- delimiter was the beginning of the string
           -- so first capture is empty string
           cap = ""
        end
        -- save the front captured piece of the string
        table.insert(t1,cap)
        last_end = e1+1
        s1, e1, cap = str:find(fpat, last_end)
   end
   -- we have run out of delimiters to find
   if last_end-1 <= #str then
        -- still have the last piece of string without delimiters
        cap = str:sub(last_end)
        table.insert(t1, cap)
    end
   return t1
end

-- -----------------------------------------------------------------------
-- Utilities for parsing colors in chat messages

-- Get the positions of all of the color markers (|c and |r) in a string
-- Return a table where each entry has the index into the string (start)
-- and the type of marker (code = "c" or "r", lower case)
-- Havok allows "|" escape character for "|" (user input) so we must handle doubled pipes for chat.
--
-- Returns the markertable for the markers that are in the string
--   (can be empty but never nil)
-- where table entry is { start, estr, code } and 
--   start is the beginning of the string section for this entry
--   estr is the end of the string section for this entry (section includes the trailing color code for |c).
--   code is either "c" or "r" (lower case)
function sfutil.getAllColorDelim(str)
    if not str then return {} end
    
    -- get positions of all of the desired delimiters
    local t1 = {}  
   
    local s1, e1, c = str:find("|+([CcRr])", 1)
    local strlen = #str
    while s1 do
        if s1 == strlen then break end
        
        local code = string.lower(c)
        if code == "c" then
            e1 = e1 + 6     -- include color code
        end
        table.insert(t1,{start=s1,estr=e1,code=code} )
        -- look for next
        s1, e1, c = str:find("|+([CcRr])", e1)
    end
    -- we have run out of delimiters to find
    return t1
end

-- Evaluate and correct the color markers in the string so that
-- empty colors are marked for removal, "|c" markers are 
-- always balanced by "|r" markers, and we don't have extra "|r"
-- markers
--
-- Uses the source string and a marker table as produced by 
-- getAllColorDelim(). The marker table is modified by this function.
--
-- Returns the modified markertable for the markers that are in (or should be in) the string
-- where table entry is { start, estr, code, action } and 
--   action is nil (keep), "+" (add), or "-" (remove);
--   estr is the end of the string section for this entry.
function sfutil.regularizeColors(markertable, str)
    if not str then return {} end
    if not markertable or #markertable == 0 then return {} end
   -- clean positions
    local prev_v, sv_start
    local needR = false
    for k, v in ipairs(markertable) do
        sv_start = v.start
        if v.code == "r" then
            if needR == false then
                -- don't need this |r so mark for removal
                v.action = "-"
            else
                needR = false
            end
        elseif v.code == "c" then
            if needR == true then
                -- we are already in a color so we need to add a |r to close it
                v = {start=sv_start,estr=sv_start,code="r",action="+"}
                table.insert(markertable,k,v)
                needR = false
                -- the color we were processing has been bumped to next, so we will process it again.
            else
                needR = true
            end
        end
        
        -- filter out empty colors. At this point if prev_v.code == "c" then v.code == "r".
        if prev_v and prev_v.code == "c" and prev_v.estr + 1 == sv_start then
            -- mark both this "|r" and the previous "|c" for removal
            prev_v.action="-"
            v.action="-"
        end
        prev_v = v
    end
    -- we've reached the end of the markertable
    if needR == true then
        -- we still need a |r, so append one
        table.insert(markertable,{start=#str+1,estr=#str+1,action="+",code="r"})
    end
    return markertable
end

function sfutil.applyColor(str, colorhex)
    if not str then return nil end
    if not colorhex then return str end
    
    local parsetbl = sfutil.getAllColorDelim(str)
    sfutil.regularizeColors(parsetbl, str)
    local newtbl = {}
    local incolor = false
    for k,v in ipairs(parsetbl) do
        if string.find(str,"|+[Cc]",v) then
            -- starting embedded color
            if incolor == true then
                newtbl[#newtbl] = "|r"
                incolor = false
            end
            newtbl[#newtbl] = v
        elseif string.find(str,"|+[Rr]",v) then
            -- exitting embedded color
            newtbl[#newtbl] = v
            newtbl[#newtbl] = string.format("|c%s",colorhex)
            incolor = true
        else
            if incolor == false then
                newtbl[#newtbl] = string.format("|c%s",colorhex)
                incolor = true
            end
            newtbl[#newtbl] = v
        end
    end
    return table.concat(new)
end

-- Strip all of the color markers out of the string.
-- Uses the source string and a marker table as produced by 
-- getAllColorDelim().
--
-- Returns a string which is the source string with all of the color
-- markers removed.
--
-- Havok allows "|" escape character for "|" (user input) so we must handle doubled pipes.
function sfutil.stripColors(markertable,str)
    if not str then return nil end
    if not markertable or #markertable == 0 then return str end
    
    local t2 = {}
    local lastv = 0
    for k,v in ipairs(markertable) do
        local code = v.code
        local action = v.action
        if not action then
            -- it's a section we're keeping
            -- string fragment
            if code == "c" then
                if v.start > lastv+1 then
                    table.insert(t2,str:sub(lastv+1,v.start-1))
                end
                ss, es = string.find(str,"|+[Cc]%x%x%x%x%x%x",v.start)
                lastv = es
            elseif code == "r" then
                -- end color
                if v.start > lastv+1 then
                    table.insert(t2,str:sub(lastv+1,v.start-1))
                end
                ss, es = string.find(str,"|+[Rr]",v.start)
                lastv = es
            else
                -- uninteresting
            end
        elseif action == "+" then
            -- new string fragment (|r)
            if v.start > lastv+1 then
                table.insert(t2,str:sub(lastv+1,v.start-1))
            end
            lastv = v.start + 1
        else    -- action == "-"
            if code == "c" then
                ss, es = string.find(str,"|+[Cc]%x%x%x%x%x%x",v.start)
                lastv = es
            elseif code == "r" and v.start ~= -1 then
                ss, es = string.find(str,"|+[Rr]",v.start)
                lastv = es
            end
        end
    end
    if lastv <= #str then
        lastv = lastv +1
        table.insert(t2,str:sub(lastv))
    end
    return table.concat(t2)
end

-- Splits the string into sections corresponding the color markers themselves
-- and the text around the markers. Doing a table.concat() will join the contents
-- of the returned table into a properly color-marked string.
-- Returns the table of sections
function sfutil.colorsplit(markertable, str)
    if not str then return {} end
    if not markertable or #markertable == 0 then
        -- no delimiters in string
        return { str }
    end
    
    -- break string into sections with color markers separated out
    local t2 = {}
    local lastv = 0
    local ss, es, cs
    for k,v in ipairs(markertable) do
        local code = v.code
        local action = v.action
        if not action then
            -- it's a section we're keeping
            if v.start > lastv+1 then
                table.insert(t2,str:sub(lastv+1,v.start-1))
            end
            -- string fragment
            if code == "c" then
                -- expect color
                ss, es, cs = string.find(str,"|+[Cc](%x%x%x%x%x%x)",v.start)
                table.insert(t2, string.format("|c%s",cs))
                lastv = es
            elseif code == "r" then
                -- end color
                ss, es = string.find(str,"|+[Rr]",v.start)
                table.insert(t2,"|r")
                lastv = es
            end
        elseif action == "+" then
            -- new string fragment (|r)
            if v.start > lastv+1 then
                table.insert(t2,str:sub(lastv+1,v.start-1))
            end
            table.insert(t2,"|r")
            lastv = v.start + 1
        else    -- action == "-"
            if code == "c" then
                ss, es = string.find(str,"|+[Cc]%x%x%x%x%x%x",v.start)
                lastv = es
            elseif code == "r" and v.start ~= -1 then
                ss, es = string.find(str,"|+[Rr]",v.start)
                lastv = es
            end
        end
    end
    if lastv <= #str then
        lastv = lastv +1
        table.insert(t2,str:sub(lastv))
    end
    return t2
end

