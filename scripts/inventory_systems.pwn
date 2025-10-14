// --------------------------- Include Guard ----------------------------------
#if defined _inventory_systems_included
    #endinput
#endif
#define _inventory_systems_included

// ------------------------------ Dialogs -------------------------------------
#define DIALOG_INVENTORY        200
#define DIALOG_ITEM_INFO        201

// ------------------------------ Item System ---------------------------------
#define MAX_ITEMS           500     // จำนวนไอเท็มสูงสุดที่โหลดจาก DB
#define MAX_ITEM_NAME       64      // ความยาวชื่อไอเท็ม
#define MAX_ITEM_DESC       256     // ความยาวคำอธิบายไอเท็ม
#define MAX_PLAYER_ITEMS    100     // จำนวนไอเท็มสูงสุดต่อผู้เล่น

// โครงสร้างข้อมูลไอเท็มจาก DB
enum E_ITEM_DATA {
    ItemDBID,               // item_id จาก database
    ItemName[MAX_ITEM_NAME],
    ItemDescription[MAX_ITEM_DESC],
    Float:ItemWeight
};
new ItemData[MAX_ITEMS][E_ITEM_DATA];
new g_TotalItems = 0;       // จำนวนไอเท็มที่โหลดจาก DB

// โครงสร้างไอเท็มในตัวผู้เล่น
enum E_PLAYER_INVENTORY {
    InvItemID,              // อ้างอิง ItemData index
    InvQuantity,
    InvInventoryID          // inventory_id จาก DB
};
new PlayerInventory[MAX_PLAYERS][MAX_PLAYER_ITEMS][E_PLAYER_INVENTORY];
new PlayerInventoryCount[MAX_PLAYERS];  // จำนวนไอเท็มที่มี

// ------------------------------ Load Items ----------------------------------
// โหลดรายการไอเท็มทั้งหมดจาก database เข้า array
stock LoadAllItemsFromDB() {
    if (dbHandle == MYSQL_INVALID_HANDLE) {
        print("[Item System] ERROR: Database not connected!");
        return 0;
    }

    new Cache:cache = mysql_query(dbHandle, "SELECT item_id, item_name, item_description, item_weight FROM items ORDER BY item_id ASC");
    new rows = cache_num_rows();
    
    if (rows == 0) {
        cache_delete(cache);
        print("[Item System] No items found in database");
        return 0;
    }

    g_TotalItems = 0;
    for (new i = 0; i < rows && i < MAX_ITEMS; i++) {
        cache_get_value_int(i, "item_id", ItemData[i][ItemDBID]);
        cache_get_value(i, "item_name", ItemData[i][ItemName], MAX_ITEM_NAME);
        cache_get_value(i, "item_description", ItemData[i][ItemDescription], MAX_ITEM_DESC);
        cache_get_value_float(i, "item_weight", ItemData[i][ItemWeight]);
        g_TotalItems++;
    }
    
    cache_delete(cache);
    printf("[Item System] Loaded %d items from database", g_TotalItems);
    return g_TotalItems;
}

// ------------------------------ Helper Functions ----------------------------
// หา index ของไอเท็มจาก item_id (DB)
stock GetItemIndexByDBID(dbid) {
    for (new i = 0; i < g_TotalItems; i++) {
        if (ItemData[i][ItemDBID] == dbid) {
            return i;
        }
    }
    return -1;
}

// หาชื่อไอเท็มจาก index
stock GetItemNameByIndex(index, dest[], len = sizeof(dest)) {
    if (index < 0 || index >= g_TotalItems) {
        dest[0] = EOS;
        return 0;
    }
    format(dest, len, "%s", ItemData[index][ItemName]);
    return 1;
}

// หาน้ำหนักไอเท็มจาก index
stock Float:GetItemWeightByIndex(index) {
    if (index < 0 || index >= g_TotalItems) return 0.0;
    return ItemData[index][ItemWeight];
}

