local DTAddon = _G['DTAddon']
local L = {}

--------------------------------------------------------------------------------------------------------------------
-- Italian (Needs human translation!)
--------------------------------------------------------------------------------------------------------------------

-- General Strings
	L.DTAddon_Title			= "Tracciamento Prigione"
	L.DTAddon_CNorm			= "Completato normale:"
	L.DTAddon_CVet			= "Veterano completato:"
	L.DTAddon_CNormI		= "Completato normale I:"
	L.DTAddon_CNormII		= "Completato Normale II:"
	L.DTAddon_CVetI			= "Veterano I completato:"
	L.DTAddon_CVetII		= "Completato Veteran II:"
	L.DTAddon_CGChal		= "Completata la sfida di gruppo:"
	L.DTAddon_CDBoss		= "Tutti i Capos sconfitti:"
	L.DTAddon_Unlock		= "Sblocca a livello: "
	L.DTAddon_DBUpdate		= "Il database di Dungeon Tracker è stato resettato da questa versione.\nAccedere a ciascun personaggio per ricostruire."

-- Account Options
	L.DTAddon_GOpts			= "Opzioni globali"
	L.DTAddon_COpts			= "Opzioni di carattere"
	L.DTAddon_SHMComp		= "Mostra il completamento della modalità Difficile"
	L.DTAddon_SHMCompD		= "Mostra un'icona dopo il nome dei personaggi che hanno completato il successo di Prigione Veterano o Prova Modalità Difficile per il prigione/prova evidenziato."
	L.DTAddon_STTComp		= "Mostra completamento prova a tempo"
	L.DTAddon_STTCompD		= "Mostra un'icona dopo il nome dei personaggi che hanno completato l'achievement Prigione Veterano o Prova a Tempo per il prigione/prova evidenziato."
	L.DTAddon_SNDComp		= "Non mostrare il completamento della morte"
	L.DTAddon_SNDCompD		= "Mostra un'icona dopo il nome dei personaggi che hanno completato l'achievement Prigione Veterano o Prova Nessuna Morte per il prigione/prova evidenziato."
	L.DTAddon_SGFComp		= "Completamento della faglia Prigione"
	L.DTAddon_SGFCompD		= "Mostra il progresso del personaggio attuale verso il completamento di tutti i prigione di gruppo nella fazione del prigione evidenziato. Richiede Traccia Carattere."
	L.DTAddon_CNColor		= "Colore nome completato:"
	L.DTAddon_CNColorD		= "Seleziona il colore per i nomi dei personaggi che hanno completato un determinato risultato."
	L.DTAddon_NNColor		= "Nome Nome incompleto:"
	L.DTAddon_NNColorD		= "Seleziona il colore per i nomi dei personaggi che NON hanno completato un determinato risultato."
	L.DTAddon_ALPHAN		= "Alfabetizza la lista dei nomi"
	L.DTAddon_ALPHAND		= "Quando è abilitato, gli elenchi di completamento del tooltip saranno alfabetizzati. Altrimenti l'ordine della lista corrisponde all'ordine dei tuoi personaggi nella schermata di accesso."
	L.DTAddon_CTDROPDOWN	= "Formato per il testo di completamento"
	L.DTAddon_CTDROPDOWND	= "Scegli se visualizzare solo i personaggi che hanno completato i risultati del target, solo quelli che non hanno o entrambi (predefinito)."
	L.DTAddon_CTOPT1		= "Mostra entrambi"
	L.DTAddon_CTOPT2		= "Solo completato"
	L.DTAddon_CTOPT3		= "Solo incompleto"
	L.DTAddon_SLFGt			= "LFG: Mostra Completamento del Prigione"
	L.DTAddon_SLFGtD		= "Mostra l'elenco di personaggi che hanno completato un Prigione nel tooltip di Trova gruppo."
	L.DTAddon_SLFGd			= "LFG: Mostra la Descrizione del Prigione"
	L.DTAddon_SLFGdD		= "Mostra la descrizione del gioco del prigione sulle descrizioni dei comandi LFG. Questo è normalmente nascosto."
	L.DTAddon_SNComp		= "MAPPA: Completamento del Prigione Normale"
	L.DTAddon_SNCompD		= "Mostra l'elenco dei caratteri che hanno completato Prigione o Prova in modalità Normale nella descrizione comando. Tieni premuto shift per passare da una versione di dungeon (I o II) durante la visualizzazione delle descrizioni dei comandi per sotterranei con più versioni."
	L.DTAddon_SVComp		= "MAPPA: Completamento di Dungeon veterano"
	L.DTAddon_SVCompD		= "Mostra l'elenco dei personaggi che hanno completato il Prigione o Prova in modalità Veterano nel suggerimento. Tenere premuto shift per passare da una versione prigione (I o II) alla visualizzazione delle descrizioni dei comandi per sotterranei con più versioni."
	L.DTAddon_SGCComp		= "MAPPA: Elimina il Completamento della Sfida di Gruppo"
	L.DTAddon_SGCCompD		= "Mostra l'elenco dei personaggi che hanno completato il punto abilità approfondire Sfida di gruppo nella descrizione comando."
	L.DTAddon_SDBComp		= "MAPPA: Elimina il Completamento del Capo"
	L.DTAddon_SDBCompD		= "Mostra l'elenco dei personaggi che hanno sconfitto tutti i boss di Delve nel tooltip."
	L.DTAddon_SDFComp		= "MAPPA: Completa il Completamento delle Fazioni"
	L.DTAddon_SDFCompD		= "Mostra il progresso del personaggio attuale verso il completamento di tutte le deviazioni nella fazione del segmento evidenziato. Richiede Traccia Carattere."

-- Character Options
	L.DTAddon_CTrack		= "Traccia il personaggio"
	L.DTAddon_CTrackD		= "Traccia questo personaggio nell'elenco dei nomi che hanno completato (o meno) un risultato selezionato."
	L.DTAddon_DCChar		= "Elimina i dati del personaggio:"
	L.DTAddon_DELETE		= "ELIMINA"
	L.DTAddon_CDELD			= "Rimuovi il personaggio selezionato dal database di tracciamento. Se rimuovi un personaggio ancora esistente qui, verranno automaticamente impostati per non tracciare. Accedere come carattere e riattivare il tracciamento in Opzioni carattere per aggiungerli nuovamente al database."

------------------------------------------------------------------------------------------------------------------

if (GetCVar('language.2') == 'it') then -- overwrite GetLanguage for new language
	for k,v in pairs(DTAddon:GetLanguage()) do
		if (not L[k]) then -- no translation for this string, use default
			L[k] = v
		end
	end

	function DTAddon:GetLanguage() -- set new language return
		return L
	end
end
