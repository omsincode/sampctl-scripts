// --------------------------- Include Guard ----------------------------------
#if defined _items_included
    #endinput
#endif
#define _items_included

// ============================= STATIC ITEM SYSTEM ==============================
// �к������Ẻ Static (��˹� ID ���� enum)
// ����ͧ��Ŵ�ҡ database Ẻ dynamic
// ૿�����Ŵ�����ż�ҹ item_id ����˹����
//
// ����к� Item Abilities:
//   - ITEM_TYPE_FOOD      : ����ѧ (+10 HP)
//   - ITEM_TYPE_DRINK     : ��Ӵ��� (+15 HP)
//   - ITEM_TYPE_MEDICAL   : �Ҿ͡ (+30 HP)
//   - ITEM_TYPE_ARMOR     : ����͡ѹ����ع (+100 Armour)
//   - ITEM_TYPE_WEAPON    : �׹ Desert Eagle, ����ʺ��
//   - ITEM_TYPE_TOOL      : �ش����ͧ��ͪ�ҧ (����ö)
//
// Functions:
//   - InitializeItems()           : ������鹰ҹ�����������
//   - GetItemName()               : �֧���������
//   - GetItemDescription()        : �֧��͸Ժ�������
//   - GetItemWeight()             : �֧���˹ѡ�����
//   - GetItemType()               : �֧�����������
//   - GetItemValue()              : �֧��Ҿ���ɢͧ�����
//   - IsValidItemID()             : ������� ID ���١��ͧ
//   - GetItemAbilityText()        : �֧��ͤ���͸Ժ�� Ability
//   - UseItem()                   : ��ҹ�������� ability
//   - UseItemBySlot()             : ��ҹ������ҡ inventory slot
// ===============================================================================

// ------------------------------ Item Definitions ----------------------------
// ��˹� Item ID Ẻ Static (��ҧ�ԧ�ҡ database startown.sql)
enum {
    ITEM_NONE = 0,
    ITEM_BREAD,                 // 1 - ����ѧ
    ITEM_WATER,                 // 2 - ��Ӵ���
    ITEM_MEDKIT,                // 3 - �Ҿ͡
    ITEM_ARMOR,                 // 4 - ����͡ѹ����ع
    ITEM_DEAGLE,                // 5 - �׹ Desert Eagle
    ITEM_BASEBALL_BAT,          // 6 - ����ʺ��
    ITEM_TOOLBOX,               // 7 - �ش����ͧ��ͪ�ҧ
    ITEM_SPARE_TIRE,            // 8 - �ҧ������
    ITEM_JUMPER_CABLE,          // 9 - ��¡���
    ITEM_PHONE,                 // 10 - ���Ѿ����Ͷ��
    // �������������ç���...
    MAX_ITEM_TYPES
};

// ------------------------------ Item Types ----------------------------------
enum E_ITEM_TYPE {
    ITEM_TYPE_NONE = 0,         // ����������
    ITEM_TYPE_FOOD,             // ����� (+HP)
    ITEM_TYPE_DRINK,            // ����ͧ���� (+HP)
    ITEM_TYPE_MEDICAL,          // �� (+HP)
    ITEM_TYPE_ARMOR,            // ���� (+Armour)
    ITEM_TYPE_WEAPON,           // ���ظ
    ITEM_TYPE_TOOL              // ����ͧ���
};

// ------------------------------ Item Data Structure -------------------------
#define MAX_ITEM_NAME       64
#define MAX_ITEM_DESC       256

enum E_ITEM_DATA {
    ItemID,                             // Item ID (�ç�Ѻ enum ��ҹ��)
    ItemName[MAX_ITEM_NAME],            // ���������
    ItemDescription[MAX_ITEM_DESC],     // ��͸Ժ��
    Float:ItemWeight,                   // ���˹ѡ
    E_ITEM_TYPE:ItemType,               // ������
    ItemValue                           // ��Ҿ���� (�� HP, Ammo)
};

