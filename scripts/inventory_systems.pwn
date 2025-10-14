// --------------------------- Include Guard ----------------------------------// --------------------------- Include Guard ----------------------------------

#if defined _inventory_systems_included#if defined _inventory_systems_included

    #endinput    #endinput

#endif#endif

#define _inventory_systems_included#define _inventory_systems_included



// ------------------------------ Dialogs -------------------------------------// ------------------------------ Dialogs -------------------------------------

#define DIALOG_INVENTORY        200#define DIALOG_INVENTORY        200

#define DIALOG_ITEM_INFO        201#define DIALOG_ITEM_INFO        201



// ------------------------------ Player Inventory ----------------------------// ------------------------------ Item Types ----------------------------------

#define MAX_PLAYER_ITEMS    100     // จำนวนไอเท็มสูงสุดต่อผู้เล่น// ประเภทของ Item Ability (ย้ายมาจาก ability_items.pwn)

enum E_ITEM_TYPE {

// โครงสร้างไอเท็มในตัวผู้เล่น (ใช้ item_id แทน index)    ITEM_TYPE_NONE = 0,         // ไอเท็มทั่วไป ไม่มี ability

enum E_PLAYER_INVENTORY {    ITEM_TYPE_FOOD,             // อาหาร (เพิ่ม Health)

    InvItemID,              // Item ID (อ้างอิงจาก items.pwn enum)    ITEM_TYPE_DRINK,            // เครื่องดื่ม (เพิ่ม Health)

    InvQuantity,            // จำนวน    ITEM_TYPE_MEDICAL,          // ยา (เพิ่ม Health)

