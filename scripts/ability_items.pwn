// --------------------------- Include Guard ----------------------------------
#if defined _ability_items_included
    #endinput
#endif
#define _ability_items_included

// ============================= ITEM ABILITY SYSTEM =============================
// ระบบความสามารถของไอเท็ม (Item Abilities)
// รองรับไอเท็มจาก startown.sql
//
// ? ไฟล์นี้ต้อง #include หลัง inventory_systems.pwn
//
// Abilities รองรับ:
//   - ITEM_TYPE_FOOD      : ขนมปัง (+10 HP)
//   - ITEM_TYPE_DRINK     : น้ำดื่ม (+15 HP)
//   - ITEM_TYPE_MEDICAL   : ยาพอก (+30 HP)
//   - ITEM_TYPE_ARMOR     : เสื้อกันกระสุน (+100 Armour)
//   - ITEM_TYPE_WEAPON    : ปืน Desert Eagle, ไม้เบสบอล
//   - ITEM_TYPE_TOOL      : ชุดเครื่องมือช่าง (ซ่อมรถ)
//
// Functions:
//   - UseItem()               : ใช้งานไอเท็มตาม ability
//   - GetItemAbilityText()    : ดึงข้อความอธิบายสำหรับ Dialog
// ===============================================================================

// หมายเหตุ: enum E_ITEM_TYPE และ DetermineItemType() ถูกย้ายไป inventory_systems.pwn แล้ว

// ------------------------------ Helper Functions ----------------------------
// ดึงข้อความอธิบาย Ability ของไอเท็ม (สำหรับแสดงใน Dialog)
stock GetItemAbilityText(E_ITEM_TYPE:itemType, dest[], maxlen = 128) {
    switch (itemType) {
        case ITEM_TYPE_FOOD: format(dest, maxlen, "{00FF00}[สามารถใช้ได้] เพิ่ม Health +10");
        case ITEM_TYPE_DRINK: format(dest, maxlen, "{00FF00}[สามารถใช้ได้] เพิ่ม Health +15");
        case ITEM_TYPE_MEDICAL: format(dest, maxlen, "{00FF00}[สามารถใช้ได้] เพิ่ม Health +30");
        case ITEM_TYPE_ARMOR: format(dest, maxlen, "{00FF00}[สามารถใช้ได้] เพิ่ม Armour 100%");
        case ITEM_TYPE_WEAPON: format(dest, maxlen, "{00FF00}[สามารถใช้ได้] รับอาวุธ");
        case ITEM_TYPE_TOOL: format(dest, maxlen, "{00FF00}[สามารถใช้ได้] ซ่อมรถ");
        default: format(dest, maxlen, "{AAAAAA}[ไม่สามารถใช้ได้] ไอเท็มทั่วไป");
    }
    return 1;
}

