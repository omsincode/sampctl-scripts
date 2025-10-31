// --------------------------- Include Guard ----------------------------------
#if defined _gui_inventory_included
    #endinput
#endif
#define _gui_inventory_included

// ------------------------------ Dialog IDs ----------------------------------
#define DIALOG_INVENTORY        9000
#define DIALOG_INVENTORY_USE    9001

// ------------------------------ GUI Functions -------------------------------

/**
 * แสดง GUI Inventory ด้วย TextDraw (TODO: ยังไม่เสร็จ)
 * ตอนนี้ใช้ Dialog แทน
 */
stock gui_show_inventory(playerid) {
    return gui_show_inventory(playerid);
}

/**
 * Handle Dialog Response สำหรับ Inventory
 */
stock gui_on_inventory_response(playerid, response, listitem) {
    if(!response) return 1; // กด "ยกเลิก"
    
    // หา slot ที่ถูกเลือก (นับเฉพาะช่องที่มีของ)
    new slot = -1;
    new count = 0;
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++) {
        if(g_player_inventory[playerid][i][inv_exists]) {
            if(count == listitem) {
                slot = i;
                break;
            }
            count++;
        }
    }
    
    if(slot == -1) {
        SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} ไม่พบไอเทม");
        return 1;
    }
    
    // สร้าง dialog แสดงรายละเอียด
    new itemname[64];
    get_item_name_by_enum(g_player_inventory[playerid][slot][inv_item_type], itemname);
    
    new dialog[256];
    format(dialog, sizeof(dialog), 
        "{FFFFFF}ไอเทม {FFFF00}%s{FFFFFF} ของคุณ\n\n\
        จำนวน: {00FF00}%d{FFFFFF}\n\
        คุณภาพ: {00FF00}%d%%",
        itemname,
        g_player_inventory[playerid][slot][inv_quantity],
        g_player_inventory[playerid][slot][inv_quality]
    );
    
    SetPVarInt(playerid, "InventorySlot", slot);
    ShowPlayerDialog(playerid, DIALOG_INVENTORY_USE, DIALOG_STYLE_MSGBOX, 
        "{FFD700}รายละเอียด", dialog, "ใช้", "ยกเลิก");
    
    return 1;
}

/**
 * Handle Dialog Response เมื่อกดใช้ไอเทม
 */
stock gui_on_inventory_use_response(playerid, response) {
    if(!response) return 1; // กด "ยกเลิก"
    
    new slot = GetPVarInt(playerid, "InventorySlot");
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 1;
    
    if(!g_player_inventory[playerid][slot][inv_exists]) {
        SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} ไม่พบไอเทมในช่องนี้");
        return 1;
    }
    
    // ใช้ไอเทม
    if(use_player_item(playerid, slot)) {
        // เปิด inventory อีกครั้งหลังใช้
        SetTimerEx("gui_reopen_inventory", 500, false, "d", playerid);
    } else {
        SendClientMessage(playerid, 0xFF0000FF, "{FF0000}[ERROR]{FFFFFF} ไม่สามารถใช้ไอเทมนี้ได้");
    }
    
    DeletePVar(playerid, "InventorySlot");
    return 1;
}

forward gui_reopen_inventory(playerid);
public gui_reopen_inventory(playerid) {
    if(IsPlayerConnected(playerid)) {
        gui_show_inventory(playerid);
    }
    return 1;
}
