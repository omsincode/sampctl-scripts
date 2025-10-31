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
 * ใช้ความสามารถของไอเทม
 * @param playerid - ไอดีของผู้เล่น
 * @param ability_id - ID ของความสามารถ
 * @param item_quality - คุณภาพของไอเทม (0-100)
 * @return 1 = สำเร็จ, 0 = ล้มเหลว
 */
stock use_item_ability(playerid, ability_id, item_quality = 100) {
    #pragma unused item_quality
    if(!IsPlayerConnected(playerid)) return 0;
    
    switch(ability_id) {
        case 0: return 1; // No ability
        
        // ================================
        // WEAPON ABILITIES (1-9)
        // ================================
        case 1: { // ABILITY_SWORD_SLASH (ฟันดาบ)
            SendClientMessage(playerid, 0x00FF00FF, "* คุณใช้การฟันดาบ!");
            // TODO: เพิ่ม damage, animation, effects
            ApplyAnimation(playerid, "KNIFE", "knife_3", 4.1, 0, 0, 0, 0, 0);
            return 1;
        }
        case 2: { // ABILITY_LASER_BEAM (ลำแสงเลเซอร์)
            SendClientMessage(playerid, 0x00FFFFFF, "* คุณยิงลำแสงเลเซอร์!");
            // TODO: สร้างลำแสง, AOE damage
            ApplyAnimation(playerid, "KNIFE", "knife_4", 4.1, 0, 0, 0, 0, 0);
            return 1;
        }
        
        // ================================
        // CONSUMABLE ABILITIES (10-29)
        // ================================
        case 10: { // ABILITY_HEAL_25 (ฟื้นฟูเล็กน้อย)
            new Float:health;
            GetPlayerHealth(playerid, health);
            if(health >= 100.0) {
                SendClientMessage(playerid, 0xFF0000FF, "* เลือดของคุณเต็มแล้ว!");
                return 0;
            }
            SetPlayerHealth(playerid, float_min(health + 25.0, 100.0));
            SendClientMessage(playerid, 0x00FF00FF, "* ฟื้นฟู HP +25");
            ApplyAnimation(playerid, "VENDING", "VEND_Drink2_P", 4.1, 0, 0, 0, 0, 0);
            return 1;
        }
        case 11: { // ABILITY_HEAL_50 (ฟื้นฟูปานกลาง)
            new Float:health;
            GetPlayerHealth(playerid, health);
            if(health >= 100.0) {
                SendClientMessage(playerid, 0xFF0000FF, "* เลือดของคุณเต็มแล้ว!");
                return 0;
            }
            SetPlayerHealth(playerid, float_min(health + 50.0, 100.0));
            SendClientMessage(playerid, 0x00FF00FF, "* ฟื้นฟู HP +50");
            ApplyAnimation(playerid, "VENDING", "VEND_Drink2_P", 4.1, 0, 0, 0, 0, 0);
            return 1;
        }
        case 12: { // ABILITY_HEAL_100 (ฟื้นฟูเต็มที่)
            new Float:health;
            GetPlayerHealth(playerid, health);
            if(health >= 100.0) {
                SendClientMessage(playerid, 0xFF0000FF, "* เลือดของคุณเต็มแล้ว!");
                return 0;
            }
            SetPlayerHealth(playerid, 100.0);
            SendClientMessage(playerid, 0x00FF00FF, "* ฟื้นฟู HP เต็ม!");
            ApplyAnimation(playerid, "VENDING", "VEND_Drink2_P", 4.1, 0, 0, 0, 0, 0);
            return 1;
        }
        case 20: { // ABILITY_DRINK (ดื่มน้ำ)
            // TODO: เชื่อมต่อ player_thirst กับ PlayerData
            SendClientMessage(playerid, 0x00B7FFFF, "* คุณดื่มน้ำ ความกระหาย -50");
            ApplyAnimation(playerid, "VENDING", "VEND_Drink2_P", 4.1, 0, 0, 0, 0, 0);
            // PlayerData[playerid][pThirst] = floatmin(PlayerData[playerid][pThirst] + 50.0, 100.0);
            return 1;
        }
        case 21: { // ABILITY_EAT_BREAD (กินขนมปัง)
            // TODO: เชื่อมต่อ player_hunger กับ PlayerData
            SendClientMessage(playerid, 0xFFAA00FF, "* คุณกินขนมปัง ความหิว -30");
            ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
            // PlayerData[playerid][pHunger] = floatmin(PlayerData[playerid][pHunger] + 30.0, 100.0);
            return 1;
        }
        
        // ================================
        // ARMOR ABILITIES (30-39)
        // ================================
        case 30: { // ABILITY_ARMOR_LIGHT (เกราะเบา)
            new Float:armour;
            GetPlayerArmour(playerid, armour);
            if(armour >= 50.0) {
                SendClientMessage(playerid, 0xFF0000FF, "* เกราะของคุณมีอย่างน้อย 50% แล้ว!");
                return 0;
            }
            SetPlayerArmour(playerid, 50.0);
            SendClientMessage(playerid, 0xAAAAAAFF, "* สวมเกราะเบา (Armor +50)");
            return 1;
        }
        case 31: { // ABILITY_ARMOR_HEAVY (เกราะหนัก)
            new Float:armour;
            GetPlayerArmour(playerid, armour);
            if(armour >= 100.0) {
                SendClientMessage(playerid, 0xFF0000FF, "* เกราะของคุณเต็มแล้ว!");
                return 0;
            }
            SetPlayerArmour(playerid, 100.0);
            SendClientMessage(playerid, 0xAAAAAAFF, "* สวมเกราะหนัก (Armor +100)");
            return 1;
        }
        
        // ================================
        // BUFF/DEBUFF ABILITIES (40-59)
        // ================================
        case 40: { // ABILITY_SPEED_BOOST (เพิ่มความเร็ว)
            SendClientMessage(playerid, 0xFFFF00FF, "* คุณได้รับ Speed Boost!");
            // TODO: ใช้ตัวแปรบัฟชั่วคราว
            return 1;
        }
        case 41: { // ABILITY_JUMP_BOOST (กระโดดสูง)
            SendClientMessage(playerid, 0xFFFF00FF, "* คุณได้รับ Jump Boost!");
            // TODO: SetPlayerGravity หรือใช้ SetPlayerVelocity
            return 1;
        }
        
        // ================================
        // SPECIAL ABILITIES (60-99)
        // ================================
        case 60: { // ABILITY_TELEPORT (วาร์ป)
            SendClientMessage(playerid, 0xFF00FFFF, "* เปิดเมนูวาร์ป!");
            // TODO: เปิด dialog เลือกจุดวาร์ป
            return 1;
        }
        case 61: { // ABILITY_INVISIBILITY (หายตัว)
            SendClientMessage(playerid, 0x00FFFFFF, "* คุณหายตัวชั่วคราว!");
            // TODO: SetPlayerColor alpha = 0, ตั้งเวลา
            return 1;
        }
    }
    
    return 0;
}

