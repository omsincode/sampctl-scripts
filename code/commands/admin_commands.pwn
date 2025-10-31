// --------------------------- Include Guard ----------------------------------
#if defined _admin_commands_included
    #endinput
#endif
#define _admin_commands_included

// ------------------------------ Includes ------------------------------------
#include <a_samp>
#include <code/core/core_player_data>

// ------------------------------ Helper Functions ----------------------------
stock IsPlayerLoggedIn(playerid) {
    return player_info[playerid][player_logged_in];
}

stock getplayername(playerid) {
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}

// ------------------------------ Defines -------------------------------------
#define COLOR_RED     0xFF0000FF
#define COLOR_GREEN   0x00FF00FF
#define COLOR_YELLOW  0xFFFF00FF
#define COLOR_WHITE   0xFFFFFFFF

// ------------------------------ Dialog IDs ----------------------------------
#define DIALOG_ADMIN_HELP         101

// ------------------------ External Variables --------------------------------
// ���������Ѻ�Դ���ö������ҧ (��С�Ȩ�ԧ� main.pwn)
#if !defined MAX_SPAWNED_VEHICLES
    #define MAX_SPAWNED_VEHICLES 100
#endif

#if !defined g_SpawnedVehicles
    new g_SpawnedVehicles[MAX_SPAWNED_VEHICLES];
    new g_SpawnedVehicleCount = 0;
#endif

// ------------------------ Spawned Vehicle Tracking --------------------------
// �ѧ��ѹ�Դ���ö���١���ҧ���
stock AddSpawnedVehicle(vehicleid) {
    if(g_SpawnedVehicleCount >= MAX_SPAWNED_VEHICLES) {
        return 0; // �������
    }
    g_SpawnedVehicles[g_SpawnedVehicleCount] = vehicleid;
    g_SpawnedVehicleCount++;
    return 1;
}

// �ѧ��ѹźö�͡�ҡ��ʵ���Դ���
stock RemoveSpawnedVehicle(vehicleid) {
    for(new i = 0; i < g_SpawnedVehicleCount; i++) {
        if(g_SpawnedVehicles[i] == vehicleid) {
            // ����͹�ء��ҷ�������ҧ˹ѧ��
            for(new j = i; j < g_SpawnedVehicleCount - 1; j++) {
                g_SpawnedVehicles[j] = g_SpawnedVehicles[j + 1];
            }
            g_SpawnedVehicleCount--;
            return 1;
        }
    }
    return 0;
}

// �ѧ��ѹ��ö��Ҷ١���ҧ�¤�����������
stock IsSpawnedVehicle(vehicleid) {
    for(new i = 0; i < g_SpawnedVehicleCount; i++) {
        if(g_SpawnedVehicles[i] == vehicleid) {
            return 1;
        }
    }
    return 0;
}

// ------------------------------ Stocks -----------------------------------
// �ѧ��ѹ�¡����������
stock SplitParams(const string[], args[][32], maxArgs = sizeof(args)) {
    new argCount = 0;
    new length = strlen(string);
    new start = 0;
    new end = 0;
    
    while(end < length && argCount < maxArgs) {
        // ������ͧ��ҧ
        while(end < length && string[end] == ' ') end++;
        start = end;
        
        // �Ҩش����ش�ͧ�ӶѴ�
        while(end < length && string[end] != ' ') end++;
        
        if(start < end) {
            // �ӡѴ��������٧�ش 31 ����ѡ�� (����� 1 �������Ѻ '\0')
            if(end - start > 31) {
                end = start + 31;
            }
            strmid(args[argCount], string, start, end, 32); // �Ѵ�͡੾����ǹ˹��
            argCount++;
        }
    }
    
    return argCount;
}