    InvInventoryID          // inventory_id จาก database (สำหรับ save/load)    ITEM_TYPE_ARMOR,            // เสื้อกันกระสุน (เพิ่ม Armour)

};    ITEM_TYPE_WEAPON,           // อาวุธ (ให้ปืน)

new PlayerInventory[MAX_PLAYERS][MAX_PLAYER_ITEMS][E_PLAYER_INVENTORY];    ITEM_TYPE_TOOL              // เครื่องมือ (ใช้งานพิเศษ)

new PlayerInventoryCount[MAX_PLAYERS];  // จำนวนไอเท็มที่มี};



// เก็บ Slot ที่ผู้เล่นเลือกล่าสุด (สำหรับ Dialog)// ------------------------------ Item System ---------------------------------

new g_PlayerSelectedSlot[MAX_PLAYERS] = {-1, ...};#define MAX_ITEMS           500     // จำนวนไอเท็มสูงสุดที่โหลดจาก DB

#define MAX_ITEM_NAME       64      // ความยาวชื่อไอเท็ม

// ------------------------------ Inventory Functions -------------------------#define MAX_ITEM_DESC       256     // ความยาวคำอธิบายไอเท็ม

// เพิ่มไอเท็มให้ผู้เล่น (ระบุด้วย item_id)#define MAX_PLAYER_ITEMS    100     // จำนวนไอเท็มสูงสุดต่อผู้เล่น

stock AddItemToPlayer(playerid, itemid, quantity = 1) {

    if (!IsPlayerConnected(playerid)) return 0;// โครงสร้างข้อมูลไอเท็มจาก DB

    if (!IsValidItemID(itemid)) {enum E_ITEM_DATA {

        printf("[Inventory] ERROR: Invalid item ID %d", itemid);    ItemDBID,               // item_id จาก database

        return 0;    ItemName[MAX_ITEM_NAME],

    }    ItemDescription[MAX_ITEM_DESC],

    if (quantity <= 0) return 0;    Float:ItemWeight,

    E_ITEM_TYPE:ItemType    // ประเภทของไอเท็ม (ใช้จาก ability_items.pwn)

    // หาว่ามีไอเท็มนี้อยู่แล้วหรือไม่ (stack)};

    for (new i = 0; i < PlayerInventoryCount[playerid]; i++) {new ItemData[MAX_ITEMS][E_ITEM_DATA];

        if (PlayerInventory[playerid][i][InvItemID] == itemid) {new g_TotalItems = 0;       // จำนวนไอเท็มที่โหลดจาก DB

            PlayerInventory[playerid][i][InvQuantity] += quantity;

            // เก็บ Item Index ที่ผู้เล่นเลือกล่าสุด (สำหรับใช้ใน Dialog)

            new itemName[MAX_ITEM_NAME];new g_PlayerSelectedItem[MAX_PLAYERS] = {-1, ...};

            GetItemName(itemid, itemName);

            new msg[128];// โครงสร้างไอเท็มในตัวผู้เล่น

            format(msg, sizeof(msg), "{00FF00}คุณได้รับ: %s x%d", itemName, quantity);enum E_PLAYER_INVENTORY {

            SendClientMessage(playerid, -1, msg);    InvItemID,              // อ้างอิง ItemData index

            return 1;    InvQuantity,

        }    InvInventoryID          // inventory_id จาก DB

    }};

new PlayerInventory[MAX_PLAYERS][MAX_PLAYER_ITEMS][E_PLAYER_INVENTORY];

    // ถ้าไม่มี ให้เพิ่ม slot ใหม่new PlayerInventoryCount[MAX_PLAYERS];  // จำนวนไอเท็มที่มี

    if (PlayerInventoryCount[playerid] >= MAX_PLAYER_ITEMS) {

        SendClientMessage(playerid, 0xFF0000FF, "กระเป๋าของคุณเต็มแล้ว!");// ------------------------------ Item Type Functions -------------------------

        return 0;// กำหนดประเภทไอเท็มตามชื่อ (ย้ายมาจาก ability_items.pwn)

    }stock E_ITEM_TYPE:DetermineItemType(const itemName[]) {

    // อาหาร

    new slot = PlayerInventoryCount[playerid];    if (strfind(itemName, "ขนมปัง", true) != -1) return ITEM_TYPE_FOOD;

    PlayerInventory[playerid][slot][InvItemID] = itemid;    

    PlayerInventory[playerid][slot][InvQuantity] = quantity;    // เครื่องดื่ม

    PlayerInventory[playerid][slot][InvInventoryID] = 0; // จะได้จาก DB ตอน load    if (strfind(itemName, "น้ำดื่ม", true) != -1) return ITEM_TYPE_DRINK;

    PlayerInventoryCount[playerid]++;    

    // ยา/การแพทย์

    new itemName[MAX_ITEM_NAME];    if (strfind(itemName, "ยาพอก", true) != -1) return ITEM_TYPE_MEDICAL;

    GetItemName(itemid, itemName);    

    new msg[128];    // เกราะ/เสื้อกันกระสุน

    format(msg, sizeof(msg), "{00FF00}คุณได้รับ: %s x%d", itemName, quantity);    if (strfind(itemName, "เสื้อกันกระสุน", true) != -1) return ITEM_TYPE_ARMOR;

    SendClientMessage(playerid, -1, msg);    

    return 1;    // อาวุธ

}    if (strfind(itemName, "ปืน", true) != -1) return ITEM_TYPE_WEAPON;

    if (strfind(itemName, "ไม้เบสบอล", true) != -1) return ITEM_TYPE_WEAPON;

// ลบไอเท็มออกจากผู้เล่น    

stock RemoveItemFromPlayer(playerid, slot, quantity = 1) {    // เครื่องมือ

    if (!IsPlayerConnected(playerid)) return 0;    if (strfind(itemName, "ชุดเครื่องมือช่าง", true) != -1) return ITEM_TYPE_TOOL;

    if (slot < 0 || slot >= PlayerInventoryCount[playerid]) return 0;    if (strfind(itemName, "ยางอะไหล่", true) != -1) return ITEM_TYPE_TOOL;

    if (quantity <= 0) return 0;    if (strfind(itemName, "สายกู้ไฟ", true) != -1) return ITEM_TYPE_TOOL;

    

    PlayerInventory[playerid][slot][InvQuantity] -= quantity;    // ไอเท็มทั่วไป (ไม่มี ability)

    return ITEM_TYPE_NONE;

    // ถ้าจำนวนเหลือ 0 ให้ลบ slot}

    if (PlayerInventory[playerid][slot][InvQuantity] <= 0) {

        // Shift array (เลื่อนไอเท็มที่เหลือมาแทน)// ------------------------------ Load Items ----------------------------------

        for (new i = slot; i < PlayerInventoryCount[playerid] - 1; i++) {// โหลดรายการไอเท็มทั้งหมดจาก database เข้า array

            PlayerInventory[playerid][i][InvItemID] = PlayerInventory[playerid][i + 1][InvItemID];stock LoadAllItemsFromDB() {

            PlayerInventory[playerid][i][InvQuantity] = PlayerInventory[playerid][i + 1][InvQuantity];    if (dbHandle == MYSQL_INVALID_HANDLE) {

            PlayerInventory[playerid][i][InvInventoryID] = PlayerInventory[playerid][i + 1][InvInventoryID];        print("[Item System] ERROR: Database not connected!");

        }        return 0;

        PlayerInventoryCount[playerid]--;    }

    }

    return 1;    new Cache:cache = mysql_query(dbHandle, "SELECT item_id, item_name, item_description, item_weight FROM items ORDER BY item_id ASC");

}    new rows = cache_num_rows();

    

// Clear inventory (ใช้ตอน disconnect)    if (rows == 0) {

stock ClearPlayerInventory(playerid) {        cache_delete(cache);

    for (new i = 0; i < MAX_PLAYER_ITEMS; i++) {        print("[Item System] No items found in database");

        PlayerInventory[playerid][i][InvItemID] = 0;        return 0;

        PlayerInventory[playerid][i][InvQuantity] = 0;    }

        PlayerInventory[playerid][i][InvInventoryID] = 0;

    }    g_TotalItems = 0;

    PlayerInventoryCount[playerid] = 0;    for (new i = 0; i < rows && i < MAX_ITEMS; i++) {

    g_PlayerSelectedSlot[playerid] = -1;        cache_get_value_int(i, "item_id", ItemData[i][ItemDBID]);

}        cache_get_value(i, "item_name", ItemData[i][ItemName], MAX_ITEM_NAME);

        cache_get_value(i, "item_description", ItemData[i][ItemDescription], MAX_ITEM_DESC);

// ------------------------------ Database Functions --------------------------        cache_get_value_float(i, "item_weight", ItemData[i][ItemWeight]);

// โหลด Inventory จาก Database        

stock LoadPlayerInventory(playerid) {        // กำหนดประเภทไอเท็มตามชื่อ (อ้างอิงจาก database)

    if (!IsPlayerConnected(playerid)) return 0;        ItemData[i][ItemType] = DetermineItemType(ItemData[i][ItemName]);

    if (dbHandle == MYSQL_INVALID_HANDLE) return 0;        

    if (!IsPlayerDataReady(playerid)) return 0;        g_TotalItems++;

    }

    new query[256];    

    mysql_format(dbHandle, query, sizeof(query),    cache_delete(cache);

        "SELECT inventory_id, item_id, quantity FROM inventory WHERE player_id = %d",    printf("[Item System] Loaded %d items from database", g_TotalItems);

        PlayerIntData[playerid][PlayerID]    return g_TotalItems;

    );}

    

    new Cache:cache = mysql_query(dbHandle, query);// ------------------------------ Helper Functions ----------------------------

    new rows = cache_num_rows();// หา index ของไอเท็มจาก item_id (DB)

stock GetItemIndexByDBID(dbid) {

    ClearPlayerInventory(playerid);    for (new i = 0; i < g_TotalItems; i++) {

        if (ItemData[i][ItemDBID] == dbid) {

    if (rows > 0) {            return i;

        for (new i = 0; i < rows && i < MAX_PLAYER_ITEMS; i++) {        }

            new itemid, quantity, inventoryid;    }

            cache_get_value_int(i, "inventory_id", inventoryid);    return -1;

            cache_get_value_int(i, "item_id", itemid);}

            cache_get_value_int(i, "quantity", quantity);

// หาชื่อไอเท็มจาก index

            if (IsValidItemID(itemid) && quantity > 0) {stock GetItemNameByIndex(index, dest[], len = sizeof(dest)) {

                PlayerInventory[playerid][i][InvItemID] = itemid;    if (index < 0 || index >= g_TotalItems) {

                PlayerInventory[playerid][i][InvQuantity] = quantity;        dest[0] = EOS;

                PlayerInventory[playerid][i][InvInventoryID] = inventoryid;        return 0;

                PlayerInventoryCount[playerid]++;    }

            }    format(dest, len, "%s", ItemData[index][ItemName]);

        }    return 1;

        printf("[Inventory] Loaded %d items for player ID %d", rows, playerid);}

    }

// หาน้ำหนักไอเท็มจาก index

    cache_delete(cache);stock Float:GetItemWeightByIndex(index) {

    return 1;    if (index < 0 || index >= g_TotalItems) return 0.0;

}    return ItemData[index][ItemWeight];

}

// บันทึก Inventory ไปยัง Database

stock SavePlayerInventory(playerid) {// ------------------------------ Player Inventory ----------------------------

    if (!IsPlayerConnected(playerid)) return 0;// โหลด inventory ของผู้เล่นจาก database

    if (dbHandle == MYSQL_INVALID_HANDLE) return 0;stock LoadPlayerInventory(playerid) {

    if (!IsPlayerDataReady(playerid)) return 0;    if (!IsPlayerConnected(playerid)) return 0;

    if (dbHandle == MYSQL_INVALID_HANDLE) return 0;

    new query[512];    

    new playerDBID = PlayerIntData[playerid][PlayerID];    // รีเซ็ต inventory ก่อน

    ResetPlayerInventory(playerid);

    // ลบไอเท็มเก่าออกก่อน (เพื่อ sync)    

    mysql_format(dbHandle, query, sizeof(query),    new query[256];

        "DELETE FROM inventory WHERE player_id = %d", playerDBID    format(query, sizeof(query), 

    );        "SELECT ii.inventory_id, ii.item_id, ii.quantity \

    mysql_query(dbHandle, query);        FROM inventory_items ii \

        INNER JOIN inventory i ON ii.inventory_id = i.inventory_id \

    // Insert ไอเท็มใหม่        WHERE i.inventory_owner = %d", 

    for (new i = 0; i < PlayerInventoryCount[playerid]; i++) {        PlayerIntData[playerid][PlayerID]

        new itemid = PlayerInventory[playerid][i][InvItemID];    );

        new quantity = PlayerInventory[playerid][i][InvQuantity];    

    new Cache:cache = mysql_query(dbHandle, query);

        if (IsValidItemID(itemid) && quantity > 0) {    new rows = cache_num_rows();

            mysql_format(dbHandle, query, sizeof(query),    

                "INSERT INTO inventory (player_id, item_id, quantity) VALUES (%d, %d, %d)",    if (rows == 0) {

                playerDBID, itemid, quantity        cache_delete(cache);

            );        printf("[Inventory] Player %d has no items", playerid);

            mysql_query(dbHandle, query);        return 0;

        }    }

    }    

    new loaded = 0;

    printf("[Inventory] Saved %d items for player ID %d", PlayerInventoryCount[playerid], playerid);    for (new i = 0; i < rows && i < MAX_PLAYER_ITEMS; i++) {

    return 1;        new dbItemID, quantity, inventoryID;

}        cache_get_value_int(i, "inventory_id", inventoryID);

        cache_get_value_int(i, "item_id", dbItemID);

// ------------------------------ Dialog Functions ----------------------------        cache_get_value_int(i, "quantity", quantity);

// แสดง Inventory Dialog        

stock ShowPlayerInventory(playerid) {        // หา index ของไอเท็มใน ItemData array

    if (!IsPlayerConnected(playerid)) return 0;        new itemIndex = GetItemIndexByDBID(dbItemID);

        if (itemIndex == -1) {

    if (PlayerInventoryCount[playerid] == 0) {            printf("[Inventory] Warning: Item ID %d not found in ItemData", dbItemID);

        SendClientMessage(playerid, 0xFF0000FF, "กระเป๋าของคุณว่างเปล่า!");            continue;

        return 0;        }

    }        

        // เพิ่มเข้า inventory ของผู้เล่น

    new dialog[2048], line[128];        PlayerInventory[playerid][loaded][InvItemID] = itemIndex;

    format(dialog, sizeof(dialog), "ลำดับ\tชื่อไอเท็ม\tจำนวน\tน้ำหนัก\tสถานะ\n");        PlayerInventory[playerid][loaded][InvQuantity] = quantity;

        PlayerInventory[playerid][loaded][InvInventoryID] = inventoryID;

    for (new i = 0; i < PlayerInventoryCount[playerid]; i++) {        loaded++;

        new itemid = PlayerInventory[playerid][i][InvItemID];    }

        new quantity = PlayerInventory[playerid][i][InvQuantity];    

    PlayerInventoryCount[playerid] = loaded;

        new itemName[MAX_ITEM_NAME];    cache_delete(cache);

        GetItemName(itemid, itemName);    printf("[Inventory] Loaded %d items for player %d", loaded, playerid);

    return loaded;

        new Float:weight = GetItemWeight(itemid) * float(quantity);}

        

        new ability[64];// รีเซ็ต inventory ของผู้เล่น

        GetItemAbilityText(itemid, ability, sizeof(ability));stock ResetPlayerInventory(playerid) {

    PlayerInventoryCount[playerid] = 0;

        format(line, sizeof(line), "%d\t%s\tx%d\t%.1f kg\t%s\n",    g_PlayerSelectedItem[playerid] = -1; // รีเซ็ตไอเท็มที่เลือก

            i + 1, itemName, quantity, weight, ability    for (new i = 0; i < MAX_PLAYER_ITEMS; i++) {

        );        PlayerInventory[playerid][i][InvItemID] = -1;

        strcat(dialog, line);        PlayerInventory[playerid][i][InvQuantity] = 0;

    }        PlayerInventory[playerid][i][InvInventoryID] = 0;

    }

    ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_TABLIST_HEADERS,}

        "{FFD700}กระเป๋าของคุณ", dialog, "เลือก", "ปิด");

    return 1;// บันทึก inventory ของผู้เล่นลง database

}stock SavePlayerInventory(playerid) {

    if (!IsPlayerConnected(playerid)) return 0;

// แสดงรายละเอียดไอเท็ม + ปุ่มใช้    if (!IsPlayerLoggedIn(playerid)) return 0;

stock ShowItemInfo(playerid, slot) {    if (dbHandle == MYSQL_INVALID_HANDLE) return 0;

    if (!IsPlayerConnected(playerid)) return 0;    if (PlayerIntData[playerid][PlayerID] == 0) return 0;

    if (slot < 0 || slot >= PlayerInventoryCount[playerid]) return 0;    

    // 1. หา inventory_id ของผู้เล่น หรือสร้างใหม่ถ้าไม่มี

    new itemid = PlayerInventory[playerid][slot][InvItemID];    new query[512];

    new quantity = PlayerInventory[playerid][slot][InvQuantity];    mysql_format(dbHandle, query, sizeof(query),

        "INSERT INTO inventory (inventory_owner) VALUES (%d) \

    new itemName[MAX_ITEM_NAME];        ON DUPLICATE KEY UPDATE inventory_owner = inventory_owner",

    GetItemName(itemid, itemName);        PlayerIntData[playerid][PlayerID]);

    mysql_tquery(dbHandle, query);

    new itemDesc[MAX_ITEM_DESC];    

    GetItemDescription(itemid, itemDesc);    // 2. ลบไอเท็มเก่าทั้งหมดของผู้เล่น

    mysql_format(dbHandle, query, sizeof(query),

    new Float:weight = GetItemWeight(itemid);        "DELETE ii FROM inventory_items ii \

    new E_ITEM_TYPE:type = GetItemType(itemid);        INNER JOIN inventory i ON ii.inventory_id = i.inventory_id \

        WHERE i.inventory_owner = %d",

    new dialog[512];        PlayerIntData[playerid][PlayerID]);

    format(dialog, sizeof(dialog),    mysql_tquery(dbHandle, query);

        "{FFFFFF}ชื่อไอเท็ม: {FFD700}%s\n\    

        {FFFFFF}จำนวน: {00FF00}x%d\n\    // 3. บันทึกไอเท็มใหม่ทั้งหมด

        {FFFFFF}น้ำหนัก: {FFFF00}%.1f kg (ต่อชิ้น)\n\    if (PlayerInventoryCount[playerid] > 0) {

        {FFFFFF}ประเภท: %s\n\n\        new values[2048], temp[128];

        {AAAAAA}%s",        format(values, sizeof(values), "");

        itemName, quantity, weight, GetItemTypeName(type), itemDesc        

    );        for (new i = 0; i < PlayerInventoryCount[playerid]; i++) {

            new itemIdx = PlayerInventory[playerid][i][InvItemID];

    new title[128];            new qty = PlayerInventory[playerid][i][InvQuantity];

    format(title, sizeof(title), "{FFD700}รายละเอียด: %s", itemName);            

            if (itemIdx < 0 || itemIdx >= g_TotalItems) continue;

    g_PlayerSelectedSlot[playerid] = slot;            if (qty <= 0) continue;

    ShowPlayerDialog(playerid, DIALOG_ITEM_INFO, DIALOG_STYLE_MSGBOX, title, dialog, "ใช้", "ปิด");            

    return 1;            new dbItemID = ItemData[itemIdx][ItemDBID];

}            

            if (i > 0) strcat(values, ", ");

// Helper: ดึงชื่อประเภทไอเท็ม            format(temp, sizeof(temp), 

stock GetItemTypeName(E_ITEM_TYPE:type) {                "((SELECT inventory_id FROM inventory WHERE inventory_owner = %d), %d, %d)",

    new name[32];                PlayerIntData[playerid][PlayerID], dbItemID, qty);

    switch (type) {            strcat(values, temp);

        case ITEM_TYPE_FOOD: format(name, sizeof(name), "{00FF00}อาหาร");        }

        case ITEM_TYPE_DRINK: format(name, sizeof(name), "{00FFFF}เครื่องดื่ม");        

        case ITEM_TYPE_MEDICAL: format(name, sizeof(name), "{FF0000}ยารักษา");        if (strlen(values) > 0) {

        case ITEM_TYPE_ARMOR: format(name, sizeof(name), "{0000FF}เกราะป้องกัน");            mysql_format(dbHandle, query, sizeof(query),

        case ITEM_TYPE_WEAPON: format(name, sizeof(name), "{FF8800}อาวุธ");                "INSERT INTO inventory_items (inventory_id, item_id, quantity) VALUES %s",

        case ITEM_TYPE_TOOL: format(name, sizeof(name), "{888888}เครื่องมือ");                values);

        default: format(name, sizeof(name), "{AAAAAA}ทั่วไป");            mysql_tquery(dbHandle, query);

    }        }

    return name;    }

}    

