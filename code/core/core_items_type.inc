// --------------------------- Include Guard ----------------------------------
#if defined _core_items_type_included
    #endinput
#endif
#define _core_items_type_included

// ------------------------------ Item Categories -----------------------------
enum e_item_category {
    ITEM_WEAPON,
    ITEM_ARMOR,
    ITEM_CONSUMABLE,
    ITEM_MATERIAL,
    ITEM_QUEST,
    ITEM_MISC
}

// ------------------------------ Item Types (Enum) ---------------------------
enum e_item_type {
    ITEM_NONE,
    
    // === WEAPONS ===
    ITEM_WOODEN_SWORD,      // ?????
    ITEM_IRON_SWORD,        // ??????
    ITEM_LASER_SWORD,       // ????????
    
    // === CONSUMABLES ===
    ITEM_HEALTH_POTION_S,   // ???????????
    ITEM_HEALTH_POTION_M,   // ???????????
    ITEM_HEALTH_POTION_L,   // ???????????
    ITEM_WATER,             // ??????
    ITEM_BREAD,             // ?????
    
    // === MATERIALS ===
    ITEM_IRON_ORE,          // ???????
    ITEM_WOOD,              // ???
    ITEM_LEATHER,           // ??????
    ITEM_CLOTH,             // ???
    
    // === ARMOR ===
    ITEM_LEATHER_ARMOR,     // ??????
    ITEM_IRON_ARMOR,        // ????????
    
    // === QUEST ITEMS ===
    ITEM_MYSTERIOUS_LETTER, // ??????????
    ITEM_ANCIENT_KEY,       // ??????
    
    // === MISC ===
    ITEM_GOLD,              // ??
    ITEM_DIAMOND,           // ??
    
    MAX_ITEM_TYPES
}

// ------------------------------ Item Data Structure -------------------------
enum e_item_data {
    e_item_type:item_enum,               // Enum ID
    item_name[64],                       // ????????
    item_description[256],               // ??????
    item_max_stack,                      // ?????????????
    e_item_category:item_category,       // ???????
    Float:item_weight,                   // ?????
    item_value,                          // ???
    item_icon_id,                        // Model/Sprite ID
    bool:item_tradable,                  // ???????????????
    item_ability_id                      // ID ??????????????
}

// ------------------------------ Static Item Database ------------------------
new const g_item_type_data[][e_item_data] = {
    // === WEAPONS ===
    {
        ITEM_WOODEN_SWORD,
        "?????",
        "????????????????????? ?????????????????",
        1,                      // max_stack
        ITEM_WEAPON,            // category
        3.5,                    // weight
        100,                    // value
        335,                    // icon_id (knife)
        true,                   // tradable
        0                       // ability_id (none)
    },
    {
        ITEM_IRON_SWORD,
        "??????",
        "???????????????? ????????????",
        1,
        ITEM_WEAPON,
        5.0,
        500,
        335,
        true,
        1                       // ability_id: ABILITY_SWORD_SLASH
    },
    {
        ITEM_LASER_SWORD,
        "????????",
        "???????????????????? ???????????????",
        1,
        ITEM_WEAPON,
        2.5,
        5000,
        335,
        true,
        2                       // ability_id: ABILITY_LASER_BEAM
    },
    
    // === CONSUMABLES ===
    {
        ITEM_HEALTH_POTION_S,
        "???????????",
        "???? HP 25 ??",
        99,                     // stackable
        ITEM_CONSUMABLE,
        0.1,
        50,
        1240,                   // medkit
        true,
        10                      // ability_id: ABILITY_HEAL_25
    },
    {
        ITEM_HEALTH_POTION_M,
        "???????????",
        "???? HP 50 ??",
        99,
        ITEM_CONSUMABLE,
        0.2,
        100,
        1240,
        true,
        11                      // ability_id: ABILITY_HEAL_50
    },
    {
        ITEM_HEALTH_POTION_L,
        "???????????",
        "???? HP 100 ??",
        99,
        ITEM_CONSUMABLE,
        0.3,
        200,
        1240,
        true,
        12                      // ability_id: ABILITY_HEAL_100
    },
    {
        ITEM_WATER,
        "??????",
        "????????????? 50 ??",
        99,
        ITEM_CONSUMABLE,
        0.5,
        10,
        1484,                   // spray can (???)
        true,
        20                      // ability_id: ABILITY_DRINK
    },
    {
        ITEM_BREAD,
        "?????",
        "???????? 30 ??",
        99,
        ITEM_CONSUMABLE,
        0.2,
        20,
        2880,                   // pizza
        true,
        21                      // ability_id: ABILITY_EAT_BREAD
    },
    
    // === MATERIALS ===
    {
        ITEM_IRON_ORE,
        "???????",
        "??????????????????????????????",
        999,
        ITEM_MATERIAL,
        1.0,
        10,
        1279,                   // ore
        true,
        0
    },
    {
        ITEM_WOOD,
        "???",
        "?????????????????? ?????????????????",
        999,
        ITEM_MATERIAL,
        0.5,
        5,
        1463,                   // wood
        true,
        0
    },
    {
        ITEM_LEATHER,
        "??????",
        "?????????????? ???????????????",
        999,
        ITEM_MATERIAL,
        0.3,
        15,
        1578,
        true,
        0
    },
    {
        ITEM_CLOTH,
        "???",
        "????????????????????",
        999,
        ITEM_MATERIAL,
        0.1,
        8,
        1271,
        true,
        0
    },
    
    // === ARMOR ===
    {
        ITEM_LEATHER_ARMOR,
        "??????",
        "?????????????? ?????????????",
        1,
        ITEM_ARMOR,
        4.0,
        300,
        373,                    // armor
        true,
        30                      // ability_id: ABILITY_ARMOR_LIGHT
    },
    {
        ITEM_IRON_ARMOR,
        "????????",
        "?????????????? ????????",
        1,
        ITEM_ARMOR,
        8.0,
        800,
        373,
        true,
        31                      // ability_id: ABILITY_ARMOR_HEAVY
    },
    
    // === QUEST ITEMS ===
    {
        ITEM_MYSTERIOUS_LETTER,
        "??????????",
        "???????????????????? ????????????",
        1,
        ITEM_QUEST,
        0.1,
        0,                      // quest item ???????
        1212,
        false,                  // ??????????
        0
    },
    {
        ITEM_ANCIENT_KEY,
        "??????",
        "????????????????????????",
        1,
        ITEM_QUEST,
        0.2,
        0,
        2946,
        false,
        0
    },
    
    // === MISC ===
    {
        ITEM_GOLD,
        "??",
        "???????????????????",
        999,
        ITEM_MISC,
        0.5,
        1000,
        1212,
        true,
        0
    },
    {
        ITEM_DIAMOND,
        "??",
        "??????????????????????",
        999,
        ITEM_MISC,
        0.1,
        5000,
        19054,
        true,
        0
    }
};