// �ѧ��ѹ�֧����ö
stock GetVehicleName(vehicleid, vehiclename[], len) {
    new vNames[212][] = {
        "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perennial", "Sentinel", "Dumper",
        "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule",
        "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington",
        "Bobcat", "Mr Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer", "Securicar",
        "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon",
        "Coach", "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster",
        "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder",
        "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", "Berkley's RC Van", "Skimmer",
        "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic", "Sanchez",
        "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler",
        "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage",
        "Dozer", "Maverick", "News Chopper", "Rancher", "FBI Rancher", "Virgo", "Greenwood",
        "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick", "Boxville", "Benson",
        "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher",
        "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropdust", "Stunt",
        "Tanker", "RoadTrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900",
        "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune", "Cadrona", "FBI Truck",
        "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan",
        "Blade", "Freight", "Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler",
        "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit",
        "Utility", "Nevada", "Yosemite", "Windsor", "Monster A", "Monster B", "Uranus", "Jester",
        "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna",
        "Bandito", "Freight", "Trailer", "Kart", "Mower", "Duneride", "Sweeper", "Broadway",
        "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "Newsvan", "Tug",
        "Trailer A", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "Trailer B", "Trailer C",
        "Andromada", "Dodo", "RC Cam", "Launch", "Police Car (LSPD)", "Police Car (SFPD)",
        "Police Car (LVPD)", "Police Ranger", "Picador", "S.W.A.T. Van", "Alpha", "Phoenix",
        "Glendale", "Sadler", "Luggage Trailer A", "Luggage Trailer B", "Stair Trailer", "Boxville",
        "Farm Plow", "Utility Trailer"
    };
    
    vehicleid -= 400; // �ŧ ID ö�� index �ͧ array
    if(vehicleid < 0 || vehicleid >= sizeof(vNames)) { // ��Ǩ�ͺ index �������㹪�ǧ���١��ͧ
        format(vehiclename, len, "Unknown");
        return 0;
    }
    
    format(vehiclename, len, "%s", vNames[vehicleid]);
    return 1;
}

// ------------------------------ Short Commands -----------------------------------
// �������ͷ�����¡��ѧ��ѹ���

CMD:v(playerid, params[]) {
    return cmd_vehicle(playerid, params);
}

CMD:dv(playerid, params[]) {
    return cmd_deletevehicle(playerid, params);
}

CMD:fix(playerid, params[]) {
    return cmd_repair(playerid, params);
}

CMD:a(playerid, params[]) {
    return cmd_adminhelp(playerid, params);
}

CMD:admin(playerid, params[]) {
    return cmd_adminhelp(playerid, params);
}

CMD:ahelp(playerid, params[]) {
    return cmd_adminhelp(playerid, params);
}

CMD:clearveh(playerid, params[]) {
    return cmd_clearspawnedvehicles(playerid, params);
}

CMD:cveh(playerid, params[]) {
    return cmd_clearspawnedvehicles(playerid, params);
}

// ------------------------------ Fully Commands ----------------------------------
// �����Ẻ������ӧҹ��ԧ

// �����źö������ҧ������ (੾��ö����ʹ�Թ���ҧ) /clearspawnedvehicles
CMD:clearspawnedvehicles(playerid, params[]) {
    if(!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || player_info[playerid][player_admin_level] < 2) {
        SendClientMessage(playerid, COLOR_RED, "��ͼԴ��Ҵ: �س��ͧ���ʹ�Թ�дѺ 2 ����!");
        return 1;
    }
    
    new deletedCount = 0;
    new skipCount = 0;
    
    // ǹ�ٻźö������ҧ������ (�ҡ��ҹ��ѧ������ա����§ index �Դ)
    for(new i = g_SpawnedVehicleCount - 1; i >= 0; i--) {
        new vehicleid = g_SpawnedVehicles[i];
        
        // ������դ��ö���
        new hasPassenger = 0;
        for(new p = 0; p < MAX_PLAYERS; p++) {
            if(IsPlayerConnected(p) && IsPlayerInVehicle(p, vehicleid)) {
                hasPassenger = 1;
                break;
            }
        }
        
        // �������դ�� ��źö
        if(!hasPassenger) {
            DestroyVehicle(vehicleid);
            RemoveSpawnedVehicle(vehicleid);
            deletedCount++;
        } else {
            skipCount++;
        }
    }
    
    // �觢�ͤ����駼�����
    new message[128];
    format(message, sizeof(message), "źö������ҧ����: %d �ѹ | ���� (�ռ�������): %d �ѹ", deletedCount, skipCount);
    SendClientMessage(playerid, COLOR_GREEN, message);
    
    // Log ���㹤͹��
    new logmsg[256];
    format(logmsg, sizeof(logmsg), "[ADMIN] %s ������źö������ҧ ź� %d �ѹ", getplayername(playerid), deletedCount);
    print(logmsg);
    
    return 1;
}