    printf("[Inventory] Saved %d items for player %d", PlayerInventoryCount[playerid], playerid);

// ------------------------------ Commands ------------------------------------    return 1;

CMD:inventory(playerid, params[]) {}

    if (!IsPlayerLoggedIn(playerid)) {

        return SendClientMessage(playerid, 0xFF0000FF, "คุณต้องล็อกอินก่อน!");// เพิ่มไอเท็มให้ผู้เล่น (ใน memory)

    }stock AddItemToPlayer(playerid, itemIndex, quantity = 1) {

    ShowPlayerInventory(playerid);    if (itemIndex < 0 || itemIndex >= g_TotalItems) return 0;

    return 1;    

}    // ตรวจสอบว่ามีไอเท็มนี้อยู่แล้วหรือไม่

    for (new i = 0; i < PlayerInventoryCount[playerid]; i++) {

CMD:inv(playerid, params[]) return cmd_inventory(playerid, params);        if (PlayerInventory[playerid][i][InvItemID] == itemIndex) {

CMD:i(playerid, params[]) return cmd_inventory(playerid, params);            PlayerInventory[playerid][i][InvQuantity] += quantity;

            return 1;

CMD:giveitem(playerid, params[]) {        }

    if (PlayerIntData[playerid][AdminLevel] < 1) {    }

        return SendClientMessage(playerid, 0xFF0000FF, "คุณไม่มีสิทธิ์ใช้คำสั่งนี้!");    

    }    // ถ้าไม่มี เพิ่มใหม่

    if (PlayerInventoryCount[playerid] >= MAX_PLAYER_ITEMS) {

    new args[3][32];        return 0; // inventory เต็ม

    new count = SplitParams(params, args);    }

    

    if (count < 2) {    new slot = PlayerInventoryCount[playerid];

        SendClientMessage(playerid, 0xFFFFFFFF, "Usage: /giveitem <targetid> <itemid> [quantity]");    PlayerInventory[playerid][slot][InvItemID] = itemIndex;

        SendClientMessage(playerid, 0xAAAAAAAA, "Example: /giveitem 0 1 5 (ให้ขนมปัง 5 ชิ้น)");    PlayerInventory[playerid][slot][InvQuantity] = quantity;

        SendClientMessage(playerid, 0xAAAAAAAA, "ใช้ /itemlist เพื่อดูรายการไอเท็ม");    PlayerInventory[playerid][slot][InvInventoryID] = 0; // จะได้ ID เมื่อ save

        return 1;    PlayerInventoryCount[playerid]++;

    }    return 1;

}

