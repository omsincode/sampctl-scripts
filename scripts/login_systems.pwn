// --------------------------- Include Guard ----------------------------------
#if defined _login_system_included
    #endinput
#endif
#define _login_system_included

// ------------------------------ Includes ------------------------------------
#include "scripts/database.pwn"
#include "scripts/player_data.pwn" // ���������� PlayerBoolData / PlayerIntData
#include "scripts/loads_systems.pwn"
#include "scripts/save_systems.pwn"

// ------------------------------ Defines -------------------------------------
#define DIALOG_LOGIN     1
#define DIALOG_REGISTER  2

// Player data moved to player_data.pwn

// ------------------------------ Stocks --------------------------------------
stock SetPlayerSpawn(playerid) {
    SetSpawnInfo(playerid, 0, 0, 1172.02, -1323.89, 15.00, 0.0, 0, 0, 0, 0, 0, 0);
    SetPlayerFacingAngle(playerid, 270.0);
    SetCameraBehindPlayer(playerid);
    SpawnPlayer(playerid);
    SendClientMessage(playerid, 0x00FF00AA, "�س���Դ��������!");
}

stock ShowLoginDialog(playerid) { // �ʴ�˹����͡�Թ
    new string[128];
    format(string, sizeof(string), "{FFFFFF}�Թ�յ�͹�Ѻ���������������\n��س�������ʼ�ҹ�����������к�:");
    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,
        "Login System", string, "�������к�", "¡��ԡ");
    return 1;
}

stock ShowRegisterDialog(playerid) { // �ʴ�˹����Ѥ���Ҫԡ
    new string[128];
    format(string, sizeof(string), "{FFFFFF}�Թ�յ�͹�Ѻ��Ҫԡ����\n��سҵ�����ʼ�ҹ������Ѥ���Ҫԡ:");
    ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,
        "Register System", string, "��Ѥ���Ҫԡ", "¡��ԡ");
    return 1;
}

stock CheckUsername(playerid) { // ��Ǩ�ͺ����ժ��ͼ����������ѧ
    new query[128], playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playername, sizeof(playername));
    mysql_format(dbHandle, query, sizeof(query),
        "SELECT * FROM players WHERE player_name = '%e' LIMIT 1", playername);
    mysql_tquery(dbHandle, query, "OnUsernameCheck", "i", playerid);
    return 1;
}

stock LoginPlayer(playerid, const password[]) { // ��͡�Թ������
    new query[256], playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playername, sizeof(playername));
    mysql_format(dbHandle, query, sizeof(query),
        "SELECT * FROM players WHERE player_name = '%e' AND player_password = '%e' LIMIT 1",
        playername, password);
    mysql_tquery(dbHandle, query, "OnPlayerLogin", "is", playerid, password);
    return 1;
}

stock RegisterPlayer(playerid, const password[]) { // ��Ѥ���Ҫԡ������
    new query[512], playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playername, sizeof(playername));
    mysql_format(dbHandle, query, sizeof(query),
        "INSERT INTO players (player_name, player_password, player_admin, player_posx, player_posy, player_posz, player_angle, player_skin, player_money, player_health, player_armour, player_level, player_xp, player_gang) VALUES ('%e', '%e', 0, 0.0, 0.0, 0.0, 0.0, 0, 0, 100, 0, 1, 0, 0)",
        playername, password);
    mysql_tquery(dbHandle, query, "OnPlayerRegister", "is", playerid, password);
    return 1;
}

stock ResetPlayerData(playerid) { // ���絢����ż�����������͡�������������
    PlayerBoolData[playerid][IsLoggedIn] = false;
    PlayerIntData[playerid][LoginAttempts] = 0;
    PlayerBoolData[playerid][DataReady] = false;
    PlayerBoolData[playerid][NewAccount] = false;
    PlayerBoolData[playerid][Spawned] = false;
    // ��ҧ��� int Ẻ�к� (��ա����§ tag mismatch warning)
    PlayerIntData[playerid][PlayerID] = 0;
    PlayerIntData[playerid][AdminLevel] = 0;
    PlayerIntData[playerid][Skin] = 0;
    PlayerIntData[playerid][Money] = 0;
    PlayerIntData[playerid][Health] = 0;
    PlayerIntData[playerid][Armour] = 0;
    PlayerIntData[playerid][Level] = 0;
    PlayerIntData[playerid][XP] = 0;
    PlayerIntData[playerid][Gang] = 0;
    PlayerIntData[playerid][LoginAttempts] = 0;
    // ��ҧ��� float
    PlayerFloatData[playerid][LastPosX] = FLOAT:0.0;
    PlayerFloatData[playerid][LastPosY] = FLOAT:0.0;
    PlayerFloatData[playerid][LastPosZ] = FLOAT:0.0;
    PlayerFloatData[playerid][LastAngle] = FLOAT:0.0;
    return 1;
}


