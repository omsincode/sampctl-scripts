// --------------------------- Include Guard ----------------------------------// --------------------------- Include Guard ----------------------------------

#if defined _inventory_systems_included#if defined _inventory_systems_included

    #endinput    #endinput

#endif#endif

#define _inventory_systems_included#define _inventory_systems_included



// ------------------------------ Dialogs -------------------------------------// ------------------------------ Dialogs -------------------------------------

#define DIALOG_INVENTORY        200#define DIALOG_INVENTORY        200

#define DIALOG_ITEM_INFO        201#define DIALOG_ITEM_INFO        201



// ------------------------------ Player Inventory ----------------------------// ------------------------------ Item Types ----------------------------------

#define MAX_PLAYER_ITEMS    100     // �ӹǹ������٧�ش��ͼ�����// �������ͧ Item Ability (�����Ҩҡ ability_items.pwn)

enum E_ITEM_TYPE {

// �ç���ҧ�����㹵�Ǽ����� (�� item_id ᷹ index)    ITEM_TYPE_NONE = 0,         // ���������� ����� ability

enum E_PLAYER_INVENTORY {    ITEM_TYPE_FOOD,             // ����� (���� Health)

    InvItemID,              // Item ID (��ҧ�ԧ�ҡ items.pwn enum)    ITEM_TYPE_DRINK,            // ����ͧ���� (���� Health)

    InvQuantity,            // �ӹǹ    ITEM_TYPE_MEDICAL,          // �� (���� Health)

