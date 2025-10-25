// --------------------------- Include Guard ----------------------------------
#include <a_samp>
#include <a_mysql>
#include <zcmd>

// ------------------------------ Includes ------------------------------------
#include "code/core/core_database.inc"

// ------------------------------ Server Configuration ------------------------
#define HOSTNAME        "Star Town"     // Server name
#define MAPNAME         "THAILAND"
#define WEBURL          "commingson"
#define VERSION         "V1.0.0"        // Server version

// ------------------------------ Main ----------------------------------------
main()
{
    return 1;
}


// ------------------------------ Login ---------------------------------------
public OnGameModeInit()
{
    connect_to_database();
    return 1;
}

public OnPlayerConnect(playerid)
{
    return 1;
}

public OnPlayerSpawn(playerid)
{
    return 1;
}

// ------------------------------ Maps ----------------------------------------

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    return 1;
}

// public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
// {
//     // Check if player is admin or higher
//     if(player_data[playerid][admin] > 0)
//     {
//         SetPlayerPosFindZ(playerid, fX, fY, fZ);
//         SendClientMessage(playerid, 0x00FF00AA, "Teleported to clicked position");
//         return 1;
//     }
//     return 0;
// }

// OnDialogResponse moved to core_player_dialogs.inc

// ------------------------------ Exit ----------------------------------------

public OnPlayerDisconnect(playerid, reason)
{
    return 1;
}

public OnGameModeExit()
{
    stop_connect_to_database();
    return 1;
}