// ------------------------------ Player Inventory ----------------------------
// โหลด inventory ของผู้เล่นจาก database
stock LoadPlayerInventory(playerid) {
    if (!IsPlayerConnected(playerid)) return 0;
    if (dbHandle == MYSQL_INVALID_HANDLE) return 0;
    
    // รีเซ็ต inventory ก่อน
    ResetPlayerInventory(playerid);
    
    new query[256];
    format(query, sizeof(query), 
        "SELECT ii.inventory_id, ii.item_id, ii.quantity \
        FROM inventory_items ii \
        INNER JOIN inventory i ON ii.inventory_id = i.inventory_id \
        WHERE i.inventory_owner = %d", 
        PlayerIntData[playerid][PlayerID]
    );
    
    new Cache:cache = mysql_query(dbHandle, query);
    new rows = cache_num_rows();
    
    if (rows == 0) {
        cache_delete(cache);
        printf("[Inventory] Player %d has no items", playerid);
        return 0;
    }
    
    new loaded = 0;
    for (new i = 0; i < rows && i < MAX_PLAYER_ITEMS; i++) {
        new dbItemID, quantity, inventoryID;
        cache_get_value_int(i, "inventory_id", inventoryID);
        cache_get_value_int(i, "item_id", dbItemID);
        cache_get_value_int(i, "quantity", quantity);
        
        // หา index ของไอเท็มใน ItemData array
        new itemIndex = GetItemIndexByDBID(dbItemID);
        if (itemIndex == -1) {
            printf("[Inventory] Warning: Item ID %d not found in ItemData", dbItemID);
            continue;
        }
        
        // เพิ่มเข้า inventory ของผู้เล่น
        PlayerInventory[playerid][loaded][InvItemID] = itemIndex;
        PlayerInventory[playerid][loaded][InvQuantity] = quantity;
        PlayerInventory[playerid][loaded][InvInventoryID] = inventoryID;
        loaded++;
    }
    
    PlayerInventoryCount[playerid] = loaded;
    cache_delete(cache);
    printf("[Inventory] Loaded %d items for player %d", loaded, playerid);
    return loaded;
}

// รีเซ็ต inventory ของผู้เล่น
stock ResetPlayerInventory(playerid) {
    PlayerInventoryCount[playerid] = 0;
    for (new i = 0; i < MAX_PLAYER_ITEMS; i++) {
        PlayerInventory[playerid][i][InvItemID] = -1;
        PlayerInventory[playerid][i][InvQuantity] = 0;
        PlayerInventory[playerid][i][InvInventoryID] = 0;
    }
}

// เพิ่มไอเท็มให้ผู้เล่น (ใน memory)
stock AddItemToPlayer(playerid, itemIndex, quantity = 1) {
    if (itemIndex < 0 || itemIndex >= g_TotalItems) return 0;
    
    // ตรวจสอบว่ามีไอเท็มนี้อยู่แล้วหรือไม่
    for (new i = 0; i < PlayerInventoryCount[playerid]; i++) {
        if (PlayerInventory[playerid][i][InvItemID] == itemIndex) {
            PlayerInventory[playerid][i][InvQuantity] += quantity;
            return 1;
        }
    }
    
    // ถ้าไม่มี เพิ่มใหม่
    if (PlayerInventoryCount[playerid] >= MAX_PLAYER_ITEMS) {
        return 0; // inventory เต็ม
    }
    
    new slot = PlayerInventoryCount[playerid];
    PlayerInventory[playerid][slot][InvItemID] = itemIndex;
    PlayerInventory[playerid][slot][InvQuantity] = quantity;
    PlayerInventory[playerid][slot][InvInventoryID] = 0; // จะได้ ID เมื่อ save
    PlayerInventoryCount[playerid]++;
    return 1;
}

// ลบไอเท็มจากผู้เล่น
stock RemoveItemFromPlayer(playerid, itemIndex, quantity = 1) {
    for (new i = 0; i < PlayerInventoryCount[playerid]; i++) {
        if (PlayerInventory[playerid][i][InvItemID] == itemIndex) {
            PlayerInventory[playerid][i][InvQuantity] -= quantity;
            
            // ถ้าจำนวนเหลือ 0 หรือน้อยกว่า ลบออก
            if (PlayerInventory[playerid][i][InvQuantity] <= 0) {
                // เลื่อนไอเท็มอื่นมาแทน
                for (new j = i; j < PlayerInventoryCount[playerid] - 1; j++) {
                    PlayerInventory[playerid][j][InvItemID] = PlayerInventory[playerid][j + 1][InvItemID];
                    PlayerInventory[playerid][j][InvQuantity] = PlayerInventory[playerid][j + 1][InvQuantity];
                    PlayerInventory[playerid][j][InvInventoryID] = PlayerInventory[playerid][j + 1][InvInventoryID];
                }
                PlayerInventoryCount[playerid]--;
            }
            return 1;
        }
    }
    return 0;
}