    InvInventoryID          // inventory_id �ҡ database (����Ѻ save/load)    ITEM_TYPE_ARMOR,            // ����͡ѹ����ع (���� Armour)

};    ITEM_TYPE_WEAPON,           // ���ظ (���׹)

new PlayerInventory[MAX_PLAYERS][MAX_PLAYER_ITEMS][E_PLAYER_INVENTORY];    ITEM_TYPE_TOOL              // ����ͧ��� (��ҹ�����)

new PlayerInventoryCount[MAX_PLAYERS];  // �ӹǹ����������};



// �� Slot �����������͡����ش (����Ѻ Dialog)// ------------------------------ Item System ---------------------------------

new g_PlayerSelectedSlot[MAX_PLAYERS] = {-1, ...};#define MAX_ITEMS           500     // �ӹǹ������٧�ش�����Ŵ�ҡ DB

#define MAX_ITEM_NAME       64      // ������Ǫ��������

// ------------------------------ Inventory Functions -------------------------#define MAX_ITEM_DESC       256     // ������Ǥ�͸Ժ�������

// ����������������� (�кش��� item_id)#define MAX_PLAYER_ITEMS    100     // �ӹǹ������٧�ش��ͼ�����

stock AddItemToPlayer(playerid, itemid, quantity = 1) {

    if (!IsPlayerConnected(playerid)) return 0;// �ç���ҧ������������ҡ DB

    if (!IsValidItemID(itemid)) {enum E_ITEM_DATA {

        printf("[Inventory] ERROR: Invalid item ID %d", itemid);    ItemDBID,               // item_id �ҡ database

        return 0;    ItemName[MAX_ITEM_NAME],

    }    ItemDescription[MAX_ITEM_DESC],

    if (quantity <= 0) return 0;    Float:ItemWeight,

    E_ITEM_TYPE:ItemType    // �������ͧ����� (��ҡ ability_items.pwn)

    // ������������������������������ (stack)};

    for (new i = 0; i < PlayerInventoryCount[playerid]; i++) {new ItemData[MAX_ITEMS][E_ITEM_DATA];

        if (PlayerInventory[playerid][i][InvItemID] == itemid) {new g_TotalItems = 0;       // �ӹǹ����������Ŵ�ҡ DB

            PlayerInventory[playerid][i][InvQuantity] += quantity;

            // �� Item Index �����������͡����ش (����Ѻ��� Dialog)

            new itemName[MAX_ITEM_NAME];new g_PlayerSelectedItem[MAX_PLAYERS] = {-1, ...};

            GetItemName(itemid, itemName);

            new msg[128];// �ç���ҧ�����㹵�Ǽ�����

            format(msg, sizeof(msg), "{00FF00}�س���Ѻ: %s x%d", itemName, quantity);enum E_PLAYER_INVENTORY {

            SendClientMessage(playerid, -1, msg);    InvItemID,              // ��ҧ�ԧ ItemData index

            return 1;    InvQuantity,

        }    InvInventoryID          // inventory_id �ҡ DB

    }};

new PlayerInventory[MAX_PLAYERS][MAX_PLAYER_ITEMS][E_PLAYER_INVENTORY];

    // �������� ������� slot ����new PlayerInventoryCount[MAX_PLAYERS];  // �ӹǹ����������

    if (PlayerInventoryCount[playerid] >= MAX_PLAYER_ITEMS) {

        SendClientMessage(playerid, 0xFF0000FF, "�����Ңͧ�س�������!");// ------------------------------ Item Type Functions -------------------------

        return 0;// ��˹������������������� (�����Ҩҡ ability_items.pwn)

    }stock E_ITEM_TYPE:DetermineItemType(const itemName[]) {

    // �����

    new slot = PlayerInventoryCount[playerid];    if (strfind(itemName, "����ѧ", true) != -1) return ITEM_TYPE_FOOD;

    PlayerInventory[playerid][slot][InvItemID] = itemid;    

    PlayerInventory[playerid][slot][InvQuantity] = quantity;    // ����ͧ����

    PlayerInventory[playerid][slot][InvInventoryID] = 0; // ����ҡ DB �͹ load    if (strfind(itemName, "��Ӵ���", true) != -1) return ITEM_TYPE_DRINK;

    PlayerInventoryCount[playerid]++;    

    // ��/���ᾷ��

    new itemName[MAX_ITEM_NAME];    if (strfind(itemName, "�Ҿ͡", true) != -1) return ITEM_TYPE_MEDICAL;

    GetItemName(itemid, itemName);    

    new msg[128];    // ����/����͡ѹ����ع

    format(msg, sizeof(msg), "{00FF00}�س���Ѻ: %s x%d", itemName, quantity);    if (strfind(itemName, "����͡ѹ����ع", true) != -1) return ITEM_TYPE_ARMOR;

    SendClientMessage(playerid, -1, msg);    

    return 1;    // ���ظ

}    if (strfind(itemName, "�׹", true) != -1) return ITEM_TYPE_WEAPON;

    if (strfind(itemName, "����ʺ��", true) != -1) return ITEM_TYPE_WEAPON;

// ź������͡�ҡ������    

stock RemoveItemFromPlayer(playerid, slot, quantity = 1) {    // ����ͧ���

    if (!IsPlayerConnected(playerid)) return 0;    if (strfind(itemName, "�ش����ͧ��ͪ�ҧ", true) != -1) return ITEM_TYPE_TOOL;

    if (slot < 0 || slot >= PlayerInventoryCount[playerid]) return 0;    if (strfind(itemName, "�ҧ������", true) != -1) return ITEM_TYPE_TOOL;

    if (quantity <= 0) return 0;    if (strfind(itemName, "��¡���", true) != -1) return ITEM_TYPE_TOOL;

    

    PlayerInventory[playerid][slot][InvQuantity] -= quantity;    // ���������� (����� ability)

    return ITEM_TYPE_NONE;

    // ��Ҩӹǹ����� 0 ���ź slot}

    if (PlayerInventory[playerid][slot][InvQuantity] <= 0) {

        // Shift array (����͹���������������᷹)// ------------------------------ Load Items ----------------------------------

        for (new i = slot; i < PlayerInventoryCount[playerid] - 1; i++) {// ��Ŵ��¡��������������ҡ database ��� array

            PlayerInventory[playerid][i][InvItemID] = PlayerInventory[playerid][i + 1][InvItemID];stock LoadAllItemsFromDB() {

            PlayerInventory[playerid][i][InvQuantity] = PlayerInventory[playerid][i + 1][InvQuantity];    if (dbHandle == MYSQL_INVALID_HANDLE) {

            PlayerInventory[playerid][i][InvInventoryID] = PlayerInventory[playerid][i + 1][InvInventoryID];        print("[Item System] ERROR: Database not connected!");

        }        return 0;

        PlayerInventoryCount[playerid]--;    }

    }

    return 1;    new Cache:cache = mysql_query(dbHandle, "SELECT item_id, item_name, item_description, item_weight FROM items ORDER BY item_id ASC");

}    new rows = cache_num_rows();

    

// Clear inventory (��͹ disconnect)    if (rows == 0) {

stock ClearPlayerInventory(playerid) {        cache_delete(cache);

    for (new i = 0; i < MAX_PLAYER_ITEMS; i++) {        print("[Item System] No items found in database");

        PlayerInventory[playerid][i][InvItemID] = 0;        return 0;

        PlayerInventory[playerid][i][InvQuantity] = 0;    }

        PlayerInventory[playerid][i][InvInventoryID] = 0;

    }    g_TotalItems = 0;

    PlayerInventoryCount[playerid] = 0;    for (new i = 0; i < rows && i < MAX_ITEMS; i++) {

    g_PlayerSelectedSlot[playerid] = -1;        cache_get_value_int(i, "item_id", ItemData[i][ItemDBID]);

}        cache_get_value(i, "item_name", ItemData[i][ItemName], MAX_ITEM_NAME);

        cache_get_value(i, "item_description", ItemData[i][ItemDescription], MAX_ITEM_DESC);

// ------------------------------ Database Functions --------------------------        cache_get_value_float(i, "item_weight", ItemData[i][ItemWeight]);

// ��Ŵ Inventory �ҡ Database        

stock LoadPlayerInventory(playerid) {        // ��˹������������������� (��ҧ�ԧ�ҡ database)

    if (!IsPlayerConnected(playerid)) return 0;        ItemData[i][ItemType] = DetermineItemType(ItemData[i][ItemName]);

    if (dbHandle == MYSQL_INVALID_HANDLE) return 0;        

    if (!IsPlayerDataReady(playerid)) return 0;        g_TotalItems++;

    }

    new query[256];    

    mysql_format(dbHandle, query, sizeof(query),    cache_delete(cache);

        "SELECT inventory_id, item_id, quantity FROM inventory WHERE player_id = %d",    printf("[Item System] Loaded %d items from database", g_TotalItems);

        PlayerIntData[playerid][PlayerID]    return g_TotalItems;

    );}

    

    new Cache:cache = mysql_query(dbHandle, query);// ------------------------------ Helper Functions ----------------------------

    new rows = cache_num_rows();// �� index �ͧ������ҡ item_id (DB)

stock GetItemIndexByDBID(dbid) {

    ClearPlayerInventory(playerid);    for (new i = 0; i < g_TotalItems; i++) {

        if (ItemData[i][ItemDBID] == dbid) {

    if (rows > 0) {            return i;

        for (new i = 0; i < rows && i < MAX_PLAYER_ITEMS; i++) {        }

            new itemid, quantity, inventoryid;    }

            cache_get_value_int(i, "inventory_id", inventoryid);    return -1;

            cache_get_value_int(i, "item_id", itemid);}

            cache_get_value_int(i, "quantity", quantity);

// �Ҫ���������ҡ index

            if (IsValidItemID(itemid) && quantity > 0) {stock GetItemNameByIndex(index, dest[], len = sizeof(dest)) {

                PlayerInventory[playerid][i][InvItemID] = itemid;    if (index < 0 || index >= g_TotalItems) {

                PlayerInventory[playerid][i][InvQuantity] = quantity;        dest[0] = EOS;

                PlayerInventory[playerid][i][InvInventoryID] = inventoryid;        return 0;

                PlayerInventoryCount[playerid]++;    }

            }    format(dest, len, "%s", ItemData[index][ItemName]);

        }    return 1;

        printf("[Inventory] Loaded %d items for player ID %d", rows, playerid);}

    }

// �ҹ��˹ѡ������ҡ index

    cache_delete(cache);stock Float:GetItemWeightByIndex(index) {

    return 1;    if (index < 0 || index >= g_TotalItems) return 0.0;

}    return ItemData[index][ItemWeight];

}

// �ѹ�֡ Inventory ��ѧ Database

stock SavePlayerInventory(playerid) {// ------------------------------ Player Inventory ----------------------------

    if (!IsPlayerConnected(playerid)) return 0;// ��Ŵ inventory �ͧ�����蹨ҡ database

    if (dbHandle == MYSQL_INVALID_HANDLE) return 0;stock LoadPlayerInventory(playerid) {

    if (!IsPlayerDataReady(playerid)) return 0;    if (!IsPlayerConnected(playerid)) return 0;

    if (dbHandle == MYSQL_INVALID_HANDLE) return 0;

    new query[512];    

    new playerDBID = PlayerIntData[playerid][PlayerID];    // ���� inventory ��͹

    ResetPlayerInventory(playerid);

    // ź���������͡��͹ (���� sync)    

    mysql_format(dbHandle, query, sizeof(query),    new query[256];

        "DELETE FROM inventory WHERE player_id = %d", playerDBID    format(query, sizeof(query), 

    );        "SELECT ii.inventory_id, ii.item_id, ii.quantity \

    mysql_query(dbHandle, query);        FROM inventory_items ii \

        INNER JOIN inventory i ON ii.inventory_id = i.inventory_id \

    // Insert ���������        WHERE i.inventory_owner = %d", 

    for (new i = 0; i < PlayerInventoryCount[playerid]; i++) {        PlayerIntData[playerid][PlayerID]

        new itemid = PlayerInventory[playerid][i][InvItemID];    );

        new quantity = PlayerInventory[playerid][i][InvQuantity];    

    new Cache:cache = mysql_query(dbHandle, query);

        if (IsValidItemID(itemid) && quantity > 0) {    new rows = cache_num_rows();

            mysql_format(dbHandle, query, sizeof(query),    

                "INSERT INTO inventory (player_id, item_id, quantity) VALUES (%d, %d, %d)",    if (rows == 0) {

                playerDBID, itemid, quantity        cache_delete(cache);

            );        printf("[Inventory] Player %d has no items", playerid);

            mysql_query(dbHandle, query);        return 0;

        }    }

    }    

    new loaded = 0;

    printf("[Inventory] Saved %d items for player ID %d", PlayerInventoryCount[playerid], playerid);    for (new i = 0; i < rows && i < MAX_PLAYER_ITEMS; i++) {

    return 1;        new dbItemID, quantity, inventoryID;

}        cache_get_value_int(i, "inventory_id", inventoryID);

        cache_get_value_int(i, "item_id", dbItemID);

// ------------------------------ Dialog Functions ----------------------------        cache_get_value_int(i, "quantity", quantity);

// �ʴ� Inventory Dialog        

stock ShowPlayerInventory(playerid) {        // �� index �ͧ������ ItemData array

    if (!IsPlayerConnected(playerid)) return 0;        new itemIndex = GetItemIndexByDBID(dbItemID);

        if (itemIndex == -1) {

    if (PlayerInventoryCount[playerid] == 0) {            printf("[Inventory] Warning: Item ID %d not found in ItemData", dbItemID);

        SendClientMessage(playerid, 0xFF0000FF, "�����Ңͧ�س��ҧ����!");            continue;

        return 0;        }

    }        

        // ������� inventory �ͧ������

    new dialog[2048], line[128];        PlayerInventory[playerid][loaded][InvItemID] = itemIndex;

    format(dialog, sizeof(dialog), "�ӴѺ\t���������\t�ӹǹ\t���˹ѡ\tʶҹ�\n");        PlayerInventory[playerid][loaded][InvQuantity] = quantity;

        PlayerInventory[playerid][loaded][InvInventoryID] = inventoryID;

    for (new i = 0; i < PlayerInventoryCount[playerid]; i++) {        loaded++;

        new itemid = PlayerInventory[playerid][i][InvItemID];    }

        new quantity = PlayerInventory[playerid][i][InvQuantity];    

    PlayerInventoryCount[playerid] = loaded;

        new itemName[MAX_ITEM_NAME];    cache_delete(cache);

        GetItemName(itemid, itemName);    printf("[Inventory] Loaded %d items for player %d", loaded, playerid);

    return loaded;

        new Float:weight = GetItemWeight(itemid) * float(quantity);}

        

        new ability[64];// ���� inventory �ͧ������

        GetItemAbilityText(itemid, ability, sizeof(ability));stock ResetPlayerInventory(playerid) {

    PlayerInventoryCount[playerid] = 0;

        format(line, sizeof(line), "%d\t%s\tx%d\t%.1f kg\t%s\n",    g_PlayerSelectedItem[playerid] = -1; // ���������������͡

            i + 1, itemName, quantity, weight, ability    for (new i = 0; i < MAX_PLAYER_ITEMS; i++) {

        );        PlayerInventory[playerid][i][InvItemID] = -1;

        strcat(dialog, line);        PlayerInventory[playerid][i][InvQuantity] = 0;

    }        PlayerInventory[playerid][i][InvInventoryID] = 0;

    }

    ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_TABLIST_HEADERS,}

        "{FFD700}�����Ңͧ�س", dialog, "���͡", "�Դ");

    return 1;// �ѹ�֡ inventory �ͧ������ŧ database

}stock SavePlayerInventory(playerid) {

    if (!IsPlayerConnected(playerid)) return 0;

// �ʴ���������´����� + ������    if (!IsPlayerLoggedIn(playerid)) return 0;

stock ShowItemInfo(playerid, slot) {    if (dbHandle == MYSQL_INVALID_HANDLE) return 0;

    if (!IsPlayerConnected(playerid)) return 0;    if (PlayerIntData[playerid][PlayerID] == 0) return 0;

    if (slot < 0 || slot >= PlayerInventoryCount[playerid]) return 0;    

    // 1. �� inventory_id �ͧ������ �������ҧ�����������

    new itemid = PlayerInventory[playerid][slot][InvItemID];    new query[512];

    new quantity = PlayerInventory[playerid][slot][InvQuantity];    mysql_format(dbHandle, query, sizeof(query),

        "INSERT INTO inventory (inventory_owner) VALUES (%d) \

    new itemName[MAX_ITEM_NAME];        ON DUPLICATE KEY UPDATE inventory_owner = inventory_owner",

    GetItemName(itemid, itemName);        PlayerIntData[playerid][PlayerID]);

    mysql_tquery(dbHandle, query);

    new itemDesc[MAX_ITEM_DESC];    

    GetItemDescription(itemid, itemDesc);    // 2. ź�������ҷ������ͧ������

    mysql_format(dbHandle, query, sizeof(query),

    new Float:weight = GetItemWeight(itemid);        "DELETE ii FROM inventory_items ii \

    new E_ITEM_TYPE:type = GetItemType(itemid);        INNER JOIN inventory i ON ii.inventory_id = i.inventory_id \

        WHERE i.inventory_owner = %d",

    new dialog[512];        PlayerIntData[playerid][PlayerID]);

    format(dialog, sizeof(dialog),    mysql_tquery(dbHandle, query);

        "{FFFFFF}���������: {FFD700}%s\n\    

        {FFFFFF}�ӹǹ: {00FF00}x%d\n\    // 3. �ѹ�֡��������������

        {FFFFFF}���˹ѡ: {FFFF00}%.1f kg (��ͪ��)\n\    if (PlayerInventoryCount[playerid] > 0) {

        {FFFFFF}������: %s\n\n\        new values[2048], temp[128];

        {AAAAAA}%s",        format(values, sizeof(values), "");

        itemName, quantity, weight, GetItemTypeName(type), itemDesc        

    );        for (new i = 0; i < PlayerInventoryCount[playerid]; i++) {

            new itemIdx = PlayerInventory[playerid][i][InvItemID];

    new title[128];            new qty = PlayerInventory[playerid][i][InvQuantity];

    format(title, sizeof(title), "{FFD700}��������´: %s", itemName);            

            if (itemIdx < 0 || itemIdx >= g_TotalItems) continue;

    g_PlayerSelectedSlot[playerid] = slot;            if (qty <= 0) continue;

    ShowPlayerDialog(playerid, DIALOG_ITEM_INFO, DIALOG_STYLE_MSGBOX, title, dialog, "��", "�Դ");            

    return 1;            new dbItemID = ItemData[itemIdx][ItemDBID];

}            

            if (i > 0) strcat(values, ", ");

// Helper: �֧���ͻ����������            format(temp, sizeof(temp), 

stock GetItemTypeName(E_ITEM_TYPE:type) {                "((SELECT inventory_id FROM inventory WHERE inventory_owner = %d), %d, %d)",

    new name[32];                PlayerIntData[playerid][PlayerID], dbItemID, qty);

    switch (type) {            strcat(values, temp);

        case ITEM_TYPE_FOOD: format(name, sizeof(name), "{00FF00}�����");        }

        case ITEM_TYPE_DRINK: format(name, sizeof(name), "{00FFFF}����ͧ����");        

        case ITEM_TYPE_MEDICAL: format(name, sizeof(name), "{FF0000}���ѡ��");        if (strlen(values) > 0) {

        case ITEM_TYPE_ARMOR: format(name, sizeof(name), "{0000FF}���л�ͧ�ѹ");            mysql_format(dbHandle, query, sizeof(query),

        case ITEM_TYPE_WEAPON: format(name, sizeof(name), "{FF8800}���ظ");                "INSERT INTO inventory_items (inventory_id, item_id, quantity) VALUES %s",

        case ITEM_TYPE_TOOL: format(name, sizeof(name), "{888888}����ͧ���");                values);

        default: format(name, sizeof(name), "{AAAAAA}�����");            mysql_tquery(dbHandle, query);

    }        }

    return name;    }

}    