// ��������ҧöẺ��� /vehicle
CMD:vehicle(playerid, params[]) {
    // ��ͧ���ʹ�Թ�дѺ 1 ���件֧����
    if(!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || player_info[playerid][player_admin_level] < 1) {
        SendClientMessage(playerid, COLOR_RED, "��ͼԴ��Ҵ: �س������Է��������觹��!");
        return 1;
    }
    
    new vehicleid, color1 = -1, color2 = -1;
    
    // ��Ǩ�ͺ����������
    if(strlen(params) == 0) {
        SendClientMessage(playerid, COLOR_YELLOW, "�Ը���: /vehicle [�ʹ�ö] [��1] [��2]");
        SendClientMessage(playerid, COLOR_WHITE, "������ҧ: /vehicle 411 (/v 411) - ���ҧö Infernus");
        SendClientMessage(playerid, COLOR_WHITE, "������ҧ: /vehicle 411 0 1 - ���ҧö Infernus �մ�-���");
        return 1;
    }
    
    new args[3][32];
    new argCount = SplitParams(params, args);
    
    vehicleid = strval(args[0]);
    if(argCount > 1) color1 = strval(args[1]); // ���á
    if(argCount > 2) color2 = strval(args[2]); // ���ͧ
    
    // ��Ǩ�ͺ�ʹ�ö��Ҷ١��ͧ������� (400-611)
    if(vehicleid < 400 || vehicleid > 611) {
        SendClientMessage(playerid, COLOR_RED, "��ͼԴ��Ҵ: �ʹ�ö���١��ͧ! (400-611)");
        return 1;
    }
    
    // ���������������к���
    if(color1 == -1) color1 = random(256); // ���á
    if(color2 == -1) color2 = random(256); // ���ͧ
    
    // �֧���˹觼�����
    new Float:x, Float:y, Float:z, Float:angle;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, angle);
    
    // ���ҧö����
    new vehicleobj = CreateVehicle(vehicleid, x + 3.0, y, z, angle, color1, color2, -1);
    
    if(vehicleobj == INVALID_VEHICLE_ID) { // ������ҧö��������
        SendClientMessage(playerid, COLOR_RED, "��ͼԴ��Ҵ: �������ö���ҧö��!");
        return 1;
    }
    
    // ����öŧ��ʵ���Դ���
    AddSpawnedVehicle(vehicleobj);
    
    // ��觼�����ŧö
    PutPlayerInVehicle(playerid, vehicleobj, 0);
    
    // �觢�ͤ����ͺ��Ѻ
    new message[128], vehiclename[32];
    GetVehicleName(vehicleid, vehiclename, sizeof(vehiclename));
    format(message, sizeof(message), "���ҧö %s (ID: %d) ���º����! ��: %d-%d", vehiclename, vehicleid, color1, color2);
    SendClientMessage(playerid, COLOR_GREEN, message);
    
    // Log ���㹤͹��
    new logmsg[256];
    format(logmsg, sizeof(logmsg), "[ADMIN] %s ���ҧö %s (ID: %d)", getplayername(playerid), vehiclename, vehicleid);
    print(logmsg);
    
    return 1;
}

