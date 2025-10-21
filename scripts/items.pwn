// --------------------------- Include Guard ----------------------------------
#if defined _items_included
    #endinput
#endif
#define _items_included

// ============================= STATIC ITEM SYSTEM ==============================
// ระบบไอเท็มแบบ Static (กำหนด ID ไว้ใน enum)
// ไม่ต้องโหลดจาก database แบบ dynamic
// เซฟและโหลดข้อมูลผ่าน item_id ที่กำหนดไว้
//
// รวมระบบ Item Abilities:
//   - ITEM_TYPE_FOOD      : ขนมปัง (+10 HP)
//   - ITEM_TYPE_DRINK     : น้ำดื่ม (+15 HP)
//   - ITEM_TYPE_MEDICAL   : ยาพอก (+30 HP)
//   - ITEM_TYPE_ARMOR     : เสื้อกันกระสุน (+100 Armour)
//   - ITEM_TYPE_WEAPON    : ปืน Desert Eagle, ไม้เบสบอล
//   - ITEM_TYPE_TOOL      : ชุดเครื่องมือช่าง (ซ่อมรถ)
//
// Functions:
//   - InitializeItems()           : เริ่มต้นฐานข้อมูลไอเท็ม
//   - GetItemName()               : ดึงชื่อไอเท็ม
//   - GetItemDescription()        : ดึงคำอธิบายไอเท็ม
//   - GetItemWeight()             : ดึงน้ำหนักไอเท็ม
//   - GetItemType()               : ดึงประเภทไอเท็ม
//   - GetItemValue()              : ดึงค่าพิเศษของไอเท็ม
//   - IsValidItemID()             : เช็คไอเท็ม ID ที่ถูกต้อง
//   - GetItemAbilityText()        : ดึงข้อความอธิบาย Ability
//   - UseItem()                   : ใช้งานไอเท็มตาม ability
//   - UseItemBySlot()             : ใช้งานไอเท็มจาก inventory slot
// ===============================================================================

// ------------------------------ Item Definitions ----------------------------
// กำหนด Item ID แบบ Static (อ้างอิงจาก database startown.sql)
enum {
    ITEM_NONE = 0,
    ITEM_BREAD,                 // 1 - ขนมปัง
    ITEM_WATER,                 // 2 - น้ำดื่ม
    ITEM_MEDKIT,                // 3 - ยาพอก
    ITEM_ARMOR,                 // 4 - เสื้อกันกระสุน
    ITEM_DEAGLE,                // 5 - ปืน Desert Eagle
    ITEM_BASEBALL_BAT,          // 6 - ไม้เบสบอล
    ITEM_TOOLBOX,               // 7 - ชุดเครื่องมือช่าง
    ITEM_SPARE_TIRE,            // 8 - ยางอะไหล่
    ITEM_JUMPER_CABLE,          // 9 - สายกู้ไฟ
    ITEM_PHONE,                 // 10 - โทรศัพท์มือถือ
    // เพิ่มไอเท็มใหม่ตรงนี้...
    MAX_ITEM_TYPES
};

// ------------------------------ Item Types ----------------------------------
enum E_ITEM_TYPE {
    ITEM_TYPE_NONE = 0,         // ไอเท็มทั่วไป
    ITEM_TYPE_FOOD,             // อาหาร (+HP)
    ITEM_TYPE_DRINK,            // เครื่องดื่ม (+HP)
    ITEM_TYPE_MEDICAL,          // ยา (+HP)
    ITEM_TYPE_ARMOR,            // เกราะ (+Armour)
    ITEM_TYPE_WEAPON,           // อาวุธ
    ITEM_TYPE_TOOL              // เครื่องมือ
};

// ------------------------------ Item Data Structure -------------------------
#define MAX_ITEM_NAME       64
#define MAX_ITEM_DESC       256

enum E_ITEM_DATA {
    ItemID,                             // Item ID (ตรงกับ enum ด้านบน)
    ItemName[MAX_ITEM_NAME],            // ชื่อไอเท็ม
    ItemDescription[MAX_ITEM_DESC],     // คำอธิบาย
    Float:ItemWeight,                   // น้ำหนัก
    E_ITEM_TYPE:ItemType,               // ประเภท
    ItemValue                           // ค่าพิเศษ (เช่น HP, Ammo)
};