    printf("[Inventory] Saved %d items for player %d", PlayerInventoryCount[playerid], playerid);

// ------------------------------ Commands ------------------------------------    return 1;

CMD:inventory(playerid, params[]) {}

    if (!IsPlayerLoggedIn(playerid)) {

        return SendClientMessage(playerid, 0xFF0000FF, "�س��ͧ��͡�Թ��͹!");// ����������������� (� memory)

    }stock AddItemToPlayer(playerid, itemIndex, quantity = 1) {

    ShowPlayerInventory(playerid);    if (itemIndex < 0 || itemIndex >= g_TotalItems) return 0;

    return 1;    

}    // ��Ǩ�ͺ����������������������������

    for (new i = 0; i < PlayerInventoryCount[playerid]; i++) {

CMD:inv(playerid, params[]) return cmd_inventory(playerid, params);        if (PlayerInventory[playerid][i][InvItemID] == itemIndex) {

CMD:i(playerid, params[]) return cmd_inventory(playerid, params);            PlayerInventory[playerid][i][InvQuantity] += quantity;

            return 1;

CMD:giveitem(playerid, params[]) {        }

    if (PlayerIntData[playerid][AdminLevel] < 1) {    }

        return SendClientMessage(playerid, 0xFF0000FF, "�س������Է��������觹��!");    

    }    // �������� ��������

    if (PlayerInventoryCount[playerid] >= MAX_PLAYER_ITEMS) {

    new args[3][32];        return 0; // inventory ���

    new count = SplitParams(params, args);    }

    

    if (count < 2) {    new slot = PlayerInventoryCount[playerid];

        SendClientMessage(playerid, 0xFFFFFFFF, "Usage: /giveitem <targetid> <itemid> [quantity]");    PlayerInventory[playerid][slot][InvItemID] = itemIndex;

        SendClientMessage(playerid, 0xAAAAAAAA, "Example: /giveitem 0 1 5 (��颹��ѧ 5 ���)");    PlayerInventory[playerid][slot][InvQuantity] = quantity;

        SendClientMessage(playerid, 0xAAAAAAAA, "�� /itemlist ���ʹ���¡�������");    PlayerInventory[playerid][slot][InvInventoryID] = 0; // ���� ID ����� save

        return 1;    PlayerInventoryCount[playerid]++;

    }    return 1;

}