/**
 * ตรวจสอบว่า Ability เป็นประเภทใช้แล้วหมดหรือไม่
 * @param ability_id - ID ของความสามารถ
 * @return true = ใช้แล้วหมด, false = ใช้ได้หลายครั้ง
 */
stock is_ability_consumable(ability_id) {
    // Consumable abilities (10-29) = ใช้แล้วหมด
    if(ability_id >= 10 && ability_id <= 29) return true;
    
    // Weapon, Armor, Special = ใช้ซ้ำได้
    return false;
}

/**
 * ดึงชื่อ Ability
 * @param ability_id - ID ของความสามารถ
 * @param output - สตริงผลลัพธ์
 */
stock get_ability_name(ability_id, output[], maxlength = sizeof(output)) {
    switch(ability_id) {
        case 0: format(output, maxlength, "ไม่มีความสามารถ");
        case 1: format(output, maxlength, "ฟันดาบ");
        case 2: format(output, maxlength, "ลำแสงเลเซอร์");
        case 10: format(output, maxlength, "ฟื้นฟู HP 25");
        case 11: format(output, maxlength, "ฟื้นฟู HP 50");
        case 12: format(output, maxlength, "ฟื้นฟู HP 100");
        case 20: format(output, maxlength, "ดื่มน้ำ");
        case 21: format(output, maxlength, "กินขนมปัง");
        case 30: format(output, maxlength, "เกราะเบา +50");
        case 31: format(output, maxlength, "เกราะหนัก +100");
        case 40: format(output, maxlength, "เพิ่มความเร็ว");
        case 41: format(output, maxlength, "กระโดดสูง");
        case 60: format(output, maxlength, "วาร์ป");
        case 61: format(output, maxlength, "หายตัว");
        default: format(output, maxlength, "Unknown Ability");
    }
    return 1;
}

/**
 * ตรวจสอบว่าผู้เล่นสามารถใช้ Ability ได้หรือไม่
 * @param playerid - ไอดีผู้เล่น
 * @param ability_id - ID ของความสามารถ
 * @return 1 = ใช้ได้, 0 = ใช้ไม่ได้
 */
stock can_use_ability(playerid, ability_id) {
    if(!IsPlayerConnected(playerid)) return 0;
    
    // TODO: เพิ่มเงื่อนไข
    // - Cooldown
    // - Mana/Energy
    // - Status effects
    // - Location restrictions
    
    return 1;
}