// ------------------------------ Static Item Database ------------------------
new ItemDatabase[MAX_ITEM_TYPES][E_ITEM_DATA];

// ------------------------------ Item Initialization -------------------------
stock InitializeItems() {
    // ITEM_NONE (0)
    ItemDatabase[ITEM_NONE][ItemID] = ITEM_NONE;
    format(ItemDatabase[ITEM_NONE][ItemName], MAX_ITEM_NAME, "ไม่มีไอเท็ม");
    format(ItemDatabase[ITEM_NONE][ItemDescription], MAX_ITEM_DESC, "ช่องว่าง");
    ItemDatabase[ITEM_NONE][ItemWeight] = 0.0;
    ItemDatabase[ITEM_NONE][ItemType] = ITEM_TYPE_NONE;
    ItemDatabase[ITEM_NONE][ItemValue] = 0;

    // ITEM_BREAD (1) - ขนมปัง
    ItemDatabase[ITEM_BREAD][ItemID] = ITEM_BREAD;
    format(ItemDatabase[ITEM_BREAD][ItemName], MAX_ITEM_NAME, "ขนมปัง");
    format(ItemDatabase[ITEM_BREAD][ItemDescription], MAX_ITEM_DESC, "ขนมปังสดใหม่ เพิ่มพลังชีวิต +10");
    ItemDatabase[ITEM_BREAD][ItemWeight] = 0.5;
    ItemDatabase[ITEM_BREAD][ItemType] = ITEM_TYPE_FOOD;
    ItemDatabase[ITEM_BREAD][ItemValue] = 10; // +10 HP

    // ITEM_WATER (2) - น้ำดื่ม
    ItemDatabase[ITEM_WATER][ItemID] = ITEM_WATER;
    format(ItemDatabase[ITEM_WATER][ItemName], MAX_ITEM_NAME, "น้ำดื่ม");
    format(ItemDatabase[ITEM_WATER][ItemDescription], MAX_ITEM_DESC, "น้ำดื่มบรรจุขวด เพิ่มพลังชีวิต +15");
    ItemDatabase[ITEM_WATER][ItemWeight] = 1.0;
    ItemDatabase[ITEM_WATER][ItemType] = ITEM_TYPE_DRINK;
    ItemDatabase[ITEM_WATER][ItemValue] = 15; // +15 HP

    // ITEM_MEDKIT (3) - ยาพอก
    ItemDatabase[ITEM_MEDKIT][ItemID] = ITEM_MEDKIT;
    format(ItemDatabase[ITEM_MEDKIT][ItemName], MAX_ITEM_NAME, "ยาพอก");
    format(ItemDatabase[ITEM_MEDKIT][ItemDescription], MAX_ITEM_DESC, "ชุดปฐมพยาบาล เพิ่มพลังชีวิต +30");
    ItemDatabase[ITEM_MEDKIT][ItemWeight] = 2.0;
    ItemDatabase[ITEM_MEDKIT][ItemType] = ITEM_TYPE_MEDICAL;
    ItemDatabase[ITEM_MEDKIT][ItemValue] = 30; // +30 HP

    // ITEM_ARMOR (4) - เสื้อกันกระสุน
    ItemDatabase[ITEM_ARMOR][ItemID] = ITEM_ARMOR;
    format(ItemDatabase[ITEM_ARMOR][ItemName], MAX_ITEM_NAME, "เสื้อกันกระสุน");
    format(ItemDatabase[ITEM_ARMOR][ItemDescription], MAX_ITEM_DESC, "เสื้อเกราะป้องกัน เพิ่มเกราะ 100%");
    ItemDatabase[ITEM_ARMOR][ItemWeight] = 5.0;
    ItemDatabase[ITEM_ARMOR][ItemType] = ITEM_TYPE_ARMOR;
    ItemDatabase[ITEM_ARMOR][ItemValue] = 100; // +100 Armour

    // ITEM_DEAGLE (5) - ปืน Desert Eagle
    ItemDatabase[ITEM_DEAGLE][ItemID] = ITEM_DEAGLE;
    format(ItemDatabase[ITEM_DEAGLE][ItemName], MAX_ITEM_NAME, "ปืน Desert Eagle");
    format(ItemDatabase[ITEM_DEAGLE][ItemDescription], MAX_ITEM_DESC, "ปืนพกขนาด .50 AE พร้อมกระสุน 50 นัด");
    ItemDatabase[ITEM_DEAGLE][ItemWeight] = 3.0;
    ItemDatabase[ITEM_DEAGLE][ItemType] = ITEM_TYPE_WEAPON;
    ItemDatabase[ITEM_DEAGLE][ItemValue] = 50; // 50 Ammo

    // ITEM_BASEBALL_BAT (6) - ไม้เบสบอล
    ItemDatabase[ITEM_BASEBALL_BAT][ItemID] = ITEM_BASEBALL_BAT;
    format(ItemDatabase[ITEM_BASEBALL_BAT][ItemName], MAX_ITEM_NAME, "ไม้เบสบอล");
    format(ItemDatabase[ITEM_BASEBALL_BAT][ItemDescription], MAX_ITEM_DESC, "ไม้เบสบอลไม้สัก แข็งแรงทนทาน");
    ItemDatabase[ITEM_BASEBALL_BAT][ItemWeight] = 2.0;
    ItemDatabase[ITEM_BASEBALL_BAT][ItemType] = ITEM_TYPE_WEAPON;
    ItemDatabase[ITEM_BASEBALL_BAT][ItemValue] = 1;

    // ITEM_TOOLBOX (7) - ชุดเครื่องมือช่าง
    ItemDatabase[ITEM_TOOLBOX][ItemID] = ITEM_TOOLBOX;
    format(ItemDatabase[ITEM_TOOLBOX][ItemName], MAX_ITEM_NAME, "ชุดเครื่องมือช่าง");
    format(ItemDatabase[ITEM_TOOLBOX][ItemDescription], MAX_ITEM_DESC, "เครื่องมือซ่อมรถยนต์ ซ่อมรถได้");
    ItemDatabase[ITEM_TOOLBOX][ItemWeight] = 4.0;
    ItemDatabase[ITEM_TOOLBOX][ItemType] = ITEM_TYPE_TOOL;
    ItemDatabase[ITEM_TOOLBOX][ItemValue] = 1;

    // ITEM_SPARE_TIRE (8) - ยางอะไหล่
    ItemDatabase[ITEM_SPARE_TIRE][ItemID] = ITEM_SPARE_TIRE;
    format(ItemDatabase[ITEM_SPARE_TIRE][ItemName], MAX_ITEM_NAME, "ยางอะไหล่");
    format(ItemDatabase[ITEM_SPARE_TIRE][ItemDescription], MAX_ITEM_DESC, "ยางรถยนต์อะไหล่ สำหรับเปลี่ยนยางแบน");
    ItemDatabase[ITEM_SPARE_TIRE][ItemWeight] = 6.0;
    ItemDatabase[ITEM_SPARE_TIRE][ItemType] = ITEM_TYPE_TOOL;
    ItemDatabase[ITEM_SPARE_TIRE][ItemValue] = 1;

    // ITEM_JUMPER_CABLE (9) - สายกู้ไฟ
    ItemDatabase[ITEM_JUMPER_CABLE][ItemID] = ITEM_JUMPER_CABLE;
    format(ItemDatabase[ITEM_JUMPER_CABLE][ItemName], MAX_ITEM_NAME, "สายกู้ไฟ");
    format(ItemDatabase[ITEM_JUMPER_CABLE][ItemDescription], MAX_ITEM_DESC, "สายกู้ไฟรถยนต์ ใช้สตาร์ทเครื่องยนต์");
    ItemDatabase[ITEM_JUMPER_CABLE][ItemWeight] = 3.0;
    ItemDatabase[ITEM_JUMPER_CABLE][ItemType] = ITEM_TYPE_TOOL;
    ItemDatabase[ITEM_JUMPER_CABLE][ItemValue] = 1;

    // ITEM_PHONE (10) - โทรศัพท์มือถือ
    ItemDatabase[ITEM_PHONE][ItemID] = ITEM_PHONE;
    format(ItemDatabase[ITEM_PHONE][ItemName], MAX_ITEM_NAME, "โทรศัพท์มือถือ");
    format(ItemDatabase[ITEM_PHONE][ItemDescription], MAX_ITEM_DESC, "โทรศัพท์สมาร์ทโฟนรุ่นใหม่");
    ItemDatabase[ITEM_PHONE][ItemWeight] = 0.3;
    ItemDatabase[ITEM_PHONE][ItemType] = ITEM_TYPE_NONE;
    ItemDatabase[ITEM_PHONE][ItemValue] = 0;

    printf("[Item System] Initialized %d static items", MAX_ITEM_TYPES);
}

