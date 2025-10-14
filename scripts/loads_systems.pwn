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
    // ถ้ามี player_id แล้ว (เช่นกรณี future re-load) ใช้ค้นด้วย id แทนชื่อ
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

// Apply loaded cached values to in-memory structures & player state (แยกฟังก์ชันให้อ่านง่าย)
stock ApplyLoadedPlayerData(playerid) {
    // Clamp / validate ints
    if (PlayerIntData[playerid][Health] < 0) PlayerIntData[playerid][Health] = 0;
    if (PlayerIntData[playerid][Health] > 100) PlayerIntData[playerid][Health] = 100;
    if (PlayerIntData[playerid][Armour] < 0) PlayerIntData[playerid][Armour] = 0;
    if (PlayerIntData[playerid][Armour] > 100) PlayerIntData[playerid][Armour] = 100;

    // Basic sanity for position (กันค่าหลุดแบบ NaN หรือ Infinity ซึ่ง pawn อาจไม่เจอ แต่กันไว้)
    if (floatcmp(Float:PlayerFloatData[playerid][LastPosX], Float:PlayerFloatData[playerid][LastPosX]) != 0) PlayerFloatData[playerid][LastPosX] = FLOAT:0.0;
    if (floatcmp(Float:PlayerFloatData[playerid][LastPosY], Float:PlayerFloatData[playerid][LastPosY]) != 0) PlayerFloatData[playerid][LastPosY] = FLOAT:0.0;
    if (floatcmp(Float:PlayerFloatData[playerid][LastPosZ], Float:PlayerFloatData[playerid][LastPosZ]) != 0) PlayerFloatData[playerid][LastPosZ] = FLOAT:5.0;

    // Safeguard: ตรวจสอบว่ามีข้อมูลตำแหน่งที่ถูกต้องหรือไม่
    // ใช้เฉพาะกรณีที่มีตำแหน่งที่บันทึกไว้แล้ว (ไม่ใช่ค่า default หรือ new account)
    new bool:hasValidPosition = !(Float:PlayerFloatData[playerid][LastPosX] == 0.0 && Float:PlayerFloatData[playerid][LastPosY] == 0.0 && Float:PlayerFloatData[playerid][LastPosZ] == 0.0);

    // Apply scalar values
    SetPlayerHealth(playerid, float(PlayerIntData[playerid][Health]));
    SetPlayerArmour(playerid, float(PlayerIntData[playerid][Armour]));
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, PlayerIntData[playerid][Money]);
    SetPlayerSkin(playerid, PlayerIntData[playerid][Skin]);

    // Apply ตำแหน่งเฉพาะเมื่อมีข้อมูลที่บันทึกไว้แล้ว
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
    if (!IsPlayerConnected(playerid)) return 0; // ผู้เล่นออกก่อนโหลดเสร็จ

    if (cache_num_rows() == 0) {
        SendClientMessage(playerid, -1, "{FF0000}ไม่พบข้อมูลผู้เล่นในฐานข้อมูล (อาจถูกลบ)");
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

    // Spawn ผู้เล่นหลังข้อมูลโหลด (ลดการกระพริบตำแหน่ง)
    if (!HasPlayerSpawned(playerid)) {
        // ใช้ตำแหน่งจากฐานข้อมูล หรือใช้ตำแหน่ง default ถ้าไม่มีข้อมูล
        new Float:spawnX = Float:PlayerFloatData[playerid][LastPosX];
        new Float:spawnY = Float:PlayerFloatData[playerid][LastPosY]; 
        new Float:spawnZ = Float:PlayerFloatData[playerid][LastPosZ];
        new Float:spawnAngle = Float:PlayerFloatData[playerid][LastAngle];
        
        // ถ้าไม่มีตำแหน่งที่บันทึกไว้ (ทั้งหมดเป็น 0) ให้ใช้ตำแหน่ง default
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

    // Apply ข้อมูลหลังจาก spawn แล้ว (รวมถึงตำแหน่งที่แม่นยำ)
    ApplyLoadedPlayerData(playerid);
    PlayerBoolData[playerid][DataReady] = true; // ข้อมูลพร้อมแล้ว

    // โหลด inventory ของผู้เล่น
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
    SendClientMessage(playerid, -1, "{00FF00}ข้อมูลของคุณถูกโหลดเรียบร้อยแล้ว!");
    return 1;
}