// --------------------------- Include Guard ----------------------------------
#if defined _ability_items_included
    #endinput
#endif
#define _ability_items_included

// ============================= ITEM ABILITY SYSTEM =============================
// �к���������ö�ͧ����� (Item Abilities)
// �ͧ�Ѻ������ҡ startown.sql
//
// ? ������ͧ #include ��ѧ inventory_systems.pwn
//
// Abilities �ͧ�Ѻ:
//   - ITEM_TYPE_FOOD      : ����ѧ (+10 HP)
//   - ITEM_TYPE_DRINK     : ��Ӵ��� (+15 HP)
//   - ITEM_TYPE_MEDICAL   : �Ҿ͡ (+30 HP)
//   - ITEM_TYPE_ARMOR     : ����͡ѹ����ع (+100 Armour)
//   - ITEM_TYPE_WEAPON    : �׹ Desert Eagle, ����ʺ��
//   - ITEM_TYPE_TOOL      : �ش����ͧ��ͪ�ҧ (����ö)
//
// Functions:
//   - UseItem()               : ��ҹ�������� ability
//   - GetItemAbilityText()    : �֧��ͤ���͸Ժ������Ѻ Dialog
// ===============================================================================

// �����˵�: enum E_ITEM_TYPE ��� DetermineItemType() �١����� inventory_systems.pwn ����

// ------------------------------ Helper Functions ----------------------------
// �֧��ͤ���͸Ժ�� Ability �ͧ����� (����Ѻ�ʴ�� Dialog)
stock GetItemAbilityText(E_ITEM_TYPE:itemType, dest[], maxlen = 128) {
    switch (itemType) {
        case ITEM_TYPE_FOOD: format(dest, maxlen, "{00FF00}[����ö����] ���� Health +10");
        case ITEM_TYPE_DRINK: format(dest, maxlen, "{00FF00}[����ö����] ���� Health +15");
        case ITEM_TYPE_MEDICAL: format(dest, maxlen, "{00FF00}[����ö����] ���� Health +30");
        case ITEM_TYPE_ARMOR: format(dest, maxlen, "{00FF00}[����ö����] ���� Armour 100%");
        case ITEM_TYPE_WEAPON: format(dest, maxlen, "{00FF00}[����ö����] �Ѻ���ظ");
        case ITEM_TYPE_TOOL: format(dest, maxlen, "{00FF00}[����ö����] ����ö");
        default: format(dest, maxlen, "{AAAAAA}[�������ö����] ����������");
    }
    return 1;
}

// ��ҹ�����
stock UseItem(playerid, inventorySlot) {
    if (!IsPlayerConnected(playerid)) return 0;
    if (inventorySlot < 0 || inventorySlot >= PlayerInventoryCount[playerid]) return 0;
    
    new itemIdx = PlayerInventory[playerid][inventorySlot][InvItemID];
    if (itemIdx < 0 || itemIdx >= g_TotalItems) return 0;
    
    new itemName[MAX_ITEM_NAME];
    GetItemNameByIndex(itemIdx, itemName);
    new msg[128];
    
    // ��Ǩ�ͺ����������������ҹ��� ability
    switch (ItemData[itemIdx][ItemType]) {
        case ITEM_TYPE_FOOD: { // ����� - ���� Health +10
            new Float:health;
            GetPlayerHealth(playerid, health);
            if (health >= 100.0) {
                SendClientMessage(playerid, 0xFF0000FF, "�س�����ʹ������� �������ö������������!");
                return 0;
            }
            SetPlayerHealth(playerid, health + 10.0);
            format(msg, sizeof(msg), "{00FF00}�س��Թ����ѧ +10 HP (%.1f HP)", health + 10.0);
            SendClientMessage(playerid, -1, msg);
            RemoveItemFromPlayer(playerid, inventorySlot, 1);
            return 1;
        }
        case ITEM_TYPE_DRINK: { // ����ͧ���� - ���� Health +15
            new Float:health;
            GetPlayerHealth(playerid, health);
            if (health >= 100.0) {
                SendClientMessage(playerid, 0xFF0000FF, "�س�����ʹ������� �������ö������������!");
                return 0;
            }
            SetPlayerHealth(playerid, health + 15.0);
            format(msg, sizeof(msg), "{00FF00}�س�������� +15 HP (%.1f HP)", health + 15.0);
            SendClientMessage(playerid, -1, msg);
            RemoveItemFromPlayer(playerid, inventorySlot, 1);
            return 1;
        }
        case ITEM_TYPE_MEDICAL: { // �� - ���� Health +30
            new Float:health;
            GetPlayerHealth(playerid, health);
            if (health >= 100.0) {
                SendClientMessage(playerid, 0xFF0000FF, "�س�����ʹ������� �������ö������������!");
                return 0;
            }
            SetPlayerHealth(playerid, health + 30.0);
            format(msg, sizeof(msg), "{00FF00}�س�����Ҿ͡ +30 HP (%.1f HP)", health + 30.0);
            SendClientMessage(playerid, -1, msg);
            RemoveItemFromPlayer(playerid, inventorySlot, 1);
            return 1;
        }
        case ITEM_TYPE_ARMOR: { // ���� - ���� Armour 100%
            new Float:armour;
            GetPlayerArmour(playerid, armour);
            if (armour >= 100.0) {
                SendClientMessage(playerid, 0xFF0000FF, "�س������������� �������ö������������!");
                return 0;
            }
            SetPlayerArmour(playerid, 100.0);
            SendClientMessage(playerid, -1, "{00FF00}�س���������͡ѹ����ع +100 Armour");
            RemoveItemFromPlayer(playerid, inventorySlot, 1);
            return 1;
        }
        case ITEM_TYPE_WEAPON: { // ���ظ
            if (strfind(itemName, "Desert Eagle", true) != -1) {
                GivePlayerWeapon(playerid, 24, 50); // Desert Eagle + 50 ����ع
                SendClientMessage(playerid, -1, "{00FF00}�س���Ѻ�׹ Desert Eagle ���������ع 50 �Ѵ");
                RemoveItemFromPlayer(playerid, inventorySlot, 1);
                return 1;
            }
            else if (strfind(itemName, "����ʺ��", true) != -1) {
                GivePlayerWeapon(playerid, 5, 1); // Baseball Bat
                SendClientMessage(playerid, -1, "{00FF00}�س���Ѻ����ʺ��");
                RemoveItemFromPlayer(playerid, inventorySlot, 1);
                return 1;
            }
        }
        case ITEM_TYPE_TOOL: { // ����ͧ��� - ����ö
            if (!IsPlayerInAnyVehicle(playerid)) {
                SendClientMessage(playerid, 0xFF0000FF, "�س��ͧ�����ö����������ͧ��͹��!");
                return 0;
            }
            new vehicleid = GetPlayerVehicleID(playerid);
            RepairVehicle(vehicleid);
            SendClientMessage(playerid, -1, "{00FF00}�س��������ͧ��ͫ���ö ö���Ѻ��ë���������!");
            RemoveItemFromPlayer(playerid, inventorySlot, 1);
            return 1;
        }
        default: { // ���������� - ����� ability
            format(msg, sizeof(msg), "{FFFF00}����� '%s' �������ö��ҹ��", itemName);
            SendClientMessage(playerid, -1, msg);
            return 0;
        }
    }
    
    return 0;
}