// ------------------------------ Helper Functions ----------------------------
// ดึงชื่อไอเท็มจาก ID
stock GetItemName(itemid, dest[], maxlen = sizeof(dest)) {
    if (itemid < 0 || itemid >= MAX_ITEM_TYPES) {
        format(dest, maxlen, "Unknown");
        return 0;
    }
    format(dest, maxlen, "%s", ItemDatabase[itemid][ItemName]);
    return 1;
}

// ดึงคำอธิบายไอเท็มจาก ID
stock GetItemDescription(itemid, dest[], maxlen = sizeof(dest)) {
    if (itemid < 0 || itemid >= MAX_ITEM_TYPES) {
        format(dest, maxlen, "Unknown item");
        return 0;
    }
    format(dest, maxlen, "%s", ItemDatabase[itemid][ItemDescription]);
    return 1;
}

// ดึงน้ำหนักไอเท็มจาก ID
stock Float:GetItemWeight(itemid) {
    if (itemid < 0 || itemid >= MAX_ITEM_TYPES) return 0.0;
    return ItemDatabase[itemid][ItemWeight];
}

// ดึงประเภทไอเท็มจาก ID
stock E_ITEM_TYPE:GetItemType(itemid) {
    if (itemid < 0 || itemid >= MAX_ITEM_TYPES) return ITEM_TYPE_NONE;
    return ItemDatabase[itemid][ItemType];
}

