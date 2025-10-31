// --------------------------- Include Guard ----------------------------------
#if defined _on_player_key_change_inc
    #endinput
#endif
#define _on_player_key_change_inc

// ------------------------------ Includes ------------------------------------
// (จะใช้ฟังก์ชันจาก gui_inventory.inc ที่ include ผ่าน core_items.inc แล้ว)

// ------------------------------ Helper Macro --------------------------------
#define PRESSED(%0) \
    (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define RELEASED(%0) \
    (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

#define HOLDING(%0) \
    ((newkeys & (%0)) == (%0))

// ------------------------------ Key State Change ----------------------------
stock on_player_key_state_change(playerid, newkeys, oldkeys) {
    // เช็คว่ากดปุ่ม Y (KEY_YES)
    if(PRESSED(KEY_YES)) {
        // เปิดกระเป๋า
        gui_show_inventory(playerid);
        return 1;
    }
    
    return 1;
}
