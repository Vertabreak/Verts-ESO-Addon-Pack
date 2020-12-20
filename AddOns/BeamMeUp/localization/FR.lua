local mkstr = ZO_CreateStringId
local SI = Teleporter.SI

-----------------------------------------------------------------------------
-- INTERFACE
-----------------------------------------------------------------------------
mkstr(SI.TELECLOSE          , "Fermer"        )
mkstr(SI.TELE_UI_PLAYER     , "Joueur"        )
mkstr(SI.TELE_UI_ZONE       , "Zone"          )
mkstr(SI.TELE_UI_TOTAL      , "Résultats :"   )
mkstr(SI.TELE_UI_GOLD       , "Or économisé :")
mkstr(SI.TELE_UI_GOLD_ABBR  , "k"             )
mkstr(SI.TELE_UI_GOLD_ABBR2 , "M"             )
mkstr(SI.TELE_UI_TOTAL_PORTS, "Total des TP :")
---------
--------- Buttons
mkstr(SI.TELE_UI_BTN_SEARCH_PLAYER      , "Recherche par joueur"                  )
mkstr(SI.TELE_UI_BTN_SEARCH_ZONE        , "Recherche par zone"                    )
mkstr(SI.TELE_UI_BTN_REFRESH_ALL        , "Rafraîchir toutes les zones"           )
mkstr(SI.TELE_UI_BTN_UNLOCK_WS          , "Déverrouiller les oratoires de la zone")
mkstr(SI.TELE_UI_BTN_CURRENT_ZONE       , "Seulement la zone affichée"            )
mkstr(SI.TELE_UI_BTN_CURRENT_ZONE_DELVES, "Antres de la zone affichée"            )
mkstr(SI.TELE_UI_BTN_RELATED_ITEMS      , "Cartes au trésor, repérages & pistes"  )
mkstr(SI.TELE_UI_BTN_SETTINGS           , "Paramètres"                            )
mkstr(SI.TELE_UI_BTN_FEEDBACK           , "Commentaires"                          )
mkstr(SI.TELE_UI_BTN_FIX_WINDOW         , "Verrouiller / Déverrouiller la fenêtre")
mkstr(SI.TELE_UI_BTN_TOGGLE_ZONE_GUIDE  , "Basculer vers BeamMeUp"                )
mkstr(SI.TELE_UI_BTN_TOGGLE_BMU         , "Basculer vers le guide de zone"        )
mkstr(SI.TELE_UI_BTN_RELATED_QUESTS     , "Zones liées aux quêtes"                )
mkstr(SI.TELE_UI_BTN_PORT_TO_OWN_HOUSE  , "Maisons possédées"                     )
mkstr(SI.TELE_UI_BTN_ANCHOR_ON_MAP      , "Ancrer à la carte / Libérer"           )
mkstr(SI.TELE_UI_BTN_GUILD_BMU          , "Guildes BeamMeUp & Guildes partenaires")
mkstr(SI.TELE_UI_BTN_GUILD_HOUSE_BMU    , "Visiter la maison de guilde BeamMeUp"  )
mkstr(SI.TELE_UI_BTN_PTF_INTEGRATION    , "Integration \"Port to Friend's House\"")
---------
--------- List
mkstr(SI.TELE_UI_SOURCE_GROUP         , "Groupe"                     )
mkstr(SI.TELE_UI_SOURCE_FRIEND        , "Ami"                        )
mkstr(SI.TELE_UI_NO_MATCHES           , "Pas de résultat"            )
mkstr(SI.TELE_UI_UNRELATED_ITEMS      , "Carte dans d'autres zones"  )
mkstr(SI.TELE_UI_UNRELATED_QUESTS     , "Quêtes dans d'autres zones" )
mkstr(SI.TELE_UI_SAME_INSTANCE        , "Même instance"              )
mkstr(SI.TELE_UI_DIFFERENT_INSTANCE   , "Instance différente"        )
mkstr(SI.TELE_UI_DISCOVERED_WAYSHRINES, "Oratoires découverts :"     )
mkstr(SI.TELE_UI_DISCOVERED_SKYSHARDS , "Éclats célestes récupérés :")
---------
--------- Menu
mkstr(SI.TELE_UI_FAVORITE_PLAYER         , "Joueurs favoris")
mkstr(SI.TELE_UI_FAVORITE_ZONE           , "Zones favorites")
mkstr(SI.TELE_UI_REMOVE_FAVORITE_PLAYER  , "Enlever le joueur des favoris")
mkstr(SI.TELE_UI_REMOVE_FAVORITE_ZONE    , "Enlever la zone des favoris")
mkstr(SI.TELE_UI_ADD_TO_GROUP            , "Inviter en groupe")
mkstr(SI.TELE_UI_PROMOTE_TO_LEADER       , "Promouvoir chef")
mkstr(SI.TELE_UI_VOTE_TO_LEADER          , "Votez pour le chef")
mkstr(SI.TELE_UI_KICK_FROM_GROUP         , "Renvoyer du groupe")
mkstr(SI.TELE_UI_VOTE_KICK_FROM_GROUP    , "Vote de renvoi")
mkstr(SI.TELE_UI_LEAVE_GROUP             , "Quitter le groupe")
mkstr(SI.TELE_UI_WHISPER_PLAYER          , "Chuchoter")
mkstr(SI.TELE_UI_JUMP_TO_HOUSE           , "Visiter la résidence principale")
mkstr(SI.TELE_UI_ADD_FRIEND              , "Ajouter ami")
mkstr(SI.TELE_UI_REMOVE_FRIEND           , "Retirer ami")
mkstr(SI.TELE_UI_SEND_MAIL               , "Envoyer un mail")
mkstr(SI.TELE_UI_FILTER_GROUP            , "Groupe seulement")
mkstr(SI.TELE_UI_FILTER_FRIENDS          , "Amis seulement")
mkstr(SI.TELE_UI_FILTER_GUILDS           , "Guildes seulement")
mkstr(SI.TELE_UI_RESET_COUNTER_ZONE      , "Réinitialiser les compteurs")
mkstr(SI.TELE_UI_INVITE_BMU_GUILD        , "Inviter dans la guilde BeamMeUp")
mkstr(SI.TELE_UI_SHOW_QUEST_MARKER_ON_MAP, "Montrer le marqueur de quête")
mkstr(SI.TELE_UI_RENAME_HOUSE_NICKNAME   , "Renommer la maison")
mkstr(SI.TELE_UI_SET_PRIMARY_HOUSE       , "Définir votre résidence principale")
mkstr(SI.TELE_UI_TOGGLE_HOUSE_NICKNAME   , "Montrer les noms personnalisés")
mkstr(SI.TELE_UI_VIEW_MAP_ITEM           , "Montrer la carte")
mkstr(SI.TELE_UI_BANK                    , "Banque :")
mkstr(SI.TELE_UI_LEAD                    , "Piste :")
mkstr(SI.TELE_UI_TOGGLE_SURVEY_MAP       , "Repérages")
mkstr(SI.TELE_UI_TOGGLE_TREASURE_MAP     , "Cartes au trésor")
mkstr(SI.TELE_UI_TOGGLE_LEADS_MAP        , "Pistes")
mkstr(SI.TELE_UI_VIEW_ANTIQUITY        	 , "Afficher le codex")