// ดึงค่าพิเศษของไอเท็ม (HP, Ammo, etc.)
stock GetItemValue(itemid) {
    if (itemid < 0 || itemid >= MAX_ITEM_TYPES) return 0;
    return ItemDatabase[itemid][ItemValue];
}

// เช็คว่าไอเท็มมีอยู่จริงหรือไม่
stock IsValidItemID(itemid) {
    return (itemid > 0 && itemid < MAX_ITEM_TYPES);
}

// ดึงข้อความอธิบาย Ability
stock GetItemAbilityText(itemid, dest[], maxlen = 128) {
    if (itemid < 0 || itemid >= MAX_ITEM_TYPES) {
        format(dest, maxlen, "{AAAAAA}[ไม่มีไอเท็ม]");
        return 0;
    }

    new E_ITEM_TYPE:type = ItemDatabase[itemid][ItemType];
    new value = ItemDatabase[itemid][ItemValue];

    switch (type) {
        case ITEM_TYPE_FOOD: format(dest, maxlen, "{00FF00}[ใช้ได้] เพิ่ม HP +%d", value);
        case ITEM_TYPE_DRINK: format(dest, maxlen, "{00FF00}[ใช้ได้] เพิ่ม HP +%d", value);
        case ITEM_TYPE_MEDICAL: format(dest, maxlen, "{00FF00}[ใช้ได้] เพิ่ม HP +%d", value);
        case ITEM_TYPE_ARMOR: format(dest, maxlen, "{00FF00}[ใช้ได้] เพิ่ม Armour +%d", value);
        case ITEM_TYPE_WEAPON: format(dest, maxlen, "{00FF00}[ใช้ได้] รับอาวุธ");
        case ITEM_TYPE_TOOL: format(dest, maxlen, "{00FF00}[ใช้ได้] ซ่อมรถยนต์");
        default: format(dest, maxlen, "{AAAAAA}[ไม่สามารถใช้ได้]");
    }
    return 1;
}

