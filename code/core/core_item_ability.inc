// --------------------------- Include Guard ----------------------------------
#if defined _core_items_ability_included
    #endinput
#endif
#define _core_items_ability_included

// ------------------------------ Helper Functions ----------------------------
stock Float:float_min(Float:a, Float:b) {
    return (a < b) ? a : b;
}

// ------------------------------ Item Ability System -------------------------

/**
 * ????????????????
 * @param playerid - ??????????????
 * @param ability_id - ID ???????????
 * @param item_quality - ?????????????? (0-100)
 * @return 1 = ?????, 0 = ???????
 */
stock use_item_ability(playerid, ability_id, item_quality = 100) {
    #pragma unused item_quality
    if(!IsPlayerConnected(playerid)) return 0;
    
    switch(ability_id) {
        case 0: return 1; // No ability
        
        // ================================
        // WEAPON ABILITIES (1-9)
        // ================================
        case 1: { // ABILITY_SWORD_SLASH (??????)
            SendClientMessage(playerid, 0x00FF00FF, "* ??????????????!");
            // TODO: ???? damage, animation, effects
            ApplyAnimation(playerid, "KNIFE", "knife_3", 4.1, 0, 0, 0, 0, 0);
            return 1;
        }
        case 2: { // ABILITY_LASER_BEAM (????????)
            SendClientMessage(playerid, 0x00FFFFFF, "* ?????????????????!");
            // TODO: ????????, AOE damage
            ApplyAnimation(playerid, "KNIFE", "knife_4", 4.1, 0, 0, 0, 0, 0);
            return 1;
        }
        
        // ================================
        // CONSUMABLE ABILITIES (10-29)
        // ================================
        case 10: { // ABILITY_HEAL_25 (???????????)
            new Float:health;
            GetPlayerHealth(playerid, health);
            if(health >= 100.0) {
                SendClientMessage(playerid, 0xFF0000FF, "* ???????????????????!");
                return 0;
            }
            SetPlayerHealth(playerid, float_min(health + 25.0, 100.0));
            SendClientMessage(playerid, 0x00FF00FF, "* ?????? HP +25");
            ApplyAnimation(playerid, "VENDING", "VEND_Drink2_P", 4.1, 0, 0, 0, 0, 0);
            return 1;
        }
        case 11: { // ABILITY_HEAL_50 (???????????)
            new Float:health;
            GetPlayerHealth(playerid, health);
            if(health >= 100.0) {
                SendClientMessage(playerid, 0xFF0000FF, "* ???????????????????!");
                return 0;
            }
            SetPlayerHealth(playerid, float_min(health + 50.0, 100.0));
            SendClientMessage(playerid, 0x00FF00FF, "* ?????? HP +50");
            ApplyAnimation(playerid, "VENDING", "VEND_Drink2_P", 4.1, 0, 0, 0, 0, 0);
            return 1;
        }
        case 12: { // ABILITY_HEAL_100 (???????????)
            new Float:health;
            GetPlayerHealth(playerid, health);
            if(health >= 100.0) {
                SendClientMessage(playerid, 0xFF0000FF, "* ???????????????????!");
                return 0;
            }
            SetPlayerHealth(playerid, 100.0);
            SendClientMessage(playerid, 0x00FF00FF, "* ?????? HP ???!");
            ApplyAnimation(playerid, "VENDING", "VEND_Drink2_P", 4.1, 0, 0, 0, 0, 0);
            return 1;
        }
        case 20: { // ABILITY_DRINK (??????)
            // TODO: ????? player_thirst ? PlayerData
            SendClientMessage(playerid, 0x00B7FFFF, "* ????????? ?????????? -50");
            ApplyAnimation(playerid, "VENDING", "VEND_Drink2_P", 4.1, 0, 0, 0, 0, 0);
            // PlayerData[playerid][pThirst] = floatmin(PlayerData[playerid][pThirst] + 50.0, 100.0);
            return 1;
        }
        case 21: { // ABILITY_EAT_BREAD (?????)
            // TODO: ????? player_hunger ? PlayerData
            SendClientMessage(playerid, 0xFFAA00FF, "* ????????? ??????? -30");
            ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
            // PlayerData[playerid][pHunger] = floatmin(PlayerData[playerid][pHunger] + 30.0, 100.0);
            return 1;
        }
        
        // ================================
        // ARMOR ABILITIES (30-39)
        // ================================
        case 30: { // ABILITY_ARMOR_LIGHT (??????)
            new Float:armour;
            GetPlayerArmour(playerid, armour);
            if(armour >= 50.0) {
                SendClientMessage(playerid, 0xFF0000FF, "* ?????????????? 50% ????!");
                return 0;
            }
            SetPlayerArmour(playerid, 50.0);
            SendClientMessage(playerid, 0xAAAAAAFF, "* ??????????? (Armor +50)");
            return 1;
        }
        case 31: { // ABILITY_ARMOR_HEAVY (????????)
            new Float:armour;
            GetPlayerArmour(playerid, armour);
            if(armour >= 100.0) {
                SendClientMessage(playerid, 0xFF0000FF, "* ??????????????????!");
                return 0;
            }
            SetPlayerArmour(playerid, 100.0);
            SendClientMessage(playerid, 0xAAAAAAFF, "* ????????????? (Armor +100)");
            return 1;
        }
        
        // ================================
        // BUFF/DEBUFF ABILITIES (40-59)
        // ================================
        case 40: { // ABILITY_SPEED_BOOST (????????????)
            SendClientMessage(playerid, 0xFFFF00FF, "* ?????? Speed Boost!");
            // TODO: ??????????????????
            return 1;
        }
        case 41: { // ABILITY_JUMP_BOOST (??????????)
            SendClientMessage(playerid, 0xFFFF00FF, "* ?????? Jump Boost!");
            // TODO: SetPlayerGravity ?????? SetPlayerVelocity
            return 1;
        }
        
        // ================================
        // SPECIAL ABILITIES (60-99)
        // ================================
        case 60: { // ABILITY_TELEPORT (????)
            SendClientMessage(playerid, 0xFF00FFFF, "* ????????????!");
            // TODO: ??? dialog ??????????
            return 1;
        }
        case 61: { // ABILITY_INVISIBILITY (????)
            SendClientMessage(playerid, 0x00FFFFFF, "* ?????????????!");
            // TODO: SetPlayerColor alpha = 0, ??????
            return 1;
        }
    }
    
    return 0;
}