mkstr(SI.TELE_UI_SUBMENU_FAVORITES       , "Favoris")
mkstr(SI.TELE_UI_SUBMENU_MISC            , "Divers")
mkstr(SI.TELE_UI_SUBMENU_GROUP           , "Groupe")
mkstr(SI.TELE_UI_SUBMENU_FILTER          , "Filtres")



-----------------------------------------------------------------------------
-- CHAT OUTPUTS
-----------------------------------------------------------------------------
mkstr(SI.TELE_CHAT_ERROR_WHILE_PORTING             , "Voyage rapide vers l'autre joueur impossible"                                                                                                 )
mkstr(SI.TELE_CHAT_TO_PLAYER                       , "Voyage rapide vers l'autre joueur :"                                                                                                          )
mkstr(SI.TELE_CHAT_UNLOCK_START_INFO               , "Lancement du déverrouillage automatique ..."																									)
mkstr(SI.TELE_CHAT_ERROR                           , "Erreur lors du voyage vers l'autre joueur"                                                                                                    )
mkstr(SI.TELE_CHAT_UNLOCK_WS_SUCCESS               , "Déverrouillage automatique terminé avec succès"                                                                                               )
mkstr(SI.TELE_CHAT_UNLOCK_WS_COUNT_CALC            , "Calcul des oratoires débloqués ..."                                                                                                           )
mkstr(SI.TELE_CHAT_UNLOCK_WS_COUNT_PLU             , "nouveaux oratoires ont été débloqués."                                                                                                        )
mkstr(SI.TELE_CHAT_UNLOCK_WS_COUNT_SING            , "nouvel oratoire a été débloqué."                                                                                                              )
mkstr(SI.TELE_CHAT_UNLOCK_WS_NO_PLAYERS            , "Aucun joueur vers lequel voyager rapidement"                                                                                                  )
mkstr(SI.TELE_CHAT_FAVORITE_UNSET                  , "L'emplacement favori est indéfini."                                                                                                           )
mkstr(SI.TELE_CHAT_FAVORITE_PLAYER_NO_FAST_TRAVEL  , "Le joueur est déconnecté ou caché par des filtres."                                                                                           )
mkstr(SI.TELE_CHAT_FAVORITE_ZONE_NO_FAST_TRAVEL    , "Aucun voyage rapide trouvé"                                                                                                                   )
mkstr(SI.TELE_CHAT_NOT_IN_GROUP                    , "Vous n'êtes pas dans un groupe."                                                                                                              )
mkstr(SI.TELE_CHAT_PORTING_NOT_POSSIBLE            , "Voyage rapide actuellement indisponible"                                                                                                      )
mkstr(SI.TELE_CHAT_PORT_TO_OWN_HOUSE               , "Voyage rapide vers votre maison : "                                                                                                           )
mkstr(SI.TELE_CHAT_PORT_TO_OWN_PRIMARY_HOUSE_FAILED, "Aucune résidence principale définie !"                                                                                                        )
mkstr(SI.TELE_CHAT_WHISPER_NOTE                    , "Attention ! Vous êtes configuré comme déconnecté, vous ne pouvez pas recevoir de message privé !"                                             )
mkstr(SI.TELE_CHAT_GROUP_LEADER_YOURSELF           , "Vous êtes chef de votre groupe."                                                                                                              )
mkstr(SI.TELE_CHAT_UNLOCK_WS_DISCOVERED_TOTAL      , "Nombre d'oratoires découverts dans cette zone :"                                                                                              )
mkstr(SI.TELE_CHAT_UNLOCK_WS_ALL_KNOWN             , "Tous les oratoires de cette zone ont été découverts et peuvent être utilisé pour voyager."                                                    )
mkstr(SI.TELE_CHAT_UNLOCK_WS_NEED_DISCOVERED       , "Vous devez toujours vous rendre sur place pour les oratoires suivants :"                                                                      )
mkstr(SI.TELE_CHAT_SHARING_FOLLOW_LINK             , "Suivre le lien..."                                                                                                                            )



