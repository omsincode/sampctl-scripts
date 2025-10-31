// --------------------------- Include Guard ----------------------------------
#if defined _core_database_included
    #endinput
#endif
#define _core_database_included

// ------------------------------ Includes ------------------------------------
#include <a_mysql>

// ------------------------------ Globals -------------------------------------
new MySQL:mysql_handle = MYSQL_INVALID_HANDLE;
static bool:mysql_ready = false; // Prevent duplicate connections

// ------------------------------ Defines --------------------------------------
#define MYSQL_HOST      "localhost"
#define MYSQL_USER      "root"
#define MYSQL_PASSWORD  ""
#define MYSQL_DATABASE  "sampctl_database"

// ------------------------------ Stocks --------------------------------------
stock connect_to_database()
{
    if(mysql_ready && mysql_handle != MYSQL_INVALID_HANDLE)
    {
        print("[MySQL] already connected, skip new connection");
        return 1;
    }
    mysql_handle = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE);
    if(mysql_handle == MYSQL_INVALID_HANDLE || mysql_errno(mysql_handle) != 0)
    {
        printf("[MySQL] cannot connect (err %d)", mysql_errno(mysql_handle));
        return SendRconCommand("exit"); // Close server if DB connection fails
    }
    
    // ตั้งค่า charset เป็น UTF-8 เพื่อรองรับภาษาไทย
    mysql_tquery(mysql_handle, "SET NAMES utf8mb4");
    mysql_tquery(mysql_handle, "SET CHARACTER SET utf8mb4");
    
    mysql_ready = true;
    printf("[MySQL] Connected successfully with UTF-8 charset");
    return 1;
}

stock stop_connect_to_database()
{
    // Close MySQL connection when server exits
    if(mysql_handle != MYSQL_INVALID_HANDLE)
    {
        mysql_close(mysql_handle);
        printf("[MySQL] Close connection");
        mysql_handle = MYSQL_INVALID_HANDLE;
        mysql_ready = false;
    }
    return 1;
}

stock reconnect_to_database()
{
    // Reconnect in case connection is lost
    stop_connect_to_database();
    return connect_to_database();
}