// ------------------------------ Static Item Database ------------------------
new ItemDatabase[MAX_ITEM_TYPES][E_ITEM_DATA];

// ------------------------------ Item Initialization -------------------------
stock InitializeItems() {
    // ITEM_NONE (0)
    ItemDatabase[ITEM_NONE][ItemID] = ITEM_NONE;
    format(ItemDatabase[ITEM_NONE][ItemName], MAX_ITEM_NAME, "����������");
    format(ItemDatabase[ITEM_NONE][ItemDescription], MAX_ITEM_DESC, "��ͧ��ҧ");
    ItemDatabase[ITEM_NONE][ItemWeight] = 0.0;
    ItemDatabase[ITEM_NONE][ItemType] = ITEM_TYPE_NONE;
    ItemDatabase[ITEM_NONE][ItemValue] = 0;

    // ITEM_BREAD (1) - ����ѧ
    ItemDatabase[ITEM_BREAD][ItemID] = ITEM_BREAD;
    format(ItemDatabase[ITEM_BREAD][ItemName], MAX_ITEM_NAME, "����ѧ");
    format(ItemDatabase[ITEM_BREAD][ItemDescription], MAX_ITEM_DESC, "����ѧʴ���� ������ѧ���Ե +10");
    ItemDatabase[ITEM_BREAD][ItemWeight] = 0.5;
    ItemDatabase[ITEM_BREAD][ItemType] = ITEM_TYPE_FOOD;
    ItemDatabase[ITEM_BREAD][ItemValue] = 10; // +10 HP

    // ITEM_WATER (2) - ��Ӵ���
    ItemDatabase[ITEM_WATER][ItemID] = ITEM_WATER;
    format(ItemDatabase[ITEM_WATER][ItemName], MAX_ITEM_NAME, "��Ӵ���");
    format(ItemDatabase[ITEM_WATER][ItemDescription], MAX_ITEM_DESC, "��Ӵ�����èآǴ ������ѧ���Ե +15");
    ItemDatabase[ITEM_WATER][ItemWeight] = 1.0;
    ItemDatabase[ITEM_WATER][ItemType] = ITEM_TYPE_DRINK;
    ItemDatabase[ITEM_WATER][ItemValue] = 15; // +15 HP

    // ITEM_MEDKIT (3) - �Ҿ͡
    ItemDatabase[ITEM_MEDKIT][ItemID] = ITEM_MEDKIT;
    format(ItemDatabase[ITEM_MEDKIT][ItemName], MAX_ITEM_NAME, "�Ҿ͡");
    format(ItemDatabase[ITEM_MEDKIT][ItemDescription], MAX_ITEM_DESC, "�ش�����Һ�� ������ѧ���Ե +30");
    ItemDatabase[ITEM_MEDKIT][ItemWeight] = 2.0;
    ItemDatabase[ITEM_MEDKIT][ItemType] = ITEM_TYPE_MEDICAL;
    ItemDatabase[ITEM_MEDKIT][ItemValue] = 30; // +30 HP

    // ITEM_ARMOR (4) - ����͡ѹ����ع
    ItemDatabase[ITEM_ARMOR][ItemID] = ITEM_ARMOR;
    format(ItemDatabase[ITEM_ARMOR][ItemName], MAX_ITEM_NAME, "����͡ѹ����ع");
    format(ItemDatabase[ITEM_ARMOR][ItemDescription], MAX_ITEM_DESC, "��������л�ͧ�ѹ �������� 100%");
    ItemDatabase[ITEM_ARMOR][ItemWeight] = 5.0;
    ItemDatabase[ITEM_ARMOR][ItemType] = ITEM_TYPE_ARMOR;
    ItemDatabase[ITEM_ARMOR][ItemValue] = 100; // +100 Armour

    // ITEM_DEAGLE (5) - �׹ Desert Eagle
    ItemDatabase[ITEM_DEAGLE][ItemID] = ITEM_DEAGLE;
    format(ItemDatabase[ITEM_DEAGLE][ItemName], MAX_ITEM_NAME, "�׹ Desert Eagle");
    format(ItemDatabase[ITEM_DEAGLE][ItemDescription], MAX_ITEM_DESC, "�׹����Ҵ .50 AE ���������ع 50 �Ѵ");
    ItemDatabase[ITEM_DEAGLE][ItemWeight] = 3.0;
    ItemDatabase[ITEM_DEAGLE][ItemType] = ITEM_TYPE_WEAPON;
    ItemDatabase[ITEM_DEAGLE][ItemValue] = 50; // 50 Ammo

    // ITEM_BASEBALL_BAT (6) - ����ʺ��
    ItemDatabase[ITEM_BASEBALL_BAT][ItemID] = ITEM_BASEBALL_BAT;
    format(ItemDatabase[ITEM_BASEBALL_BAT][ItemName], MAX_ITEM_NAME, "����ʺ��");
    format(ItemDatabase[ITEM_BASEBALL_BAT][ItemDescription], MAX_ITEM_DESC, "����ʺ������ѡ ���ç���ҹ");
    ItemDatabase[ITEM_BASEBALL_BAT][ItemWeight] = 2.0;
    ItemDatabase[ITEM_BASEBALL_BAT][ItemType] = ITEM_TYPE_WEAPON;
    ItemDatabase[ITEM_BASEBALL_BAT][ItemValue] = 1;

    // ITEM_TOOLBOX (7) - �ش����ͧ��ͪ�ҧ
    ItemDatabase[ITEM_TOOLBOX][ItemID] = ITEM_TOOLBOX;
    format(ItemDatabase[ITEM_TOOLBOX][ItemName], MAX_ITEM_NAME, "�ش����ͧ��ͪ�ҧ");
    format(ItemDatabase[ITEM_TOOLBOX][ItemDescription], MAX_ITEM_DESC, "����ͧ��ͫ���ö¹�� ����ö��");
    ItemDatabase[ITEM_TOOLBOX][ItemWeight] = 4.0;
    ItemDatabase[ITEM_TOOLBOX][ItemType] = ITEM_TYPE_TOOL;
    ItemDatabase[ITEM_TOOLBOX][ItemValue] = 1;

    // ITEM_SPARE_TIRE (8) - �ҧ������
    ItemDatabase[ITEM_SPARE_TIRE][ItemID] = ITEM_SPARE_TIRE;
    format(ItemDatabase[ITEM_SPARE_TIRE][ItemName], MAX_ITEM_NAME, "�ҧ������");
    format(ItemDatabase[ITEM_SPARE_TIRE][ItemDescription], MAX_ITEM_DESC, "�ҧö¹�������� ����Ѻ����¹�ҧẹ");
    ItemDatabase[ITEM_SPARE_TIRE][ItemWeight] = 6.0;
    ItemDatabase[ITEM_SPARE_TIRE][ItemType] = ITEM_TYPE_TOOL;
    ItemDatabase[ITEM_SPARE_TIRE][ItemValue] = 1;

    // ITEM_JUMPER_CABLE (9) - ��¡���
    ItemDatabase[ITEM_JUMPER_CABLE][ItemID] = ITEM_JUMPER_CABLE;
    format(ItemDatabase[ITEM_JUMPER_CABLE][ItemName], MAX_ITEM_NAME, "��¡���");
    format(ItemDatabase[ITEM_JUMPER_CABLE][ItemDescription], MAX_ITEM_DESC, "��¡���ö¹�� ��ʵ�������ͧ¹��");
    ItemDatabase[ITEM_JUMPER_CABLE][ItemWeight] = 3.0;
    ItemDatabase[ITEM_JUMPER_CABLE][ItemType] = ITEM_TYPE_TOOL;
    ItemDatabase[ITEM_JUMPER_CABLE][ItemValue] = 1;

    // ITEM_PHONE (10) - ���Ѿ����Ͷ��
    ItemDatabase[ITEM_PHONE][ItemID] = ITEM_PHONE;
    format(ItemDatabase[ITEM_PHONE][ItemName], MAX_ITEM_NAME, "���Ѿ����Ͷ��");
    format(ItemDatabase[ITEM_PHONE][ItemDescription], MAX_ITEM_DESC, "���Ѿ�������⿹�������");
    ItemDatabase[ITEM_PHONE][ItemWeight] = 0.3;
    ItemDatabase[ITEM_PHONE][ItemType] = ITEM_TYPE_NONE;
    ItemDatabase[ITEM_PHONE][ItemValue] = 0;

    printf("[Item System] Initialized %d static items", MAX_ITEM_TYPES);
}