// แสดง inventory แบบ Dialog
stock ShowPlayerInventory(playerid) {
    if (PlayerInventoryCount[playerid] == 0) {
        ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_MSGBOX,
            "{FF6347}คลังไอเท็ม",
            "{FFFFFF}คุณไม่มีไอเท็มในคลัง\n\n{FFFF00}น้ำหนักรวม: {FFFFFF}0.00 kg",
            "ปิด", "");
        return 1;
    }
    
    new list[2048], itemName[MAX_ITEM_NAME];
    new Float:totalWeight = GetPlayerInventoryWeight(playerid);
    
    // สร้างรายการไอเท็ม
    for (new i = 0; i < PlayerInventoryCount[playerid]; i++) {
        new itemIdx = PlayerInventory[playerid][i][InvItemID];
        new qty = PlayerInventory[playerid][i][InvQuantity];
        new Float:weight = GetItemWeightByIndex(itemIdx);
        
        GetItemNameByIndex(itemIdx, itemName);
        
        // เพิ่มรายการแต่ละไอเท็ม
        format(list, sizeof(list), "%s{FFFFFF}%s\t{00FF00}x%d\t{FFFF00}%.1f kg\n", 
            list, itemName, qty, weight * float(qty));
    }
    
    // แสดง Dialog
    new title[64];
    format(title, sizeof(title), "{33CCFF}คลังไอเท็ม {FFFFFF}(%d/%d)", 
        PlayerInventoryCount[playerid], MAX_PLAYER_ITEMS);
    
    new info[128];
    format(info, sizeof(info), "\n{FFFF00}น้ำหนักรวม: {FFFFFF}%.2f kg", totalWeight);
    strcat(list, info);
    
    new header[128];
    format(header, sizeof(header), "{FFFF00}ชื่อไอเท็ม\t{FFFF00}จำนวน\t{FFFF00}น้ำหนัก\n%s", list);
    
    ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_TABLIST_HEADERS,
        title,
        header,
        "ดูรายละเอียด", "ปิด");
    
    return 1;
}

// คำนวณน้ำหนักรวมของ inventory
stock Float:GetPlayerInventoryWeight(playerid) {
    new Float:totalWeight = 0.0;
    
    for (new i = 0; i < PlayerInventoryCount[playerid]; i++) {
        new itemIdx = PlayerInventory[playerid][i][InvItemID];
        new qty = PlayerInventory[playerid][i][InvQuantity];
        totalWeight += (GetItemWeightByIndex(itemIdx) * float(qty));
    }
    
    return totalWeight;
}

// ------------------------------ Commands ------------------------------------
CMD:inventory(playerid, params[]) {
    if (!IsPlayerLoggedIn(playerid)) {
        SendClientMessage(playerid, 0xFF6347AA, "คุณต้องล็อกอินก่อน!");
        return 1;
    }
    
    ShowPlayerInventory(playerid);
    return 1;
}

CMD:inv(playerid, params[]) {
    return cmd_inventory(playerid, params);
}

CMD:i(playerid, params[]) {
    return cmd_inventory(playerid, params);
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

CMD:itemlist(playerid, params[]) {
    if (PlayerIntData[playerid][AdminLevel] < 1) {
        SendClientMessage(playerid, 0xFF6347AA, "คุณไม่มีสิทธิ์ใช้คำสั่งนี้!");
        return 1;
    }
    
    if (g_TotalItems == 0) {
        SendClientMessage(playerid, 0xFF6347AA, "ไม่มีไอเท็มในระบบ!");
        return 1;
    }
    
    SendClientMessage(playerid, 0x33CCFFAA, "=== รายการไอเท็มทั้งหมด ===");
    new string[256], itemName[MAX_ITEM_NAME];
    
    for (new i = 0; i < g_TotalItems && i < 50; i++) { // จำกัดแสดง 50 รายการ
        GetItemNameByIndex(i, itemName);
        format(string, sizeof(string), "[Index: %d | DB ID: %d] %s (น้ำหนัก: %.2f kg)", 
            i, ItemData[i][ItemDBID], itemName, ItemData[i][ItemWeight]);
        SendClientMessage(playerid, 0xFFFFFFAA, string);
    }
    
    if (g_TotalItems > 50) {
        format(string, sizeof(string), "... และอีก %d รายการ", g_TotalItems - 50);
        SendClientMessage(playerid, 0xFFFFFFAA, string);
    }
    
    format(string, sizeof(string), "รวมทั้งหมด: %d ไอเท็ม", g_TotalItems);
    SendClientMessage(playerid, 0x33CCFFAA, string);
    return 1;
}