    new targetid = strval(args[0]);

    new itemid = strval(args[1]);// ź������ҡ������

    new quantity = (count >= 3) ? strval(args[2]) : 1;stock RemoveItemFromPlayer(playerid, itemIndex, quantity = 1) {

    for (new i = 0; i < PlayerInventoryCount[playerid]; i++) {

    if (!IsPlayerConnected(targetid)) {        if (PlayerInventory[playerid][i][InvItemID] == itemIndex) {

        return SendClientMessage(playerid, 0xFF0000FF, "����������͹�Ź�!");            PlayerInventory[playerid][i][InvQuantity] -= quantity;

    }            

            // ��Ҩӹǹ����� 0 ���͹��¡��� ź�͡

    if (!IsValidItemID(itemid)) {            if (PlayerInventory[playerid][i][InvQuantity] <= 0) {

        new msg[128];                // ����͹����������᷹

        format(msg, sizeof(msg), "Item ID ���١��ͧ! (�� 1-%d)", MAX_ITEM_TYPES - 1);                for (new j = i; j < PlayerInventoryCount[playerid] - 1; j++) {

        return SendClientMessage(playerid, 0xFF0000FF, msg);                    PlayerInventory[playerid][j][InvItemID] = PlayerInventory[playerid][j + 1][InvItemID];

    }                    PlayerInventory[playerid][j][InvQuantity] = PlayerInventory[playerid][j + 1][InvQuantity];

                    PlayerInventory[playerid][j][InvInventoryID] = PlayerInventory[playerid][j + 1][InvInventoryID];

    if (quantity <= 0) quantity = 1;                }

                PlayerInventoryCount[playerid]--;

    AddItemToPlayer(targetid, itemid, quantity);            }

            return 1;

    new itemName[MAX_ITEM_NAME];        }

    GetItemName(itemid, itemName);    }

    return 0;

    new msg[128];}