// ------------------------------ Helper Functions ----------------------------

/**
 * ???????????????? Static Data
 */
stock get_static_item_count() {
    return sizeof(g_item_type_data);
}

/**
 * ???????????? Enum
 */
stock get_item_name_by_enum(e_item_type:itemtype, output[], maxlength = sizeof(output)) {
    for(new i = 0; i < sizeof(g_item_type_data); i++) {
        if(g_item_type_data[i][item_enum] == itemtype) {
            format(output, maxlength, "%s", g_item_type_data[i][item_name]);
            return 1;
        }
    }
    format(output, maxlength, "Unknown Item");
    return 0;
}

/**
 * ?? Category ?? String
 */
stock get_category_string(e_item_category:category, output[], maxlength = sizeof(output)) {
    switch(category) {
        case ITEM_WEAPON: format(output, maxlength, "weapon");
        case ITEM_ARMOR: format(output, maxlength, "armor");
        case ITEM_CONSUMABLE: format(output, maxlength, "consumable");
        case ITEM_MATERIAL: format(output, maxlength, "material");
        case ITEM_QUEST: format(output, maxlength, "quest");
        case ITEM_MISC: format(output, maxlength, "misc");
        default: format(output, maxlength, "misc");
    }
    return 1;
}

/**
 * ?????????????? Enum
 */
stock get_item_data_by_enum(e_item_type:itemtype, output[e_item_data]) {
    for(new i = 0; i < sizeof(g_item_type_data); i++) {
        if(g_item_type_data[i][item_enum] == itemtype) {
            output[item_enum] = g_item_type_data[i][item_enum];
            format(output[item_name], 64, "%s", g_item_type_data[i][item_name]);
            format(output[item_description], 256, "%s", g_item_type_data[i][item_description]);
            output[item_max_stack] = g_item_type_data[i][item_max_stack];
            output[item_category] = g_item_type_data[i][item_category];
            output[item_weight] = g_item_type_data[i][item_weight];
            output[item_value] = g_item_type_data[i][item_value];
            output[item_icon_id] = g_item_type_data[i][item_icon_id];
            output[item_tradable] = g_item_type_data[i][item_tradable];
            output[item_ability_id] = g_item_type_data[i][item_ability_id];
            return 1;
        }
    }
    return 0;
}

/**
 * ?? index ???????? array g_item_type_data
 */
stock get_item_index_by_enum(e_item_type:itemtype) {
    for(new i = 0; i < sizeof(g_item_type_data); i++) {
        if(g_item_type_data[i][item_enum] == itemtype) {
            return i;
        }
    }
    return -1;
}
