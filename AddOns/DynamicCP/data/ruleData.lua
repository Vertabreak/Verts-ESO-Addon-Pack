DynamicCP = DynamicCP or {}

--[[
"|ce46b2e" -- Red
"|c59bae7" -- Blue
"|ca5d752" -- Green
    [""] = {
        description = "",
        rules = {

        },
    },
]]

-- [name of group to display] = {description = desc, rules = {}}
DynamicCP.exampleRules = {
    ["House Decon"] = {
        description = "A single rule that slots:\n\n|ca5d752Steed's Blessing|r, |ca5d752Liquid Efficiency|r, and |ca5d752Meticulous Disassembly|r\n\nwhen you enter a player-owned house.",
        rules = {
            ["House Green Decon"] = {
                ["dps"] = true,
                ["healer"] = true,
                ["name"] = "House Green Decon",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 0,
                ["reeval"] = false,
                ["tank"] = true,
                ["trigger"] = "Player House",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = 66, -- Steed's Blessing
                    [3] = 86, -- Liquid Efficiency
                    [4] = 83, -- Meticulous Disassembly
                    [5] = -1,
                    [6] = -1,
                    [7] = -1,
                    [8] = -1,
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = -1,
                },
            },
        },
    },
    ["Trial"] = {
        description = "A set of rules that slots:\n\n|ca5d752Treasure Hunter|r, |ca5d752Steed's Blessing|r, |ca5d752Liquid Efficiency|r, |ce46b2eBoundless Vitality|r, |ce46b2eIronclad|r, and |ce46b2eRejuvenation|r on all roles;\n\n|ce46b2eSpirit Mastery|r, |c59bae7Backstabber|r, |c59bae7Fighting Finesse|r, |c59bae7Biting Aura|r, and |c59bae7Thaumaturge|r on dps;\n\n|ce46b2eExpert Evasion|r, |c59bae7Duelist's Rebuff|r, |c59bae7Enduring Resolve|r, |c59bae7Unassailable|r, and |c59bae7Bulwark|r on tank;\n\n|ce46b2eSlippery|r, |c59bae7Soothing Tide|r, |c59bae7Fighting Finesse|r, |c59bae7Arcane Supremacy|r, and |c59bae7Untamed Aggression|r on healer;\n\nwhen you enter a trial.",
        rules = {
            ["Trial Green / Red"] = {
                ["dps"] = true,
                ["healer"] = true,
                ["name"] = "Trial Green / Red",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 100,
                ["reeval"] = false,
                ["tank"] = true,
                ["trigger"] = "Trial",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = 79, -- Treasure Hunter
                    [2] = 66, -- Steed's Blessing
                    [3] = 86, -- Liquid Efficiency
                    [4] = -1,
                    [5] = -1,
                    [6] = -1,
                    [7] = -1,
                    [8] = -1,
                    [9] = 2, -- Boundless Vitality
                    [10] = 34, -- Ironclad
                    [11] = 35, -- Rejuvenation
                    [12] = -1,
                },
            },
            ["Trial Dps Stab AOE / Rezzer"] = {
                ["dps"] = true,
                ["healer"] = false,
                ["name"] = "Trial Dps Stab AOE / Rezzer",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 110,
                ["reeval"] = false,
                ["tank"] = false,
                ["trigger"] = "Trial",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = 31, -- Backstabber
                    [6] = 12, -- Fighting Finesse
                    [7] = 23, -- Biting Aura
                    [8] = 264, -- Master-at-Arms
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = 56, -- Spirit Mastery
                },
            },
            ["Trial Tank Blue / Red Dodge"] = {
                ["dps"] = false,
                ["healer"] = false,
                ["name"] = "Trial Tank Blue / Red Dodge",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 110,
                ["reeval"] = false,
                ["tank"] = true,
                ["trigger"] = "Trial",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = 134, -- Duelist's Rebuff
                    [6] = 136, -- Enduring Resolve
                    [7] = 133, -- Unassailable
                    [8] = 159, -- Bulwark
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = 51, -- Expert Evasion
                },
            },
            ["Trial Healer Blue / Slippery"] = {
                ["dps"] = false,
                ["healer"] = true,
                ["name"] = "Trial Healer Blue / Slippery",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 110,
                ["reeval"] = false,
                ["tank"] = false,
                ["trigger"] = "Trial",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = 24, -- Soothing Tide
                    [6] = 12, -- Fighting Finesse
                    [7] = 3, -- Arcane Supremacy
                    [8] = 4, -- Untamed Aggression
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = 52, -- Slippery
                },
            },
        },
    },
    ["Dungeon / Group Arena"] = {
        description = "A set of rules that slots:\n\n|ca5d752Treasure Hunter|r, |ca5d752Steed's Blessing|r, |ca5d752Liquid Efficiency|r, |ca5d752Homemaker|r, |ce46b2eBoundless Vitality|r, |ce46b2eIronclad|r, and |ce46b2eRejuvenation|r on all roles;\n\n|ce46b2eBloody Renewal / Siphoning Spells|r, |c59bae7Backstabber|r, |c59bae7Fighting Finesse|r, |c59bae7Biting Aura|r, and |c59bae7Thaumaturge|r on dps;\n\n|ce46b2eExpert Evasion|r, |c59bae7Duelist's Rebuff|r, |c59bae7Enduring Resolve|r, |c59bae7Unassailable|r, and |c59bae7Bulwark|r on tank;\n\n|ce46b2eSlippery|r, |c59bae7Soothing Tide|r, |c59bae7Fighting Finesse|r, |c59bae7Arcane Supremacy|r, and |c59bae7Untamed Aggression|r on healer;\n\nwhen you enter a group dungeon or group arena.",
        rules = {
            ["Dungeon Green / Red"] = {
                ["dps"] = true,
                ["healer"] = true,
                ["name"] = "Dungeon Green / Red",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 300,
                ["reeval"] = false,
                ["tank"] = true,
                ["trigger"] = "Group Dungeon",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = 79, -- Treasure Hunter
                    [2] = 66, -- Steed's Blessing
                    [3] = 86, -- Liquid Efficiency
                    [4] = 91, -- Homemaker
                    [5] = -1,
                    [6] = -1,
                    [7] = -1,
                    [8] = -1,
                    [9] = 2, -- Boundless Vitality
                    [10] = 34, -- Ironclad
                    [11] = 35, -- Rejuvenation
                    [12] = -1,
                },
            },
            ["Dungeon Dps Stab AOE / Sustain"] = {
                ["dps"] = true,
                ["healer"] = false,
                ["name"] = "Dungeon Dps Stab AOE / Sustain",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 310,
                ["reeval"] = false,
                ["tank"] = false,
                ["trigger"] = "Group Dungeon",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = 31, -- Backstabber
                    [6] = 12, -- Fighting Finesse
                    [7] = 23, -- Biting Aura
                    [8] = 264, -- Master-at-Arms
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = 48, -- Bloody Renewal
                },
            },
            ["Dungeon Tank Blue / Dodge"] = {
                ["dps"] = false,
                ["healer"] = false,
                ["name"] = "Dungeon Tank Blue / Dodge",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 310,
                ["reeval"] = false,
                ["tank"] = true,
                ["trigger"] = "Group Dungeon",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = 134, -- Duelist's Rebuff
                    [6] = 136, -- Enduring Resolve
                    [7] = 133, -- Unassailable
                    [8] = 159, -- Bulwark
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = 51, -- Expert Evasion
                },
            },
            ["Dungeon Healer Blue / Dodge"] = {
                ["dps"] = false,
                ["healer"] = true,
                ["name"] = "Dungeon Healer Blue / Dodge",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 310,
                ["reeval"] = false,
                ["tank"] = false,
                ["trigger"] = "Group Dungeon",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = 24, -- Soothing Tide
                    [6] = 12, -- Fighting Finesse
                    [7] = 3, -- Arcane Supremacy
                    [8] = 4, -- Untamed Aggression
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = 51, -- Expert Evasion
                },
            },
            ["Arena Green / Red"] = {
                ["dps"] = true,
                ["healer"] = true,
                ["name"] = "Arena Green / Red",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 400,
                ["reeval"] = false,
                ["tank"] = true,
                ["trigger"] = "Group Arena",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = 79, -- Treasure Hunter
                    [2] = 66, -- Steed's Blessing
                    [3] = 86, -- Liquid Efficiency
                    [4] = 91, -- Homemaker
                    [5] = -1,
                    [6] = -1,
                    [7] = -1,
                    [8] = -1,
                    [9] = 2, -- Boundless Vitality
                    [10] = 34, -- Ironclad
                    [11] = 35, -- Rejuvenation
                    [12] = -1,
                },
            },
            ["Arena Dps Stab AOE / Sustain"] = {
                ["dps"] = true,
                ["healer"] = false,
                ["name"] = "Arena Dps Stab AOE / Sustain",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 410,
                ["reeval"] = false,
                ["tank"] = false,
                ["trigger"] = "Group Arena",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = 31, -- Backstabber
                    [6] = 12, -- Fighting Finesse
                    [7] = 23, -- Biting Aura
                    [8] = 264, -- Master-at-Arms
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = 48, -- Bloody Renewal
                },
            },
            ["Arena Tank Blue / Dodge"] = {
                ["dps"] = false,
                ["healer"] = false,
                ["name"] = "Arena Tank Blue / Dodge",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 410,
                ["reeval"] = false,
                ["tank"] = true,
                ["trigger"] = "Group Arena",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = 134, -- Duelist's Rebuff
                    [6] = 136, -- Enduring Resolve
                    [7] = 133, -- Unassailable
                    [8] = 159, -- Bulwark
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = 51, -- Expert Evasion
                },
            },
            ["Arena Healer Blue / Slippery"] = {
                ["dps"] = false,
                ["healer"] = true,
                ["name"] = "Arena Healer Blue / Slippery",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 410,
                ["reeval"] = false,
                ["tank"] = false,
                ["trigger"] = "Group Arena",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = 24, -- Soothing Tide
                    [6] = 12, -- Fighting Finesse
                    [7] = 3, -- Arcane Supremacy
                    [8] = 4, -- Untamed Aggression
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = 52, -- Slippery
                },
            },
        },
    },
    ["Solo Arena"] = {
        description = "A single rule that slots:\n\n|ca5d752Rationer|r, |ca5d752Steed's Blessing|r, |ca5d752Liquid Efficiency|r, |ca5d752Professional Upkeep|r, |ce46b2eBoundless Vitality|r, |ce46b2eIronclad|r, |ce46b2eRejuvenation|r, |ce46b2eBloody Renewal / Siphoning Spells|r, |c59bae7Deadly Aim|r, |c59bae7Fighting Finesse|r, |c59bae7Biting Aura|r, and |c59bae7Thaumaturge|r\n\nwhen you enter a solo arena.",
        rules = {
            ["Solo Arena Green / Red / NonStab"] = {
                ["dps"] = true,
                ["healer"] = true,
                ["name"] = "Solo Arena Green / Red / NonStab",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 200,
                ["reeval"] = false,
                ["tank"] = true,
                ["trigger"] = "Solo Arena",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = 85, -- Rationer
                    [2] = 66, -- Steed's Blessing
                    [3] = 86, -- Liquid Efficiency
                    [4] = 1, -- Professional Upkeep
                    [5] = 25, -- Deadly Aim
                    [6] = 12, -- Fighting Finesse
                    [7] = 23, -- Biting Aura
                    [8] = 264, -- Master-at-Arms
                    [9] = 2, -- Boundless Vitality
                    [10] = 34, -- Ironclad
                    [11] = 35, -- Rejuvenation
                    [12] = 48, -- Bloody Renewal
                },
            },
        },
    },
    ["Overland"] = {
        description = "A set of rules that slots:\n\n|ca5d752Treasure Hunter|r, |ca5d752Steed's Blessing|r, |ca5d752Homemaker|r, and |ca5d752Gifted Rider|r on all roles;\n\n|ce46b2eBloody Renewal / Siphoning Spells|r, |c59bae7Deadly Aim|r, |c59bae7Fighting Finesse|r, |c59bae7Biting Aura|r, and |c59bae7Thaumaturge|r on dps;\n\nwhen you enter an overland zone.\n\nAnd slots |ca5d752Liquid Efficiency|r instead of Gifted Rider in public dungeons, delves, and group instances.",
        rules = {
            ["Instance Green"] = {
                ["dps"] = true,
                ["healer"] = true,
                ["name"] = "Instance Green",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 640,
                ["reeval"] = false,
                ["tank"] = true,
                ["trigger"] = "Group Instance **",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = 79, -- Treasure Hunter
                    [2] = 66, -- Steed's Blessing
                    [3] = 91, -- Homemaker
                    [4] = 86, -- Liquid Efficiency
                    [5] = -1,
                    [6] = -1,
                    [7] = -1,
                    [8] = -1,
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = -1,
                },
            },
            ["Instance Dps NonStab"] = {
                ["dps"] = true,
                ["healer"] = false,
                ["name"] = "Instance Dps NonStab",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 650,
                ["reeval"] = false,
                ["tank"] = false,
                ["trigger"] = "Group Instance **",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = 25, -- Deadly Aim
                    [6] = 12, -- Fighting Finesse
                    [7] = 23, -- Biting Aura
                    [8] = 264, -- Master-at-Arms
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = -1,
                },
            },
            ["Overland Green"] = {
                ["dps"] = true,
                ["healer"] = true,
                ["name"] = "Overland Green",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 600,
                ["reeval"] = false,
                ["tank"] = true,
                ["trigger"] = "Overland",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = 79, -- Treasure Hunter
                    [2] = 66, -- Steed's Blessing
                    [3] = 91, -- Homemaker
                    [4] = 92, -- Gifted Rider
                    [5] = -1,
                    [6] = -1,
                    [7] = -1,
                    [8] = -1,
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = -1,
                },
            },
            ["Public / Delve Dps NonStab"] = {
                ["dps"] = true,
                ["healer"] = false,
                ["name"] = "Public / Delve Dps NonStab",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 630,
                ["reeval"] = false,
                ["tank"] = false,
                ["trigger"] = "Public Instance *",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = 25, -- Deadly Aim
                    [6] = 12, -- Fighting Finesse
                    [7] = 23, -- Biting Aura
                    [8] = 264, -- Master-at-Arms
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = -1,
                },
            },
            ["Public / Delve Green"] = {
                ["dps"] = true,
                ["healer"] = true,
                ["name"] = "Public / Delve Green",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 620,
                ["reeval"] = false,
                ["tank"] = true,
                ["trigger"] = "Public Instance *",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = 79, -- Treasure Hunter
                    [2] = 66, -- Steed's Blessing
                    [3] = 91, -- Homemaker
                    [4] = 86, -- Liquid Efficiency
                    [5] = -1,
                    [6] = -1,
                    [7] = -1,
                    [8] = -1,
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = -1,
                },
            },
            ["Overland Dps NonStab"] = {
                ["dps"] = true,
                ["healer"] = false,
                ["name"] = "Overland Dps NonStab",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 610,
                ["reeval"] = false,
                ["tank"] = false,
                ["trigger"] = "Overland",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = 25, -- Deadly Aim
                    [6] = 12, -- Fighting Finesse
                    [7] = 23, -- Biting Aura
                    [8] = 264, -- Master-at-Arms
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = -1,
                },
            },
        },
    },
    ["PVP"] = {
        description = "A set of rules that slots:\n\n|ca5d752Gifted Rider|r, |ca5d752Steed's Blessing|r, |ca5d752Liquid Efficiency|r, and |ca5d752War Mount|r on all roles;\n\n|ce46b2eBoundless Vitality|r, |ce46b2eJuggernaut|r, |ce46b2eRejuvenation|r, |ce46b2eStrategic Reserve|r, |c59bae7Backstabber|r, |c59bae7Fighting Finesse|r, |c59bae7Deadly Aim|r, and |c59bae7Resilience|r on dps;\n\nwhen you enter Cyrodiil or Imperial City / Sewers.",
        rules = {
            ["IC Dps Red / Blue"] = {
                ["dps"] = true,
                ["healer"] = false,
                ["name"] = "IC Dps Red / Blue",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 730,
                ["reeval"] = false,
                ["tank"] = false,
                ["trigger"] = "Imperial City",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = 31, -- Backstabber
                    [6] = 12, -- Fighting Finesse
                    [7] = 25, -- Deadly Aim
                    [8] = 13, -- Resilience
                    [9] = 2, -- Boundless Vitality
                    [10] = 59, -- Juggernaut
                    [11] = 35, -- Rejuvenation
                    [12] = 49, -- Strategic Reserve
                },
            },
            ["Cyro Dps Red / Blue"] = {
                ["dps"] = true,
                ["healer"] = false,
                ["name"] = "Cyro Dps Red / Blue",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 710,
                ["reeval"] = false,
                ["tank"] = false,
                ["trigger"] = "Cyrodiil",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = 31, -- Backstabber
                    [6] = 12, -- Fighting Finesse
                    [7] = 25, -- Deadly Aim
                    [8] = 13, -- Resilience
                    [9] = 2, -- Boundless Vitality
                    [10] = 59, -- Juggernaut
                    [11] = 35, -- Rejuvenation
                    [12] = 49, -- Strategic Reserve
                },
            },
            ["IC Green"] = {
                ["dps"] = true,
                ["healer"] = true,
                ["name"] = "IC Green",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 720,
                ["reeval"] = false,
                ["tank"] = true,
                ["trigger"] = "Imperial City",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = 92, -- Gifted Rider
                    [2] = 66, -- Steed's Blessing
                    [3] = 86, -- Liquid Efficiency
                    [4] = 82, -- War Mount
                    [5] = -1,
                    [6] = -1,
                    [7] = -1,
                    [8] = -1,
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = -1,
                },
            },
            ["Cyro Green"] = {
                ["dps"] = true,
                ["healer"] = true,
                ["name"] = "Cyro Green",
                ["normal"] = true,
                ["param1"] = "",
                ["param2"] = "",
                ["priority"] = 700,
                ["reeval"] = false,
                ["tank"] = true,
                ["trigger"] = "Cyrodiil",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = 92, -- Gifted Rider
                    [2] = 66, -- Steed's Blessing
                    [3] = 86, -- Liquid Efficiency
                    [4] = 82, -- War Mount
                    [5] = -1,
                    [6] = -1,
                    [7] = -1,
                    [8] = -1,
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = -1,
                },
            },
        },
    },
}