    new targetid = strval(args[0]);

    new itemid = strval(args[1]);// ลบไอเท็มจากผู้เล่น

    new quantity = (count >= 3) ? strval(args[2]) : 1;stock RemoveItemFromPlayer(playerid, itemIndex, quantity = 1) {

    for (new i = 0; i < PlayerInventoryCount[playerid]; i++) {

    if (!IsPlayerConnected(targetid)) {        if (PlayerInventory[playerid][i][InvItemID] == itemIndex) {

        return SendClientMessage(playerid, 0xFF0000FF, "ผู้เล่นไม่ออนไลน์!");            PlayerInventory[playerid][i][InvQuantity] -= quantity;

    }            

            // ถ้าจำนวนเหลือ 0 หรือน้อยกว่า ลบออก

    if (!IsValidItemID(itemid)) {            if (PlayerInventory[playerid][i][InvQuantity] <= 0) {

        new msg[128];                // เลื่อนไอเท็มอื่นมาแทน

        format(msg, sizeof(msg), "Item ID ไม่ถูกต้อง! (ใช้ 1-%d)", MAX_ITEM_TYPES - 1);                for (new j = i; j < PlayerInventoryCount[playerid] - 1; j++) {

        return SendClientMessage(playerid, 0xFF0000FF, msg);                    PlayerInventory[playerid][j][InvItemID] = PlayerInventory[playerid][j + 1][InvItemID];

    }                    PlayerInventory[playerid][j][InvQuantity] = PlayerInventory[playerid][j + 1][InvQuantity];

                    PlayerInventory[playerid][j][InvInventoryID] = PlayerInventory[playerid][j + 1][InvInventoryID];

    if (quantity <= 0) quantity = 1;                }

                PlayerInventoryCount[playerid]--;

    AddItemToPlayer(targetid, itemid, quantity);            }

            return 1;

    new itemName[MAX_ITEM_NAME];        }

    GetItemName(itemid, itemName);    }

    return 0;

    new msg[128];}

