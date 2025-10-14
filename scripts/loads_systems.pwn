// --------------------------- Include Guard ----------------------------------
#if defined _loads_systems_included
    #endinput
#endif
#define _loads_systems_included

// ------------------------------ Includes ------------------------------------
#include "database.pwn"
#include "player_data.pwn"

// ------------------------------ Stocks --------------------------------------
stock LoadPlayerData(playerid) {
    if (dbHandle == MYSQL_INVALID_HANDLE) return 0;
    new query[256];
    // ����� player_id ���� (�蹡ó� future re-load) ��鹴��� id ᷹����
    if (PlayerIntData[playerid][PlayerID] > 0) {
        mysql_format(dbHandle, query, sizeof(query),
            "SELECT * FROM players WHERE player_id = %d LIMIT 1",
            PlayerIntData[playerid][PlayerID]);
    } else {
        new playername[MAX_PLAYER_NAME];
        GetPlayerName(playerid, playername, sizeof(playername));
        mysql_format(dbHandle, query, sizeof(query),
            "SELECT * FROM players WHERE player_name = '%e' LIMIT 1",
            playername);
    }
    mysql_tquery(dbHandle, query, "OnPlayerDataLoad", "i", playerid);
    return 1;
}

// Apply loaded cached values to in-memory structures & player state (�¡�ѧ��ѹ�����ҹ����)
stock ApplyLoadedPlayerData(playerid) {
    // Clamp / validate ints
    if (PlayerIntData[playerid][Health] < 0) PlayerIntData[playerid][Health] = 0;
    if (PlayerIntData[playerid][Health] > 100) PlayerIntData[playerid][Health] = 100;
    if (PlayerIntData[playerid][Armour] < 0) PlayerIntData[playerid][Armour] = 0;
    if (PlayerIntData[playerid][Armour] > 100) PlayerIntData[playerid][Armour] = 100;

    // Basic sanity for position (�ѹ�����شẺ NaN ���� Infinity ��� pawn �Ҩ����� ��ѹ���)
    if (floatcmp(Float:PlayerFloatData[playerid][LastPosX], Float:PlayerFloatData[playerid][LastPosX]) != 0) PlayerFloatData[playerid][LastPosX] = FLOAT:0.0;
    if (floatcmp(Float:PlayerFloatData[playerid][LastPosY], Float:PlayerFloatData[playerid][LastPosY]) != 0) PlayerFloatData[playerid][LastPosY] = FLOAT:0.0;
    if (floatcmp(Float:PlayerFloatData[playerid][LastPosZ], Float:PlayerFloatData[playerid][LastPosZ]) != 0) PlayerFloatData[playerid][LastPosZ] = FLOAT:5.0;

    // Safeguard: ��Ǩ�ͺ����բ����ŵ��˹觷��١��ͧ�������
    // ��੾�Сóշ���յ��˹觷��ѹ�֡������� (������� default ���� new account)
    new bool:hasValidPosition = !(Float:PlayerFloatData[playerid][LastPosX] == 0.0 && Float:PlayerFloatData[playerid][LastPosY] == 0.0 && Float:PlayerFloatData[playerid][LastPosZ] == 0.0);

    // Apply scalar values
    SetPlayerHealth(playerid, float(PlayerIntData[playerid][Health]));
    SetPlayerArmour(playerid, float(PlayerIntData[playerid][Armour]));
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, PlayerIntData[playerid][Money]);
    SetPlayerSkin(playerid, PlayerIntData[playerid][Skin]);

    // Apply ���˹�੾��������բ����ŷ��ѹ�֡�������
    if (hasValidPosition) {
        SetPlayerPos(playerid,
            Float:PlayerFloatData[playerid][LastPosX],
            Float:PlayerFloatData[playerid][LastPosY],
            Float:PlayerFloatData[playerid][LastPosZ]
        );
        SetPlayerFacingAngle(playerid, Float:PlayerFloatData[playerid][LastAngle]);
    }
    return 1;
}

// ------------------------------ Forwards ------------------------------------
forward OnPlayerDataLoad(playerid);