// ใช้งานไอเท็ม
stock UseItem(playerid, inventorySlot) {
    if (!IsPlayerConnected(playerid)) return 0;
    if (inventorySlot < 0 || inventorySlot >= PlayerInventoryCount[playerid]) return 0;
    
    new itemIdx = PlayerInventory[playerid][inventorySlot][InvItemID];
    if (itemIdx < 0 || itemIdx >= g_TotalItems) return 0;
    
    new itemName[MAX_ITEM_NAME];
    GetItemNameByIndex(itemIdx, itemName);
    new msg[128];
    
    // ตรวจสอบประเภทไอเท็มและใช้งานตาม ability
    switch (ItemData[itemIdx][ItemType]) {
        case ITEM_TYPE_FOOD: { // อาหาร - เพิ่ม Health +10
            new Float:health;
            GetPlayerHealth(playerid, health);
            if (health >= 100.0) {
                SendClientMessage(playerid, 0xFF0000FF, "คุณมีเลือดเต็มแล้ว ไม่สามารถใช้ไอเท็มนี้ได้!");
                return 0;
            }
            SetPlayerHealth(playerid, health + 10.0);
            format(msg, sizeof(msg), "{00FF00}คุณได้กินขนมปัง +10 HP (%.1f HP)", health + 10.0);
            SendClientMessage(playerid, -1, msg);
            RemoveItemFromPlayer(playerid, inventorySlot, 1);
            return 1;
        }
        case ITEM_TYPE_DRINK: { // เครื่องดื่ม - เพิ่ม Health +15
            new Float:health;
            GetPlayerHealth(playerid, health);
            if (health >= 100.0) {
                SendClientMessage(playerid, 0xFF0000FF, "คุณมีเลือดเต็มแล้ว ไม่สามารถใช้ไอเท็มนี้ได้!");
                return 0;
            }
            SetPlayerHealth(playerid, health + 15.0);
            format(msg, sizeof(msg), "{00FF00}คุณได้ดื่มน้ำ +15 HP (%.1f HP)", health + 15.0);
            SendClientMessage(playerid, -1, msg);
            RemoveItemFromPlayer(playerid, inventorySlot, 1);
            return 1;
        }
        case ITEM_TYPE_MEDICAL: { // ยา - เพิ่ม Health +30
            new Float:health;
            GetPlayerHealth(playerid, health);
            if (health >= 100.0) {
                SendClientMessage(playerid, 0xFF0000FF, "คุณมีเลือดเต็มแล้ว ไม่สามารถใช้ไอเท็มนี้ได้!");
                return 0;
            }
            SetPlayerHealth(playerid, health + 30.0);
            format(msg, sizeof(msg), "{00FF00}คุณได้ใช้ยาพอก +30 HP (%.1f HP)", health + 30.0);
            SendClientMessage(playerid, -1, msg);
            RemoveItemFromPlayer(playerid, inventorySlot, 1);
            return 1;
        }
        case ITEM_TYPE_ARMOR: { // เกราะ - เพิ่ม Armour 100%
            new Float:armour;
            GetPlayerArmour(playerid, armour);
            if (armour >= 100.0) {
                SendClientMessage(playerid, 0xFF0000FF, "คุณมีเกราะเต็มแล้ว ไม่สามารถใช้ไอเท็มนี้ได้!");
                return 0;
            }
            SetPlayerArmour(playerid, 100.0);
            SendClientMessage(playerid, -1, "{00FF00}คุณได้สวมเสื้อกันกระสุน +100 Armour");
            RemoveItemFromPlayer(playerid, inventorySlot, 1);
            return 1;
        }
        case ITEM_TYPE_WEAPON: { // อาวุธ
            if (strfind(itemName, "Desert Eagle", true) != -1) {
                GivePlayerWeapon(playerid, 24, 50); // Desert Eagle + 50 กระสุน
                SendClientMessage(playerid, -1, "{00FF00}คุณได้รับปืน Desert Eagle พร้อมกระสุน 50 นัด");
                RemoveItemFromPlayer(playerid, inventorySlot, 1);
                return 1;
            }
            else if (strfind(itemName, "ไม้เบสบอล", true) != -1) {
                GivePlayerWeapon(playerid, 5, 1); // Baseball Bat
                SendClientMessage(playerid, -1, "{00FF00}คุณได้รับไม้เบสบอล");
                RemoveItemFromPlayer(playerid, inventorySlot, 1);
                return 1;
            }
        }
        case ITEM_TYPE_TOOL: { // เครื่องมือ - ซ่อมรถ
            if (!IsPlayerInAnyVehicle(playerid)) {
                SendClientMessage(playerid, 0xFF0000FF, "คุณต้องอยู่ในรถเพื่อใช้เครื่องมือนี้!");
                return 0;
            }
            new vehicleid = GetPlayerVehicleID(playerid);
            RepairVehicle(vehicleid);
            SendClientMessage(playerid, -1, "{00FF00}คุณได้ใช้เครื่องมือซ่อมรถ รถได้รับการซ่อมแซมแล้ว!");
            RemoveItemFromPlayer(playerid, inventorySlot, 1);
            return 1;
        }
        default: { // ไอเท็มทั่วไป - ไม่มี ability
            format(msg, sizeof(msg), "{FFFF00}ไอเท็ม '%s' ไม่สามารถใช้งานได้", itemName);
            SendClientMessage(playerid, -1, msg);
            return 0;
        }
    }
    
    return 0;
}
