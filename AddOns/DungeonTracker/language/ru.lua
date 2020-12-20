local DTAddon = _G['DTAddon']
local L = {}

--------------------------------------------------------------------------------------------------------------------
-- Russian translation by ESOUI.com user KiriX. (Non-indented and commented lines still need human translation!)
--------------------------------------------------------------------------------------------------------------------

-- General Strings
	L.DTAddon_Title			= "Отслеживание подземелий"
	L.DTAddon_CNorm			= "Пройденные обычные:"
	L.DTAddon_CVet			= "Пройденные ветеранские:"
	L.DTAddon_CNormI		= "Пройденные обычные I:"
	L.DTAddon_CNormII		= "Пройденные обычные II:"
	L.DTAddon_CVetI			= "Пройденные ветеранские I:"
	L.DTAddon_CVetII		= "Пройденные ветеранские II:"
	L.DTAddon_CGChal		= "Пройденные групповые испытания:"
	L.DTAddon_CDBoss		= "Все боссы побеждены:"
L.DTAddon_Unlock		= "Разблокируется на уровне: "
L.DTAddon_DBUpdate		= "База данных Dungeon Tracker была сброшена с этой версии.\nПожалуйста, войдите в каждый символ, чтобы перестроить."

-- Account Options
	L.DTAddon_GOpts			= "Общие настройки"
	L.DTAddon_COpts			= "Настройки персонажа"
L.DTAddon_SHMComp		= "Показать завершение жесткого режима"
L.DTAddon_SHMCompD		= "Покажите значок после имени персонажей, которые завершили достижение «Ветеранская подземелье» или «Пробный трудный режим» для выделенного подземелья/пробного периода."
L.DTAddon_STTComp		= "Показывать завершенное пробное завершение"
L.DTAddon_STTCompD		= "Покажите значок после имени персонажей, которые завершили достижение «Ветеранское подземелье» или «Пробное время» для подсвеченного подземелья/пробного периода."
L.DTAddon_SNDComp		= "Покажите завершение смерти"
L.DTAddon_SNDCompD		= "Покажите значок после имени персонажей, которые завершили достижение «Ветеранское подземелье» или «Пробное без смерти» для подсвеченного подземелья/пробной версии."
	L.DTAddon_SGFComp		= "Прохождение подземелий Альянса"
	L.DTAddon_SGFCompD		= "Показывает текущий прогресс пероснажа в прохождении всех групповых подземелий Альянса, на землях которого находится выбранное подземелье. Требуется отслеживание персонажей."
	L.DTAddon_CNColor		= "Цвет имени прошедших:"
	L.DTAddon_CNColorD		= "Выберите цвет имени для персонажей, которые получили достижение."
	L.DTAddon_NNColor		= "Цвет имени НЕпрошедших:"
	L.DTAddon_NNColorD		= "Выберите цвет имени для персонажей, которые НЕ получили достижение."
L.DTAddon_ALPHAN		= "Алфавитный список имен"
L.DTAddon_ALPHAND		= "Когда включено, списки завершения всплывающих подсказок будут в алфавитном порядке. В противном случае порядок списка соответствует порядку ваших символов на экране входа в систему."
L.DTAddon_CTDROPDOWN	= "Формат для текста завершения"
L.DTAddon_CTDROPDOWND	= "Выберите, показывать ли только символы, которые завершили целевые достижения, только те, у кого их нет, или оба (по умолчанию)."
L.DTAddon_CTOPT1		= "Покажите оба"
L.DTAddon_CTOPT2		= "Только завершено"
L.DTAddon_CTOPT3		= "Только неполный"
L.DTAddon_SLFGt			= "LFG: Показать завершение подземелья"
L.DTAddon_SLFGtD		= "Показывать список символов, которые завершили подземелье в подсказке Group Finder."
L.DTAddon_SLFGd			= "LFG: Показать описание подземелья"
L.DTAddon_SLFGdD		= "Отобразите описание игры подземелья на всплывающих подсказках LFG. Это обычно скрыто."
L.DTAddon_SNComp		= "КАРТА: нормальное заполнение подземелья"
L.DTAddon_SNCompD		= "Показывать список символов, которые завершили подземелья или пробный в нормальном режиме в всплывающей подсказке. Удерживайте shift для переключения между версиями подземелий (I или II) при просмотре всплывающих подсказок для подземелья с несколькими версиями."
L.DTAddon_SVComp		= "КАРТА: Ветеран Завершение подземелья"
L.DTAddon_SVCompD		= "Покажите список символов, которые завершили подземелья или пробной в режиме ветеранов во всплывающей подсказке. Удерживайте shift для переключения между версиями подземелий (I или II) при просмотре подсказок для подземелий с несколькими версиями."
L.DTAddon_SGCComp		= "КАРТА: завершение группового опроса"
L.DTAddon_SGCCompD		= "Показывать список символов, которые завершили задачу подсказки группы навыков в подсказке."
L.DTAddon_SDBComp		= "КАРТА: завершите выполнение босса"
L.DTAddon_SDBCompD		= "Покажите список персонажей, которые победили всех боссов дельвы во всплывающей подсказке."
L.DTAddon_SDFComp		= "КАРТА: завершить завершение фракции"
L.DTAddon_SDFCompD		= "Покажите текущий прогресс персонажа, чтобы завершить все переходы в фракции выделенного эффекта. Требуется символ трека."

-- Character Options
	L.DTAddon_CTrack		= "Отслеживание персонажей"
	L.DTAddon_CTrackD		= "Отслеживать этого персонажа в списке имён получивших (или нет) выбранное достижение."
L.DTAddon_DCChar		= "Удалить данные персонажа:"
L.DTAddon_DELETE		= "УДАЛЯТЬ"
L.DTAddon_CDELD			= "Удалить выбранный символ из базы данных отслеживания. Если вы удалите еще существующий символ здесь, они будут автоматически настроены на не отслеживание. Войдите в систему как символ и снова включите отслеживание в разделе «Параметры персонажа», чтобы повторно добавить их в базу данных."

------------------------------------------------------------------------------------------------------------------

if (GetCVar('language.2') == 'ru') then -- overwrite GetLanguage for new language
	for k,v in pairs(DTAddon:GetLanguage()) do
		if (not L[k]) then -- no translation for this string, use default
			L[k] = v
		end
	end

	function DTAddon:GetLanguage() -- set new language return
		return L
	end
end