// ------------------------------ Callbacks -----------------------------------
public OnPlayerDataLoad(playerid) {
    if (!IsPlayerConnected(playerid)) return 0; // �������͡��͹��Ŵ����

    if (cache_num_rows() == 0) {
        SendClientMessage(playerid, -1, "{FF0000}��辺�����ż�����㹰ҹ������ (�Ҩ�١ź)");
        return 1;
    }

    // Load data into memory from cache
    cache_get_value_name_int(0, "player_id", PlayerIntData[playerid][PlayerID]);
    cache_get_value_name_int(0, "player_admin", PlayerIntData[playerid][AdminLevel]);
    cache_get_value_name_float(0, "player_posx", Float:PlayerFloatData[playerid][LastPosX]);
    cache_get_value_name_float(0, "player_posy", Float:PlayerFloatData[playerid][LastPosY]);
    cache_get_value_name_float(0, "player_posz", Float:PlayerFloatData[playerid][LastPosZ]);
    cache_get_value_name_float(0, "player_angle", Float:PlayerFloatData[playerid][LastAngle]);
    cache_get_value_name_int(0, "player_skin", PlayerIntData[playerid][Skin]);
    cache_get_value_name_int(0, "player_money", PlayerIntData[playerid][Money]);
    cache_get_value_name_int(0, "player_health", PlayerIntData[playerid][Health]);
    cache_get_value_name_int(0, "player_armour", PlayerIntData[playerid][Armour]);
    cache_get_value_name_int(0, "player_level", PlayerIntData[playerid][Level]);
    cache_get_value_name_int(0, "player_xp", PlayerIntData[playerid][XP]);
    cache_get_value_name_int(0, "player_gang", PlayerIntData[playerid][Gang]);

    // Spawn ��������ѧ��������Ŵ (Ŵ��á�о�Ժ���˹�)
    if (!HasPlayerSpawned(playerid)) {
        // ����˹觨ҡ�ҹ������ ��������˹� default �������բ�����
        new Float:spawnX = Float:PlayerFloatData[playerid][LastPosX];
        new Float:spawnY = Float:PlayerFloatData[playerid][LastPosY]; 
        new Float:spawnZ = Float:PlayerFloatData[playerid][LastPosZ];
        new Float:spawnAngle = Float:PlayerFloatData[playerid][LastAngle];
        
        // �������յ��˹觷��ѹ�֡��� (�������� 0) �������˹� default
        if (spawnX == 0.0 && spawnY == 0.0 && spawnZ == 0.0 && spawnAngle == 0.0) {
            spawnX = 1172.02;
            spawnY = -1323.89;
            spawnZ = 15.00;
            spawnAngle = 0.0;
        }
        
        SetSpawnInfo(playerid, 0, PlayerIntData[playerid][Skin], spawnX, spawnY, spawnZ, spawnAngle, 0, 0, 0, 0, 0, 0);
        SpawnPlayer(playerid);
        PlayerBoolData[playerid][Spawned] = true;
    }

    // Apply ��������ѧ�ҡ spawn ���� (����֧���˹觷�������)
    ApplyLoadedPlayerData(playerid);
    PlayerBoolData[playerid][DataReady] = true; // �����ž��������

    // ��Ŵ inventory �ͧ������
    LoadPlayerInventory(playerid);

    printf("[Load] id=%d pos=(%.2f, %.2f, %.2f) ang=%.2f hp=%d ar=%d money=%d lvl=%d xp=%d",
        PlayerIntData[playerid][PlayerID],
        Float:PlayerFloatData[playerid][LastPosX],
        Float:PlayerFloatData[playerid][LastPosY],
        Float:PlayerFloatData[playerid][LastPosZ],
        Float:PlayerFloatData[playerid][LastAngle],
        PlayerIntData[playerid][Health],
        PlayerIntData[playerid][Armour],
        PlayerIntData[playerid][Money],
        PlayerIntData[playerid][Level],
        PlayerIntData[playerid][XP]
    );
    SendClientMessage(playerid, -1, "{00FF00}�����Ţͧ�س�١��Ŵ���º��������!");
    return 1;
}