stock ShowLoginOrRegister(playerid) { // ��Ǩ�ͺ������˹�ҷ���������
    new query[128], playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playername, sizeof(playername));
    mysql_format(dbHandle, query, sizeof(query),
        "SELECT * FROM players WHERE player_name = '%e' LIMIT 1", playername);
    mysql_tquery(dbHandle, query, "OnCheckAccount", "i", playerid);
    return 1;
}

// ------------------------------ Forwards ------------------------------------
forward OnUsernameCheck(playerid);
forward OnPlayerLogin(playerid, const password[]);
forward OnPlayerRegister(playerid, const password[]);
forward OnCheckAccount(playerid);

// ---------------------------- Public Callbacks ------------------------------
public OnUsernameCheck(playerid) {
    if (cache_num_rows() > 0) {
        ShowLoginDialog(playerid);
    } else {
        ShowRegisterDialog(playerid);
    }
    return 1;
}

public OnPlayerLogin(playerid, const password[]) {
    // �ҡ�������� (��͡�Թ�����)
    if (cache_num_rows() > 0) {
        PlayerBoolData[playerid][IsLoggedIn] = true;
        SendClientMessage(playerid, -1, "{00FF00}�������к������!");
        LoadPlayerData(playerid); // �� spawn ��ѧ��Ŵ������� OnPlayerDataLoad
        return 1; // �͡�ѹ����ѧ�����
    }

    // �ó���辺 (���ʼ�ҹ�Դ) - �����ӹǹ����
    PlayerIntData[playerid][LoginAttempts]++;

    if (PlayerIntData[playerid][LoginAttempts] >= 3) { // �Թ 3 ����
        SendClientMessage(playerid, -1, "{FF0000}�س������ʼ�ҹ�Դ�Թ 3 ����!");
        Kick(playerid);
        return 1;
    }

    // �ѧ���ú 3 ���� ����͹�������ͧ����
    SendClientMessage(playerid, -1, "{FF0000}���ʼ�ҹ���١��ͧ ��س��ͧ�����ա����!");
    ShowLoginDialog(playerid);
    return 1;
}

public OnPlayerRegister(playerid, const password[]) {
    if (cache_affected_rows() > 0) {
        PlayerBoolData[playerid][IsLoggedIn] = true;
        PlayerBoolData[playerid][NewAccount] = true; // �к�����繺ѭ������
        // �纤�� insert id (primary key) ����Ѻ��㹡�� UPDATE �Ѵ�
        PlayerIntData[playerid][PlayerID] = cache_insert_id();
        SendClientMessage(playerid, -1, "{00FF00}��Ѥ���Ҫԡ����������к������!");
        SetPlayerSpawn(playerid); // ��૿��ѧ DataReady �蹡ѹ
    } else {
        SendClientMessage(playerid, -1, "{FF0000}�Դ��ͼԴ��Ҵ㹡����Ѥ���Ҫԡ!");
        ShowRegisterDialog(playerid);
    }
    return 1;
}

public OnCheckAccount(playerid) {
    if (cache_num_rows() > 0) {
        ShowLoginDialog(playerid);
        SendClientMessage(playerid, -1, "{FFFF00}��Ǩ���ѭ�բͧ�س��к� ��س��������к�");
    } else {
        ShowRegisterDialog(playerid);
        SendClientMessage(playerid, -1, "{FFFF00}��辺�ѭ�բͧ�س��к� ��س���Ѥ���Ҫԡ");
    }
    return 1;
}