// ------------------------------ Helper Functions ----------------------------
// �֧����������ҡ ID
stock GetItemName(itemid, dest[], maxlen = sizeof(dest)) {
    if (itemid < 0 || itemid >= MAX_ITEM_TYPES) {
        format(dest, maxlen, "Unknown");
        return 0;
    }
    format(dest, maxlen, "%s", ItemDatabase[itemid][ItemName]);
    return 1;
}

// �֧��͸Ժ��������ҡ ID
stock GetItemDescription(itemid, dest[], maxlen = sizeof(dest)) {
    if (itemid < 0 || itemid >= MAX_ITEM_TYPES) {
        format(dest, maxlen, "Unknown item");
        return 0;
    }
    format(dest, maxlen, "%s", ItemDatabase[itemid][ItemDescription]);
    return 1;
}

// �֧���˹ѡ������ҡ ID
stock Float:GetItemWeight(itemid) {
    if (itemid < 0 || itemid >= MAX_ITEM_TYPES) return 0.0;
    return ItemDatabase[itemid][ItemWeight];
}

// �֧������������ҡ ID
stock E_ITEM_TYPE:GetItemType(itemid) {
    if (itemid < 0 || itemid >= MAX_ITEM_TYPES) return ITEM_TYPE_NONE;
    return ItemDatabase[itemid][ItemType];
}

