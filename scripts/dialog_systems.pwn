// --------------------------- Include Guard ----------------------------------
#if defined _dialog_systems_included
    #endinput
#endif
#define _dialog_systems_included

// ------------------------------ Includes ------------------------------------
#include "scripts/login_systems.pwn"
#include "scripts/commands/admin_commands.pwn"

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
        

        // ==================== OTHER SYSTEM DIALOGS ====================
    }
    
    return 0; // ไม่พบ dialog ที่ตรงกัน
}
