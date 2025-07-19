_,db = ...
db.instanceOrderList = {
    249, 329, 532, 550, 556, 575, 585, 603, 616, 624, 631, 657, 720, 725,
    754, 859, 967, 1008, 1098, 1136, 1205, 1448, 1530, 1651, 1676, 1712,
    1754, 1762, 1841, 2070, 2217, 2286, 2441, 2450, 2481
}
db.waypoints = {
    [249] = {point = {70, 0.5217, 0.7595}},
    [329] = {point = {23, 0.4361, 0.1756}},
    [532] = {point = {42, 0.4715, 0.7494}},
    [550] = {point = {109, 0.7329, 0.6386}},
    [556] = {point = {108, 0.4455, 0.6549}},
    [575] = {point = {117, 0.572, 0.4652}},
    [585] = {point = {122, 0.6082, 0.3077}},
    [603] = {point = {120, 0.4179, 0.1754}},
    [616] = {point = {114, 0.2756, 0.2677}},
    [624] = {point = {123, 0.5008, 0.1189}},
    [631] = {point = {118, 0.5391, 0.8729}},
    [657] = {point = {249, 0.7665, 0.8433}},
    [720] = {point = {198, 0.4647, 0.7812}},
    [725] = {point = {207, 0.4743, 0.5254}},
    [754] = {point = {249, 0.3712, 0.8162}},
    [859] = {point = {50, 0.7219, 0.3284}},
    [967] = {point = {75, 0.6103, 0.2105}},
    [1008] = {point = {379, 0.5967, 0.3963}},
    [1098] = {point = {504, 0.6379, 0.3220}},
    [1136] = {point = {390, 0.7421, 0.4202}},
    [1205] = {point = {543, 0.5146, 0.2710}},
    [1448] = {point = {534, 0.4689, 0.5213}},
    [1530] = {point = {680, 0.4349, 0.5707}},
    [1651] = {point = {42, 0.467, 0.701}},
    [1676] = {point = {646, 0.6397, 0.2138}},
    [1712] = {point = {885, 0.5486, 0.6256}},
    [1754] = {point = {895, 0.843, 0.7836}},
    [1762] = {point = {862, 0.3712, 0.3938}},
    [1841] = {point = {863, 0.5125, 0.6472}},
    [2070] = {point = {{895, 0.7444, 0.2853}, {862, 0.5421, 0.2991}}},
    [2217] = {point = {{1527, 0.5519, 0.4398}, {1530, 0.3973, 0.4628}}},
    [2286] = {point = {1533, 0.4017, 0.5516}},
    [2441] = {point = {1550, 0.3154, 0.7609, 2016}},
    [2450] = {point = {1543, 0.6974, 0.322}},
    [2481] = {point = {1970, 0.8026, 0.5302}}
}