    new targetName[MAX_PLAYER_NAME];

    GetPlayerName(targetid, targetName, sizeof(targetName));// �ӹǳ���˹ѡ����ͧ inventory

    stock Float:GetPlayerInventoryWeight(playerid) {

    format(msg, sizeof(msg), "{00FF00}[Admin] �س���������� '%s' x%d �� %s",     new Float:totalWeight = 0.0;

        itemName, quantity, targetName);    

    SendClientMessage(playerid, -1, msg);    for (new i = 0; i < PlayerInventoryCount[playerid]; i++) {

        new itemIdx = PlayerInventory[playerid][i][InvItemID];

    return 1;        new qty = PlayerInventory[playerid][i][InvQuantity];

}        totalWeight += (GetItemWeightByIndex(itemIdx) * float(qty));

    }

CMD:itemlist(playerid, params[]) {    

    SendClientMessage(playerid, 0xFFD700FF, "=== ��¡������������� ===");    return totalWeight;

    SendClientMessage(playerid, -1, "1. ����ѧ | 2. ��Ӵ��� | 3. �Ҿ͡");}

    SendClientMessage(playerid, -1, "4. ����͡ѹ����ع | 5. �׹ Desert Eagle | 6. ����ʺ��");

    SendClientMessage(playerid, -1, "7. �ش����ͧ��ͪ�ҧ | 8. �ҧ������ | 9. ��¡��� | 10. ���Ѿ����Ͷ��");// �ʴ� inventory Ẻ Dialog

