local DTAddon = _G['DTAddon']
local L = {}

--------------------------------------------------------------------------------------------------------------------
-- English
--------------------------------------------------------------------------------------------------------------------

-- General Strings
	L.DTAddon_Title			= "Dungeon Tracker"
	L.DTAddon_CNorm			= "Completed Normal:"
	L.DTAddon_CVet			= "Completed Veteran:"
	L.DTAddon_CNormI		= "Completed Normal I:"
	L.DTAddon_CNormII		= "Completed Normal II:"
	L.DTAddon_CVetI			= "Completed Veteran I:"
	L.DTAddon_CVetII		= "Completed Veteran II:"
	L.DTAddon_CGChal		= "Completed Group Challenge:"
	L.DTAddon_CDBoss		= "All Bosses Defeated:"
	L.DTAddon_Unlock		= "Unlocks at Level: "
	L.DTAddon_DBUpdate		= "Dungeon Tracker database was reset this version.\nPlease log into each character to rebuild."

-- Account Options
	L.DTAddon_GOpts			= "Global options"
	L.DTAddon_COpts			= "Character options"
	L.DTAddon_SHMComp		= "Show Hard Mode Completion"
	L.DTAddon_SHMCompD		= "Show an icon after the name of characters that have completed the Veteran Dungeon or Trial Hard Mode achievement for the highlighted dungeon/trial."
	L.DTAddon_STTComp		= "Show Time Trial Completion"
	L.DTAddon_STTCompD		= "Show an icon after the name of characters that have completed the Veteran Dungeon or Timed Trial achievement for the highlighted dungeon/trial."
	L.DTAddon_SNDComp		= "Show No Death Completion"
	L.DTAddon_SNDCompD		= "Show an icon after the name of characters that have completed the Veteran Dungeon or Trial No Death achievement for the highlighted dungeon/trial."
	L.DTAddon_SGFComp		= "Dungeon Faction Completion"
	L.DTAddon_SGFCompD		= "Show current character progress towards completing all Group Dungeons in the faction of the highlighted dungeon. Requires Track Character."
	L.DTAddon_CNColor		= "Completed Name Color:"
	L.DTAddon_CNColorD		= "Select color for the names of characters that have completed a given achievement."
	L.DTAddon_NNColor		= "Incomplete Name Color:"
	L.DTAddon_NNColorD		= "Select color for the names of characters that have NOT completed a given achievement."
	L.DTAddon_ALPHAN		= "Alphabetize Name List"
	L.DTAddon_ALPHAND		= "When enabled the tooltip completion lists will be alphabetized. Otherwise the list order matches the order of your characters on the login screen."
	L.DTAddon_CTDROPDOWN	= "Format for completion text"
	L.DTAddon_CTDROPDOWND	= "Choose whether to display only characters who have completed the target achievements, only those who have not, or both (default)."
	L.DTAddon_CTOPT1		= "Show both"
	L.DTAddon_CTOPT2		= "Only completed"
	L.DTAddon_CTOPT3		= "Only incomplete"
	L.DTAddon_SLFGt			= "LFG: Show Dungeon Completion"
	L.DTAddon_SLFGtD		= "Show list of characters that have completed a Dungeon in the Group Finder tooltip."
	L.DTAddon_SLFGd			= "LFG: Show Dungeon Description"
	L.DTAddon_SLFGdD		= "Display the game's description of the dungeon on the LFG tooltips. This is normally hidden."
	L.DTAddon_SNComp		= "MAP: Normal Dungeon Completion"
	L.DTAddon_SNCompD		= "Show list of characters that have completed the Dungeon or Trial on Normal mode in the tooltip. Hold shift to switch between dungeon versions (I or II) when viewing tooltips for dungeons with multiple versions."
	L.DTAddon_SVComp		= "MAP: Veteran Dungeon Completion"
	L.DTAddon_SVCompD		= "Show list of characters that have completed the Dungeon or Trial on Veteran mode in the tooltip. Hold shift to switch between dungeon versions (I or II) when viewing tooltips for dungeons with multiple versions."
	L.DTAddon_SGCComp		= "MAP: Delve Group Challenge Completion"
	L.DTAddon_SGCCompD		= "Show list of characters that have completed the delve skillpoint Group Challenge in the tooltip."
	L.DTAddon_SDBComp		= "MAP: Delve Boss Completion"
	L.DTAddon_SDBCompD		= "Show list of characters that have defeated all the delve's bosses in the tooltip."
	L.DTAddon_SDFComp		= "MAP: Delve Faction Completion"
	L.DTAddon_SDFCompD		= "Show current character progress towards completing all delves in the faction of the highlighted delve. Requires Track Character."

-- Character Options
	L.DTAddon_CTrack		= "Track Character"
	L.DTAddon_CTrackD		= "Track this character in the list of names that have completed (or not) a selected achievement."
	L.DTAddon_DCChar		= "Delete Character's Data:"
	L.DTAddon_DELETE		= "DELETE"
	L.DTAddon_CDELD			= "Remove selected character from the tracking database. If you remove a still-existing character here, they will be automatically set to not track. Log in as the character and re-enable tracking under Character Options to re-add them to the database."

------------------------------------------------------------------------------------------------------------------

function DTAddon:GetLanguage() -- default locale, will be the return unless overwritten
	return L
end