// �֧��Ҿ���ɢͧ����� (HP, Ammo, etc.)
stock GetItemValue(itemid) {
    if (itemid < 0 || itemid >= MAX_ITEM_TYPES) return 0;
    return ItemDatabase[itemid][ItemValue];
}

// �����������������ԧ�������
stock IsValidItemID(itemid) {
    return (itemid > 0 && itemid < MAX_ITEM_TYPES);
}

// �֧��ͤ���͸Ժ�� Ability
stock GetItemAbilityText(itemid, dest[], maxlen = 128) {
    if (itemid < 0 || itemid >= MAX_ITEM_TYPES) {
        format(dest, maxlen, "{AAAAAA}[����������]");
        return 0;
    }

    new E_ITEM_TYPE:type = ItemDatabase[itemid][ItemType];
    new value = ItemDatabase[itemid][ItemValue];

    switch (type) {
        case ITEM_TYPE_FOOD: format(dest, maxlen, "{00FF00}[����] ���� HP +%d", value);
        case ITEM_TYPE_DRINK: format(dest, maxlen, "{00FF00}[����] ���� HP +%d", value);
        case ITEM_TYPE_MEDICAL: format(dest, maxlen, "{00FF00}[����] ���� HP +%d", value);
        case ITEM_TYPE_ARMOR: format(dest, maxlen, "{00FF00}[����] ���� Armour +%d", value);
        case ITEM_TYPE_WEAPON: format(dest, maxlen, "{00FF00}[����] �Ѻ���ظ");
        case ITEM_TYPE_TOOL: format(dest, maxlen, "{00FF00}[����] ����ö¹��");
        default: format(dest, maxlen, "{AAAAAA}[�������ö����]");
    }
    return 1;
}