    new targetName[MAX_PLAYER_NAME];

    GetPlayerName(targetid, targetName, sizeof(targetName));// คำนวณน้ำหนักรวมของ inventory

    stock Float:GetPlayerInventoryWeight(playerid) {

    format(msg, sizeof(msg), "{00FF00}[Admin] คุณได้ให้ไอเท็ม '%s' x%d แก่ %s",     new Float:totalWeight = 0.0;

        itemName, quantity, targetName);    

    SendClientMessage(playerid, -1, msg);    for (new i = 0; i < PlayerInventoryCount[playerid]; i++) {

        new itemIdx = PlayerInventory[playerid][i][InvItemID];

    return 1;        new qty = PlayerInventory[playerid][i][InvQuantity];

}        totalWeight += (GetItemWeightByIndex(itemIdx) * float(qty));

    }

CMD:itemlist(playerid, params[]) {    

    SendClientMessage(playerid, 0xFFD700FF, "=== รายการไอเท็มทั้งหมด ===");    return totalWeight;

    SendClientMessage(playerid, -1, "1. ขนมปัง | 2. น้ำดื่ม | 3. ยาพอก");}

    SendClientMessage(playerid, -1, "4. เสื้อกันกระสุน | 5. ปืน Desert Eagle | 6. ไม้เบสบอล");