// �����źöẺ��� /deletevehicle
CMD:deletevehicle(playerid, params[]) {
    if(!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || player_info[playerid][player_admin_level] < 1) {
        SendClientMessage(playerid, COLOR_RED, "��ͼԴ��Ҵ: �س������Է��������觹��!");
        return 1;
    }
    
    if(!IsPlayerInAnyVehicle(playerid)) { // ��Ǩ�ͺ��Ҽ����������ö�������
        SendClientMessage(playerid, COLOR_RED, "��ͼԴ��Ҵ: �س��ͧ�����ö����źö!");
        return 1;
    }
    
    new vehicleobj = GetPlayerVehicleID(playerid);
    new vehiclemodel = GetVehicleModel(vehicleobj);
    new vehiclename[32];
    GetVehicleName(vehiclemodel, vehiclename, sizeof(vehiclename));
    
    DestroyVehicle(vehicleobj); // źö
    
    new message[128];
    format(message, sizeof(message), "źö %s ���º����!", vehiclename);
    SendClientMessage(playerid, COLOR_GREEN, message);
    
    return 1;
}

// ����觫���öẺ��� /repair
CMD:repair(playerid, params[]) {
    if(!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || player_info[playerid][player_admin_level] < 1) {
        SendClientMessage(playerid, COLOR_RED, "��ͼԴ��Ҵ: �س������Է��������觹��!");
        return 1;
    }
    
    if(!IsPlayerInAnyVehicle(playerid)) { // ��Ǩ�ͺ��Ҽ����������ö�������
        SendClientMessage(playerid, COLOR_RED, "��ͼԴ��Ҵ: �س��ͧ�����ö���ͫ���ö!");
        return 1;
    }
    
    new vehicleobj = GetPlayerVehicleID(playerid);
    RepairVehicle(vehicleobj); // ����ö
    
    SendClientMessage(playerid, COLOR_GREEN, "����ö���º��������!");
    
    return 1;
}

// ������ʴ���������������ʹ�Թ /adminhelp
CMD:adminhelp(playerid, params[]) {
    if(!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || player_info[playerid][player_admin_level] < 1) {
        SendClientMessage(playerid, COLOR_RED, "��ͼԴ��Ҵ: �س������Է��������觹��!");
        return 1;
    }
    
    ShowAdminHelpDialog(playerid);
    return 1;
}

// ------------------------------ Dialog Admin Help ---------------------------------
// �ʴ� Dialog �������¡�ä��������Ѻ�ʹ�Թ
stock ShowAdminHelpDialog(playerid) {
    if(!IsPlayerLoggedIn(playerid) || player_info[playerid][player_admin_level] < 1) {
        SendClientMessage(playerid, 0xFF0000AA, "��ͼԴ��Ҵ: �س������Է��������觹��!");
        return 0;
    }
    
    new list_content[1024];

    // �ʴ�੾�Ф���觷������Ǣ�ͧ ������ö��������
    strcat(list_content, "{00FF00}/vehicle [ID] [��1] [��2]{FFFFFF} - ���ҧö\n");
    strcat(list_content, "{00FF00}/deletevehicle{FFFFFF} - źö\n");
    strcat(list_content, "{00FF00}/clearspawnedvehicles{FFFFFF} - źö������ҧ������ (����դ��)\n");
    strcat(list_content, "{00FF00}/repair{FFFFFF} - ����ö\n");
    strcat(list_content, "{00FF00}/giveitem [ID] [ItemIndex] [�ӹǹ]{FFFFFF} - �������\n");
    strcat(list_content, "{00FF00}/createitem [����] [���˹ѡ] [��͸Ժ��]{FFFFFF} - ���ҧ��������\n");
    strcat(list_content, "{00FF00}/reloaditems{FFFFFF} - ��Ŵ��������\n");
    strcat(list_content, "{00FF00}/itemlist{FFFFFF} - �ʴ���¡������\n");
    strcat(list_content, "{00FF00}/adminhelp{FFFFFF} - �ʴ�������������͹��");

    ShowPlayerDialog(playerid, DIALOG_ADMIN_HELP, DIALOG_STYLE_LIST,
        "�����ͤ�����ʹ�Թ (���͡����ʹ���������´)", list_content, "���͡", "�Դ");
    return 1;
}

