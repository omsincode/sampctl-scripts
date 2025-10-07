// --------------------------- Include Guard ----------------------------------
#if defined _player_data_included
    #endinput
#endif
#define _player_data_included

// ------------------------------ Player Data ---------------------------------
stock getplayername(playerid) {
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}

enum E_PLAYER_INT_DATA {
    PlayerID,
    AdminLevel,
    Skin,
    Money,
    Health,
    Armour,
    Level,
    XP,
    Gang,
    LoginAttempts
};
new PlayerIntData[MAX_PLAYERS][E_PLAYER_INT_DATA];

enum E_PLAYER_FLOAT_DATA {
    FLOAT:LastPosX,
    FLOAT:LastPosY,
    FLOAT:LastPosZ,
    FLOAT:LastAngle
};
    new FLOAT:PlayerFloatData[MAX_PLAYERS][E_PLAYER_FLOAT_DATA];

enum E_PLAYER_BOOL_DATA { bool:IsLoggedIn, bool:DataReady, bool:NewAccount, bool:Spawned };
new PlayerBoolData[MAX_PLAYERS][E_PLAYER_BOOL_DATA];

// ------------------------------ Helper Macro --------------------------------
// ใช้ macro แทน stock function เพื่อลดโอกาส symbol ซ้ำเวลา include หลาย path
#if defined IsPlayerLoggedIn
    #undef IsPlayerLoggedIn
#endif
#define IsPlayerLoggedIn(%0) (PlayerBoolData[%0][IsLoggedIn])
#define IsPlayerDataReady(%0) (PlayerBoolData[%0][DataReady])
#define IsPlayerNewAccount(%0) (PlayerBoolData[%0][NewAccount])
#define HasPlayerSpawned(%0) (PlayerBoolData[%0][Spawned])

stock ResetAllPlayerData(playerid) {
    PlayerBoolData[playerid][IsLoggedIn] = false;
    PlayerBoolData[playerid][DataReady] = false;
    PlayerBoolData[playerid][NewAccount] = false;
    PlayerBoolData[playerid][Spawned] = false;
    PlayerIntData[playerid][LoginAttempts] = 0;
    return 1;
}