db.bossData = {
    [249] = { -- Onyxia's Lair
        { name = "Onyxia", encounterID = 1651, killedAtDiff = { [3] = false, [4] = false } },
    },
    [329] = { -- Stratholme
        { name = "Lord Aurius Rivendare", encounterID = 456, killedAtDiff = { [1] = false } },
    },
    [532] = { -- Karazhan
        { name = "Attumen the Huntsman", encounterID = 1553, killedAtDiff = { [3] = false } },
    },
    [550] = { -- The Eye
        { name = "Kael'thas Sunstrider", encounterID = 1576, killedAtDiff = { [4] = false } },
    },
    [556] = { -- Sethekk Halls
        { name = "Anzu", encounterID = 542, killedAtDiff = { [2] = false } },
    },
    [575] = { -- Utgarde Pinnacle
        { name = "Skadi the Ruthless", encounterID = 643, killedAtDiff = { [2] = false } },
    },
    [585] = { -- Magisters' Terrace
        { name = "Kael'thas Sunstrider", encounterID = 533, killedAtDiff = { [2] = false } },
    },
    [603] = { -- Ulduar
        { name = "Yogg-Saron", encounterID = 1649, killedAtDiff = { [14] = false } },
    },
    [616] = { -- The Eye of Eternity
        { name = "Malygos", encounterID = 1617, killedAtDiff = { [3] = false, [4] = false } },
    },
    [624] = { -- Vault of Archavon
        { name = "Archavon the Stone Watcher", encounterID = 1597, killedAtDiff = { [3] = false, [4] = false } },
        { name = "Emalon the Storm Watcher", encounterID = 1598, killedAtDiff = { [3] = false, [4] = false } },
        { name = "Koralon the Flame Watcher", encounterID = 1599, killedAtDiff = { [3] = false, [4] = false } },
        { name = "Toravon the Ice Watcher", encounterID = 1600, killedAtDiff = { [3] = false, [4] = false } },
    },
    [631] = { -- Icecrown Citadel
        { name = "The Lich King", encounterID = 1636, killedAtDiff = { [6] = false } },
    },
    [657] = { -- The Vortex Pinnacle
        { name = "Altairus", encounterID = 115, killedAtDiff = { [1] = false, [2] = false } },
    },
    [720] = { -- Firelands
        { name = "Alysrazor", encounterID = 194, killedAtDiff = { [14] = false, [15] = false } },
        { name = "Ragnaros", encounterID = 198, killedAtDiff = { [14] = false, [15] = false } },
    },
    [725] = { -- The Stonecore
        { name = "Slabhide", encounterID = 111, killedAtDiff = { [1] = false, [2] = false } },
    },
    [754] = { -- Throne of the Four Winds
        { name = "Al'Akir", encounterID = 155, killedAtDiff = { [3] = false, [4] = false, [5] = false, [6] = false } },
    },
    [859] = { -- Zul'Gurub
        { name = "Bloodlord Mandokir", encounterID = 176, killedAtDiff = { [2] = false } },
        { name = "High Priestess Kilnara", encounterID = 181, killedAtDiff = { [2] = false } },
    },
    [967] = { -- Dragon Soul
        { name = "Ultraxion", encounterID = 331, killedAtDiff = { [3] = false, [4] = false, [5] = false, [6] = false } },
        { name = "Madness of Deathwing", encounterID = 333, killedAtDiff = { [3] = false, [4] = false, [5] = false, [6] = false } },
    },
    [1008] = { -- Mogu'shan Vaults
        { name = "Elegon", encounterID = 726, killedAtDiff = { [3] = false, [4] = false, [5] = false, [6] = false } },
    },
    [1098] = { -- Throne of Thunder
        { name = "Horridon", encounterID = 819, killedAtDiff = { [3] = false, [4] = false, [5] = false, [6] = false } },
        { name = "Ji-Kun", encounterID = 828, killedAtDiff = { [3] = false, [4] = false, [5] = false, [6] = false } },
    },
    [1136] = { -- Siege of Orgrimmar
        { name = "Garrosh Hellscream", encounterID = 869, killedAtDiff = { [16] = false } },
    },
    [1205] = { -- Blackrock Foundry
        { name = "Blackhand", encounterID = 959, killedAtDiff = { [16] = false } },
    },
    [1448] = { -- Hellfire Citadel
        { name = "Archimonde", encounterID = 1438, killedAtDiff = { [16] = false } },
    },
    [1530] = { -- The Nighthold
        { name = "Gul'dan", encounterID = 1737, killedAtDiff = { [14] = false, [15] = false, [16] = false } },
    },
    [1651] = { -- Return to Karazhan
        { name = "Attumen the Huntsman", encounterID = 1835, killedAtDiff = { [23] = false } },
    },
    [1676] = { -- Tomb of Sargeras
        { name = "Mistress Sassz'ine", encounterID = 1861, killedAtDiff = { [14] = false, [15] = false, [16] = false, [17] = false } },
    },
    [1712] = { -- Antorus, the Burning Throne
        { name = "Felhounds of Sargeras", encounterID = 1987, killedAtDiff = { [14] = false, [15] = false, [16] = false, [17] = false } },
        { name = "Argus the Unmaker", encounterID = 2031, killedAtDiff = { [16] = false } },
    },
    [1754] = { -- Freehold
        { name = "Lord Harlan Sweete", encounterID = 2095, killedAtDiff = { [23] = false } },
    },
    [1762] = { -- Kings' Rest
        { name = "King Dazar", encounterID = 2172, killedAtDiff = { [23] = false } },
    },
    [1841] = { -- The Underrot
        { name = "Unbound Abomination", encounterID = 2158, killedAtDiff = { [23] = false } },
    },
    [2070] = { -- Battle of Dazar'alor
        { name = "Mekkatorque", encounterID = 2334, killedAtDiff = { [14] = false, [15] = false, [16] = false } },
        { name = "Lady Jaina Proudmoore", encounterID = 2343, killedAtDiff = { [16] = false, [17] = false } },
    },
    [2217] = { -- Ny'alotha, the Waking City
        { name = "N'Zoth the Corruptor", encounterID = 2375, killedAtDiff = { [16] = false } },
    },
    [2286] = { -- The Necrotic Wake
        { name = "Nalthor the Rimebinder", encounterID = 2396, killedAtDiff = { [23] = false } },
    },
    [2441] = { -- Tazavesh, the Veiled Market
        { name = "So'leah", encounterID = 2455, killedAtDiff = { [2] = false, [23] = false } },
    },
    [2450] = { -- Sanctum of Domination
        { name = "The Nine", encounterID = 2439, killedAtDiff = { [14] = false, [15] = false, [16] = false, [17] = false } },
        { name = "Sylvanas Windrunner", encounterID = 2441, killedAtDiff = { [16] = false } },
    },
    [2481] = { -- Sepulcher of the First Ones
        { name = "The Jailer", encounterID = 2464, killedAtDiff = { [16] = false } },
    },
}

