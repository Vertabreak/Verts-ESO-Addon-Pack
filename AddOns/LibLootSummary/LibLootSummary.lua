-- LibLootSummary & its files copyright silvereyes                          --
-- Distributed under the MIT license (see LICENSE.txt)          --
------------------------------------------------------------------

LibLootSummary = { version = "2.2.3" }
local lls = LibLootSummary

--[[ Shortcut to creating a new LibLootSumary.List instance ]]--
function lls:New(...)
    return lls.List:New(...)
end
setmetatable(lls, { __call = function(_, ...) return lls.List:New(...) end })