    SendClientMessage(playerid, -1, "7. ชุดเครื่องมือช่าง | 8. ยางอะไหล่ | 9. สายกู้ไฟ | 10. โทรศัพท์มือถือ");// แสดง inventory แบบ Dialog

    return 1;stock ShowPlayerInventory(playerid) {

}    if (PlayerInventoryCount[playerid] == 0) {

        ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_MSGBOX,

// ------------------------------ Callbacks -----------------------------------            "{FF6347}คลังไอเท็ม",

// Handle Inventory Dialog Response (ใช้แทน OnDialogResponse)            "{FFFFFF}คุณไม่มีไอเท็มในคลัง\n\n{FFFF00}น้ำหนักรวม: {FFFFFF}0.00 kg",

stock HandleInventoryDialogs(playerid, dialogid, response, listitem, inputtext[]) {            "ปิด", "");

    if (dialogid == DIALOG_INVENTORY) {        return 1;

        if (!response) return 1; // กดปิด    }

    

        if (listitem >= 0 && listitem < PlayerInventoryCount[playerid]) {    new list[2048], itemName[MAX_ITEM_NAME];

            ShowItemInfo(playerid, listitem);    new Float:totalWeight = GetPlayerInventoryWeight(playerid);

        }    

        return 1;    // สร้างรายการไอเท็ม

    }    for (new i = 0; i < PlayerInventoryCount[playerid]; i++) {

        new itemIdx = PlayerInventory[playerid][i][InvItemID];

    if (dialogid == DIALOG_ITEM_INFO) {        new qty = PlayerInventory[playerid][i][InvQuantity];

        if (!response) return 1; // กดปิด        new Float:weight = GetItemWeightByIndex(itemIdx);

        

        // กดปุ่ม "ใช้"        GetItemNameByIndex(itemIdx, itemName);

        new slot = g_PlayerSelectedSlot[playerid];        

        if (slot < 0 || slot >= PlayerInventoryCount[playerid]) return 1;        // เพิ่มรายการแต่ละไอเท็ม

        format(list, sizeof(list), "%s{FFFFFF}%s\t{00FF00}x%d\t{FFFF00}%.1f kg\n", 

        new itemid = PlayerInventory[playerid][slot][InvItemID];            list, itemName, qty, weight * float(qty));

            }

        // เรียกฟังก์ชัน UseItem จาก items.pwn    

        if (UseItem(playerid, itemid, slot)) {    // แสดง Dialog

            // ใช้สำเร็จ - ลบไอเท็ม 1 ชิ้น    new title[64];

            RemoveItemFromPlayer(playerid, slot, 1);    format(title, sizeof(title), "{33CCFF}คลังไอเท็ม {FFFFFF}(%d/%d)", 

        }        PlayerInventoryCount[playerid], MAX_PLAYER_ITEMS);

    

        // เปิด inventory กลับ    new info[128];

        ShowPlayerInventory(playerid);    format(info, sizeof(info), "\n{FFFF00}น้ำหนักรวม: {FFFFFF}%.2f kg", totalWeight);

        return 1;    strcat(list, info);

    }    

    new header[128];

    return 0; // ให้ dialog อื่นๆ ประมวลผลต่อ    format(header, sizeof(header), "{FFFF00}ชื่อไอเท็ม\t{FFFF00}จำนวน\t{FFFF00}น้ำหนัก\n%s", list);

}    

    ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_TABLIST_HEADERS,

// Handle Hotkey (เรียกจาก main.pwn OnPlayerKeyStateChange)        title,

stock HandleInventoryHotkey(playerid, newkeys, oldkeys) {        header,

    if (PRESSED(KEY_YES)) { // กดปุ่ม Y หรือ ~        "ดูรายละเอียด", "ปิด");

        if (IsPlayerLoggedIn(playerid)) {    

            ShowPlayerInventory(playerid);    return 1;

            return 1;}

        }

    }// ------------------------------ Commands ------------------------------------