    return 1;stock ShowPlayerInventory(playerid) {

}    if (PlayerInventoryCount[playerid] == 0) {

        ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_MSGBOX,

// ------------------------------ Callbacks -----------------------------------            "{FF6347}��ѧ�����",

// Handle Inventory Dialog Response (��᷹ OnDialogResponse)            "{FFFFFF}�س����������㹤�ѧ\n\n{FFFF00}���˹ѡ���: {FFFFFF}0.00 kg",

stock HandleInventoryDialogs(playerid, dialogid, response, listitem, inputtext[]) {            "�Դ", "");

    if (dialogid == DIALOG_INVENTORY) {        return 1;

        if (!response) return 1; // ���Դ    }

    

        if (listitem >= 0 && listitem < PlayerInventoryCount[playerid]) {    new list[2048], itemName[MAX_ITEM_NAME];

            ShowItemInfo(playerid, listitem);    new Float:totalWeight = GetPlayerInventoryWeight(playerid);

        }    

        return 1;    // ���ҧ��¡�������

    }    for (new i = 0; i < PlayerInventoryCount[playerid]; i++) {

        new itemIdx = PlayerInventory[playerid][i][InvItemID];

    if (dialogid == DIALOG_ITEM_INFO) {        new qty = PlayerInventory[playerid][i][InvQuantity];

        if (!response) return 1; // ���Դ        new Float:weight = GetItemWeightByIndex(itemIdx);

        

        // ������ "��"        GetItemNameByIndex(itemIdx, itemName);

        new slot = g_PlayerSelectedSlot[playerid];        

        if (slot < 0 || slot >= PlayerInventoryCount[playerid]) return 1;        // ������¡�����������

        format(list, sizeof(list), "%s{FFFFFF}%s\t{00FF00}x%d\t{FFFF00}%.1f kg\n", 

        new itemid = PlayerInventory[playerid][slot][InvItemID];            list, itemName, qty, weight * float(qty));

            }

        // ���¡�ѧ��ѹ UseItem �ҡ items.pwn    

        if (UseItem(playerid, itemid, slot)) {    // �ʴ� Dialog

            // ������� - ź����� 1 ���    new title[64];

            RemoveItemFromPlayer(playerid, slot, 1);    format(title, sizeof(title), "{33CCFF}��ѧ����� {FFFFFF}(%d/%d)", 

        }        PlayerInventoryCount[playerid], MAX_PLAYER_ITEMS);

    

        // �Դ inventory ��Ѻ    new info[128];

        ShowPlayerInventory(playerid);    format(info, sizeof(info), "\n{FFFF00}���˹ѡ���: {FFFFFF}%.2f kg", totalWeight);

        return 1;    strcat(list, info);

    }    

    new header[128];

    return 0; // ��� dialog ���� �����żŵ��    format(header, sizeof(header), "{FFFF00}���������\t{FFFF00}�ӹǹ\t{FFFF00}���˹ѡ\n%s", list);

}    

    ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_TABLIST_HEADERS,

// Handle Hotkey (���¡�ҡ main.pwn OnPlayerKeyStateChange)        title,

stock HandleInventoryHotkey(playerid, newkeys, oldkeys) {        header,

    if (PRESSED(KEY_YES)) { // ������ Y ���� ~        "����������´", "�Դ");

        if (IsPlayerLoggedIn(playerid)) {    

            ShowPlayerInventory(playerid);    return 1;

            return 1;}

        }

    }// ------------------------------ Commands ------------------------------------

