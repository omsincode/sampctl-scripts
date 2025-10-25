// --------------------------- Include Guard ----------------------------------
#if defined _database_included
    #endinput
#endif
#define _database_included

// ------------------------------ Includes ------------------------------------
#include <a_mysql>

// ------------------------------ Globals -------------------------------------
new MySQL:mysql_handle = MYSQL_INVALID_HANDLE;
static bool:mysql_ready = false; // ป้องกันเชื่อมต่อซ้ำ

// ------------------------------ Defines --------------------------------------
#define MYSQL_HOST      "localhost"
#define MYSQL_USER      "root"
#define MYSQL_PASSWORD  ""
#define MYSQL_DATABASE  "startown_database"

// ------------------------------ Stocks --------------------------------------
stock connect_to_database()
{
    if (mysql_ready && mysql_handle != MYSQL_INVALID_HANDLE)
    {
        print("[MySQL] already connected, skip new connection");
        return 1;
    }
    mysql_handle = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE);
    if (mysql_handle == MYSQL_INVALID_HANDLE || mysql_errno(mysql_handle) != 0)
    {
        printf("[MySQL] cannot connect (err %d)", mysql_errno(mysql_handle));
        return SendRconCommand("exit"); // ปิด server ถ้าเชื่อมต่อ DB ไม่ได้
    }
    mysql_ready = true;
    return 1;
}

stock stop_connect_to_database()
{ // ปิดการเชื่อมต่อ MySQL ถ้ามีอยู่
    if (mysql_handle != MYSQL_INVALID_HANDLE)
    {
        mysql_close(mysql_handle);
        printf("[MySQL] Close connection");
        mysql_handle = MYSQL_INVALID_HANDLE;
        mysql_ready = false;
    }
    return 1;
}

stock reconnect_to_database()
{ // ใช้เมื่อจำเป็นต้องรีสตาร์ทการเชื่อมต่อ
    stop_connect_to_database();
    return connect_to_database();
}
