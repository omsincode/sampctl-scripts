// --------------------------- Include Guard ----------------------------------
#if defined _save_systems_included
    #endinput
#endif
#define _save_systems_included

// ------------------------------ Includes ------------------------------------
#include "database.pwn"      // include �������������ǡѹ
#include "player_data.pwn"

// ------------------------------ Config -------------------------------------
#if !defined MIN_SAVE_INTERVAL
    #define MIN_SAVE_INTERVAL 300000  // 5 �ҷ� ����Ѻ production
#endif

new LastSaveTick[MAX_PLAYERS];

// ------------------------------ Stocks ------------------------------------
stock SavePlayerData(playerid) { // ૿Ẻ������ (�� throttle)
    if (!IsPlayerConnected(playerid)) return 0;
    if (!IsPlayerLoggedIn(playerid)) return 0;
    if (!IsPlayerDataReady(playerid)) return 0; // �ѧ��Ŵ������������� ���૿
    if (dbHandle == MYSQL_INVALID_HANDLE) return 0;
    if (PlayerIntData[playerid][PlayerID] == 0) return 0; // �ѧ������ player_id �ҡ DB

    new now = GetTickCount();
    if (now - LastSaveTick[playerid] < MIN_SAVE_INTERVAL) return 0; // �ѧ���ú����
    LastSaveTick[playerid] = now;
    return InternalDoPlayerSave(playerid, false); // false = auto save
}

stock ForceSavePlayerData(playerid) { // �ѧ�Ѻ૿ (�蹵͹ disconnect)
    if (!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || !IsPlayerDataReady(playerid)) {
        return 0;
    }
    
    if (dbHandle == MYSQL_INVALID_HANDLE || PlayerIntData[playerid][PlayerID] == 0) {
        return 0;
    }
    
    return InternalDoPlayerSave(playerid, true); // true = manual save
}

// �ѧ��ѹ���㹵�Ǩ�ԧ���� query
stock InternalDoPlayerSave(playerid, bool:isManualSave = false) {
    new query[512], Float:health, Float:armour, Float:x, Float:y, Float:z, Float:angle;

    GetPlayerHealth(playerid, health);
    GetPlayerArmour(playerid, armour);
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, angle);

    // Fallback: �������ѧ�� 0 ���դ����� (��м������� spawn) ������ҡ�͹˹������Ŵ snapshot 0 ���������
    if (angle == 0.0 && Float:PlayerFloatData[playerid][LastAngle] != 0.0) {
        angle = Float:PlayerFloatData[playerid][LastAngle];
    }

    // Clamp
    if (health > 100.0) health = 100.0;
    if (armour > 100.0) armour = 100.0;
    if (health < 0.0) health = 0.0;
    if (armour < 0.0) armour = 0.0;

    // Sync ��Ѻ array (������� cache �ç�Ѻ DB)
    PlayerIntData[playerid][Money] = GetPlayerMoney(playerid);
    PlayerIntData[playerid][Health] = floatround(health);
    PlayerIntData[playerid][Armour] = floatround(armour);
    PlayerFloatData[playerid][LastPosX] = FLOAT:x;
    PlayerFloatData[playerid][LastPosY] = FLOAT:y;
    PlayerFloatData[playerid][LastPosZ] = FLOAT:z;
    PlayerFloatData[playerid][LastAngle] = FLOAT:angle;

    // Clamp / sanity �����������ҧ��� 1 (�ѹ�ó���ش�� 0)
    if (PlayerIntData[playerid][Level] < 1) PlayerIntData[playerid][Level] = 1;

    mysql_format(dbHandle, query, sizeof(query),
        "UPDATE players SET \
        player_posx = %f, \
        player_posy = %f, \
        player_posz = %f, \
        player_angle = %f, \
        player_skin = %d, \
        player_money = %d, \
        player_health = %d, \
        player_armour = %d, \
        player_level = %d, \
        player_xp = %d, \
        player_gang = %d, \
        player_last_login = NOW() \
        WHERE player_id = %d LIMIT 1",
        x, y, z, angle,
        GetPlayerSkin(playerid),
        PlayerIntData[playerid][Money],
        PlayerIntData[playerid][Health],
        PlayerIntData[playerid][Armour],
        PlayerIntData[playerid][Level],
        PlayerIntData[playerid][XP],
        PlayerIntData[playerid][Gang],
        PlayerIntData[playerid][PlayerID]
    );

    mysql_tquery(dbHandle, query, "OnPlayerSave", "ii", playerid, isManualSave);
    return 1;
}

// ------------------------------ Forwards -----------------------------------
forward OnPlayerSave(playerid, isManualSave);

// ------------------------------ Callbacks ----------------------------------
public OnPlayerSave(playerid, isManualSave) {
    if (mysql_errno(dbHandle) != 0) {
        printf("[MySQL] Save failed (player %d, err %d)", playerid, mysql_errno(dbHandle));
        if (IsPlayerConnected(playerid)) {
            SendClientMessage(playerid, 0xFF6666AA, "[���������] �Դ��ͼԴ��Ҵ㹡�úѹ�֡������ ��سҵԴ����ʹ�Թ");
        }
    } else {
        // �駼����������૿�����
        if (IsPlayerConnected(playerid)) {
            if (isManualSave) {
                SendClientMessage(playerid, 0x66FF66AA, "[���������] �ѹ�֡�����������");
            } else {
                SendClientMessage(playerid, 0x66DDFFAA, "[���������] �ѹ�֡�������ѵ��ѵ������");
            }
        }
        printf("[MySQL] Save success (player %d, %s)", playerid, isManualSave ? "manual" : "auto");
    }
    return 1;
}