-----------------------------------------------------------------------------
-- SETTINGS
-----------------------------------------------------------------------------
mkstr(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN, "Ouvrir BeamMeUp avec la carte")
mkstr(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN_TOOLTIP, "Quand vous ouvrez la carte, BeamMeUp s'ouvre automatiquement aussi. Sinon, un bouton s'affiche en haut à gauche de la carte, et un bouton d'échange dans le guide de zone.")
mkstr(SI.TELE_SETTINGS_ZONE_ONCE_ONLY, "Montrer une seule fois chaque zone")
mkstr(SI.TELE_SETTINGS_ZONE_ONCE_ONLY_TOOLTIP, "Montre une seule destination par zone (au lieu de toutes celles possibles).")
mkstr(SI.TELE_SETTINGS_AUTO_PORT_FREQ, "Vitesse de déverrouillage des oratoires")
mkstr(SI.TELE_SETTINGS_AUTO_PORT_FREQ_TOOLTIP, "Adapte automatiquement la vitesse de déverrouillage automatique des oratoires. Des valeurs plus élevées peuvent aider pour éviter d'être déconnecté ou pour des ordinateurs lents.")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH, "Réinitialisation à l'ouverture")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_TOOLTIP, "Mise à jour de la liste des destinations à chaque fois que BeamMeUp est ouvert. Les champs d'entrée sont effacés.")
mkstr(SI.TELE_SETTINGS_HEADER_BLACKLISTING, "Liste noire")
mkstr(SI.TELE_SETTINGS_HIDE_OTHERS, "Cacher les diverses zones inaccessibles")
mkstr(SI.TELE_SETTINGS_HIDE_OTHERS_TOOLTIP, "Cacher les zones comme l'Arène de Maelstrom, les refuges de hors-la-loi et les zones solo")
mkstr(SI.TELE_SETTINGS_HIDE_PVP, "Cacher les zones JcJ")
mkstr(SI.TELE_SETTINGS_HIDE_PVP_TOOLTIP, "Cacher les zones comme Cyrodiil, la Cité Impériale, et les champs de bataille.")
mkstr(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS, "Cacher les donjons de groupe et les épreuves")
mkstr(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS_TOOLTIP, "Cacher tous les donjons de groupe à 4 joueurs, les épreuves à 12 joueurs ainsi que les donjons de groupe à Raidelorn. Les membres du groupe dans ces zones seront quand même affichés !")
mkstr(SI.TELE_SETTINGS_HIDE_HOUSES, "Cacher les maisons")
mkstr(SI.TELE_SETTINGS_HIDE_HOUSES_TOOLTIP, "Cacher toutes les maisons")
mkstr(SI.TELE_SETTINGS_DISABLE_DIALOG, "Déverrouillage des oratoires sans confirmation")
mkstr(SI.TELE_SETTINGS_DISABLE_DIALOG_TOOLTIP, "N'affiche pas de dialogue de confirmation quand vous utilisez la fonction de déverrouillage automatique des oratoires.")
mkstr(SI.TELE_SETTINGS_WINDOW_STAY, "Maintenir BeamMeUp ouvert")
mkstr(SI.TELE_SETTINGS_WINDOW_STAY_TOOLTIP, "Quand vous ouvrez BeamMeUp sans la carte, il restera ouvert même si vous bougez ou si vous ouvrez d'autres fenêtres. Si vous activez cette option, il est recommandé de désactiver l'option « Fermer BeamMeUp avec la carte ».")
mkstr(SI.TELE_SETTINGS_ONLY_MAPS, "Ne montrer que les régions")
mkstr(SI.TELE_SETTINGS_ONLY_MAPS_TOOLTIP, "Montrer seulement les régions principales, comme Deshaan ou le Couchant")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ, "Intervalle(s) de mise à jour")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ_TOOLTIP, "Quand BeamMeUp est ouvert, une réactualisation automatique des résultats est faite toutes les x secondes. Réglez la valeur sur 0 afin de désactiver l'actualisation automatique.")
mkstr(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN, "Focalisation sur la recherche de zone")
mkstr(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN_TOOLTIP, "Mettre le focus sur la boîte de recherche de zone quand BeamMeUp est ouvert avec la carte.")
mkstr(SI.TELE_SETTINGS_HIDE_DELVES, "Cacher les antres")
mkstr(SI.TELE_SETTINGS_HIDE_DELVES_TOOLTIP, "Cacher tous les antres (exemples : le pic de Taléon, la mine de Crêtombre, etc.)")
mkstr(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS, "Cacher les donjons publics")
mkstr(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS_TOOLTIP, "Cacher tous les donjons publics (exemples : les cryptes oubliées, le sanctuaire du Malandrin, etc.)")
mkstr(SI.TELE_SETTINGS_FORMAT_ZONE_NAME, "Cacher les articles de zone")
mkstr(SI.TELE_SETTINGS_FORMAT_ZONE_NAME_TOOLTIP, "Cacher les articles ('le', 'la', 'les'...) des noms de zone pour améliorer le tri et vous permettre de trouver les zones plus rapidement.")
mkstr(SI.TELE_SETTINGS_NUMBER_LINES, "Nombre de lignes à afficher")
mkstr(SI.TELE_SETTINGS_NUMBER_LINES_TOOLTIP, "Changer le nombre de lignes à afficher pour ajuster la hauteur de l'extension.")
mkstr(SI.TELE_SETTINGS_HEADER_ADVANCED, "Fonctionnalités supplémentaires")
mkstr(SI.TELE_SETTINGS_HEADER_UI, "Général")
mkstr(SI.TELE_SETTINGS_HEADER_RECORDS, "Affichages")
mkstr(SI.TELE_SETTINGS_CLOSE_ON_PORTING, "Fermeture automatique de la carte & BeamMeUp")
mkstr(SI.TELE_SETTINGS_CLOSE_ON_PORTING_TOOLTIP, "Fermer automatiquement la carte et BeamMeUp lorsque le processus de voyage rapide commence.")
mkstr(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS, "Afficher le nombre de joueurs par carte")
mkstr(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS_TOOLTIP, "Montre le nombre de joueurs par carte vers qui vous pouvez voyager. Vous pouvez cliquer sur ce nombre pour voir tous ces joueurs.")
mkstr(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET, "Décalage du bouton dans la fenêtre de tchat")
mkstr(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET_TOOLTIP, "Augmente le décalage horizontal du raccourci dans la barre des titres de la fenêtre de tchat pour éviter les conflits visuels avec les icônes d'autres extensions.")
mkstr(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES, "Rechercher aussi le nom des personnages")
mkstr(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES_TOOLTIP, "Recherche également le nom des personnages lorsqu'une recherche de joueurs est effectuée.")
mkstr(SI.TELE_SETTINGS_SORTING, "Options de tri")
mkstr(SI.TELE_SETTINGS_SORTING_TOOLTIP, "Choisissez l'une des options de tri possibles dans la liste.")
mkstr(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE, "Deuxième langue de recherche")
mkstr(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE_TOOLTIP, "Vous pouvez effectuer vos recherches par nom de zone dans la langue de votre client et dans cette seconde langue en même temps. L'infobulle du nom de la zone affiche également le nom dans la langue secondaire.")
mkstr(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE, "Notification de connexion de joueur favoris")
mkstr(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE_TOOLTIP, "Vous recevrez une notification (message au centre de votre écran) lorsqu'un joueur configuré en favoris se connecte au serveur.")
mkstr(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE, "Fermer BeamMeUp à la fermeture de la carte")
mkstr(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE_TOOLTIP, "Lorsque vous fermez la carte, BeamMeUp se ferme également.")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL, "Décalage de l'ancrage à la carte - horizontal")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL_TOOLTIP, "Ici vous pouvez configurer le décalage horizontal de la fenêtre de l'extension ancrée à la carte.")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL, "Décalage de l'ancrage à la carte - vertical")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL_TOOLTIP, "Ici vous pouvez configurer le décalage vertical de la fenêtre de l'extension ancrée à la carte.")
mkstr(SI.TELE_SETTINGS_RESET_ALL_COUNTERS, "Réinitialiser les compteurs")
mkstr(SI.TELE_SETTINGS_RESET_ALL_COUNTERS_TOOLTIP, "Tous les compteurs de zone sont remis à zéro. Par conséquent, le tri des zones les plus utilisées est également réinitialisé.")
mkstr(SI.TELE_SETTINGS_WHISPER_NOTE, "Notification de message privé")
mkstr(SI.TELE_SETTINGS_WHISPER_NOTE_TOOLTIP, "Lorsque vous êtes configuré comme déconnecté et que vous envoyez un message privé à un autre joueur, vous recevrez une notification dans le tchat indiquant que vous ne pouvez pas recevoir de message privé. Cette fonctionnalité vous permet d'éviter le blocage non désiré des réponses.")
mkstr(SI.TELE_SETTINGS_SCALE, "Échelle IU")
mkstr(SI.TELE_SETTINGS_SCALE_TOOLTIP, "Facteur d'échelle de la fenêtre/IU entière de BeamMeUp. Il sera nécessaire de recharger l'interface utilisateur pour appliquer les modifications.")
mkstr(SI.TELE_SETTINGS_RESET_UI, "Réinitialiser l'IU")
mkstr(SI.TELE_SETTINGS_RESET_UI_TOOLTIP, "Réinitialiser l'interface utilisateur de BeamMeUp en remettant les options suivantes à leur valeur par défaut : Échelle IU, Décalage du bouton, Décalages de l'ancrage et Positions de la fenêtre. La totalité de l'IU sera rechargée.")
mkstr(SI.TELE_SETTINGS_HOUSE_NICKNAMES, "Montrer les noms personnalisés des maisons")
mkstr(SI.TELE_SETTINGS_HOUSE_NICKNAMES_TOOLTIP, "Affiche les noms personnalisés (modifiables) de vos maisons au lieu des noms par défaut.")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION, "Notification de repérage")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_TOOLTIP, "Si vous récoltez un repérage et qu'il reste encore des cartes identiques (même endroit) dans votre inventaire, une notification (message au centre de l'écran) vous en avertira.")
mkstr(SI.TELE_SETTINGS_HEADER_PRIO, "Priorisation")
mkstr(SI.TELE_SETTINGS_HEADER_CHAT_COMMANDS, "Commandes de tchat")
mkstr(SI.TELE_SETTINGS_UNLOCKING_LESS_CHAT_OUTPUT, "Limiter les messages dans le tchat")
mkstr(SI.TELE_SETTINGS_UNLOCKING_LESS_CHAT_OUTPUT_TOOLTIP, "Réduire le nombre de messages dans le tchat lors de l'utilisation de la fonctionnalité d'auto-découverte.")
mkstr(SI.TELE_SETTINGS_PRIORITIZATION_DESCRIPTION, "Ici, vous pouvez configurer vers quel joueur se téléporter de préférence. Après avoir rejoint ou quitté une guilde, un rechargement de l'UI est nécessaire pour mettre à jour l'affichage. |ca20000Cette option est uniquement liée à ce personnage.|r")
mkstr(SI.TELE_SETTINGS_SCAN_BANK_FOR_MAPS, "Recherche de carte dans votre banque")
mkstr(SI.TELE_SETTINGS_SCAN_BANK_FOR_MAPS_TOOLTIP, "Recherche additionnelle de cartes aux trésors et de repérages dans votre banque")
mkstr(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP, "Bouton supplémentaire sur la carte")
mkstr(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP_TOOLTIP, "Afficher un bouton texte supplémentaire dans le coin en haut à gauche de la carte du monde, pour ouvrir BeamMeUp.")
mkstr(SI.TELE_SETTINGS_SCAN_LEADS, "Afficher les pistes sondables")
mkstr(SI.TELE_SETTINGS_SCAN_LEADS_TOOLTIP, "Afficher les pistes sondables en même temps que les cartes au trésor et les repérages.")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND, "Jouer un son")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND_TOOLTIP, "Jouer un son en affichant la notification.")
mkstr(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL, "Auto-confirmation du voyage vers un oratoire")
mkstr(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL_TOOLTIP, "Désactive le dialogue de confirmation quand vous vous téléportez vers d'autres oratoires.")
mkstr(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP, "Afficher d'abord la zone courante")
mkstr(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP_TOOLTIP, "Toujours afficher la zone courante en début de liste.")