// �觢�ͤ����й��Ը���ҹ����� (੾�Ф�������͡)
stock ShowAdminCommandUsage(playerid, index) {
    switch(index) {
        case 0: { // /vehicle
            SendClientMessage(playerid, COLOR_YELLOW, "�Ը���: /vehicle [�ʹ�ö] [��1] [��2]");
            SendClientMessage(playerid, COLOR_WHITE,  "������ҧ: /vehicle 411 0 1  |  �ҧ�Ѵ: /v 411 0 1");
            SendClientMessage(playerid, COLOR_GREEN,  "���͹�: �ʹ�Թ�дѺ 1+, �ʹ�ö 400-611");
        }
        case 1: { // /deletevehicle
            SendClientMessage(playerid, COLOR_YELLOW, "�Ը���: /deletevehicle  |  �ҧ�Ѵ: /dv");
            SendClientMessage(playerid, COLOR_WHITE,  "�����˵�: ��ͧ�����ö����ͧ���ź");
        }
        case 2: { // /clearspawnedvehicles
            SendClientMessage(playerid, COLOR_YELLOW, "�Ը���: /clearspawnedvehicles  |  �ҧ�Ѵ: /clearveh, /cveh");
            SendClientMessage(playerid, COLOR_WHITE,  "�����˵�: źö����ʡ�ҡ����觷����� (੾��ö�������դ����)");
            SendClientMessage(playerid, COLOR_GREEN,  "��͡�˹�: �ʹ�Թ����� 2+");
        }
        case 3: { // /repair
            SendClientMessage(playerid, COLOR_YELLOW, "�Ը���: /repair  |  �ҧ�Ѵ: /fix");
            SendClientMessage(playerid, COLOR_WHITE,  "�����˵�: ��ͧ��������ö���Ы���");
        }
        case 4: { // /giveitem
            SendClientMessage(playerid, COLOR_YELLOW, "�Ը���: /giveitem [PlayerID] [ItemIndex] [�ӹǹ]");
            SendClientMessage(playerid, COLOR_WHITE,  "������ҧ: /giveitem 0 1 5  (�������� index 1 �ӹǹ 5 ���������� ID 0)");
            SendClientMessage(playerid, COLOR_GREEN,  "��͡�˹�: �ʹ�Թ����� 3+");
        }
        case 5: { // /createitem
            SendClientMessage(playerid, COLOR_YELLOW, "�Ը���: /createitem [���������] [���˹ѡ] [��͸Ժ��]");
            SendClientMessage(playerid, COLOR_WHITE,  "������ҧ: /createitem Sword 2.5 �Һ���硤���Ժ");
            SendClientMessage(playerid, COLOR_GREEN,  "��͡�˹�: �ʹ�Թ����� 5+");
        }
        case 6: { // /reloaditems
            SendClientMessage(playerid, COLOR_YELLOW, "�Ը���: /reloaditems");
            SendClientMessage(playerid, COLOR_WHITE,  "�����˵�: ��Ŵ���������������ҡ�ҹ������");
            SendClientMessage(playerid, COLOR_GREEN,  "��͡�˹�: �ʹ�Թ����� 5+");
        }
        case 7: { // /itemlist
            SendClientMessage(playerid, COLOR_YELLOW, "�Ը���: /itemlist");
            SendClientMessage(playerid, COLOR_WHITE,  "�����˵�: �ʴ���¡���������������к� (�٧�ش 50 ��¡��)");
            SendClientMessage(playerid, COLOR_GREEN,  "��͡�˹�: �ʹ�Թ����� 1+");
        }
        case 8: { // /adminhelp
            SendClientMessage(playerid, COLOR_YELLOW, "�Ը���: /adminhelp  |  �ҧ�Ѵ: /ahelp, /admin, /a");
            SendClientMessage(playerid, COLOR_WHITE,  "��÷ӧҹ: �Դ˹�Ҥ�������������ʹ�Թ");
        }
        default: {
            SendClientMessage(playerid, COLOR_RED, "��辺�������Ը���ͧ����觷�����͡");
        }
    }
    return 1;
}
