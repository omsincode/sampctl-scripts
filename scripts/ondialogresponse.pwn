// --------------------------- Include Guard ----------------------------------
#if defined _dialog_systems_included
    #endinput
#endif
#define _dialog_systems_included

// ------------------------------ Includes ------------------------------------
#include "login_systems.pwn"
#include "commands/admin_commands.pwn"

// --------------------------- Dialog Systems ---------------------------------
// จัดการ Dialog ทั้งหมดในที่เดียว แบบ switch statement แบบเดิม
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    switch(dialogid) {
        // ==================== LOGIN SYSTEM DIALOGS ====================
        case DIALOG_LOGIN: {
            if(!response) { // กดปุ่ม "ยกเลิก"
                Kick(playerid);
                return 1;
            }
            // กดปุ่ม "เข้าสู่ระบบ"
            if(strlen(inputtext) < 1) {
                SendClientMessage(playerid, -1, "{FF0000}กรุณาใส่รหัสผ่าน!");
                return ShowLoginDialog(playerid);
            }
            LoginPlayer(playerid, inputtext);
            return 1;
        }
        
        case DIALOG_REGISTER: {
            if(!response) { // กดปุ่ม "ยกเลิก"
                Kick(playerid);
                return 1;
            }
            // กดปุ่ม "สมัครสมาชิก"
            if(strlen(inputtext) < 1) {
                SendClientMessage(playerid, -1, "{FF0000}กรุณาใส่รหัสผ่าน!");
                return ShowRegisterDialog(playerid);
            }
            RegisterPlayer(playerid, inputtext);
            return 1;
        }

        // ==================== ADMIN SYSTEM DIALOGS ====================
        case DIALOG_ADMIN_HELP: {
            if(!response) {
                // ปุ่ม "ปิด" จากลิสต์
                return 1;
            }
            // เลือกรายการจากลิสต์ -> ส่งวิธีใช้ไปที่แชท
            ShowAdminCommandUsage(playerid, listitem);
            return 1;
        }
        
        // ==================== INVENTORY SYSTEM DIALOGS ====================
        case DIALOG_INVENTORY: {
            if(!response) {
                // กดปุ่ม "ปิด"
                return 1;
            }
            // กดปุ่ม "ดูรายละเอียด" - แสดงข้อมูลไอเท็มที่เลือก
            if(listitem < 0 || listitem >= PlayerInventoryCount[playerid]) {
                return 1;
            }
            
            new itemIdx = PlayerInventory[playerid][listitem][InvItemID];
            new qty = PlayerInventory[playerid][listitem][InvQuantity];
            new itemName[MAX_ITEM_NAME], itemDesc[MAX_ITEM_DESC];
            new Float:weight = GetItemWeightByIndex(itemIdx);
            
            GetItemNameByIndex(itemIdx, itemName);
            format(itemDesc, sizeof(itemDesc), "%s", ItemData[itemIdx][ItemDescription]);
            
            new info[512];
            format(info, sizeof(info),
                "{FFFFFF}ชื่อไอเท็ม: {FFFF00}%s\n\n\
                {FFFFFF}คำอธิบาย:\n{CCCCCC}%s\n\n\
                {FFFFFF}จำนวน: {00FF00}x%d\n\
                {FFFFFF}น้ำหนัก (ต่อชิ้น): {FFFF00}%.2f kg\n\
                {FFFFFF}น้ำหนักรวม: {FF6347}%.2f kg\n\n\
                {FFFFFF}Item ID (Database): {AAAAAA}%d\n\
                {FFFFFF}Item Index (Array): {AAAAAA}%d",
                itemName, itemDesc, qty, weight, weight * float(qty),
                ItemData[itemIdx][ItemDBID], itemIdx
            );
            
            ShowPlayerDialog(playerid, DIALOG_ITEM_INFO, DIALOG_STYLE_MSGBOX,
                "{33CCFF}รายละเอียดไอเท็ม", info, "กลับ", "ปิด");
            return 1;
        }
        
        case DIALOG_ITEM_INFO: {
            if(response) {
                // กดปุ่ม "กลับ" - เปิด inventory อีกครั้ง
                ShowPlayerInventory(playerid);
            }
            // กดปุ่ม "ปิด" - ไม่ทำอะไร
            return 1;
        }

        // ==================== OTHER SYSTEM DIALOGS ====================
    }
    
    return 0; // ไม่พบ dialog ที่ตรงกัน
}
