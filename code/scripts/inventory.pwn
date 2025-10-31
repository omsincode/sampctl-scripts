// --------------------------- Include Guard ----------------------------------
#if defined _inventory_included
    #endinput
#endif
#define _inventory_included

// ------------------------------ Includes ------------------------------------
#include <code/gui/gui_inventory>

// ------------------------------ Inventory Commands --------------------------

/**
 * แสดงกระเป๋า
 */
CMD:inventory(playerid, params[]) {
    if(!player_info[playerid][player_logged_in]) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} กรุณาเข้าสู่ระบบก่อน");
    }
    
    gui_show_inventory(playerid);
    return 1;
}

CMD:inv(playerid, params[]) {
    return cmd_inventory(playerid, params);
}

CMD:i(playerid, params[]) {
    return cmd_inventory(playerid, params);
}

// ------------------------------ Admin Commands ------------------------------

/**
 * ให้ไอเทมผู้เล่น (Admin Level 5+)
 */
CMD:giveitem(playerid, params[]) {
    if(player_info[playerid][player_admin_level] < 5) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} คุณไม่มีสิทธิ์ใช้คำสั่งนี้");
    }
    
    new targetid, itemid, quantity;
    if(sscanf(params, "uD(1)D(1)", targetid, itemid, quantity)) {
        SendClientMessage(playerid, 0xAAAAAAAA, "{FFAA00}[USAGE]{FFFFFF} /giveitem [playerid] [item_id] [quantity]");
        SendClientMessage(playerid, 0xAAAAAAAA, "{FFAA00}[TIP]{FFFFFF} ใช้ /itemlist เพื่อดูรายการไอเทม");
        return 1;
    }
    
    if(!IsPlayerConnected(targetid)) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} ไม่พบผู้เล่นนี้");
    }
    
    if(!player_info[targetid][player_logged_in]) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} ผู้เล่นยังไม่ได้เข้าสู่ระบบ");
    }
    
    if(itemid < 0 || itemid >= _:MAX_ITEM_TYPES) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} Item ID ไม่ถูกต้อง");
    }
    
    if(quantity < 1) quantity = 1;
    
    give_player_item(targetid, e_item_type:itemid, quantity, 100);
    
    new itemname[64];
    get_item_name_by_enum(e_item_type:itemid, itemname);
    new string[128];
    format(string, sizeof(string), "{00FF00}[ADMIN]{FFFFFF} ให้ {FFFF00}%s x%d{FFFFFF} กับ {00FF00}%s", 
        itemname, quantity, player_info[targetid][player_name]);
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), "{00FF00}[ADMIN]{FFFFFF} คุณได้รับ {FFFF00}%s{FFFFFF} จาก {FFFF00}%s x%d{FFFFFF} ชิ้น", 
        player_info[playerid][player_name], itemname, quantity);
    SendClientMessage(targetid, -1, string);
    
    return 1;
}

/**
 * ดูรายการไอเทม (Admin Level 1+)
 */
CMD:itemlist(playerid, params[]) {
    if(player_info[playerid][player_admin_level] < 1) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} คุณไม่มีสิทธิ์ใช้คำสั่งนี้");
    }
    
    SendClientMessage(playerid, 0xFFD700FF, "======= {FFFFFF}รายการไอเทม {FFD700}=======");
    
    for(new i = 0; i < get_static_item_count(); i++) {
        new string[128];
        format(string, sizeof(string), "{FFAA00}ID %d:{FFFFFF} %s {888888}(Max: %d)", 
            _:g_item_type_data[i][item_enum], 
            g_item_type_data[i][item_name],
            g_item_type_data[i][item_max_stack]
        );
        SendClientMessage(playerid, -1, string);
    }
    
    new string[128];
    format(string, sizeof(string), "{FFD700}======= {FFFFFF}ทั้งหมด %d ชนิด {FFD700}=======", get_static_item_count());
    SendClientMessage(playerid, 0xFFD700FF, string);
    
    return 1;
}

