local DTAddon = _G['DTAddon']
local L = {}
 
--------------------------------------------------------------------------------------------------------------------
-- French translation by ESOUI.com user lexo1000. (Non-indented lines still need human translation!)
--------------------------------------------------------------------------------------------------------------------

-- General Strings
L.DTAddon_Title			= "Suivi de Donjon"
	L.DTAddon_CNorm			= "Accompli en Normal :"
	L.DTAddon_CVet			= "Accompli en Vétéran :"
	L.DTAddon_CNormI		= "Accompli en Normal I :"
	L.DTAddon_CNormII		= "Accompli en Normal II :"
	L.DTAddon_CVetI			= "Accompli en Vétéran I :"
	L.DTAddon_CVetII		= "Accompli en Vétéran II :"
	L.DTAddon_CGChal		= "Accompli le Défi de Groupe :"
	L.DTAddon_CDBoss		= "Tous les Boss vaincus: "
	L.DTAddon_Unlock		= "Débloqué au niveau "
L.DTAddon_DBUpdate		= "La base de données Dungeon Tracker a été réinitialisée cette version.\nVeuillez vous connecter à chaque personnage pour reconstruire."

-- Account Options
	L.DTAddon_GOpts			= "Options générales"
	L.DTAddon_COpts			= "Option de suivi"
	L.DTAddon_SHMComp		= "Afficher l'accomplissement en Mode Difficile"
	L.DTAddon_SHMCompD		= "Affiche une icône après le nom des personnages ayant accompli le donjon en mode Vétéran ou le Succès de raid difficile."
	L.DTAddon_STTComp		= "Afficher l'accomplissement en Contre la Montre"
	L.DTAddon_STTCompD		= "Affiche une icône après le nom des personnages ayant accompli le donjon en Vétéran ou le Succès de Contre la Montre en raid."
	L.DTAddon_SNDComp		= "Afficher l'accomplissement Sans Mort"
	L.DTAddon_SNDCompD		= "Affiche une icône après le nom des personnages ayant accompli le donjon en Vétéran ou le Succès Sans Mort en raid."
	L.DTAddon_SGFComp		= "Afficher la progression des Succès de faction"
	L.DTAddon_SGFCompD		= "Affiche la progression actuelle du personnage dans l'accomplissement de tous les donjons de la faction. Nécessite que l'option Suivre le personnage soit activée."
	L.DTAddon_CNColor		= "Couleur du nom pour les succès complétés"
	L.DTAddon_CNColorD		= "Détermine la couleur utilisée pour afficher le nom des personnages ayant accompli un Succès donné."
	L.DTAddon_NNColor		= "Couleur du nom pour les succès non complétés"
	L.DTAddon_NNColorD		= "Détermine la couleur utilisée pour afficher le nom des personnages n'ayant pas encore accompli un Succès donné."
L.DTAddon_ALPHAN		= "Liste alphabétique des noms"
L.DTAddon_ALPHAND		= "Lorsque cette option est activée, les listes d'achèvement des info-bulles seront classées par ordre alphabétique. Sinon, l'ordre de la liste correspond à l'ordre de vos caractères sur l'écran de connexion."
L.DTAddon_CTDROPDOWN	= "Format pour compléter le texte"
L.DTAddon_CTDROPDOWND	= "Choisissez d'afficher uniquement les personnages ayant terminé les réalisations cibles, uniquement ceux qui ne l'ont pas encore fait ou les deux (par défaut)."
L.DTAddon_CTOPT1		= "Montrer les deux"
L.DTAddon_CTOPT2		= "Seulement complété"
L.DTAddon_CTOPT3		= "Seulement incomplet"
L.DTAddon_SLFGt			= "LFG: Afficher l'achèvement du donjon."
L.DTAddon_SLFGtD		= "Affiche la liste des personnages ayant terminé une info-bulle sur les donjons dans le groupe"
L.DTAddon_SLFGd			= "LFG: Montre la description du donjon"
L.DTAddon_SLFGdD		= "Affichez la description du donjon dans les info-bulles de LFG. Ceci est normalement caché."
L.DTAddon_SNComp		= "MAP: Achèvement normal du donjon."
L.DTAddon_SNCompD		= "Afficher la liste des personnages ayant terminé le mode Donjon ou Essai en mode normal dans l'info-bulle. Maintenez la touche Maj enfoncée pour basculer entre les versions de donjon (I ou II) lors de l'affichage des info-bulles pour les donjons avec plusieurs versions."
L.DTAddon_SVComp		= "MAP: Achèvement des donjons d'anciens combattants"
L.DTAddon_SVCompD		= "Afficher la liste des personnages ayant terminé le mode Donjon ou Trial on Veteran dans l’aide Maintenez la touche Maj enfoncée pour basculer entre les versions de donjon (I ou II) lors de l'affichage des info-bulles pour les donjons avec plusieurs versions."
L.DTAddon_SGCComp		= "MAP: Terminer le challenge du groupe"
L.DTAddon_SGCCompD		= "Afficher la liste des personnages qui ont terminé le défi de groupe approfondi skillpoint dans l’aide"
L.DTAddon_SDBComp		= "MAP: Terminez la finition du patron"
L.DTAddon_SDBCompD		= "Affiche la liste des personnages qui ont vaincu tous les boss de la fouille dans l'info-bulle."
L.DTAddon_SDFComp		= "MAP: Terminez la faction"
L.DTAddon_SDFCompD		= "Afficher les progrès du personnage en cours vers l’achèvement de toutes les fouilles dans la faction de la fouille en surbrillance. Requiert un personnage de piste."

-- Character Options
	L.DTAddon_CTrack		= "Suivre le personnage"
	L.DTAddon_CTrackD		= "Permet de conserver la progression de ce personnage dans la liste des noms ayant accompli ou non les Succès."
L.DTAddon_DCChar		= "Supprimer les données du personnage:"
L.DTAddon_DELETE		= "EFFACER"
L.DTAddon_CDELD			= "Supprimer le caractère sélectionné de la base de suivi. Si vous supprimez un caractère encore existant ici, ils seront automatiquement configurés pour ne pas suivre. Connectez-vous en tant que personnage et réactivez le suivi sous Options de personnage pour les rajouter à la base de données."

------------------------------------------------------------------------------------------------------------------

if (GetCVar('language.2') == 'fr') then -- overwrite GetLanguage for new language
	for k,v in pairs(DTAddon:GetLanguage()) do
		if (not L[k]) then -- no translation for this string, use default
			L[k] = v
		end
	end
	function DTAddon:GetLanguage() -- set new language return
		return L
	end
end