    return 0;CMD:inventory(playerid, params[]) {

}    if (!IsPlayerLoggedIn(playerid)) {

        SendClientMessage(playerid, 0xFF6347AA, "คุณต้องล็อกอินก่อน!");
        return 1;
    }
    
    ShowPlayerInventory(playerid);
    return 1;
}

CMD:reloaditems(playerid, params[]) {
    if (PlayerIntData[playerid][AdminLevel] < 5) {
        SendClientMessage(playerid, 0xFF6347AA, "คุณไม่มีสิทธิ์ใช้คำสั่งนี้!");
        return 1;
    }
    
    LoadAllItemsFromDB();
    SendClientMessage(playerid, 0x00FF00AA, "[Admin] โหลดข้อมูลไอเท็มใหม่จาก database แล้ว!");
    return 1;
}

CMD:i(playerid, params[]) {
    return ShowPlayerInventory(playerid);
}

CMD:inv(playerid, params[]) {
    return ShowPlayerInventory(playerid);
}

// ------------------------------ Admin Item Management -----------------------
// สร้างไอเท็มใหม่และเพิ่มลง database
stock CreateNewItem(const itemName[], const itemDesc[], Float:itemWeight) {
    if (dbHandle == MYSQL_INVALID_HANDLE) {
        print("[Item System] ERROR: Database not connected!");
        return 0;
    }
    
    if (strlen(itemName) == 0 || strlen(itemName) > MAX_ITEM_NAME - 1) {
        print("[Item System] ERROR: Invalid item name length!");
        return 0;
    }
    
    if (itemWeight < 0.0) {
        print("[Item System] ERROR: Item weight cannot be negative!");
        return 0;
    }
    
    new query[512];
    mysql_format(dbHandle, query, sizeof(query),
        "INSERT INTO items (item_name, item_description, item_weight) VALUES ('%e', '%e', %f)",
        itemName, itemDesc, itemWeight);
    
    mysql_tquery(dbHandle, query, "OnItemCreated", "ssd", itemName, itemDesc, itemWeight);
    return 1;
}

