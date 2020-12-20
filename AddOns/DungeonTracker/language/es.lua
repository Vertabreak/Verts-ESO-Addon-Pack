local DTAddon = _G['DTAddon']
local L = {}

--------------------------------------------------------------------------------------------------------------------
-- Spanish (Needs human translation!)
--------------------------------------------------------------------------------------------------------------------

-- General Strings
	L.DTAddon_Title			= "Rastreador Mazmorra"
	L.DTAddon_CNorm			= "Completado Normal:"
	L.DTAddon_CVet			= "Veterano completado:"
	L.DTAddon_CNormI		= "Completado Normal I:"
	L.DTAddon_CNormII		= "Completado Normal II:"
	L.DTAddon_CVetI			= "Veterano completado I:"
	L.DTAddon_CVetII		= "Veterano completado II:"
	L.DTAddon_CGChal		= "Reto de grupo completado:"
	L.DTAddon_CDBoss		= "Todos los jefes derrotados:"
	L.DTAddon_Unlock		= "Desbloquea a nivel: "
	L.DTAddon_DBUpdate		= "La base de datos de Dungeon Tracker fue restablecida esta versión.\nPor favor inicie sesión en cada personaje para reconstruir."

-- Account Options
	L.DTAddon_GOpts			= "Opciones globales"
	L.DTAddon_COpts			= "Opciones de personaje"
	L.DTAddon_SHMComp		= "Mostrar finalización de modo difícil"
	L.DTAddon_SHMCompD		= "Muestra un icono después del nombre de los personajes que han completado el logro Mazmorra de Veteranos o Juicio de modo difícil para el mazmorra/juicio resaltado."
	L.DTAddon_STTComp		= "Mostrar finalización de prueba cronometrada"
	L.DTAddon_STTCompD		= "Muestra un icono después del nombre de los personajes que han completado el logro Mazmorra de Veteranos o Ensayo Cronometrado para el mazmorra/juicio resaltado."
	L.DTAddon_SNDComp		= "No mostrar la muerte completa"
	L.DTAddon_SNDCompD		= "Muestra un icono después del nombre de los personajes que han completado el logro Mazmorra de Veteranos o Juicio no Muerte para el mazmorra/juicio resaltado."
	L.DTAddon_SGFComp		= "Finalización de facción de mazmorra"
	L.DTAddon_SGFCompD		= "Muestra el progreso del personaje actual para completar todas las mazmorras grupales en la facción de la mazmorra resaltada. Requiere carácter de pista."
	L.DTAddon_CNColor		= "Nombre del color completo:"
	L.DTAddon_CNColorD		= "Seleccione el color para los nombres de los personajes que hayan completado un logro determinado."
	L.DTAddon_NNColor		= "Nombre de color incompleto:"
	L.DTAddon_NNColorD		= "Seleccione el color para los nombres de los personajes que NO han completado un logro determinado."
	L.DTAddon_ALPHAN		= "Alfabetizar la lista de nombres"
	L.DTAddon_ALPHAND		= "Cuando se habilite, las listas de finalización de información sobre herramientas se ordenarán alfabéticamente. De lo contrario, el orden de la lista coincide con el orden de sus personajes en la pantalla de inicio de sesión."
	L.DTAddon_CTDROPDOWN	= "Formato para completar el texto"
	L.DTAddon_CTDROPDOWND	= "Elija si desea mostrar solo los personajes que han completado los logros objetivo, solo los que no lo han hecho, o ambos (predeterminado)."
	L.DTAddon_CTOPT1		= "Mostrar ambos"
	L.DTAddon_CTOPT2		= "Solo completado"
	L.DTAddon_CTOPT3		= "Solo incompleto"
	L.DTAddon_SLFGt			= "LFG: Mostrar Finalización de Mazmorra"
	L.DTAddon_SLFGtD		= "Muestra la lista de personajes que han completado un mazmorra en la información sobre herramientas del Buscador de grupos."
	L.DTAddon_SLFGd			= "LFG: Mostrar Descripción de la Mazmorra"
	L.DTAddon_SLFGdD		= "Muestra la descripción del juego de la mazmorra en la información sobre herramientas de LFG. Esto normalmente está oculto."
	L.DTAddon_SNComp		= "MAPA: Finalización de Mazmorra Normal"
	L.DTAddon_SNCompD		= "Muestre la lista de caracteres que completaron Mazmorra o Juicio en modo Normal en la información sobre herramientas. Mantenga presionada la tecla shift para alternar entre las versiones de mazmorra (I o II) cuando vea información sobre herramientas para mazmorras con varias versiones."
	L.DTAddon_SVComp		= "MAPA: Finalización de Mazmorra Veterana"
	L.DTAddon_SVCompD		= "Muestra la lista de caracteres que han completado el Mazmorra o el Juicio en el modo Veterano en la información sobre herramientas. Mantenga presionada la tecla shift para alternar entre las versiones mazmorra (I o II) cuando vea información sobre herramientas para mazmorras con varias versiones."
	L.DTAddon_SGCComp		= "MAPA: Completa el Desafío del Grupo"
	L.DTAddon_SGCCompD		= "Muestra la lista de personajes que han completado el desafío de grupo de skillpoint delve en la información sobre herramientas."
	L.DTAddon_SDBComp		= "MAPA: Completa la Terminación del Jefe"
	L.DTAddon_SDBCompD		= "Muestra la lista de personajes que han derrotado a todos los jefes de excavación en la información sobre herramientas."
	L.DTAddon_SDFComp		= "MAPA: Delve Completar la Facción"
	L.DTAddon_SDFCompD		= "Muestra el progreso del personaje actual para completar todas las profundidades en la facción de la profundidad destacada. Requiere carácter de pista."

-- Character Options
	L.DTAddon_CTrack		= "Carácter de la pista"
	L.DTAddon_CTrackD		= "Rastrea este personaje en la lista de nombres que han completado (o no) un logro seleccionado."
	L.DTAddon_DCChar		= "Eliminar datos del personaje:"
	L.DTAddon_DELETE		= "BORRAR"
	L.DTAddon_CDELD			= "Eliminar el carácter seleccionado de la base de datos de seguimiento. Si elimina un carácter que aún existe aquí, se configurarán automáticamente para no rastrear. Inicie sesión como el carácter y vuelva a habilitar el seguimiento en Opciones de caracteres para volver a agregarlos a la base de datos."

------------------------------------------------------------------------------------------------------------------

if (GetCVar('language.2') == 'es') then -- overwrite GetLanguage for new language
	for k,v in pairs(DTAddon:GetLanguage()) do
		if (not L[k]) then -- no translation for this string, use default
			L[k] = v
		end
	end

	function DTAddon:GetLanguage() -- set new language return
		return L
	end
end
