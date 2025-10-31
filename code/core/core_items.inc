// --------------------------- Include Guard ----------------------------------
#if defined _core_items_included
    #endinput
#endif
#define _core_items_included

// ------------------------------ Includes ------------------------------------
#include <a_mysql>
#include <code/core/core_database>
#include <code/core/core_items_type>
#include <code/core/core_item_ability>

// ------------------------------ Configuration -------------------------------
#define MAX_INVENTORY_SLOTS     20

// ------------------------------ Player Inventory ----------------------------
enum e_player_inventory {
    inv_db_id,                          // player_item_id (database)
    e_item_type:inv_item_type,          // enum ????? (ITEM_WOODEN_SWORD, etc)
    inv_slot,                           // ?????? 0-19
    inv_quantity,
    inv_quality,
    bool:inv_exists
}

new g_player_inventory[MAX_PLAYERS][MAX_INVENTORY_SLOTS][e_player_inventory];

// ------------------------------ Player Inventory Functions ------------------

/**
 * โหลด Inventory ของผู้เล่น
 */
stock load_player_inventory(playerid) {
    if(!IsPlayerConnected(playerid)) return 0;
    
    // ล้าง inventory ก่อน
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++) {
        g_player_inventory[playerid][i][inv_exists] = false;
    }
    
    new query[256];
    mysql_format(mysql_handle, query, sizeof(query), 
        "SELECT player_item_id, player_item_type, player_item_slot, player_item_quantity, player_item_quality \
        FROM player_items WHERE player_item_owner_id = %d ORDER BY player_item_slot ASC",
        player_info[playerid][player_id]
    );
    
    mysql_tquery(mysql_handle, query, "on_player_inventory_loaded", "d", playerid);
    return 1;
}

forward on_player_inventory_loaded(playerid);
public on_player_inventory_loaded(playerid) {
    new rows = cache_num_rows();
    if(rows > 0) {
        new item_type, slot;
        for(new i = 0; i < rows && i < MAX_INVENTORY_SLOTS; i++) {
            cache_get_value_int(i, "player_item_slot", slot);
            if(slot >= 0 && slot < MAX_INVENTORY_SLOTS) {
                cache_get_value_int(i, "player_item_id", g_player_inventory[playerid][slot][inv_db_id]);
                cache_get_value_int(i, "player_item_type", item_type);
                cache_get_value_int(i, "player_item_quantity", g_player_inventory[playerid][slot][inv_quantity]);
                cache_get_value_int(i, "player_item_quality", g_player_inventory[playerid][slot][inv_quality]);
                
                g_player_inventory[playerid][slot][inv_item_type] = e_item_type:item_type;
                g_player_inventory[playerid][slot][inv_slot] = slot;
                g_player_inventory[playerid][slot][inv_exists] = true;
            }
        }
        
        printf("[ITEMS] Loaded %d items for player %s (ID: %d)", rows, player_info[playerid][player_name], playerid);
    }
    return 1;
}

/**
 * ให้ไอเทมแก่ผู้เล่น
 */
stock give_player_item(playerid, e_item_type:itemtype, quantity = 1, quality = 100) {
    if(!IsPlayerConnected(playerid)) return 0;
    if(!player_info[playerid][player_logged_in]) return 0;
    if(itemtype == ITEM_NONE) return 0;
    
    // ดึงข้อมูลจากตาราง static data
    new item_index = get_item_index_by_enum(itemtype);
    if(item_index == -1) {
        printf("[ITEMS] ERROR: Item type %d not found!", _:itemtype);
        return 0;
    }
    
    new max_stack = g_item_type_data[item_index][item_max_stack];
    
    // ถ้า stackable แล้วมีช่องเดิมอยู่แล้ว ใส่เพิ่ม
    if(max_stack > 1) {
        for(new i = 0; i < MAX_INVENTORY_SLOTS; i++) {
            if(g_player_inventory[playerid][i][inv_exists] && 
               g_player_inventory[playerid][i][inv_item_type] == itemtype &&
               g_player_inventory[playerid][i][inv_quantity] < max_stack) {
                // ใส่เพิ่ม - จนเต็ม stack
                new space = max_stack - g_player_inventory[playerid][i][inv_quantity];
                new add_amount = (quantity > space) ? space : quantity;
                
                g_player_inventory[playerid][i][inv_quantity] += add_amount;
                
                // UPDATE database
                new query[256];
                mysql_format(mysql_handle, query, sizeof(query), 
                    "UPDATE player_items SET player_item_quantity = %d WHERE player_item_id = %d",
                    g_player_inventory[playerid][i][inv_quantity], g_player_inventory[playerid][i][inv_db_id]
                );
                mysql_tquery(mysql_handle, query);
                
                new itemname[64];
                get_item_name_by_enum(itemtype, itemname, sizeof(itemname));
                new string[128];
                format(string, sizeof(string), "{00FF00}[ITEM]{FFFFFF} ได้รับ: {FFFF00}%s x%d", itemname, add_amount);
                SendClientMessage(playerid, -1, string);
                
                quantity -= add_amount;
                if(quantity <= 0) return 1;
            }
        }
    }
    
    // หาช่องว่าง
    new slot = -1;
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++) {
        if(!g_player_inventory[playerid][i][inv_exists]) {
            slot = i;
            break;
        }
    }
    
    if(slot == -1) {
        SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} กระเป๋าเต็ม!");
        return 0;
    }
    
    // จำกัดจำนวนไม่เกิน max_stack
    if(quantity > max_stack) quantity = max_stack;
    
    // เพิ่มลงฐานข้อมูล
    new query[512];
    mysql_format(mysql_handle, query, sizeof(query), 
        "INSERT INTO player_items (player_item_owner_id, player_item_type, player_item_slot, player_item_quantity, player_item_quality) \
        VALUES (%d, %d, %d, %d, %d)",
        player_info[playerid][player_id], _:itemtype, slot, quantity, quality
    );
    mysql_tquery(mysql_handle, query, "on_player_item_added", "dddd", playerid, slot, _:itemtype, quantity);
    
    return 1;
}

