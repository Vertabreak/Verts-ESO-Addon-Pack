-- LibMotif: Provide data about motifs that the ESO API does not.
--
-- Originally broken out from WritWorthy to hold motif knowledge
-- achievement_id numbers.

LibMotif = LibMotif or {}

LibMotif.name = "LibMotif"

-- There's nothing here.
-- The data you seek is in LibMotif_Data.lua


-- Optional Helper Function --------------------------------------------------

-- Does the current character know this crafting motif for
-- axes, chests, whatever?
--
-- motif_id is a motif number, range [1..117].
--
-- page_num is a purple motif page index, [1..14].
--
function LibMotif.IsKnown(motif_id, page_num)
    local m = LibMotif.DATA[motif_id]
    if not m then return false end

                        -- Original 9 simple racial motifs (orc, wood elf, ...)
                        -- and any newer crown-exclusives (frostcaller,...)
                        -- can only be learned all at once from a full book.
    local is_known = false
    if m.is_simple then
        is_known = IsSmithingStyleKnown(motif_id)
    end

                        -- Most motifs are learned piecemeal, one page at a time.
    if (not is_known) and m.achievement_id then
        local _, completed_ct = GetAchievementCriterion(
                                  m.achievement_id
                                , page_num)
        is_known = 0 < completed_ct
    end

    return is_known
end



