// --------------------------- Include Guard ----------------------------------
#if defined _core_player_data_included
    #endinput
#endif
#define _core_player_data_included

// ------------------------------ Includes ------------------------------------
#include <a_mysql>

// ------------------------------ Player Data Enum ----------------------------

enum player_data
{
    // String Data
    player_name[MAX_PLAYER_NAME],
    player_password[65],
    
    // Integer Data
    player_id,
    player_admin_level,
    player_skin,
    
    // Float Data
    Float:player_money,
    Float:player_health,
    Float:player_armour,
    Float:player_hunger,
    Float:player_thirst,
    Float:player_position_x,
    Float:player_position_y,
    Float:player_position_z,
    
    // Boolean Data
    bool:player_logged_in
};

new player_info[MAX_PLAYERS][player_data];

// ------------------------------ Functions -----------------------------------

stock reset_player_data(playerid)
{
    player_info[playerid][player_id] = 0;
    player_info[playerid][player_name][0] = EOS;
    player_info[playerid][player_password][0] = EOS;
    player_info[playerid][player_admin_level] = 0;
    player_info[playerid][player_skin] = 0;
    player_info[playerid][player_money] = 0.0;
    player_info[playerid][player_health] = 0.0;
    player_info[playerid][player_armour] = 0.0;
    player_info[playerid][player_position_x] = 0.0;
    player_info[playerid][player_position_y] = 0.0;
    player_info[playerid][player_position_z] = 0.0;
    player_info[playerid][player_logged_in] = false;
    return 1;
}