    return 0;CMD:inventory(playerid, params[]) {

}    if (!IsPlayerLoggedIn(playerid)) {

        SendClientMessage(playerid, 0xFF6347AA, "�س��ͧ��͡�Թ��͹!");
        return 1;
    }
    
    ShowPlayerInventory(playerid);
    return 1;
}

CMD:reloaditems(playerid, params[]) {
    if (PlayerIntData[playerid][AdminLevel] < 5) {
        SendClientMessage(playerid, 0xFF6347AA, "�س������Է��������觹��!");
        return 1;
    }
    
    LoadAllItemsFromDB();
    SendClientMessage(playerid, 0x00FF00AA, "[Admin] ��Ŵ���������������ҡ database ����!");
    return 1;
}

CMD:i(playerid, params[]) {
    return ShowPlayerInventory(playerid);
}

CMD:inv(playerid, params[]) {
    return ShowPlayerInventory(playerid);
}

// ------------------------------ Admin Item Management -----------------------
// ���ҧ����������������ŧ database
stock CreateNewItem(const itemName[], const itemDesc[], Float:itemWeight) {
    if (dbHandle == MYSQL_INVALID_HANDLE) {
        print("[Item System] ERROR: Database not connected!");
        return 0;
    }
    
    if (strlen(itemName) == 0 || strlen(itemName) > MAX_ITEM_NAME - 1) {
        print("[Item System] ERROR: Invalid item name length!");
        return 0;
    }
    
    if (itemWeight < 0.0) {
        print("[Item System] ERROR: Item weight cannot be negative!");
        return 0;
    }
    
    new query[512];
    mysql_format(dbHandle, query, sizeof(query),
        "INSERT INTO items (item_name, item_description, item_weight) VALUES ('%e', '%e', %f)",
        itemName, itemDesc, itemWeight);
    
    mysql_tquery(dbHandle, query, "OnItemCreated", "ssd", itemName, itemDesc, itemWeight);
    return 1;
}

