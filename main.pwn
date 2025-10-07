// --------------------------- Include Guard ----------------------------------
#include <a_samp>
#include <a_mysql>
#include <zcmd>

// ------------------------------ Includes ------------------------------------
#include "scripts/database.pwn"
#include "scripts/login_systems.pwn"
#include "scripts/save_systems.pwn"
#include "scripts/dialog_systems.pwn"
#include "scripts/commands/admin_commands.pwn"

// ��˹�������������
#define HOSTNAME        "Star Town" // �������������
#define MAPNAME         "THAILAND"
#define WEBURL          "commingson"
#define VERSION         "V1.0.0" // �����ѹ�ͧ���������
// ��˹�������������

// -------------------------- Autosave Settings ------------------------------
#define AUTOSAVE_INTERVAL_MS   (300000) // 5 �ҷյ���ͺ
new g_AutoSaveTimer = -1;

// -------------------------- forward declarations -----------------------------
forward AutoSaveTick();


// ------------------------------ Main ----------------------------------------
main() {
    printf("[Debug] Run GameMode Success!");
    

}


// ------------------------------ Login -----------------------------------
public OnGameModeInit() {
    printf("[Debug] Run GameMode...");
    ConnectToDatabase();

    if (g_AutoSaveTimer != -1) KillTimer(g_AutoSaveTimer);
    g_AutoSaveTimer = SetTimer("AutoSaveTick", AUTOSAVE_INTERVAL_MS, true);
    printf("[Autosave] Started interval every %d ms", AUTOSAVE_INTERVAL_MS);

    return 1;
}

public OnPlayerConnect(playerid) {
    ResetPlayerData(playerid);
    ShowLoginOrRegister(playerid);
    // ��� load �ç��� �������� login_systems ���¡ LoadPlayerData ��ѧ login
    return 1;
}

public OnPlayerSpawn(playerid) {
    // �ӧҹ�͹ spawn (�����ѧ login ��� register)
    PlayerBoolData[playerid][Spawned] = true;

    // ����繺ѭ������ �������� data ���������� (�������Ŵ�ҡ DB)
    if (IsPlayerNewAccount(playerid) && !IsPlayerDataReady(playerid)) {
        // �纵��˹觻Ѩ�غѹ�繤����������á
        new Float:x, Float:y, Float:z, Float:a;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);
        PlayerFloatData[playerid][LastPosX] = FLOAT:x;
        PlayerFloatData[playerid][LastPosY] = FLOAT:y;
        PlayerFloatData[playerid][LastPosZ] = FLOAT:z;
        PlayerFloatData[playerid][LastAngle] = FLOAT:a;
        PlayerBoolData[playerid][DataReady] = true;
        // ૿ snapshot �á
        ForceSavePlayerData(playerid);
        PlayerBoolData[playerid][NewAccount] = false;
    }
    return 1;
}

// ------------------------------ Maps -------------------------------
public AutoSaveTick() {
    // ǹ૿�����蹷����͡�ԹẺ throttle-friendly (�� SavePlayerData)
    new count = 0;
    for (new i = 0; i < MAX_PLAYERS; i++) {
        if (!IsPlayerConnected(i)) continue; // ���������蹷�������������
        if (!IsPlayerLoggedIn(i)) continue; // ���������蹷���ѧ�����͡�Թ
        if (SavePlayerData(i)) count++; // �Ѻ�����蹷��૿�����
    }
    if (count > 0) {
        printf("[Autosave] Saved %d player(s)", count);
    }
    return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ) {
    // ��Ǩ�ͺ����� admin �������
    if (PlayerIntData[playerid][AdminLevel] > 0) {
        SetPlayerPosFindZ(playerid, fX, fY, fZ);
        SendClientMessage(playerid, 0x00FF00AA, "Teleported to clicked position");
        return 1;
    }
    return 0;
}

// OnDialogResponse moved to systems/dialog_systems.pwn

// ------------------------------ Exit ------------------------------------

public OnPlayerDisconnect(playerid, reason) {
    ForceSavePlayerData(playerid); // �ѧ�Ѻ૿�����ش���¡�͹�͡ (��͹��ҧ������)
    ResetPlayerData(playerid);
    return 1;
}

public OnGameModeExit() {
    printf("[Debug] Stop GameMode...");
    if (g_AutoSaveTimer != -1) { // ����� timer �ӧҹ����
        KillTimer(g_AutoSaveTimer);
        g_AutoSaveTimer = -1;
    }
    // ૿�����蹷����������ش����
    for (new i = 0; i < MAX_PLAYERS; i++) {
        if (IsPlayerConnected(i) && IsPlayerLoggedIn(i)) ForceSavePlayerData(i);
    }
    StopConnectToDatabase();
    
    return 1;
}