// ------------------------------ Item Usage ----------------------------------
// ใช้งานไอเท็มโดยตรงจาก item_id (ไม่ลบไอเท็มออกจาก inventory)
// เรียกใช้จาก inventory_systems.pwn หรือระบบอื่นๆ
// Return: 1 = สำเร็จ, 0 = ไม่สำเร็จ
stock UseItem(playerid, itemid, slot = -1) {
    if (!IsPlayerConnected(playerid)) return 0;
    if (!IsValidItemID(itemid)) return 0;

    new E_ITEM_TYPE:type = ItemDatabase[itemid][ItemType];
    new value = ItemDatabase[itemid][ItemValue];
    new itemName[MAX_ITEM_NAME];
    GetItemName(itemid, itemName);
    new msg[128];

    switch (type) {
        case ITEM_TYPE_FOOD, ITEM_TYPE_DRINK, ITEM_TYPE_MEDICAL: {
            new Float:health;
            GetPlayerHealth(playerid, health);
            if (health >= 100.0) {
                SendClientMessage(playerid, 0xFF0000FF, "คุณมีเลือดเต็มแล้ว ไม่สามารถใช้ไอเท็มนี้ได้!");
                return 0;
            }
            SetPlayerHealth(playerid, health + float(value));
            format(msg, sizeof(msg), "{00FF00}คุณได้ใช้ %s +%d HP (%.1f HP)", itemName, value, health + float(value));
            SendClientMessage(playerid, -1, msg);
            return 1; // สำเร็จ - จะลบไอเท็มใน inventory_systems
        }
        case ITEM_TYPE_ARMOR: {
            new Float:armour;
            GetPlayerArmour(playerid, armour);
            if (armour >= 100.0) {
                SendClientMessage(playerid, 0xFF0000FF, "คุณมีเกราะเต็มแล้ว ไม่สามารถใช้ไอเท็มนี้ได้!");
                return 0;
            }
            SetPlayerArmour(playerid, float(value));
            format(msg, sizeof(msg), "{00FF00}คุณได้สวม%s +%d Armour", itemName, value);
            SendClientMessage(playerid, -1, msg);
            return 1;
        }
        case ITEM_TYPE_WEAPON: {
            if (itemid == ITEM_DEAGLE) {
                GivePlayerWeapon(playerid, 24, value); // Desert Eagle + ammo
                format(msg, sizeof(msg), "{00FF00}คุณได้รับ%s พร้อมกระสุน %d นัด", itemName, value);
            }
            else if (itemid == ITEM_BASEBALL_BAT) {
                GivePlayerWeapon(playerid, 5, 1); // Baseball Bat
                format(msg, sizeof(msg), "{00FF00}คุณได้รับ%s", itemName);
            }
            SendClientMessage(playerid, -1, msg);
            return 1;
        }
        case ITEM_TYPE_TOOL: {
            if (!IsPlayerInAnyVehicle(playerid)) {
                SendClientMessage(playerid, 0xFF0000FF, "คุณต้องอยู่ในรถเพื่อใช้เครื่องมือนี้!");
                return 0;
            }
            new vehicleid = GetPlayerVehicleID(playerid);
            RepairVehicle(vehicleid);
            format(msg, sizeof(msg), "{00FF00}คุณได้ใช้%s ซ่อมรถเรียบร้อยแล้ว!", itemName);
            SendClientMessage(playerid, -1, msg);
            return 1;
        }
        default: {
            format(msg, sizeof(msg), "{FFFF00}ไอเท็ม '%s' ไม่สามารถใช้งานได้", itemName);
            SendClientMessage(playerid, -1, msg);
            return 0;
        }
    }
    return 0;
}

// ------------------------------ Inventory Slot Usage ------------------------
// ใช้งานไอเท็มจาก inventory slot (รองรับ dynamic item system)
// ฟังก์ชันนี้จะเรียก RemoveItemFromPlayer() หลังใช้งานสำเร็จ
// ต้อง #include ไฟล์นี้หลัง inventory_systems.pwn
// Return: 1 = สำเร็จ, 0 = ไม่สำเร็จ
stock UseItemBySlot(playerid, inventorySlot) {
    if (!IsPlayerConnected(playerid)) return 0;
    
    // ตรวจสอบว่ามีฟังก์ชัน inventory_systems อยู่หรือไม่
    #if !defined PlayerInventoryCount
        printf("[Item System ERROR] inventory_systems.pwn not included!");
        return 0;
    #endif
    
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