DynamicCP.exampleBossRules = {
    ["Sunspire"] = {
        description = "You can't effectively flank the dragons in Sunspire, so this set of rules will slot |c59bae7Deadly Aim|r instead of Backstabber when you enter the boss areas, and slot |c59bae7Backstabber|r instead of Deadly Aim after you kill the bosses, because you usually flank for the trash pulls.",
        rules = {
            ["SS Trash Stab AOE"] = {
                ["dps"] = true,
                ["healer"] = false,
                ["name"] = "SS Trash Stab AOE",
                ["normal"] = true,
                ["param1"] = "Lokkestiiz%Yolnahkriin",
                ["param2"] = "",
                ["priority"] = 921,
                ["reeval"] = false,
                ["tank"] = false,
                ["trigger"] = "Specific Boss Death",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = 31, -- Backstabber
                    [6] = 12, -- Fighting Finesse
                    [7] = 23, -- Biting Aura
                    [8] = 264, -- Master-at-Arms
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = -1,
                },
            },
            ["SS Boss NonStab"] = {
                ["dps"] = true,
                ["healer"] = false,
                ["name"] = "SS Boss NonStab",
                ["normal"] = true,
                ["param1"] = "Lokkestiiz%Yolnahkriin%Nahviintaas",
                ["param2"] = "",
                ["priority"] = 920,
                ["reeval"] = false,
                ["tank"] = false,
                ["trigger"] = "Specific Boss Name",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = 25, -- Deadly Aim
                    [6] = 12, -- Fighting Finesse
                    [7] = 23, -- Biting Aura
                    [8] = 264, -- Master-at-Arms
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = -1,
                },
            },
        },
    },
    ["Halls of Fabrication"] = {
        description = "This set of rules will slot |c59bae7Deadly Aim|r instead of Backstabber after the Pinnacle Factotum dies (in preparation for Archcustodian) and when you encounter Assembly General, and slot |c59bae7Backstabber|r instead of Deadly Aim after you kill Archcustodian.",
        rules = {
            ["HoF Trash Stab AOE"] = {
                ["dps"] = true,
                ["healer"] = false,
                ["name"] = "HoF Trash Stab AOE",
                ["normal"] = true,
                ["param1"] = "Archcustodian",
                ["param2"] = "",
                ["priority"] = 932,
                ["reeval"] = false,
                ["tank"] = false,
                ["trigger"] = "Specific Boss Death",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = 31, -- Backstabber
                    [6] = 12, -- Fighting Finesse
                    [7] = 23, -- Biting Aura
                    [8] = 264, -- Master-at-Arms
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = -1,
                },
            },
            ["HoF AG NonStab"] = {
                ["dps"] = true,
                ["healer"] = false,
                ["name"] = "HoF AG NonStab",
                ["normal"] = true,
                ["param1"] = "Assembly General",
                ["param2"] = "",
                ["priority"] = 930,
                ["reeval"] = false,
                ["tank"] = false,
                ["trigger"] = "Specific Boss Name",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = 25, -- Deadly Aim
                    [6] = 12, -- Fighting Finesse
                    [7] = 23, -- Biting Aura
                    [8] = 264, -- Master-at-Arms
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = -1,
                },
            },
            ["HoF Spider NonStab"] = {
                ["dps"] = true,
                ["healer"] = false,
                ["name"] = "HoF Spider NonStab",
                ["normal"] = true,
                ["param1"] = "Pinnacle Factotum",
                ["param2"] = "",
                ["priority"] = 931,
                ["reeval"] = false,
                ["tank"] = false,
                ["trigger"] = "Specific Boss Death",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = 25, -- Deadly Aim
                    [6] = 12, -- Fighting Finesse
                    [7] = 23, -- Biting Aura
                    [8] = 264, -- Master-at-Arms
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = -1,
                },
            },
        },
    },
    ["Maelstrom Arena"] = {
        description = "Backstabber is viable on some bosses in Maelstrom Arena, especially if you use mechanics to stun the bosses. This set of rules will slot |c59bae7Backstabber|r instead of Deadly Aim when you encounter The Control Guardian (arena 4), Champion of Atrocity (arena 6), and Voriak Solkyn (arena 9). Upon death of the bosses, your solo arena rules will be restored.",
        rules = {
            ["vMA ReEval NonStab"] = {
                ["dps"] = true,
                ["healer"] = true,
                ["name"] = "vMA ReEval NonStab",
                ["normal"] = true,
                ["param1"] = "The Control Guardian%Champion of Atrocity",
                ["param2"] = "",
                ["priority"] = 941,
                ["reeval"] = true,
                ["tank"] = true,
                ["trigger"] = "Specific Boss Death",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = -1,
                    [6] = -1,
                    [7] = -1,
                    [8] = -1,
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = -1,
                },
            },
            ["vMA Boss Stab AOE"] = {
                ["dps"] = true,
                ["healer"] = true,
                ["name"] = "vMA Boss Stab AOE",
                ["normal"] = true,
                ["param1"] = "Voriak Solkyn%The Control Guardian%Champion of Atrocity",
                ["param2"] = "",
                ["priority"] = 940,
                ["reeval"] = false,
                ["tank"] = true,
                ["trigger"] = "Specific Boss Name",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = 31, -- Backstabber
                    [6] = 12, -- Fighting Finesse
                    [7] = 23, -- Biting Aura
                    [8] = 264, -- Master-at-Arms
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = -1,
                },
            },
        },
    },
    ["Scalecaller Peak"] = {
        description = "Breaking free prematurely due to |ce46b2eSlippery|r in some Scalecaller Peak mechanics can result in death. Since I typically run Slippery on a healer, I opt for |ce46b2eExpert Evasion|r in Scalecaller Peak instead.",
        rules = {
            ["SCP Healer Dodge"] = {
                ["dps"] = false,
                ["healer"] = true,
                ["name"] = "SCP Healer Dodge",
                ["normal"] = true,
                ["param1"] = "1010",
                ["param2"] = "",
                ["priority"] = 800,
                ["reeval"] = false,
                ["tank"] = false,
                ["trigger"] = "Specific Zone ID",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = -1,
                    [6] = -1,
                    [7] = -1,
                    [8] = -1,
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = 51, -- Expert Evasion
                },
            },
        },
    },
    ["Asylum Sanctorium"] = {
        description = "There's not much that stuns you in Asylum Sanctorium. Since I typically run Slippery on a healer, I opt for |ce46b2eBastion|r in Asylum instead.",
        rules = {
            ["AS Healer Bastion"] = {
                ["dps"] = false,
                ["healer"] = true,
                ["name"] = "AS Healer Bastion",
                ["normal"] = true,
                ["param1"] = "1000",
                ["param2"] = "",
                ["priority"] = 800,
                ["reeval"] = false,
                ["tank"] = false,
                ["trigger"] = "Specific Zone ID",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = -1,
                    [2] = -1,
                    [3] = -1,
                    [4] = -1,
                    [5] = -1,
                    [6] = -1,
                    [7] = -1,
                    [8] = -1,
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = 46, -- Bastion
                },
            },
        },
    },
    ["Vvardenfell"] = {
        description = "I go to Vivec City to do my writs and inventory management, so this rule slots |ca5d752Meticulous Disassembly|r, |ca5d752Steed's Blessing|r, |ca5d752Homemaker|r, and |ca5d752Professional Upkeep|r instead of the usual overland rules.",
        rules = {
            ["Vvardenfell Green"] = {
                ["dps"] = true,
                ["healer"] = true,
                ["name"] = "Vvardenfell Green",
                ["normal"] = true,
                ["param1"] = "849",
                ["param2"] = "",
                ["priority"] = 699,
                ["reeval"] = false,
                ["tank"] = true,
                ["trigger"] = "Specific Zone ID",
                ["veteran"] = true,
                ["stars"] = {
                    [1] = 83, -- Meticulous Disassembly
                    [2] = 66, -- Steed's Blessing
                    [3] = 91, -- Homemaker
                    [4] = 1, -- Professional Upkeep
                    [5] = -1,
                    [6] = -1,
                    [7] = -1,
                    [8] = -1,
                    [9] = -1,
                    [10] = -1,
                    [11] = -1,
                    [12] = -1,
                },
            },
        },
    },
}