// Callback ��ѧ���ҧ����������
forward OnItemCreated(const itemName[], const itemDesc[], Float:itemWeight);
public OnItemCreated(const itemName[], const itemDesc[], Float:itemWeight) {
    new insertId = cache_insert_id();
    
    if (insertId == 0) {
        printf("[Item System] ERROR: Failed to create item '%s'", itemName);
        return 0;
    }
    
    // ������������ cache �˹��¤�����
    if (g_TotalItems < MAX_ITEMS) {
        ItemData[g_TotalItems][ItemDBID] = insertId;
        format(ItemData[g_TotalItems][ItemName], MAX_ITEM_NAME, "%s", itemName);
        format(ItemData[g_TotalItems][ItemDescription], MAX_ITEM_DESC, "%s", itemDesc);
        ItemData[g_TotalItems][ItemWeight] = itemWeight;
        g_TotalItems++;
        
        printf("[Item System] Created item '%s' (ID: %d) successfully! Total items: %d", 
            itemName, insertId, g_TotalItems);
    } else {
        printf("[Item System] WARNING: Item cache is full! Reload items to sync.");
    }
    
    return 1;
}

CMD:createitem(playerid, params[]) {
    if (PlayerIntData[playerid][AdminLevel] < 5) {
        SendClientMessage(playerid, 0xFF6347AA, "�س��ͧ���ʹ�Թ����� 5 ����!");
        return 1;
    }
    
    if (strlen(params) == 0) {
        SendClientMessage(playerid, 0xFFFF00AA, "�Ը���: /createitem [���������] [���˹ѡ] [��͸Ժ��]");
        SendClientMessage(playerid, 0xFFFFFFAA, "������ҧ: /createitem Sword 2.5 �Һ���硤���Ժ");
        return 1;
    }
    
    new args[3][128];
    new argCount = 0;
    new length = strlen(params);
    new start = 0, end = 0;
    
    // �¡ argument ���ª�ͧ��ҧ (�٧�ش 3 arguments)
    while (end < length && argCount < 3) {
        while (end < length && params[end] == ' ') end++;
        start = end;
        while (end < length && params[end] != ' ') end++;
        
        if (start < end) {
            strmid(args[argCount], params, start, end, 128);
            argCount++;
        }
    }
    
    if (argCount < 3) {
        SendClientMessage(playerid, 0xFF6347AA, "��ͼԴ��Ҵ: ��س��кؾ������������ú!");
        SendClientMessage(playerid, 0xFFFFFFAA, "�Ը���: /createitem [���������] [���˹ѡ] [��͸Ժ��]");
        return 1;
    }
    
    new itemName[MAX_ITEM_NAME];
    format(itemName, sizeof(itemName), "%s", args[0]);
    
    new Float:weight = floatstr(args[1]);
    
    // ��� args[2] �֧�����ش�繤�͸Ժ��
    new itemDesc[MAX_ITEM_DESC];
    new descStart = 0;
    
    // �ҵ��˹�������鹢ͧ description (��ѧ argument ��� 2)
    new spaceCount = 0;
    for (new i = 0; i < length; i++) {
        if (params[i] == ' ') {
            spaceCount++;
            if (spaceCount == 2) {
                descStart = i + 1;
                break;
            }
        }
    }
    
    if (descStart < length) {
        strmid(itemDesc, params, descStart, length, MAX_ITEM_DESC);
    } else {
        format(itemDesc, sizeof(itemDesc), "No description");
    }
    
    // ��Ǩ�ͺ�����١��ͧ
    if (strlen(itemName) == 0) {
        SendClientMessage(playerid, 0xFF6347AA, "��ͼԴ��Ҵ: ����������������ö�����ҧ��!");
        return 1;
    }
    
    if (weight < 0.0 || weight > 1000.0) {
        SendClientMessage(playerid, 0xFF6347AA, "��ͼԴ��Ҵ: ���˹ѡ��ͧ���������ҧ 0-1000 kg!");
        return 1;
    }
    
    // ���ҧ�����
    if (CreateNewItem(itemName, itemDesc, weight)) {
        new msg[256];
        format(msg, sizeof(msg), 
            "{00FF00}[Admin] ���ҧ����������!\n\
            {FFFFFF}����: {FFFF00}%s\n\
            {FFFFFF}���˹ѡ: {FFFF00}%.2f kg\n\
            {FFFFFF}��͸Ժ��: {CCCCCC}%s",
            itemName, weight, itemDesc);
        SendClientMessage(playerid, -1, msg);
        
        printf("[Admin] %s created item '%s' (%.2f kg)", getplayername(playerid), itemName, weight);
    } else {
        SendClientMessage(playerid, 0xFF6347AA, "��ͼԴ��Ҵ: �������ö���ҧ�������!");
    }
    
    return 1;
}
