// --------------------------- Include Guard ----------------------------------
#if defined _login_system_included
    #endinput
#endif
#define _login_system_included

// ------------------------------ Includes ------------------------------------
#include "scripts/database.pwn"
#include "scripts/player_data.pwn" // เพิ่มเพื่อใช้ PlayerBoolData / PlayerIntData
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
    SendClientMessage(playerid, 0x00FF00AA, "คุณได้เกิดใหม่แล้ว!");
}

stock ShowLoginDialog(playerid) { // แสดงหน้าล็อกอิน
    new string[128];
    format(string, sizeof(string), "{FFFFFF}ยินดีต้อนรับเข้าสู่เซิร์ฟเวอร์\nกรุณาใส่รหัสผ่านเพื่อเข้าสู่ระบบ:");
    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,
        "Login System", string, "เข้าสู่ระบบ", "ยกเลิก");
    return 1;
}

stock ShowRegisterDialog(playerid) { // แสดงหน้าสมัครสมาชิก
    new string[128];
    format(string, sizeof(string), "{FFFFFF}ยินดีต้อนรับสมาชิกใหม่\nกรุณาตั้งรหัสผ่านเพื่อสมัครสมาชิก:");
    ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,
        "Register System", string, "สมัครสมาชิก", "ยกเลิก");
    return 1;
}

stock CheckUsername(playerid) { // ตรวจสอบว่ามีชื่อผู้เล่นหรือยัง
    new query[128], playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playername, sizeof(playername));
    mysql_format(dbHandle, query, sizeof(query),
        "SELECT * FROM players WHERE player_name = '%e' LIMIT 1", playername);
    mysql_tquery(dbHandle, query, "OnUsernameCheck", "i", playerid);
    return 1;
}

stock LoginPlayer(playerid, const password[]) { // ล็อกอินผู้เล่น
    new query[256], playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playername, sizeof(playername));
    mysql_format(dbHandle, query, sizeof(query),
        "SELECT * FROM players WHERE player_name = '%e' AND player_password = '%e' LIMIT 1",
        playername, password);
    mysql_tquery(dbHandle, query, "OnPlayerLogin", "is", playerid, password);
    return 1;
}

stock RegisterPlayer(playerid, const password[]) { // สมัครสมาชิกผู้เล่น
    new query[512], playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playername, sizeof(playername));
    mysql_format(dbHandle, query, sizeof(query),
        "INSERT INTO players (player_name, player_password, player_admin, player_posx, player_posy, player_posz, player_angle, player_skin, player_money, player_health, player_armour, player_level, player_xp, player_gang) VALUES ('%e', '%e', 0, 0.0, 0.0, 0.0, 0.0, 0, 0, 100, 0, 1, 0, 0)",
        playername, password);
    mysql_tquery(dbHandle, query, "OnPlayerRegister", "is", playerid, password);
    return 1;
}

stock ResetPlayerData(playerid) { // รีเซ็ตข้อมูลผู้เล่นเมื่อออกหรือเริ่มใหม่
    PlayerBoolData[playerid][IsLoggedIn] = false;
    PlayerIntData[playerid][LoginAttempts] = 0;
    PlayerBoolData[playerid][DataReady] = false;
    PlayerBoolData[playerid][NewAccount] = false;
    PlayerBoolData[playerid][Spawned] = false;
    // ล้างค่า int แบบระบุ (หลีกเลี่ยง tag mismatch warning)
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
    // ล้างค่า float
    PlayerFloatData[playerid][LastPosX] = FLOAT:0.0;
    PlayerFloatData[playerid][LastPosY] = FLOAT:0.0;
    PlayerFloatData[playerid][LastPosZ] = FLOAT:0.0;
    PlayerFloatData[playerid][LastAngle] = FLOAT:0.0;
    return 1;
}


stock ShowLoginOrRegister(playerid) { // ตรวจสอบและโชว์หน้าที่เหมาะสม
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
    // หากพบข้อมูล (ล็อกอินสำเร็จ)
    if (cache_num_rows() > 0) {
        PlayerBoolData[playerid][IsLoggedIn] = true;
        SendClientMessage(playerid, -1, "{00FF00}เข้าสู่ระบบสำเร็จ!");
        LoadPlayerData(playerid); // จะ spawn หลังโหลดข้อมูลใน OnPlayerDataLoad
        return 1; // ออกทันทีหลังสำเร็จ
    }

    // กรณีไม่พบ (รหัสผ่านผิด) - เพิ่มจำนวนครั้ง
    PlayerIntData[playerid][LoginAttempts]++;

    if (PlayerIntData[playerid][LoginAttempts] >= 3) { // เกิน 3 ครั้ง
        SendClientMessage(playerid, -1, "{FF0000}คุณใส่รหัสผ่านผิดเกิน 3 ครั้ง!");
        Kick(playerid);
        return 1;
    }

    // ยังไม่ครบ 3 ครั้ง แจ้งเตือนและให้ลองใหม่
    SendClientMessage(playerid, -1, "{FF0000}รหัสผ่านไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง!");
    ShowLoginDialog(playerid);
    return 1;
}

public OnPlayerRegister(playerid, const password[]) {
    if (cache_affected_rows() > 0) {
        PlayerBoolData[playerid][IsLoggedIn] = true;
        PlayerBoolData[playerid][NewAccount] = true; // ระบุว่าเป็นบัญชีใหม่
        // เก็บค่า insert id (primary key) สำหรับใช้ในการ UPDATE ถัดไป
        PlayerIntData[playerid][PlayerID] = cache_insert_id();
        SendClientMessage(playerid, -1, "{00FF00}สมัครสมาชิกและเข้าสู่ระบบสำเร็จ!");
        SetPlayerSpawn(playerid); // จะเซฟหลัง DataReady เช่นกัน
    } else {
        SendClientMessage(playerid, -1, "{FF0000}เกิดข้อผิดพลาดในการสมัครสมาชิก!");
        ShowRegisterDialog(playerid);
    }
    return 1;
}

public OnCheckAccount(playerid) {
    if (cache_num_rows() > 0) {
        ShowLoginDialog(playerid);
        SendClientMessage(playerid, -1, "{FFFF00}ตรวจพบบัญชีของคุณในระบบ กรุณาเข้าสู่ระบบ");
    } else {
        ShowRegisterDialog(playerid);
        SendClientMessage(playerid, -1, "{FFFF00}ไม่พบบัญชีของคุณในระบบ กรุณาสมัครสมาชิก");
    }
    return 1;
}
