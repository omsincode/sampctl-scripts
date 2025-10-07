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

// กำหนดค่าเซิร์ฟเวอร์
#define HOSTNAME        "Star Town" // ชื่อเซิร์ฟเวอร์
#define MAPNAME         "THAILAND"
#define WEBURL          "commingson"
#define VERSION         "V1.0.0" // เวอร์ชันของเซิร์ฟเวอร์
// กำหนดค่าเซิร์ฟเวอร์

// -------------------------- Autosave Settings ------------------------------
#define AUTOSAVE_INTERVAL_MS   (300000) // 5 นาทีต่อรอบ
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
    // ไม่ load ตรงนี้ ปล่อยให้ login_systems เรียก LoadPlayerData หลัง login
    return 1;
}

public OnPlayerSpawn(playerid) {
    // ทำงานตอน spawn (ทั้งหลัง login และ register)
    PlayerBoolData[playerid][Spawned] = true;

    // ถ้าเป็นบัญชีใหม่ ให้ถือว่า data พร้อมได้เลย (ไม่มีโหลดจาก DB)
    if (IsPlayerNewAccount(playerid) && !IsPlayerDataReady(playerid)) {
        // เก็บตำแหน่งปัจจุบันเป็นค่าเริ่มต้นแรก
        new Float:x, Float:y, Float:z, Float:a;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);
        PlayerFloatData[playerid][LastPosX] = FLOAT:x;
        PlayerFloatData[playerid][LastPosY] = FLOAT:y;
        PlayerFloatData[playerid][LastPosZ] = FLOAT:z;
        PlayerFloatData[playerid][LastAngle] = FLOAT:a;
        PlayerBoolData[playerid][DataReady] = true;
        // เซฟ snapshot แรก
        ForceSavePlayerData(playerid);
        PlayerBoolData[playerid][NewAccount] = false;
    }
    return 1;
}

// ------------------------------ Maps -------------------------------
public AutoSaveTick() {
    // วนเซฟผู้เล่นที่ล็อกอินแบบ throttle-friendly (ใช้ SavePlayerData)
    new count = 0;
    for (new i = 0; i < MAX_PLAYERS; i++) {
        if (!IsPlayerConnected(i)) continue; // ข้ามผู้เล่นที่ไม่เชื่อมต่อ
        if (!IsPlayerLoggedIn(i)) continue; // ข้ามผู้เล่นที่ยังไม่ล็อกอิน
        if (SavePlayerData(i)) count++; // นับผู้เล่นที่เซฟสำเร็จ
    }
    if (count > 0) {
        printf("[Autosave] Saved %d player(s)", count);
    }
    return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ) {
    // ตรวจสอบว่าเป็น admin หรือไม่
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
    ForceSavePlayerData(playerid); // บังคับเซฟครั้งสุดท้ายก่อนออก (ก่อนล้างข้อมูล)
    ResetPlayerData(playerid);
    return 1;
}

public OnGameModeExit() {
    printf("[Debug] Stop GameMode...");
    if (g_AutoSaveTimer != -1) { // ถ้ามี timer ทำงานอยู่
        KillTimer(g_AutoSaveTimer);
        g_AutoSaveTimer = -1;
    }
    // เซฟผู้เล่นทั้งหมดครั้งสุดท้าย
    for (new i = 0; i < MAX_PLAYERS; i++) {
        if (IsPlayerConnected(i) && IsPlayerLoggedIn(i)) ForceSavePlayerData(i);
    }
    StopConnectToDatabase();
    
    return 1;
}
