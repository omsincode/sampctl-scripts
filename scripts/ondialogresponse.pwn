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
        
        // ==================== INVENTORY SYSTEM DIALOGS ====================
        case DIALOG_INVENTORY: {
            if(!response) {
                // ������ "�Դ"
                return 1;
            }
            // ������ "����������´" - �ʴ������������������͡
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
                "{FFFFFF}���������: {FFFF00}%s\n\n\
                {FFFFFF}��͸Ժ��:\n{CCCCCC}%s\n\n\
                {FFFFFF}�ӹǹ: {00FF00}x%d\n\
                {FFFFFF}���˹ѡ (��ͪ��): {FFFF00}%.2f kg\n\
                {FFFFFF}���˹ѡ���: {FF6347}%.2f kg\n\n\
                {FFFFFF}Item ID (Database): {AAAAAA}%d\n\
                {FFFFFF}Item Index (Array): {AAAAAA}%d",
                itemName, itemDesc, qty, weight, weight * float(qty),
                ItemData[itemIdx][ItemDBID], itemIdx
            );
            
            ShowPlayerDialog(playerid, DIALOG_ITEM_INFO, DIALOG_STYLE_MSGBOX,
                "{33CCFF}��������´�����", info, "��Ѻ", "�Դ");
            return 1;
        }
        
        case DIALOG_ITEM_INFO: {
            if(response) {
                // ������ "��Ѻ" - �Դ inventory �ա����
                ShowPlayerInventory(playerid);
            }
            // ������ "�Դ" - ��������
            return 1;
        }

        // ==================== OTHER SYSTEM DIALOGS ====================
    }
    
    return 0; // ��辺 dialog ���ç�ѹ
}