-----------------------------------------------------------------------------
-- KEY BINDING
-----------------------------------------------------------------------------
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN, "Ouvrir BeamMeUp")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_RELATED_ITEMS, "Cartes au trésor, Repérages & Pistes")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_CURRENT_ZONE, "Zone actuelle")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_DELVES, "Antres dans la zone actuelle")
mkstr(SI.TELE_KEYBINDING_REFRESH, "Actualiser")
mkstr(SI.TELE_KEYBINDING_WAYSHRINE_UNLOCK, "Déblocage des oratoires")
mkstr(SI.TELE_KEYBINDING_GROUP_LEADER, "Voyage vers le chef de groupe")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_ACTIVE_QUESTS, "Quêtes actives")
mkstr(SI.TELE_KEYBINDING_PRIMARY_RESIDENCE, "Visiter votre résidence principale")
mkstr(SI.TELE_KEYBINDING_GUILD_HOUSE_BMU, "Visiter la maison de guilde BeamMeUp")



-----------------------------------------------------------------------------
-- DIALOGS | NOTIFICATIONS
-----------------------------------------------------------------------------
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_TITLE, "Commencer le déverrouillage automatique des oratoires ?")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_BODY, "Si vous confirmer, BeamMeUp commencera une série de voyages rapides incomplets vers d'autres joueurs dans votre région. Si ces joueurs se trouvent dans les environs d'oratoires inconnus, ce processus suffira à vous permettre d'utiliser ces oratoires à l'avenir. Notez que le guide de zone ne se mettra à jour que lorsque vous vous rendrez physiquement à l'oratoire.")
mkstr(SI.TELE_DIALOG_NO_BMU_GUILD_BODY, "Nous sommes désolés, mais il semblerait qu'il n'y a pas encore de guilde BeamMeUp active sur ce serveur.\n\nN'hésitez pas à nous contacter via le site ESOUI afin qu'une guilde officielle BeamMeUp soit créée sur ce serveur.")
mkstr(SI.TELE_DIALOG_INFO_BMU_GUILD_BODY, "Bonjour et merci d'utiliser BeamMeUp. En 2019, nous avons créé plusieurs guildes BeamMeUp dans le but de partager librement nos options de voyage rapide. Toutle monde est bienvenu, aucun prérequis ni obligation !\n\nEn confirmant cette boîte de dialogue, vous verrez les guildes officielles BeamMeUp et les guildes partenaires. Nous vous invitons cordialement à nous rejoindre ! Vous pouvez aussi afficher les guildes en cliquant sur le bouton guilde dans le coin en haut à gauche.\nVotre équipe BeamMeUp")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE, "La découverte n'est plus nécessaire")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY, "Tous les oratoires de la zone ont été découverts")
mkstr(SI.TELE_DIALOG_INFO_NEW_FEATURE_FAVORITE_PLAYER_NOTIFICATION, "Vous recevez une notification (message au centre de l'écran) quand un joueur favori se connecte.\n\nActiver cette fonctionnalité ?")
mkstr(SI.TELE_DIALOG_INFO_NEW_FEATURE_SURVEY_MAP_NOTIFICATION, "Si vous récoltez un repérage et qu'il reste encore des cartes identiques (même endroit) dans votre inventaire, une notification (message au centre de l'écran) vous en avertira.\n\nActiver cette fonctionnalité ?")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE2, "La découverte n'est pas possible.")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY2, "La découverte des oratoires n'est pas disponible dans cette zone. Cette fonctionnalité n'est disponible que dans les zones et régions principales.")
mkstr(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_TITLE, "Integration de \"Port to Friend's House\"")
mkstr(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_BODY, "Pour utiliser la fonctionnalité d'intégration, installez l'extension \"Port to Friend's House\". Vos maisons et manoirs de guilde configurés apparaitront alors dans cette liste.\n\nVoulez-vous accéder au site de l'extension ?")


-----------------------------------------------------------------------------
-- ITEM NAMES (PART OF IT) - BACKUP
-----------------------------------------------------------------------------
mkstr(SI.CONSTANT_TREASURE_MAP, "carte au trésor") -- need a part of the item name that is in every treasure map item the same no matter which zone
mkstr(SI.CONSTANT_SURVEY_MAP, "repérages") -- need a part of the item name that is in every survey map item the same no matter which zone and kind of craft