// ------------------------------ Item Usage ----------------------------------
// ��ҹ������µç�ҡ item_id (���ź������͡�ҡ inventory)
// ���¡��ҡ inventory_systems.pwn �����к�����
// Return: 1 = �����, 0 = ��������
stock UseItem(playerid, itemid, slot = -1) {
    if (!IsPlayerConnected(playerid)) return 0;
    if (!IsValidItemID(itemid)) return 0;

    new E_ITEM_TYPE:type = ItemDatabase[itemid][ItemType];
    new value = ItemDatabase[itemid][ItemValue];
    new itemName[MAX_ITEM_NAME];
    GetItemName(itemid, itemName);
    new msg[128];

    switch (type) {
        case ITEM_TYPE_FOOD, ITEM_TYPE_DRINK, ITEM_TYPE_MEDICAL: {
            new Float:health;
            GetPlayerHealth(playerid, health);
            if (health >= 100.0) {
                SendClientMessage(playerid, 0xFF0000FF, "�س�����ʹ������� �������ö������������!");
                return 0;
            }
            SetPlayerHealth(playerid, health + float(value));
            format(msg, sizeof(msg), "{00FF00}�س���� %s +%d HP (%.1f HP)", itemName, value, health + float(value));
            SendClientMessage(playerid, -1, msg);
            return 1; // ����� - ��ź������ inventory_systems
        }
        case ITEM_TYPE_ARMOR: {
            new Float:armour;
            GetPlayerArmour(playerid, armour);
            if (armour >= 100.0) {
                SendClientMessage(playerid, 0xFF0000FF, "�س������������� �������ö������������!");
                return 0;
            }
            SetPlayerArmour(playerid, float(value));
            format(msg, sizeof(msg), "{00FF00}�س�����%s +%d Armour", itemName, value);
            SendClientMessage(playerid, -1, msg);
            return 1;
        }
        case ITEM_TYPE_WEAPON: {
            if (itemid == ITEM_DEAGLE) {
                GivePlayerWeapon(playerid, 24, value); // Desert Eagle + ammo
                format(msg, sizeof(msg), "{00FF00}�س���Ѻ%s ���������ع %d �Ѵ", itemName, value);
            }
            else if (itemid == ITEM_BASEBALL_BAT) {
                GivePlayerWeapon(playerid, 5, 1); // Baseball Bat
                format(msg, sizeof(msg), "{00FF00}�س���Ѻ%s", itemName);
            }
            SendClientMessage(playerid, -1, msg);
            return 1;
        }
        case ITEM_TYPE_TOOL: {
            if (!IsPlayerInAnyVehicle(playerid)) {
                SendClientMessage(playerid, 0xFF0000FF, "�س��ͧ�����ö����������ͧ��͹��!");
                return 0;
            }
            new vehicleid = GetPlayerVehicleID(playerid);
            RepairVehicle(vehicleid);
            format(msg, sizeof(msg), "{00FF00}�س����%s ����ö���º��������!", itemName);
            SendClientMessage(playerid, -1, msg);
            return 1;
        }
        default: {
            format(msg, sizeof(msg), "{FFFF00}����� '%s' �������ö��ҹ��", itemName);
            SendClientMessage(playerid, -1, msg);
            return 0;
        }
    }
    return 0;
}

// ------------------------------ Inventory Slot Usage ------------------------
// ��ҹ������ҡ inventory slot (�ͧ�Ѻ dynamic item system)
// �ѧ��ѹ�������¡ RemoveItemFromPlayer() ��ѧ��ҹ�����
// ��ͧ #include �������ѧ inventory_systems.pwn
// Return: 1 = �����, 0 = ��������
stock UseItemBySlot(playerid, inventorySlot) {
    if (!IsPlayerConnected(playerid)) return 0;
    
    // ��Ǩ�ͺ����տѧ��ѹ inventory_systems �����������
    #if !defined PlayerInventoryCount
        printf("[Item System ERROR] inventory_systems.pwn not included!");
        return 0;
    #endif
    
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