// Callback หลังสร้างไอเท็มสำเร็จ
forward OnItemCreated(const itemName[], const itemDesc[], Float:itemWeight);
public OnItemCreated(const itemName[], const itemDesc[], Float:itemWeight) {
    new insertId = cache_insert_id();
    
    if (insertId == 0) {
        printf("[Item System] ERROR: Failed to create item '%s'", itemName);
        return 0;
    }
    
    // เพิ่มไอเท็มเข้า cache ในหน่วยความจำ
    if (g_TotalItems < MAX_ITEMS) {
        ItemData[g_TotalItems][ItemDBID] = insertId;
        format(ItemData[g_TotalItems][ItemName], MAX_ITEM_NAME, "%s", itemName);
        format(ItemData[g_TotalItems][ItemDescription], MAX_ITEM_DESC, "%s", itemDesc);
        ItemData[g_TotalItems][ItemWeight] = itemWeight;
        g_TotalItems++;
        
        printf("[Item System] Created item '%s' (ID: %d) successfully! Total items: %d", 
            itemName, insertId, g_TotalItems);
    } else {
        printf("[Item System] WARNING: Item cache is full! Reload items to sync.");
    }
    
    return 1;
}

CMD:createitem(playerid, params[]) {
    if (PlayerIntData[playerid][AdminLevel] < 5) {
        SendClientMessage(playerid, 0xFF6347AA, "คุณต้องเป็นแอดมินเลเวล 5 ขึ้นไป!");
        return 1;
    }
    
    if (strlen(params) == 0) {
        SendClientMessage(playerid, 0xFFFF00AA, "วิธีใช้: /createitem [ชื่อไอเท็ม] [น้ำหนัก] [คำอธิบาย]");
        SendClientMessage(playerid, 0xFFFFFFAA, "ตัวอย่าง: /createitem Sword 2.5 ดาบเหล็กคมกริบ");
        return 1;
    }
    
    new args[3][128];
    new argCount = 0;
    new length = strlen(params);
    new start = 0, end = 0;
    
    // แยก argument ด้วยช่องว่าง (สูงสุด 3 arguments)
    while (end < length && argCount < 3) {
        while (end < length && params[end] == ' ') end++;
        start = end;
        while (end < length && params[end] != ' ') end++;
        
        if (start < end) {
            strmid(args[argCount], params, start, end, 128);
            argCount++;
        }
    }
    
    if (argCount < 3) {
        SendClientMessage(playerid, 0xFF6347AA, "ข้อผิดพลาด: กรุณาระบุพารามิเตอร์ให้ครบ!");
        SendClientMessage(playerid, 0xFFFFFFAA, "วิธีใช้: /createitem [ชื่อไอเท็ม] [น้ำหนัก] [คำอธิบาย]");
        return 1;
    }
    
    new itemName[MAX_ITEM_NAME];
    format(itemName, sizeof(itemName), "%s", args[0]);
    
    new Float:weight = floatstr(args[1]);
    
    // รวม args[2] ถึงท้ายสุดเป็นคำอธิบาย
    new itemDesc[MAX_ITEM_DESC];
    new descStart = 0;
    
    // หาตำแหน่งเริ่มต้นของ description (หลัง argument ที่ 2)
    new spaceCount = 0;
    for (new i = 0; i < length; i++) {
        if (params[i] == ' ') {
            spaceCount++;
            if (spaceCount == 2) {
                descStart = i + 1;
                break;
            }
        }
    }
    
    if (descStart < length) {
        strmid(itemDesc, params, descStart, length, MAX_ITEM_DESC);
    } else {
        format(itemDesc, sizeof(itemDesc), "No description");
    }
    
    // ตรวจสอบความถูกต้อง
    if (strlen(itemName) == 0) {
        SendClientMessage(playerid, 0xFF6347AA, "ข้อผิดพลาด: ชื่อไอเท็มไม่สามารถเว้นว่างได้!");
        return 1;
    }
    
    if (weight < 0.0 || weight > 1000.0) {
        SendClientMessage(playerid, 0xFF6347AA, "ข้อผิดพลาด: น้ำหนักต้องอยู่ระหว่าง 0-1000 kg!");
        return 1;
    }
    
    // สร้างไอเท็ม
    if (CreateNewItem(itemName, itemDesc, weight)) {
        new msg[256];
        format(msg, sizeof(msg), 
            "{00FF00}[Admin] สร้างไอเท็มสำเร็จ!\n\
            {FFFFFF}ชื่อ: {FFFF00}%s\n\
            {FFFFFF}น้ำหนัก: {FFFF00}%.2f kg\n\
            {FFFFFF}คำอธิบาย: {CCCCCC}%s",
            itemName, weight, itemDesc);
        SendClientMessage(playerid, -1, msg);
        
        printf("[Admin] %s created item '%s' (%.2f kg)", getplayername(playerid), itemName, weight);
    } else {
        SendClientMessage(playerid, 0xFF6347AA, "ข้อผิดพลาด: ไม่สามารถสร้างไอเท็มได้!");
    }
    
    return 1;
}
