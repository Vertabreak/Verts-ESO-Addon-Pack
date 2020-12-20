local DTAddon = _G['DTAddon']
local L = {}

--------------------------------------------------------------------------------------------------------------------
-- Japanese (Needs human translation!)
--------------------------------------------------------------------------------------------------------------------

-- General Strings
	L.DTAddon_Title			= "ダンジョントラッカー"
	L.DTAddon_CNorm			= "正常終了："
	L.DTAddon_CVet			= "完成したベテラン："
	L.DTAddon_CNormI		= "完了標準I："
	L.DTAddon_CNormII		= "正常終了II："
	L.DTAddon_CVetI			= "完成ベテランI："
	L.DTAddon_CVetII		= "完成ベテランII："
	L.DTAddon_CGChal		= "グループチャレンジの完了："
	L.DTAddon_CDBoss		= "すべての上司が敗北："
	L.DTAddon_Unlock		= "レベルでロック解除： "
	L.DTAddon_DBUpdate		= "Dungeon Trackerデータベースがこのバージョンにリセットされました。\n再構築するには、各文字にログインしてください。"

-- Account Options
	L.DTAddon_GOpts			= "グローバルオプション"
	L.DTAddon_COpts			= "文字オプション"
	L.DTAddon_SHMComp		= "ハードモード完了を表示"
	L.DTAddon_SHMCompD		= "強調表示されたダンジョン/トライアルのXXまたはYY達成を完了したキャラクターの名前の後にアイコンを表示します。"
	L.DTAddon_STTComp		= "トライアルの完了を表示する"
	L.DTAddon_STTCompD		= "ハイライトされたダンジョン/トライアルのベテランダンジョンまたはトライアル・タイム達成を完了したキャラクターの名前の後にアイコンを表示します。"
	L.DTAddon_SNDComp		= "死の完了を表示しない"
	L.DTAddon_SNDCompD		= "ハイライトされたダンジョン/トライアルのベテランダンジョンまたはトライアルノーデスアチーブメントを達成したキャラクターの名前の後にアイコンを表示します。"
	L.DTAddon_SGFComp		= "ダンジョン派閥完成"
	L.DTAddon_SGFCompD		= "ハイライトされたダンジョンの派閥内のすべてのグループダンジョンを完了するために、現在のキャラクターの進行状況を表示します。 トラックキャラクターが必要です。"
	L.DTAddon_CNColor		= "完了した名前色："
	L.DTAddon_CNColorD		= "特定の成果を達成したキャラクターの名前の色を選択します。"
	L.DTAddon_NNColor		= "不完全な名前の色："
	L.DTAddon_NNColorD		= "特定の達成を完了していない文字の名前の色を選択します。"
	L.DTAddon_ALPHAN		= "名前リストをアルファベット順に並べ替える"
	L.DTAddon_ALPHAND		= "有効にすると、ツールヒント補完リストがアルファベット順に表示されます。 それ以外の場合、リストの順序はログイン画面の文字の順序と一致します。"
	L.DTAddon_CTDROPDOWN	= "完了テキストの書式"
	L.DTAddon_CTDROPDOWND	= "目標の成果を達成したキャラクターのみを表示するか、表示しなかったキャラクターのみを表示するか、またはその両方を表示するかを選択します（デフォルト）。"
	L.DTAddon_CTOPT1		= "両方を表示"
	L.DTAddon_CTOPT2		= "完了した"
	L.DTAddon_CTOPT3		= "不完全なだけ"
	L.DTAddon_SLFGt			= "LFG：ダンジョンの完了を表示します"
	L.DTAddon_SLFGtD		= "グループファインダーツールチップでDungeonを完了した文字のリストを表示します。"
	L.DTAddon_SLFGd			= "LFG：ダンジョンの説明を表示します"
	L.DTAddon_SLFGdD		= "ダンジョンのゲームの説明をLFGのツールチップに表示します。 これは通常隠されています。"
	L.DTAddon_SNComp		= "MAP：通常のダンジョン完了"
	L.DTAddon_SNCompD		= "ツールチップの標準モードでダンジョンまたはトライアルを完了した文字のリストを表示します。 複数のバージョンのダンジョンのツールチップを表示するときに、シフトをホールドしてダンジョンバージョン（IまたはII）を切り替えます。"
	L.DTAddon_SVComp		= "MAP：退役軍人ダンジョン完了"
	L.DTAddon_SVCompD		= "ツールチップのベテランモードでダンジョンまたはトライアルを完了した文字のリストを表示します。 複数のバージョンのダンジョンのツールチップを表示しているときに、ダンジョンバージョン（IまたはII）を切り替えるためにシフトをホールドします。"
	L.DTAddon_SGCComp		= "MAP：グループチャレンジの完了を確認します"
	L.DTAddon_SGCCompD		= "ツールチップで熟練スキルポイントグループチャレンジを完了したキャラクターのリストを表示します。"
	L.DTAddon_SDBComp		= "MAP：上司補充を完了する"
	L.DTAddon_SDBCompD		= "ツールチップのすべてのデベロッパーのボスを倒したキャラクターのリストを表示する。"
	L.DTAddon_SDFComp		= "MAP：派閥の完成を調べる"
	L.DTAddon_SDFCompD		= "強調表示された洞察の派閥内のすべての洞察を完了するために、現在のキャラクターの進捗状況を表示します。 トラックキャラクターが必要です。"

-- Character Options
	L.DTAddon_CTrack		= "トラックキャラクター"
	L.DTAddon_CTrackD		= "選択したアチーブメントを完了した（またはしなかった）名前のリストでこの文字を追跡します。"
	L.DTAddon_DCChar		= "キャラクターのデータを削除する："
	L.DTAddon_DELETE		= "削除"
	L.DTAddon_CDELD			= "選択した文字を追跡データベースから削除します。 ここにまだ存在する文字を削除すると、それらは自動的にトラックしないように設定されます。 キャラクタとしてログインし、キャラクタオプションの下で再度トラッキングを有効にして、それらをデータベースに再追加します。"

------------------------------------------------------------------------------------------------------------------

if (GetCVar('language.2') == 'ja') or (GetCVar('language.2') == 'jp') then -- overwrite GetLanguage for new language
	for k,v in pairs(DTAddon:GetLanguage()) do
		if (not L[k]) then -- no translation for this string, use default
			L[k] = v
		end
	end

	function DTAddon:GetLanguage() -- set new language return
		return L
	end
end
