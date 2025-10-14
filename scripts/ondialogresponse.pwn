// --------------------------- Include Guard ----------------------------------
#if defined _dialog_systems_included
    #endinput
#endif
#define _dialog_systems_included

// ------------------------------ Includes ------------------------------------
#include "login_systems.pwn"
#include "commands/admin_commands.pwn"

// --------------------------- Dialog Systems ---------------------------------
// �Ѵ��� Dialog ������㹷������ Ẻ switch statement Ẻ���
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    // �� inventory dialogs ��͹
    if (HandleInventoryDialogs(playerid, dialogid, response, listitem, inputtext)) {
        return 1;
    }

    switch(dialogid) {
        // ==================== LOGIN SYSTEM DIALOGS ====================
        case DIALOG_LOGIN: {
            if(!response) { // ������ "¡��ԡ"
                Kick(playerid);
                return 1;
            }
            // ������ "�������к�"
            if(strlen(inputtext) < 1) {
                SendClientMessage(playerid, -1, "{FF0000}��س�������ʼ�ҹ!");
                return ShowLoginDialog(playerid);
            }
            LoginPlayer(playerid, inputtext);
            return 1;
        }
        
        case DIALOG_REGISTER: {
            if(!response) { // ������ "¡��ԡ"
                Kick(playerid);
                return 1;
            }
            // ������ "��Ѥ���Ҫԡ"
            if(strlen(inputtext) < 1) {
                SendClientMessage(playerid, -1, "{FF0000}��س�������ʼ�ҹ!");
                return ShowRegisterDialog(playerid);
            }
            RegisterPlayer(playerid, inputtext);
            return 1;
        }

        // ==================== ADMIN SYSTEM DIALOGS ====================
        case DIALOG_ADMIN_HELP: {
            if(!response) {
                // ���� "�Դ" �ҡ��ʵ�
                return 1;
            }
            // ���͡��¡�èҡ��ʵ� -> ���Ը���价��᪷
            ShowAdminCommandUsage(playerid, listitem);
            return 1;
        }

        // ==================== OTHER SYSTEM DIALOGS ====================
    }
    
    return 0; // ��辺 dialog ���ç�ѹ
}