/**
 * ลบไอเทมออก (Admin Level 5+)
 */
CMD:removeitem(playerid, params[]) {
    if(player_info[playerid][player_admin_level] < 5) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} คุณไม่มีสิทธิ์ใช้คำสั่งนี้");
    }
    
    new targetid, slot, quantity;
    if(sscanf(params, "uD(1)D(1)", targetid, slot, quantity)) {
        SendClientMessage(playerid, 0xAAAAAAAA, "{FFAA00}[USAGE]{FFFFFF} /removeitem [playerid] [slot] [quantity]");
        return 1;
    }
    
    if(!IsPlayerConnected(targetid)) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} ไม่พบผู้เล่นนี้");
    }
    
    if(!player_info[targetid][player_logged_in]) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} ผู้เล่นยังไม่ได้เข้าสู่ระบบ");
    }
    
    if(slot < 1 || slot > MAX_INVENTORY_SLOTS) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} Slot ต้องอยู่ในช่วง 1-20");
    }
    
    if(quantity < 1) quantity = 1;
    
    slot--; // แปลง 1-based เป็น 0-based
    
    if(!g_player_inventory[targetid][slot][inv_exists]) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} ไม่มีไอเทมในช่องนี้");
    }
    
    new itemname[64];
    get_item_name_by_enum(g_player_inventory[targetid][slot][inv_item_type], itemname);
    
    remove_player_item(targetid, slot, quantity);
    
    new string[128];
    format(string, sizeof(string), "{00FF00}[ADMIN]{FFFFFF} ลบ {FFFF00}%s x%d{FFFFFF} จาก {00FF00}%s", 
        itemname, quantity, player_info[targetid][player_name]);
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), "{FF0000}[ADMIN]{FFFFFF} ถูกลบ {FFFF00}%s x%d{FFFFFF} ออก", 
        itemname, quantity);
    SendClientMessage(targetid, -1, string);
    
    return 1;
}

/**
 * ล้างกระเป๋าทั้งหมด (Admin Level 6+)
 */
CMD:clearinv(playerid, params[]) {
    if(player_info[playerid][player_admin_level] < 6) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} คุณไม่มีสิทธิ์ใช้คำสั่งนี้");
    }
    
    new targetid;
    if(sscanf(params, "u", targetid)) {
        SendClientMessage(playerid, 0xAAAAAAAA, "{FFAA00}[USAGE]{FFFFFF} /clearinv [playerid]");
        return 1;
    }
    
    if(!IsPlayerConnected(targetid)) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} ไม่พบผู้เล่นนี้");
    }
    
    if(!player_info[targetid][player_logged_in]) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} ผู้เล่นยังไม่ได้เข้าสู่ระบบ");
    }
    
    // ลบจากฐานข้อมูล
    new query[128];
    mysql_format(mysql_handle, query, sizeof(query), 
        "DELETE FROM player_items WHERE player_item_owner_id = %d",
        player_info[targetid][player_id]
    );
    mysql_tquery(mysql_handle, query);
    
    // ล้าง cache
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++) {
        g_player_inventory[targetid][i][inv_exists] = false;
    }
    
    new string[128];
    format(string, sizeof(string), "{00FF00}[ADMIN]{FFFFFF} ล้างกระเป๋าของ {00FF00}%s{FFFFFF} เรียบร้อย", 
        player_info[targetid][player_name]);
    SendClientMessage(playerid, -1, string);
    
    SendClientMessage(targetid, 0xFF0000FF, "{FF0000}[ADMIN]{FFFFFF} กระเป๋าของคุณถูกล้างแล้ว");
    
    return 1;
}

// ------------------------------ Callbacks -----------------------------------

/**
 * Handle Dialog Response
 */
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    switch(dialogid) {
        case DIALOG_INVENTORY: {
            gui_on_inventory_response(playerid, response, listitem);
            return 1;
        }
        case DIALOG_INVENTORY_USE: {
            gui_on_inventory_use_response(playerid, response);
            return 1;
        }
    }
    return 0;
}
