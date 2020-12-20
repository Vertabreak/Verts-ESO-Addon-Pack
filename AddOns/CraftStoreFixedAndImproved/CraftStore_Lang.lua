local CS = CraftStoreFixedAndImprovedLongClassName
local lmb,rmb,mmb = '|t16:16:CraftStoreFixedAndImproved/DDS/lmb.dds|t','|t16:16:CraftStoreFixedAndImproved/DDS/rmb.dds|t','|t16:16:CraftStoreFixedAndImproved/DDS/mmb.dds|t'
local i,o = GetString('SI_ITEMTRAITTYPE',ITEM_TRAIT_TYPE_ARMOR_INTRICATE),GetString('SI_ITEMTRAITTYPE',ITEM_TRAIT_TYPE_ARMOR_ORNATE)

CS.Lang = {
de = {
	options = {
		showbutton = 'Zeigen Sie die CraftStore-Taste',
		lockbutton = 'Sperren Sie die CraftStore-Taste',
		lockelements = 'Sperren Sie die CraftStore-Elemente',
		closeonmove = 'CraftStore-Fenster bei Bewegung schließen',
		useartisan = 'CraftStoreArtisan benutzen (fehlt)',
		useflask = 'CraftStoreFlask benutzen (fehlt)',
		usequest = 'CraftStoreQuest anzeigen',
		usecook = 'CraftStoreCook benutzen',
		userune = 'CraftStoreRune benutzen',
		displaystyles = 'Itemstil im Tooltip anzeigen',
		markitems = 'Bedarf-Markierungen anzeigen',
		showsymbols = i..'/'..o..'-Symbole anzeigen',
		marksetitems = 'Sets für Forschung markieren',
		showstock = 'Lagerbestand im Tooltip anzeigen',
		stacksplit = 'Vorauswahl der Stapelaufteilung',
		markduplicates = 'Erlauben Markierungs-Duplikate für die Forschung',
		displayrunelevel = 'Anzeige Runenebene in Tooltips',
		displaymm = 'Anzeigen Master Merchant in Tooltips',
		displayttc = 'Anzeigen Tamriel Trade Centre in Tooltips',
		timeralarm = 'Timer Alarm anzeigen',
		mountalarm = 'Mount Alarm anzeigen',
		researchalarm = 'Forschungsalarm anzeigen',
		playrunevoice = 'Runen-Stimmen abspielen',
		advancedcolorgrid = 'Erweitertes farbcodiertes Raster',
		lockprotection = 'Aktivieren Sie den Sperrschutz',
		sortsets = 'Sets sortieren',
		sortstyles = 'Stile sortieren',
		bulkcraftlimit = 'Die Massenproduktion begrenzen',
		overviewstyle = 'Zeichenübersicht Stil',
		userunecreation = 'CraftStoreRune Schöpfung benutzen',
		useruneextraction = 'CraftStoreRune Extraktion benutzen',
		userunerecipe = 'CraftStoreRune Möbel benutzen',
		displayunknown = 'Anzeigen unbekannt in Tooltips',
		displayknown = 'Anzeigen bekannt in Tooltips',	
	},
	suboptions = {
		sortstyles = {
			[1] = "Alphabetisch",
			[2] = "Motiv #",
			[3] = "Intern #",
		},
		sortsets = {
			[1] = "Alphabetisch",
			[2] = "Merkmale",
		},
		alarms = {
			[1] = "Bekannt geben",
			[2] = "Plaudern",
			[3] = "Beide",
			[4] = "Aus",
		},
		overviewstyle = {
			[1] = "Komplett",
			[2] = "Schlank",
			[3] = "Minimal",
		},	
	},	
	TT = {
		'|cFFFFFF<<C:1>>|r\n|cE8DFAF'..lmb..' Forschung an- oder abwählen\n\n|t20:20:<<2>>|t|r |cFFFFFFGesamte <<C:3>>|r\n|cE8DFAF'..rmb..' Forschung an- oder abwählen|r', --1
		'|cE8DFAF'..lmb..' <<1>> x herstellen|r', --2
		'|cE8DFAF'..rmb..' <<1>> x herstellen|r', --3
		'|cE8DFAF'..mmb..' Zum Favoriten |r|t16:16:esoui/art/characterwindow/equipmentbonusicon_full.dds|t', --4
		'|cE8DFAF'..lmb..' Auswählen|r', --5
		'|cE8DFAF'..rmb..' Im Chat verlinken|r', --6
		'|cE8DFAF'..mmb..' Zutaten markieren|r', --7
		'|cE8DFAF'..lmb..' Glyphe zerlegen|r', --8
		'|cE8DFAF'..lmb..' Alle nicht hergestellen Glyphen zerlegen\n'..rmb..' Alle verfügbaren Glyphen zerlegen|r', --9
		'|cE8DFAF'..lmb..' Charakter auswählen\n'..rmb..' Als Hauptcharakter setzen\n'..mmb..' Charakter löschen!|r', --10
		'Favoriten', --11
		'Runen-Modus-Herstellung', --12
		'Verfolgt bekannte Stile', --13
		'Verfolgt bekannte Rezepte', --14
		'Zeige CraftStore', --15
		'Verfügbare Hehler-Aktionen und heutige Goldeinnahmen', --16
		'Magiergilde - Augvea - benutze ein Portal im Gebäude der Magiergilde', --17
		'Kriegergilde - Erdschmiede - benutze ein Portal im Gebäude der Kriegergilde', --18
		'Klicken, um zum nächsten Wegschrein der Set-Schmiede zu reisen', --19
		'|cFFFFFFReitfertigkeiten|r\nNutzlast und Ausdauer\nund Tempo', --20
		{'Jedes Gewässer','Trübes Wasser','Fluss','See','Ozean'}, --21
		'Alle Glyphen zerlegen', --22
		'Schrieb', --23
		'Möbel', --24
		'Verfolgt bekannte Merkmale', --25
		'|cE8DFAF'..lmb..' Möbel Vorschau|r', --26
		'|cE8DFAF'..rmb..' Möbel Vorschau|r', --27
		'|cE8DFAF'..rmb..' Stapel verfeinern|r', --28
		'|cFFFFFFFertigkeitspunkte|r\nNicht Ausgegeben/Insgesamt Verdient',--29
		'|cFFFFFFFP|r ',--30
		'|cFFFFFFHimmelsscherben|r\nGesammelt/Gesamt',--31
		'Verfolgt bekannte Blaupausen',--32
		'|cE8DFAF'..mmb..' Forschung|r',
		'|cE8DFAF'..lmb..' Verfolgen|r',
	},
	nobagspace = '|cFF0000Nicht genügend Platz im Inventar!|r',
	noItemPreview = '|cFF0000ItemPreview erforderlich!|r',
	noFurnitureData = '|cFF0000ItemPreview fehlt dieser Gegenstand.|r',
	noSlot = '|cFF0000Kein freier Forschungsschlitz oder Artikel unzugänglich!|r',
	blueprintSearchLimit = '|cFF0000Grenzen Sie Ihre Suche ein, um alle Ergebnisse anzuzeigen.|r',
	removeCurrentCharacter = '|cFF0000Aktueller Charakter kann nicht entfernt werden.|r',
	searchfor = 'Suche nach: ',
	finished = 'fertig',
	level = 'Stufe',
	rank = 'Rang',
	bank = 'Bank',
	housebank = 'Hausbank ',
	guildbank = 'Gildenbank',
	craftbag = 'Handwerksbeutel',
	chars = 'Charakter-Übersicht',
	set = 'Wähle ein Set aus...',
	unknown = 'unbekannt',
	knownStyles = 'Bekannte Stile',
	finishResearch = '<<C:1>> hat |c00FF00<<C:2>>|r |c00FF88(<<C:3>>)|r fertig erforscht.',
	finishMount = '<<C:1>> hat die Reitausbildung abgeschlossen.',
	finish12 = 'Der 12-Stunden-Countdown ist abgelaufen.',
	finish24 = 'Der 24-Stunden-Countdown ist abgelaufen.',
	itemsearch = 'Suche: <<C:1>> | <<c:2>> ... Angebote?',
	hideStyles = 'Einfache ausblenden',
	hideCrownStyles = 'Krone ausblenden',
	hideKnown = "Ausblenden bekannt",
	hideUnknown = "Verstecken unbekannt", 
	unselectedWayshrine = "|cFF0000Wähle ein herstellbaren set aus.|r",
	unknownWayshrine = "|cFF0000Kann nicht zu unentdecktem Wegschrein reisen.|r",   
	previewType = {"Schwer", "Mittel", "Leicht + Robe", "Leicht + Jacke"},
	styleNames = {},
	reload = "Benötigt Nachladen",
},
en = {
	options = {
		showbutton = 'Show CraftStore button',
		lockbutton = 'Lock CraftStore button',
		lockelements = 'Lock CraftStore elements',
		closeonmove = 'Close CraftStore window on movement',
		useartisan = 'Use CraftStoreArtisan (not ready)',
		useflask = 'Use CraftStoreFlask (not ready)',
		usequest = 'Use CraftStoreQuest',
		usecook = 'Use CraftStoreCook',
		userune = 'Use CraftStoreRune',
		displaystyles = 'Display itemstyle in tooltips',
		markitems = 'Mark needed items',
		showsymbols = 'Show '..i..'/'..o..'-symbols',
		marksetitems = 'Mark set-items for research',
		showstock = 'Show item stock in tooltip',
		stacksplit = 'Preselect stack-split',
		markduplicates = 'Mark duplicates for research',
		displayrunelevel = 'Display rune level in tooltips',
		displaymm = 'Show Master Merchant in tooltips',
		displayttc = 'Show Tamriel Trade Centre in tooltips',
		timeralarm = 'Show timer alarm',
		mountalarm = 'Show mount alarm',
		researchalarm = 'Show research alarm',
		playrunevoice = 'Play enchanting rune voices',
		advancedcolorgrid = 'Advanced color coded grid',
		lockprotection = 'Enable lock protection',
		sortsets = 'Sort sets',
		sortstyles = 'Sort styles',
		bulkcraftlimit = 'Bulk craft limit',
		overviewstyle = 'Character overview style',
		userunecreation = 'Use CraftStoreRune Creation',
		useruneextraction = 'Use CraftStoreRune Extraction',
		userunerecipe = 'Use CraftStoreRune Furniture',
		displayunknown = 'Display unknown in tooltips',
		displayknown = 'Display known in tooltips',
	},
	suboptions = {
		sortstyles = {
			[1] = "Alphabetically",
			[2] = "Motif #",
			[3] = "Internal #",
		},
		sortsets = {
			[1] = "Alphabetically",
			[2] = "Traits",
		},
		alarms = {
			[1] = "Announce",
			[2] = "Chat",
			[3] = "Both",
			[4] = "Off",
		},
		overviewstyle = {
			[1] = "Complete",
			[2] = "Slim",
			[3] = "Minimal",
		},
	},
	TT = {
		'|cFFFFFF<<C:1>>|r\n'..lmb..' Select/deselect research\n\n|t20:20:<<2>>|t |cFFFFFFEntire <<C:3>>|r\n'..rmb..' Select/deselect research',
		'|cE8DFAF'..lmb..' Craft x <<1>>|r',
		'|cE8DFAF'..rmb..' Craft x <<1>>|r',
		'|cE8DFAF'..mmb..' Mark as favorite |r|t16:16:esoui/art/characterwindow/equipmentbonusicon_full.dds|t',
		'|cE8DFAF'..lmb..' Select|r',
		'|cE8DFAF'..rmb..' Link in chat|r',
		'|cE8DFAF'..mmb..' Mark ingredients|r',
		'|cE8DFAF'..lmb..' Refine glyph|r',
		'|cE8DFAF'..lmb..' Refine all non-crafted glyphs\n'..rmb..' Refine all available glyphs|r',
		'|cE8DFAF'..lmb..' Select this character\n'..rmb..' Set this character as main character\n'..mmb..' Remove this character.',
		'Favorites',
		'Rune-Mode-Crafting',
		'Tracks known styles',
		'Tracks known recipes',
		'Show CraftStore',
		'Available fence transactions and today\'s income',
		'Mage Guild - Eyevea - use portal in the nearest Mage Guild building',
		'Fighters Guild - The Earth Forge - use portal in the nearest Fighters Guild building',
		'Click to travel to the nearest wayshrine of the set-crafting-station',
		'|cFFFFFFMount Skills|r\nCapacity, Stamina\nand Speed',
		{'Any Water','Foul Water','River','Lake','Ocean'},
		'Refine all glyphs',
		'Writ',
		'Furniture',
		'Tracks known traits',
		'|cE8DFAF'..lmb..' Furniture Preview|r',
		'|cE8DFAF'..rmb..' Furniture Preview|r',
		'|cE8DFAF'..rmb..' Refine stack|r',
		'|cFFFFFFSkill Points|r\nUnspent/Total Earned',--29
		'|cFFFFFFSP|r ',--30
		'|cFFFFFFSkyshards|r\nCollected/Total',--31
		'Tracks known blueprints',--32
		'|cE8DFAF'..mmb..' Research|r',
		'|cE8DFAF'..lmb..' Track|r',
	},
	nobagspace = '|cFF0000Not enough bagspace!|r',
	noSlot = '|cFF0000No free research slot or item inaccessible!|r',
	noItemPreview = '|cFF0000ItemPreview required!|r',
	noFurnitureData = '|cFF0000ItemPreview lacks this item.|r',
	blueprintSearchLimit = '|cFF0000Narrow your search to show all results.|r',
	removeCurrentCharacter = '|cFF0000Cannot remove current character.|r',
	searchfor = 'Search for: ',
	finished = 'finished',
	level = 'Level',
	rank = 'Rank',
	bank = 'Bank',
	housebank = 'House Bank ',
	guildbank = 'Guildbank',
	craftbag = 'Craft Bag',
	chars = 'Character-Overview',
	set = 'Choose a set...',
	unknown = 'unknown',
	knownStyles = 'Known styles',
	finishResearch = '<<C:1>> has finished |c00FF00<<C:2>>|r |c00FF88(<<C:3>>)|r research.',
	finishMount = '<<C:1>> has completed the mount training.',
	finish12 = 'The 12-hour-countdown has expired.',
	finish24 = 'The 24-hour-countdown has expired.',
	itemsearch = 'Looking for: <<C:1>> | <<c:2>> ... Offers?',
	hideStyles = 'Hide simple',
	hideCrownStyles = 'Hide crown',
	hideKnown = "Hide known",
	hideUnknown = "Hide unknown",
	unselectedWayshrine = "|cFF0000Choose a craftable set.|r",
	unknownWayshrine = "|cFF0000Cannot travel to undiscovered wayshrine.|r", 
	previewType = {"Heavy", "Medium", "Light + Robe", "Light + Jack"},
	provisioningWritOffset = 7,
	styleNames = {},
	reload = "Requires reload",
},
fr = {
	options = {
		showbutton = 'Bouton Show CraftStore',
		lockbutton = 'Bouton Verrouiller CraftStore',
		lockelements = 'Verrouiller les éléments CraftStore',
		closeonmove = 'Fermer la fenêtre au déplacement du personnage',
		useartisan = 'Utiliser CraftStoreArtisan (pas finalisé)',
		useflask = 'Utiliser CraftStoreFlask (pas finalisé)',
		usequest = 'Utiliser CraftStoreQuest',
		usecook = 'Utiliser CraftStoreCook',
		userune = 'Utiliser CraftStoreRune',
		displaystyles = 'Afficher le style racial dans le tooltip',
		markitems = 'Marquer les matériaux requis',
		showsymbols = 'Marquer les équipements '..i..'/'..o..' dans l\'inventaire',
		playrunevoice = 'Jouer voix runiques enchanteur',
		marksetitems = 'Marquer set-éléments pour la recherche',
		showstock = 'Afficher le stock dans le tooltip',
		stacksplit = 'Présélectionner l\'empilement fractionné',
		markduplicates = 'Autoriser le marquage des doublons pour la recherche',
		displayrunelevel = 'Afficher le niveau de Rune dans le tooltip',
		displaymm = 'Afficher Master Merchant dans le tooltips',
		displayttc = 'Afficher Tamriel Trade Centre dans le tooltips',
		timeralarm = 'Afficher l\'alarme de la minuterie',
		mountalarm = 'Afficher l\'alarme de montage',
		researchalarm = 'Afficher l\'alarme de recherche',
		advancedcolorgrid = 'Grille de couleur avancée',
		lockprotection = 'Activer la protection de verrouillage',
		sortsets = 'Trier les ensembles',
		sortstyles = 'Trier les styles',
		bulkcraftlimit = 'Limite de fabrication en vrac',
		overviewstyle = 'Style de présentation du personnage',
		userunecreation = 'Utiliser CraftStoreRune Création',
		useruneextraction = 'Utiliser CraftStoreRune Extraction',
		userunerecipe = 'Utiliser CraftStoreRune Meubles',
		displayunknown = 'Afficher l\'inconnu dans le tooltips',
		displayknown = 'Afficher connu dans le tooltips',		
	},
	suboptions = {
		sortstyles = {
			[1] = "Alphabétiquement",
			[2] = "Motif #",
			[3] = "Interne #",
		},
		sortsets = {
			[1] = "Alphabétiquement",
			[2] = "Traits",
		},
		alarms = {
			[1] = "Annoncer",
			[2] = "Bavarder",
			[3] = "Tous les deux",
			[4] = "éteint",
		},
		overviewstyle = {
			[1] = "Achevé",
			[2] = "Mince",
			[3] = "Minimal",
		},			
	},	
	TT = {
		'|cFFFFFF<<C:1>>|r\n'..lmb..' Sélectionner/désélectionner les recherches\n\n|t20:20:<<2>>|t |cFFFFFFToute la <<C:3>>|r\n'..rmb..' Sélectionner/désélectionner les recherches',
		'|cE8DFAF'..lmb..' Créer x <<1>>|r',
		'|cE8DFAF'..rmb..' Créer x <<1>>|r',
		'|cE8DFAF'..mmb..' Marquer comme favoris |r|t16:16:esoui/art/characterwindow/equipmentbonusicon_full.dds|t',
		'|cE8DFAF'..lmb..' Sélectionner',
		'|cE8DFAF'..rmb..' Créer un lien dans le chat|r',
		'|cE8DFAF'..mmb..' Marquer les ingrédients|r',
		'|cE8DFAF'..lmb..' Affiner la glyphe|r',
		'|cE8DFAF'..lmb..' Affiner tous les glyphes pas fabriqués\n'..rmb..' Affiner les glyphes tous disponibles|r',
		'|cE8DFAF'..lmb..' Sélectionner ce personnage\n'..rmb..'Choisir ce personnage comme personnage principal\n'..mmb..' Supprimer ce personnage!',
		'Favoris',
		'L\'utilisation en mode rune',
		'Rechercher les styles connus',
		'Rechercher les recettes connus',
		'Afficher CraftStore',
		'Transactions disponibles avec le receleur et gains du jour',
		'Eyévéa - Utiliser le portail du bâtiment de la Guilde des Mages le plus proche',
		'Forgeterre - Utiliser le portail du bâtiment de la Guilde des Guerriers le plus proche',
		'Voyager vers l\'Oratoire le plus proche de la station de fabrication du Set',
		'|cFFFFFFCompétence de monture|r\nCapacité et endurance\net Vitesse',
		{'Chaque Eaux','Eaux Usées','Débit','Lac','Ocean'},
		'Affiner les glyphes',
		'Ordonnance',
		'Meubles',
		'Trace les traits connus',
		'|cE8DFAF'..lmb..' Aperçu du mobilier|r',
		'|cE8DFAF'..rmb..' Aperçu du mobilier|r',
		'|cE8DFAF'..rmb..' Affiner la pile|r',
		'|cFFFFFFPoints de compétences|r\nNon Dépensé/Total Gagné',
		'|cFFFFFFPC|r ',
		'|cFFFFFFÉclats célestes|r\nRecueilli/Total',
		'Suit les plans connus',--32
		'|cE8DFAF'..mmb..' Recherche|r',
		'|cE8DFAF'..lmb..' Piste|r',		
	},
	nobagspace = '|cFF0000Pas assez d\'espace d\'inventaire!|r',
	noSlot = '|cFF0000Aucun emplacement de recherche gratuit ou élément inaccessible!|r',
	noItemPreview = '|cFF0000ItemPreview requis!|r',
	noFurnitureData = '|cFF0000ItemPreview manque de cet article.|r',
	blueprintSearchLimit = '|cFF0000Affinez votre recherche pour afficher tous les résultats.|r',
	removeCurrentCharacter = '|cFF0000Impossible de supprimer le personnage actuel.|r',
	searchfor = 'Rechercher: ',
	finished = 'complété',
	level = 'Niveau',
	rank = 'Rang',
	bank = 'Banque',
	housebank = 'Banque de maison ',
	guildbank = 'Banque de guilde',
	craftbag = 'Sac d\'artisanat',
	chars = 'Vue d\'ensemble des personnage',
	set = 'Sélectionner un Set...',
	unknown = 'inconnu',
	knownStyles = 'Styles connus',
	finishResearch = '<<C:1>> a terminé la recherche de |c00FF00<<C:2>>|r |c00FF88(<<C:3>>)|r.',
	finishMount = '<<C:1>> a fini l\'entrainement de sa monture.',
	finish12 = 'Le compte à rebours de 12 heures a expiré.',
	finish24 = 'Le compte à rebours de 24 heures a expiré.',
	itemsearch = 'Recherche: <<C:1>> | <<c:2>> ... Offres?',
	hideStyles = 'Masquer simples',
	hideCrownStyles = 'Masquer couronne',
	hideKnown = "Masquer connus",
	hideUnknown = "Masquer inconnu",  
	unselectedWayshrine = "|cFF0000Choisissez un ensemble manufacturable.|r",
	unknownWayshrine = "|cFF0000Impossible de voyager vers des chemins inconnus.|r",  
	previewType = {"Lourde", "Moyenne", "Legere + Peignoir", "Legere + Pourpoint"},
	styleNames = {},
	reload = "Nécessite un rechargement",
},
br = {
	options = {
		showbutton = 'Mostra botão CraftStore',
		lockbutton = 'Botão Bloquear CraftStore',
		lockelements = 'Trava elementos CraftStore',
		closeonmove = 'Fecha janela-CraftStore no movimento',
		useartisan = 'Usa CraftStoreArtisan (não pronto)',
		useflask = 'Usa CraftStoreFlask (não pronto)',
		usequest = 'Usa CraftStoreQuest',
		usecook = 'Usa CraftStoreCook',
		userune = 'Usa CraftStoreRune',
		displaystyles = 'Mosta itens de estilo nas dicas',
		markitems = 'Marca itens necessários',
		showsymbols = 'Mostra '..i..'/'..o..'-simbolos',
		playrunevoice = 'Toca vozes no encantamento de runa',
		marksetitems = 'Marca itens de conjuntos para pesquisa',
		showstock = 'Mostra estoque de itens nas dicas',
		stacksplit = 'Preselect stack-split',
		markduplicates = 'Permite marcar duplicados para pesquisa',
		displayrunelevel = 'Mostra nível da runa nas dicas',
		displaymm = 'Mostrar Master Merchant nas dicas',
		displayttc = 'Mostrar Tamriel Trade Centre nas dicas',
		timeralarm = 'Mostrar alarme do temporizador',
		mountalarm = 'Mostrar alarme de montagem',
		researchalarm = 'Mostrar alarme de pesquisa',
		advancedcolorgrid = 'Grade avançada codificada por cores',
		lockprotection = 'Ativar proteção de bloqueio',
		sortsets = 'Ordenar conjuntos',
		sortstyles = 'Ordenar estilos',
		bulkcraftlimit = 'Limite de produção em massa',
		overviewstyle = 'Estilo de visão geral do personagem',
		userunecreation = 'Usa CraftStoreRune Criação',
		useruneextraction = 'Usa CraftStoreRune Extração',
		userunerecipe = 'Usa CraftStoreRune Mobília',	
		displayunknown = 'Mostrar desconhecido nas dicas',
		displayknown = 'Mostrar conhecido nas dicas',		
	},
	suboptions = {
		sortstyles = {
			[1] = "Alfabeticamente",
			[2] = "Motivo #",
			[3] = "Interno #",
		},
		sortsets = {
			[1] = "Alfabeticamente",
			[2] = "Atributos",
		},
		alarms = {
			[1] = "Anunciar",
			[2] = "Bate-papo",
			[3] = "Ambos",
			[4] = "Fora",
		},
		overviewstyle = {
			[1] = "Completo",
			[2] = "Fino",
			[3] = "Mínimo",
		},	
	},	
	TT = {
		'|cFFFFFF<<C:1>>|r\n'..lmb..' Marca/desmarca pesquisa\n\n|t20:20:<<2>>|t |cFFFFFFEnteira <<C:3>>|r\n'..rmb..' Marca/desmarca pesquisa',
		'|cE8DFAF'..lmb..' Fabrica x <<1>>|r',
		'|cE8DFAF'..rmb..' Fabrica x <<1>>|r',
		'|cE8DFAF'..mmb..' Marca como favorito |r|t16:16:esoui/art/characterwindow/equipmentbonusicon_full.dds|t',
		'|cE8DFAF'..lmb..' Escolhe|r',
		'|cE8DFAF'..rmb..' Mostra no chat|r',
		'|cE8DFAF'..mmb..' Marca ingredientes|r',
		'|cE8DFAF'..lmb..' Refina glifo|r',
		'|cE8DFAF'..lmb..' Refina todos os glifos não-fabricados \n'..rmb..' Refina todos os glifos disponíveis|r',
		'|cE8DFAF'..lmb..' Escolhe este personagem\n'..rmb..' Define este personagem como o personagem principal\n'..mmb..' Remove este personagem.',
		'Favoritos',
		'Rune-Mode-Crafting',
		'Rastreia Estilos Conhecidos',
		'Rastreia Receitas Conhecidas',
		'Mostra CraftStore',
		'Transações disponíveis com o receptador e lucro de hoje',
		'Guilda dos Magos - Eyevea - use o portal do predio da Guilda dos Magos mais próxima',
		'Guilda dos Guerreiros - A Forja da Terra - use o portal no prédio da Guilda dos Guerreiros mais próximo',
		'Clique para viajar para o santuário ádito mais próximo da estação-de-fabricação-do-conjunto',
		'|cFFFFFFMount-Skills|r\nCapacidade e vigor\ne Velocidade',
		{'Qualquer Água','Água Suja','Rio','Lago','Oceano'},
		'Refina todos os glifos',
		'Ordem',
		'Mobiliário',
		'Rastreia atributos conhecidos',
		'|cE8DFAF'..lmb..' Prevê Mobilia|r',
		'|cE8DFAF'..rmb..' Prevê Mobilia|r',
		'|cE8DFAF'..rmb..' Refina montão|r',
		'|cFFFFFFPontos de Habilidade|r\nNão Usado/Total Ganho',--29
		'|cFFFFFFSP|r ',--30
		'|cFFFFFFSkyshards|r\nColetado/Total',--31
		'Rastreia diagrama Conhecidas',--32
		'|cE8DFAF'..mmb..' Pesquisa|r',
		'|cE8DFAF'..lmb..' Seguir|r',
	},
	nobagspace = '|cFF0000Sem espaço suficiente!|r',
	noSlot = '|cFF0000Nenhuma posição de pesquisa livre ou item inacessível!|r',
	noItemPreview = '|cFF0000PrevêMobília requerido!|r',
	noFurnitureData = '|cFF0000PrevêMobília ausente para este item.|r',
	blueprintSearchLimit = '|cFF0000Limite sua pesquisa para mostrar todos os resultados.|r',
	removeCurrentCharacter = '|cFF0000Não é possível remover o personagem atual.|r',
	searchfor = 'Pesquisa por: ',
	finished = 'terminado',
	level = 'Nível',
	rank = 'Ranque',
	bank = 'Banco',
	housebank = 'Banco de Casa ',
	guildbank = 'Banco da Guilda',
	craftbag = 'Bolsa de Materiais',
	chars = 'Resumo-de-Personagem',
	set = 'Escolhe um conjunto...',
	unknown = 'Desconhecido',
	knownStyles = 'Estilos Conhecidos',
	finishResearch = '<<C:1>> terminou de pesquisar |c00FF00<<C:2>>|r |c00FF88(<<C:3>>)|r.',
	finishMount = '<<C:1>> completou o treinamento de montaria.',
	finish12 = 'O contador de 12-horas expirou.',
	finish24 = 'O contador de 24-horas expirou.',
	itemsearch = 'Procurando por: <<C:1>> | <<c:2>> ... Ofertas?',
	hideStyles = 'Esconde simples',
	hideCrownStyles = 'Esconde crown',
	hideKnown = "Esconde conhecido",
	hideUnknown = "Esconde desconhecido",
	unselectedWayshrine = "|cFF0000Escolha um conjunto fabricável.|r",
	unknownWayshrine = "|cFF0000Não pode viajar para um santuário não descoberto.|r", 
	previewType = {"Pesada", "Media", "Leve + Túnica", "Leve + Gibão"},
	provisioningWritOffset = 7,
	styleNames = {},
	reload = "Requer recarga",
},
ru = {
	options = {
		showbutton = 'Кнопка CraftStore',
		lockbutton = 'Кнопка блокировки CraftStore',
		lockelements = 'Зафиксировать элементы CraftStore',
		closeonmove = 'Закрывать CraftStore при движении',
		useartisan = 'Использовать CraftStoreArtisan (не готово)',
		useflask = 'Использовать CraftStoreFlask (не готово)',
		usequest = 'Использовать CraftStoreQuest',
		usecook = 'Использовать CraftStoreCook',
		userune = 'Использовать CraftStoreRune',
		displaystyles = 'Стиль в подсказке',
		markitems = 'Отмечать необходимые предметы',
		showsymbols = 'Показывать значки '..i..'/'..o..'',
		playrunevoice = 'Озвучивать руны',
		marksetitems = 'Отмечать предметы для исследования',
		showstock = 'Запасы предмета в подсказке',
		stacksplit = 'Фокусировать на разделении',
		markduplicates = 'Разрешить отмечать дубли для исследования',
		displayrunelevel = 'Уровень руны в подсказке',
		displaymm = 'Показать Master Merchant подсказке',
		displayttc = 'Показать Tamriel Trade Centre подсказке',
		timeralarm = 'Показать таймер',
		mountalarm = 'Показать маунт сигнал тревоги',
		researchalarm = 'Показать исследование сигнал тревоги',
		advancedcolorgrid = 'Продвинутые цвета сетки',
		lockprotection = 'Включить защиту от блокировки',
		sortsets = 'Сортировать комплекты',
		sortstyles = 'Сортировать стили',
		bulkcraftlimit = 'Предел массового производства',
		overviewstyle = 'Стиль обзора персонажа',
		userunecreation = 'Использовать CraftStoreRune Творчество',
		useruneextraction = 'Использовать CraftStoreRune экстракция',
		userunerecipe = 'Использовать CraftStoreRune Мебель',
		displayunknown = 'Показать неизвестно подсказке',
		displayknown = 'Показать известный подсказке',			
	},
	suboptions = {
		sortstyles = {
			[1] = "алфавиту",
			[2] = "лейтмотив #",
			[3] = "внутренний #",
		},
		sortsets = {
			[1] = "алфавиту",
			[2] = "особенности",
		},
		alarms = {
			[1] = "анонсировать",
			[2] = "чат",
			[3] = "Обе",
			[4] = "от",
		},
		overviewstyle = {
			[1] = "полный",
			[2] = "тонкий",
			[3] = "минимальная",
		},	
	},	
	TT = {
		'|cFFFFFF<<C:1>>|r\n'..lmb..' Выбрать/Отменить исследования\n\n|t20:20:<<2>>|t |cFFFFFF<<C:3>> в целом|r\n'..rmb..' Выбрать/Отменить исследования',
		'|cE8DFAF'..lmb..' Создать x <<1>>|r',
		'|cE8DFAF'..rmb..' Создать x <<1>>|r',
		'|cE8DFAF'..mmb..' Добавить в избранное |r|t16:16:esoui/art/characterwindow/equipmentbonusicon_full.dds|t',
		'|cE8DFAF'..lmb..' Выбрать|r',
		'|cE8DFAF'..rmb..' Ссылка в чат|r',
		'|cE8DFAF'..mmb..' Отметить ингредиенты|r',
		'|cE8DFAF'..lmb..' Разобрать глиф|r',
		'|cE8DFAF'..lmb..' Разобрать все не крафтовые глифы\n'..rmb..' Разобрать все имеющиеся глифы|r',
		'|cE8DFAF'..lmb..' Выбрать персонажа\n'..rmb..' Назначить персонажа основным\n'..mmb..' Удалить персонажа.',
		'Избраное',
		'Создание глифов',
		'Отслеживать известные стили',
		'Отслеживать известные рецепты',
		'Показать CraftStore',
		'Доступные операции отмывания и сегодняшний доход',
		'Гильдия магов - Айвея - используйте портал в ближайшем здании Гильдии магов',
		'Гильдия бойцов - Земная кузница - используйте портал в ближайшем здании Гильдии бойцов',
		'Щелкните, чтобы переместиться к дорожному святилищу, расположенному рядом с выбранным ремесленным станком комплекта',
		'|cFFFFFFНавыки верховой езды|r\nПереносимый вес и запас сил\nСкрость и тренировки',
		{'Любая вода','Грязная вода','Речная вода','Озёрная вода','Солёная вода'},
		'Разобрать все глифы',
		'Заказ',
		'Мебель',
		'Отслеживать известные особенности',
		'|cE8DFAF'..lmb..' Предпросмотр мебели|r',
		'|cE8DFAF'..rmb..' Предпросмотр мебели|r',
		'|cE8DFAF'..rmb..' Разобрать всю кучу|r',
		'|cFFFFFFОчки навыков|r\Доступных/Получено всего',--29
		'|cFFFFFFОН|r ',--30
		'|cFFFFFFНебесные осколки|r\nСобрано/Всего',--31
		'Отслеживать известные чертежи',--32
		'|cE8DFAF'..mmb..' исследовать|r',
		'|cE8DFAF'..lmb..' трек|r',		
	},
	nobagspace = '|cFF0000Недостаточно места!|r',
	noSlot = '|cFF0000Нет свободного слота для исследования или предмет недоступен!|r',
	noItemPreview = '|cFF0000Требуется аддон ItemPreview!|r',
	noFurnitureData = '|cFF0000В FurniturePreview нет такого предмета.|r',
	blueprintSearchLimit = '|cFF0000Ограничьте свой поиск, чтобы показать все результаты.|r',
	searchfor = 'Исследование предмета: ',
	finished = 'завершено',
	level = 'Уровень',
	rank = 'Ранг',
	bank = 'Банк',
	housebank = 'Дом.хранилище ',
	guildbank = 'Гильд.банк',
	craftbag = 'Ремесленная сумка',
	chars = 'Обзор персонажа',
	set = 'Выберите комплект...',
	unknown = 'неизвестно',
	knownStyles = 'Известные стили',
	finishResearch = 'Персонаж <<C:1>> завершил исследование |c00FF00<<C:2>>|r |c00FF88(<<C:3>>)|r.',
	finishMount = 'Персонажем <<C:1>> завершён урок верховой езды.',
	finish12 = '12-часовой таймер истёк.',
	finish24 = '24-часовой таймер истёк.',
	itemsearch = 'Ищу <<C:1>> с трейтом "<<c:2>>"... Предложения?',
	hideStyles = 'Скрыть простые',
	hideCrownStyles = 'Скрыть кронные',
	hideKnown = "Скрыть известные",
	hideUnknown = "Скрыть неизвестные",
	unselectedWayshrine = "|cFF0000Выберите ремесленный комплект.|r",
	unknownWayshrine = "|cFF0000Невозможно переместиться к не открытому дорожному святилищу.|r", 
	previewType = {"Тяжёлая", "Средняя", "Лёгкая + Роба", "Лёгкая + Куртка"},
	provisioningWritOffset = 7,
	styleNames = {},
	reload = "Требуется перезагрузка",
}
}