forward on_player_item_added(playerid, slot, itemtype, quantity);
public on_player_item_added(playerid, slot, itemtype, quantity) {
    new insert_id = cache_insert_id();
    
    g_player_inventory[playerid][slot][inv_db_id] = insert_id;
    g_player_inventory[playerid][slot][inv_item_type] = e_item_type:itemtype;
    g_player_inventory[playerid][slot][inv_slot] = slot;
    g_player_inventory[playerid][slot][inv_quantity] = quantity;
    g_player_inventory[playerid][slot][inv_quality] = 100;
    g_player_inventory[playerid][slot][inv_exists] = true;
    
    new itemname[64];
    get_item_name_by_enum(e_item_type:itemtype, itemname, sizeof(itemname));
    new string[128];
    format(string, sizeof(string), "{00FF00}[ITEM]{FFFFFF} ได้รับ: {FFFF00}%s x%d", itemname, quantity);
    SendClientMessage(playerid, -1, string);
    
    return 1;
}

/**
 * ลบไอเทมออก
 */
stock remove_player_item(playerid, slot, quantity = 1) {
    if(!IsPlayerConnected(playerid)) return 0;
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    if(!g_player_inventory[playerid][slot][inv_exists]) return 0;
    
    new current_qty = g_player_inventory[playerid][slot][inv_quantity];
    
    if(quantity >= current_qty) {
        // ลบทั้งหมด
        new query[256];
        mysql_format(mysql_handle, query, sizeof(query), 
            "DELETE FROM player_items WHERE player_item_id = %d",
            g_player_inventory[playerid][slot][inv_db_id]
        );
        mysql_tquery(mysql_handle, query);
        
        g_player_inventory[playerid][slot][inv_exists] = false;
    } else {
        // ลบบางส่วน
        g_player_inventory[playerid][slot][inv_quantity] -= quantity;
        
        new query[256];
        mysql_format(mysql_handle, query, sizeof(query), 
            "UPDATE player_items SET player_item_quantity = %d WHERE player_item_id = %d",
            g_player_inventory[playerid][slot][inv_quantity], g_player_inventory[playerid][slot][inv_db_id]
        );
        mysql_tquery(mysql_handle, query);
    }
    
    return 1;
}

/**
 * ใช้ไอเทมจากช่อง
 */
stock use_player_item(playerid, slot) {
    if(!IsPlayerConnected(playerid)) return 0;
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    if(!g_player_inventory[playerid][slot][inv_exists]) return 0;
    
    new e_item_type:itemtype = g_player_inventory[playerid][slot][inv_item_type];
    new item_index = get_item_index_by_enum(itemtype);
    if(item_index == -1) return 0;
    
    new ability_id = g_item_type_data[item_index][item_ability_id];
    
    // เรียกใช้ความสามารถของไอเทม
    new result = use_item_ability(playerid, ability_id, g_player_inventory[playerid][slot][inv_quality]);
    
    if(result) {
        // ถ้าไอเทมเป็น consumable ให้ลบออกหลังใช้
        if(is_ability_consumable(ability_id)) {
            remove_player_item(playerid, slot, 1);
        }
    }
    
    return result;
}

/**
 * ล้างกระเป๋าทั้งหมด
 */
stock clear_player_inventory(playerid) {
    if(!IsPlayerConnected(playerid)) return 0;
    
    new query[256];
    mysql_format(mysql_handle, query, sizeof(query), 
        "DELETE FROM player_items WHERE player_item_owner_id = %d",
        player_info[playerid][player_id]
    );
    mysql_tquery(mysql_handle, query);
    
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++) {
        g_player_inventory[playerid][i][inv_exists] = false;
    }
    
    return 1;
}

/**
 * นับจำนวนช่องว่าง
 */
stock get_player_free_slots(playerid) {
    new count = 0;
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++) {
        if(!g_player_inventory[playerid][i][inv_exists]) count++;
    }
    return count;
}

/**
 * นับจำนวนไอเทมชนิดนั้น
 */
stock get_player_item_count(playerid, e_item_type:itemtype) {
    new count = 0;
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++) {
        if(g_player_inventory[playerid][i][inv_exists] && 
           g_player_inventory[playerid][i][inv_item_type] == itemtype) {
            count += g_player_inventory[playerid][i][inv_quantity];
        }
    }
    return count;
}
