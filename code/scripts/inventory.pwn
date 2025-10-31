// --------------------------- Include Guard ----------------------------------
#if defined _inventory_included
    #endinput
#endif
#define _inventory_included

// ------------------------------ Includes ------------------------------------
#include <code/gui/gui_inventory>

// ------------------------------ Inventory Commands --------------------------

/**
 * �ʴ�������
 */
CMD:inventory(playerid, params[]) {
    if(!player_info[playerid][player_logged_in]) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} ��س��������к���͹");
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
 * ������������� (Admin Level 5+)
 */
CMD:giveitem(playerid, params[]) {
    if(player_info[playerid][player_admin_level] < 5) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} �س������Է��������觹��");
    }
    
    new targetid, itemid, quantity;
    if(sscanf(params, "uD(1)D(1)", targetid, itemid, quantity)) {
        SendClientMessage(playerid, 0xAAAAAAAA, "{FFAA00}[USAGE]{FFFFFF} /giveitem [playerid] [item_id] [quantity]");
        SendClientMessage(playerid, 0xAAAAAAAA, "{FFAA00}[TIP]{FFFFFF} �� /itemlist ���ʹ���¡������");
        return 1;
    }
    
    if(!IsPlayerConnected(targetid)) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} ��辺�����蹹��");
    }
    
    if(!player_info[targetid][player_logged_in]) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} �������ѧ������������к�");
    }
    
    if(itemid < 0 || itemid >= _:MAX_ITEM_TYPES) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} Item ID ���١��ͧ");
    }
    
    if(quantity < 1) quantity = 1;
    
    give_player_item(targetid, e_item_type:itemid, quantity, 100);
    
    new itemname[64];
    get_item_name_by_enum(e_item_type:itemid, itemname);
    new string[128];
    format(string, sizeof(string), "{00FF00}[ADMIN]{FFFFFF} ��� {FFFF00}%s x%d{FFFFFF} �Ѻ {00FF00}%s", 
        itemname, quantity, player_info[targetid][player_name]);
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), "{00FF00}[ADMIN]{FFFFFF} �س���Ѻ {FFFF00}%s{FFFFFF} �ҡ {FFFF00}%s x%d{FFFFFF} ���", 
        player_info[playerid][player_name], itemname, quantity);
    SendClientMessage(targetid, -1, string);
    
    return 1;
}

/**
 * ����¡������ (Admin Level 1+)
 */
CMD:itemlist(playerid, params[]) {
    if(player_info[playerid][player_admin_level] < 1) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} �س������Է��������觹��");
    }
    
    SendClientMessage(playerid, 0xFFD700FF, "======= {FFFFFF}��¡������ {FFD700}=======");
    
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
    format(string, sizeof(string), "{FFD700}======= {FFFFFF}������ %d ��Դ {FFD700}=======", get_static_item_count());
    SendClientMessage(playerid, 0xFFD700FF, string);
    
    return 1;
}

/**
 * ź�����͡ (Admin Level 5+)
 */
CMD:removeitem(playerid, params[]) {
    if(player_info[playerid][player_admin_level] < 5) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} �س������Է��������觹��");
    }
    
    new targetid, slot, quantity;
    if(sscanf(params, "uD(1)D(1)", targetid, slot, quantity)) {
        SendClientMessage(playerid, 0xAAAAAAAA, "{FFAA00}[USAGE]{FFFFFF} /removeitem [playerid] [slot] [quantity]");
        return 1;
    }
    
    if(!IsPlayerConnected(targetid)) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} ��辺�����蹹��");
    }
    
    if(!player_info[targetid][player_logged_in]) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} �������ѧ������������к�");
    }
    
    if(slot < 1 || slot > MAX_INVENTORY_SLOTS) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} Slot ��ͧ����㹪�ǧ 1-20");
    }
    
    if(quantity < 1) quantity = 1;
    
    slot--; // �ŧ 1-based �� 0-based
    
    if(!g_player_inventory[targetid][slot][inv_exists]) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} ���������㹪�ͧ���");
    }
    
    new itemname[64];
    get_item_name_by_enum(g_player_inventory[targetid][slot][inv_item_type], itemname);
    
    remove_player_item(targetid, slot, quantity);
    
    new string[128];
    format(string, sizeof(string), "{00FF00}[ADMIN]{FFFFFF} ź {FFFF00}%s x%d{FFFFFF} �ҡ {00FF00}%s", 
        itemname, quantity, player_info[targetid][player_name]);
    SendClientMessage(playerid, -1, string);
    
    format(string, sizeof(string), "{FF0000}[ADMIN]{FFFFFF} �١ź {FFFF00}%s x%d{FFFFFF} �͡", 
        itemname, quantity);
    SendClientMessage(targetid, -1, string);
    
    return 1;
}

/**
 * ��ҧ�����ҷ����� (Admin Level 6+)
 */
CMD:clearinv(playerid, params[]) {
    if(player_info[playerid][player_admin_level] < 6) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} �س������Է��������觹��");
    }
    
    new targetid;
    if(sscanf(params, "u", targetid)) {
        SendClientMessage(playerid, 0xAAAAAAAA, "{FFAA00}[USAGE]{FFFFFF} /clearinv [playerid]");
        return 1;
    }
    
    if(!IsPlayerConnected(targetid)) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} ��辺�����蹹��");
    }
    
    if(!player_info[targetid][player_logged_in]) {
        return SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} �������ѧ������������к�");
    }
    
    // ź�ҡ�ҹ������
    new query[128];
    mysql_format(mysql_handle, query, sizeof(query), 
        "DELETE FROM player_items WHERE player_item_owner_id = %d",
        player_info[targetid][player_id]
    );
    mysql_tquery(mysql_handle, query);
    
    // ��ҧ cache
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++) {
        g_player_inventory[targetid][i][inv_exists] = false;
    }
    
    new string[128];
    format(string, sizeof(string), "{00FF00}[ADMIN]{FFFFFF} ��ҧ�����Ңͧ {00FF00}%s{FFFFFF} ���º����", 
        player_info[targetid][player_name]);
    SendClientMessage(playerid, -1, string);
    
    SendClientMessage(targetid, 0xFF0000FF, "{FF0000}[ADMIN]{FFFFFF} �����Ңͧ�س�١��ҧ����");
    
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
