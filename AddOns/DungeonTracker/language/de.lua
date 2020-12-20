local DTAddon = _G['DTAddon']
local L = {}

--------------------------------------------------------------------------------------------------------------------
-- German translation by ESOUI.com user Baertram. (Non-indented lines still need human translation!)
--------------------------------------------------------------------------------------------------------------------

-- General Strings
	L.DTAddon_Title			= "Verlies Verfolgung"
	L.DTAddon_CNorm			= "Abgeschlossen Normal:"
	L.DTAddon_CVet			= "Abgeschlossener Veteran:"
	L.DTAddon_CNormI		= "Abgeschlossen Normal I:"
	L.DTAddon_CNormII		= "Abgeschlossen Normal II:"
	L.DTAddon_CVetI			= "Abgeschlossener Veteran I:"
	L.DTAddon_CVetII		= "Abgeschlossener Veteran II:"
	L.DTAddon_CGChal		= "Abgeschlossene Gruppen Herausforderung:"
	L.DTAddon_CDBoss		= "Alle Bosse Besiegt:"
L.DTAddon_Unlock			= "Freigeschaltet auf Stufe: "
L.DTAddon_DBUpdate		= "Die Dungeon Tracker-Datenbank wurde in dieser Version zurückgesetzt.\nBitte melde dich bei jedem Charakter an, um es neu zu erstellen."

-- Account Options
	L.DTAddon_GOpts			= "Globale Optionen"
	L.DTAddon_COpts			= "Charakter Optionen"
L.DTAddon_SHMComp		= "Show Hard-Modus-Abschluss"
L.DTAddon_SHMCompD		= "Zeige ein Symbol nach dem Namen der Charaktere, die den Veteranen Verlies oder Test im harten Modus für den markierten verlies/versuch erreicht haben."
L.DTAddon_STTComp		= "Zeigen Sie Abschluss des Testzeitraums"
L.DTAddon_STTCompD		= "Zeige ein Symbol nach dem Namen der Charaktere, die den Veteranen Verlies oder Zeitlicher Test für den markierten verlies/versuch erreicht haben."
L.DTAddon_SNDComp		= "Zeige keine Todesbeendigung"
L.DTAddon_SNDCompD		= "Zeige ein Symbol nach dem Namen der Charaktere, die den Veteranen Verlies oder Prozess Kein Tod für den markierten verlies/versuch erreicht haben."
	L.DTAddon_SGFComp		= "Fraktion - Dungeon Fertigstellungsgrad"
	L.DTAddon_SGFCompD		= "Zeigt den aktuellen Charakterfortschritt für den Abschluss aller Gruppen-Dungeons in der Fraktion des hervorgehobenen Dungeons an.\n\nErfordert 'Charakterverfolgung'"
	L.DTAddon_CNColor		= "Name - Abgeschlossen Farbe:"
	L.DTAddon_CNColorD		= "Wählen Sie die Farbe für die Namen der Charaktere aus, welche eine bestimmte Leistung abgeschlossen haben."
	L.DTAddon_NNColor		= "Name - Unvollständig Farbe:"
	L.DTAddon_NNColorD		= "Wählen Sie die Farbe für die Namen der Charaktere aus, welche eine bestimmte Leistung NICHT abgeschlossen haben."
L.DTAddon_ALPHAN		= "Alphabetisch Namensliste"
L.DTAddon_ALPHAND		= "Wenn aktiviert, werden die Tooltip-Vervollständigungslisten alphabetisch sortiert. Andernfalls stimmt die Reihenfolge der Liste mit der Reihenfolge Ihrer Zeichen auf dem Anmeldebildschirm überein."
L.DTAddon_CTDROPDOWN	= "Format für den Fertigstellungstext"
L.DTAddon_CTDROPDOWND	= "Wählen Sie aus, ob nur Charaktere angezeigt werden sollen, die die Zielerreichung abgeschlossen haben, nur diejenigen, die dies noch nicht getan haben, oder beides (Standard)."
L.DTAddon_CTOPT1		= "Zeig beides"
L.DTAddon_CTOPT2		= "Nur abgeschlossen"
L.DTAddon_CTOPT3		= "Nur unvollständig"
L.DTAddon_SLFGt			= "LFG: Zeigt die Fertigstellung des Verlies"
L.DTAddon_SLFGtD		= "Zeige die Liste der Charaktere, die einen Verlies im Gruppenfinder-Tooltip abgeschlossen haben."
L.DTAddon_SLFGd			= "LFG: Zeige Verlies Beschreibung"
L.DTAddon_SLFGdD		= "Zeigen Sie die Spielbeschreibung des Spiels in den LFG-Tooltips an. Dies ist normalerweise verborgen."
L.DTAddon_SNComp		= "KARTE: Normale Verlies-Vervollständigung"
L.DTAddon_SNCompD		= "Liste der Charaktere anzeigen, die den Verlies oder Versuch im Normalmodus im Tooltip abgeschlossen haben. Halten Sie die Umschalttaste gedrückt, um zwischen den Dungeon-Versionen (I oder II) zu wechseln, wenn Sie Tooltips für Verliese mit mehreren Versionen anzeigen."
L.DTAddon_SVComp		= "KARTE: Veteranen Dungeon Abschluss"
L.DTAddon_SVCompD		= "Liste der Charaktere anzeigen, die den Verlies oder Versuch im Veteranenmodus im Tooltip beendet haben. Halten Sie die Umschalttaste gedrückt, um zwischen den verlies-Versionen (I oder II) zu wechseln, wenn Sie Tooltips für Verliese mit mehreren Versionen anzeigen."
L.DTAddon_SGCComp		= "KARTE: Delve Gruppenherausforderung Abgeschlossen"
L.DTAddon_SGCCompD		= "Zeige eine Liste von Charakteren, die die Gruppen-Challenge-Aufgabe in der Tooltip abgeschlossen haben."
L.DTAddon_SDBComp		= "KARTE: Abschluss des Chefs abschließen"
L.DTAddon_SDBCompD		= "Zeige eine Liste der Charaktere, die im Tooltip alle Bosse der Höhle besiegt haben."
L.DTAddon_SDFComp		= "KARTE: Fraktionsvervollständigung abschließen"
L.DTAddon_SDFCompD		= "Zeigen Sie den Fortschritt des aktuellen Charakters in Richtung des Abschlusses aller Bereiche in der Fraktion des markierten Bereichs. Benötigt Titelzeichen."

-- Character Options
	L.DTAddon_CTrack		= "Charakterverfolgung"
	L.DTAddon_CTrackD		= "Verfolgen Sie diesen Charakter in der Liste der Namen, die eine ausgewählte Leistung abgeschlossen haben oder nicht."
L.DTAddon_DCChar		= "Löschen der Daten des Charakters:"
L.DTAddon_DELETE		= "LÖSCHEN"
L.DTAddon_CDELD			= "Entfernen Sie das ausgewählte Zeichen aus der Tracking-Datenbank. Wenn Sie hier ein noch vorhandenes Zeichen entfernen, werden diese automatisch so eingestellt, dass sie nicht nachverfolgt werden. Logge dich als Charakter ein und aktiviere das Tracking erneut unter Zeichenoptionen, um sie wieder zur Datenbank hinzuzufügen."

------------------------------------------------------------------------------------------------------------------

if (GetCVar('language.2') == 'de') then -- overwrite GetLanguage for new language
	for k,v in pairs(DTAddon:GetLanguage()) do
		if (not L[k]) then -- no translation for this string, use default
			L[k] = v
		end
	end
	function DTAddon:GetLanguage() -- set new language return
		return L
	end
end