-- mountData is indexed by mountID.
-- `dropsBy` contains a list of all sources for the mount.
-- `index` refers to the boss's position in the `bossData[instanceID]` table above.
db.mountData = {
    [13335] = { journalMountID = 69, dropsBy = {
        { instanceID = 329, diff = 1, index = 1, chance = 0.9 },
    }},
    [30480] = { journalMountID = 168, dropsBy = {
        { instanceID = 532, diff = 3, index = 1, chance = 1.1 },
    }},
    [32458] = { journalMountID = 183, dropsBy = {
        { instanceID = 550, diff = 4, index = 1, chance = 1.7 },
    }},
    [32768] = { journalMountID = 185, dropsBy = {
        { instanceID = 556, diff = 2, index = 1, chance = 1.6 },
    }},
    [35513] = { journalMountID = 213, dropsBy = {
        { instanceID = 585, diff = 2, index = 1, chance = 4.0 },
    }},
    [43952] = { journalMountID = 246, dropsBy = {
        { instanceID = 616, diff = 3, index = 1, chance = 3.0 },
        { instanceID = 616, diff = 4, index = 1, chance = 3.0 },
    }},
    [43953] = { journalMountID = 247, dropsBy = {
        { instanceID = 616, diff = 3, index = 1, chance = 4.0 },
        { instanceID = 616, diff = 4, index = 1, chance = 4.0 },
    }},
    [43959] = { journalMountID = 286, dropsBy = {
        { instanceID = 624, diff = 3, index = 1, chance = 1.1 }, { instanceID = 624, diff = 4, index = 1, chance = 1.1 },
        { instanceID = 624, diff = 3, index = 2, chance = 1.0 }, { instanceID = 624, diff = 4, index = 2, chance = 1.0 },
        { instanceID = 624, diff = 3, index = 3, chance = 1.0 }, { instanceID = 624, diff = 4, index = 3, chance = 1.0 },
        { instanceID = 624, diff = 3, index = 4, chance = 0.8 }, { instanceID = 624, diff = 4, index = 4, chance = 0.8 },
    }},
    [44151] = { journalMountID = 264, dropsBy = {
        { instanceID = 575, diff = 2, index = 1, chance = 0.8 },
    }},
    [45693] = { journalMountID = 304, dropsBy = {
        { instanceID = 603, diff = 14, index = 1, chance = 1.0 },
    }},
    [49636] = { journalMountID = 349, dropsBy = {
        { instanceID = 249, diff = 3, index = 1, chance = 1.5 },
        { instanceID = 249, diff = 4, index = 1, chance = 1.5 },
    }},
    [50818] = { journalMountID = 363, dropsBy = {
        { instanceID = 631, diff = 6, index = 1, chance = 0.8 },
    }},
    [63040] = { journalMountID = 395, dropsBy = {
        { instanceID = 657, diff = 1, index = 1, chance = 0.7 },
        { instanceID = 657, diff = 2, index = 1, chance = 0.7 },
    }},
    [63041] = { journalMountID = 396, dropsBy = {
        { instanceID = 754, diff = 3, index = 1, chance = 2.0 }, { instanceID = 754, diff = 4, index = 1, chance = 2.0 },
        { instanceID = 754, diff = 5, index = 1, chance = 2.0 }, { instanceID = 754, diff = 6, index = 1, chance = 2.0 },
    }},
    [63043] = { journalMountID = 397, dropsBy = {
        { instanceID = 725, diff = 1, index = 1, chance = 0.7 },
        { instanceID = 725, diff = 2, index = 1, chance = 0.7 },
    }},
    [68823] = { journalMountID = 410, dropsBy = {
        { instanceID = 859, diff = 2, index = 1, chance = 0.7 },
    }},
    [68824] = { journalMountID = 411, dropsBy = {
        { instanceID = 859, diff = 2, index = 2, chance = 0.9 },
    }},
    [69224] = { journalMountID = 415, dropsBy = {
        { instanceID = 720, diff = 14, index = 2, chance = 1.7 },
        { instanceID = 720, diff = 15, index = 2, chance = 1.7 },
    }},
    [71665] = { journalMountID = 425, dropsBy = {
        { instanceID = 720, diff = 14, index = 1, chance = 2.0 },
        { instanceID = 720, diff = 15, index = 1, chance = 2.0 },
    }},
    [77067] = { journalMountID = 442, dropsBy = {
        { instanceID = 967, diff = 3, index = 2, chance = 3.0 }, { instanceID = 967, diff = 4, index = 2, chance = 3.0 },
        { instanceID = 967, diff = 5, index = 2, chance = 3.0 }, { instanceID = 967, diff = 6, index = 2, chance = 3.0 },
    }},
    [77069] = { journalMountID = 444, dropsBy = {
        { instanceID = 967, diff = 5, index = 2, chance = 1.8 },
        { instanceID = 967, diff = 6, index = 2, chance = 1.8 },
    }},
    [78919] = { journalMountID = 445, dropsBy = {
        { instanceID = 967, diff = 3, index = 1, chance = 1.2 }, { instanceID = 967, diff = 4, index = 1, chance = 1.2 },
        { instanceID = 967, diff = 5, index = 1, chance = 1.2 }, { instanceID = 967, diff = 6, index = 1, chance = 1.2 },
    }},
    [87777] = { journalMountID = 478, dropsBy = {
        { instanceID = 1008, diff = 3, index = 1, chance = 4.0 }, { instanceID = 1008, diff = 4, index = 1, chance = 4.0 },
        { instanceID = 1008, diff = 5, index = 1, chance = 4.0 }, { instanceID = 1008, diff = 6, index = 1, chance = 4.0 },
    }},
    [93666] = { journalMountID = 531, dropsBy = {
        { instanceID = 1098, diff = 3, index = 1, chance = 2.0 }, { instanceID = 1098, diff = 4, index = 1, chance = 2.0 },
        { instanceID = 1098, diff = 5, index = 1, chance = 2.0 }, { instanceID = 1098, diff = 6, index = 1, chance = 2.0 },
    }},
    [95059] = { journalMountID = 543, dropsBy = {
        { instanceID = 1098, diff = 3, index = 2, chance = 2.0 }, { instanceID = 1098, diff = 4, index = 2, chance = 2.0 },
        { instanceID = 1098, diff = 5, index = 2, chance = 2.0 }, { instanceID = 1098, diff = 6, index = 2, chance = 2.0 },
    }},
    [104253] = { journalMountID = 559, dropsBy = {
        { instanceID = 1136, diff = 16, index = 1, chance = 0.9 },
    }},
    [116660] = { journalMountID = 613, dropsBy = {
        { instanceID = 1205, diff = 16, index = 1, chance = 2.0 },
    }},
    [123890] = { journalMountID = 751, dropsBy = {
        { instanceID = 1448, diff = 16, index = 1, chance = 4.0 },
    }},
    [137574] = { journalMountID = 791, dropsBy = {
        { instanceID = 1530, diff = 14, index = 1, chance = 0.5 },
        { instanceID = 1530, diff = 15, index = 1, chance = 0.5 },
        { instanceID = 1530, diff = 16, index = 1, chance = 0.5 },
    }},
    [137575] = { journalMountID = 633, dropsBy = {
        { instanceID = 1530, diff = 16, index = 1, chance = 8.0 },
    }},
    [142236] = { journalMountID = 875, dropsBy = {
        { instanceID = 1651, diff = 23, index = 1, chance = 0.9 },
    }},
    [143643] = { journalMountID = 899, dropsBy = {
        { instanceID = 1676, diff = 17, index = 1, chance = 0.2, lfr = {619, 0.4647, 0.6488, 627}, wing = 1494}, { instanceID = 1676, diff = 14, index = 1, chance = 0.2 },
        { instanceID = 1676, diff = 15, index = 1, chance = 0.2 }, { instanceID = 1676, diff = 16, index = 1, chance = 0.2 }
    }},
    [152789] = { journalMountID = 954, dropsBy = {
        { instanceID = 1712, diff = 16, index = 2, chance = 0.8 },
    }},
    [152816] = { journalMountID = 971, dropsBy = {
        { instanceID = 1712, diff = 17, index = 1, chance = 1.0, lfr = {619, 0.4647, 0.6488, 627}, wing = 1610}, { instanceID = 1712, diff = 14, index = 1, chance = 1.0 },
        { instanceID = 1712, diff = 15, index = 1, chance = 1.0 }, { instanceID = 1712, diff = 16, index = 1, chance = 1.0 }
    }},
    [159842] = { journalMountID = 995, dropsBy = {
        { instanceID = 1754, diff = 23, index = 1, chance = 0.8 },
    }},
    [159921] = { journalMountID = 1040, dropsBy = {
        { instanceID = 1762, diff = 23, index = 1, chance = 0.7 },
    }},
    [160829] = { journalMountID = 1053, dropsBy = {
        { instanceID = 1841, diff = 23, index = 1, chance = 0.7 },
    }},
    [166518] = { journalMountID = 1217, dropsBy = {
        { instanceID = 2070, diff = 17, index = 2, chance = 2.0, lfr = {{1161, 0.7418, 0.135}, {1164, 0.6859, 0.3042}}, wing = {1947, 1950}}, { instanceID = 2070, diff = 14, index = 1, chance = 2.0 },
        { instanceID = 2070, diff = 15, index = 1, chance = 2.0 }, { instanceID = 2070, diff = 16, index = 1, chance = 2.0 }
    }},
    [166705] = { journalMountID = 1219, dropsBy = {
        { instanceID = 2070, diff = 16, index = 2, chance = 0.6 },
    }},
    [174872] = { journalMountID = 1293, dropsBy = {
        { instanceID = 2217, diff = 16, index = 1, chance = 0.6 },
    }},
    [181819] = { journalMountID = 1406, dropsBy = {
        { instanceID = 2286, diff = 23, index = 1, chance = 0.8 },
    }},
    [186638] = { journalMountID = 1481, dropsBy = {
        { instanceID = 2441, diff = 2, index = 1, chance = 2.0 },
        { instanceID = 2441, diff = 23, index = 1, chance = 2.0 },
    }},
    [186642] = { journalMountID = 1471, dropsBy = {
        { instanceID = 2450, diff = 16, index = 2, chance = 0.4 },
    }},
    [186656] = { journalMountID = 1500, dropsBy = {
        { instanceID = 2450, diff = 17, index = 1, chance = 0.3, lfr = {1670, 0.4163, 0.711}, wing = 2221}, { instanceID = 2450, diff = 14, index = 1, chance = 0.3 },
        { instanceID = 2450, diff = 15, index = 1, chance = 0.3 }, { instanceID = 2450, diff = 16, index = 1, chance = 0.3 }
    }},
    [190768] = { journalMountID = 1587, dropsBy = {
        { instanceID = 2481, diff = 16, index = 1, chance = 0.5 },
    }},
}