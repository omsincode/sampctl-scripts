// --------------------------- Include Guard ----------------------------------
#if defined _database_included
    #endinput
#endif
#define _database_included

// ------------------------------ Includes ------------------------------------
#include <a_mysql>

// ------------------------------ Globals -------------------------------------
new MySQL:dbHandle = MYSQL_INVALID_HANDLE;
static bool:g_DBReady = false; // ��ͧ�ѹ�������ͫ��

// ------------------------------ Defines --------------------------------------
#define MYSQL_HOST      "localhost"
#define MYSQL_USER      "root"
#define MYSQL_PASSWORD  ""
#define MYSQL_DATABASE  "sampctl_database"

// ------------------------------ Stocks --------------------------------------
stock ConnectToDatabase() {
    if (g_DBReady && dbHandle != MYSQL_INVALID_HANDLE) {
        print("[MySQL] already connected, skip new connection");
        return 1;
    }
    dbHandle = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE);
    if (dbHandle == MYSQL_INVALID_HANDLE || mysql_errno(dbHandle) != 0) {
        printf("[MySQL] cannot connect (err %d)", mysql_errno(dbHandle));
        return 0;
    }
    g_DBReady = true;
    print("[MySQL] successfully connected to database");
    return 1;
}

stock StopConnectToDatabase() { // �Դ����������� MySQL ���������
    if (dbHandle != MYSQL_INVALID_HANDLE) {
        mysql_close(dbHandle);
        printf("[MySQL] Close connection");
        dbHandle = MYSQL_INVALID_HANDLE;
        g_DBReady = false;
    }
    return 1;
}

stock ReconnectDatabase() { // ������ͨ��繵�ͧ��ʵ��췡����������
    StopConnectToDatabase();
    return ConnectToDatabase();
}