/**
 * ???????? Ability ???????????????????
 * @param ability_id - ID ???????????
 * @return true = ?????????, false = ???????????
 */
stock is_ability_consumable(ability_id) {
    // Consumable abilities (10-29) = ?????????
    if(ability_id >= 10 && ability_id <= 29) return true;
    
    // Weapon, Armor, Special = ??????
    return false;
}

/**
 * ?????? Ability
 * @param ability_id - ID ???????????
 * @param output - ??????????
 */
stock get_ability_name(ability_id, output[], maxlength = sizeof(output)) {
    switch(ability_id) {
        case 0: format(output, maxlength, "?????????????");
        case 1: format(output, maxlength, "????????");
        case 2: format(output, maxlength, "??????????");
        case 10: format(output, maxlength, "??? HP 25");
        case 11: format(output, maxlength, "??? HP 50");
        case 12: format(output, maxlength, "??? HP 100");
        case 20: format(output, maxlength, "???????");
        case 21: format(output, maxlength, "???????");
        case 30: format(output, maxlength, "?????? +50");
        case 31: format(output, maxlength, "?????? +100");
        case 40: format(output, maxlength, "????????????");
        case 41: format(output, maxlength, "??????");
        case 60: format(output, maxlength, "????");
        case 61: format(output, maxlength, "????");
        default: format(output, maxlength, "Unknown Ability");
    }
    return 1;
}

/**
 * ??????????????? Ability ?????????
 * @param playerid - ??????
 * @param ability_id - ID ???????????
 * @return 1 = ????, 0 = ???????
 */
stock can_use_ability(playerid, ability_id) {
    if(!IsPlayerConnected(playerid)) return 0;
    
    // TODO: ??????????
    // - Cooldown
    // - Mana/Energy
    // - Status effects
    // - Location restrictions
    
    return 1;
}

