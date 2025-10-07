// --------------------------- Include Guard ----------------------------------
#if defined _admin_commands_included
    #endinput
#endif
#define _admin_commands_included

// ------------------------------ Includes ------------------------------------
#include <a_samp>

// ------------------------------ Defines -------------------------------------
#define COLOR_RED     0xFF0000FF
#define COLOR_GREEN   0x00FF00FF
#define COLOR_YELLOW  0xFFFF00FF
#define COLOR_WHITE   0xFFFFFFFF

// ------------------------------ Dialog IDs ----------------------------------
#define DIALOG_ADMIN_HELP         101

// ------------------------------ Stocks -----------------------------------
// �ѧ��ѹ�����¡����������
stock SplitParams(const string[], args[][32], maxArgs = sizeof(args)) {
    new argCount = 0;
    new length = strlen(string);
    new start = 0;
    new end = 0;
    
    while(end < length && argCount < maxArgs) {
        // ������ͧ��ҧ
        while(end < length && string[end] == ' ') end++;
        start = end;
        
        // �Ҩش����ش�ͧ����������
        while(end < length && string[end] != ' ') end++;
        
        if(start < end) {
            // �ӡѴ��������٧�ش 31 ����ѡ�� (���� 1 �������Ѻ '\0')
            if(end - start > 31) {
                end = start + 31;
            }
            strmid(args[argCount], string, start, end, 32); // �Ѵ�͡੾�Ъ�ǧ����˹�
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
// �����Ẻ��鹷�����¡���������

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

// ------------------------------ Fully Commands ----------------------------------
// �����Ẻ���������ѧ��ѹ��÷ӧҹ������

// ������ʡöẺ��� /vehicle
CMD:vehicle(playerid, params[]) {
    // ��������ʹ�Թ�дѺ 1 �����������
    if(!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || PlayerIntData[playerid][AdminLevel] < 1) {
        SendClientMessage(playerid, COLOR_RED, "��ͼԴ��Ҵ: �س������Է��������觹��!");
        return 1;
    }
    
    new vehicleid, color1 = -1, color2 = -1;
    
    // ��Ǩ�ͺ����������
    if(strlen(params) == 0) {
        SendClientMessage(playerid, COLOR_YELLOW, "�Ը���: /vehicle [����ö] [��1] [��2]");
        SendClientMessage(playerid, COLOR_WHITE, "������ҧ: /vehicle 411 (/v 411) - �ʡö Infernus");
        SendClientMessage(playerid, COLOR_WHITE, "������ҧ: /vehicle 411 0 1 - �ʡö Infernus �մ�-���");
        return 1;
    }
    
    new args[3][32];
    new argCount = SplitParams(params, args);
    
    vehicleid = strval(args[0]);
    if(argCount > 1) color1 = strval(args[1]); // ����ѡ
    if(argCount > 2) color2 = strval(args[2]); // ���ͧ
    
    // ��Ǩ�ͺ����ö��Ҷ١��ͧ������� (400-611)
    if(vehicleid < 400 || vehicleid > 611) {
        SendClientMessage(playerid, COLOR_RED, "��ͼԴ��Ҵ: ����ö���١��ͧ! (400-611)");
        return 1;
    }
    
    // ��駤����������鹶��������к�
    if(color1 == -1) color1 = random(256); // ��������ѡ
    if(color2 == -1) color2 = random(256); // �������ͧ
    
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
    
    // �����������ö
    PutPlayerInVehicle(playerid, vehicleobj, 0);
    
    // �觢�ͤ�������͹
    new message[128], vehiclename[32];
    GetVehicleName(vehicleid, vehiclename, sizeof(vehiclename));
    format(message, sizeof(message), "�ʡö %s (ID: %d) �����! ��: %d-%d", vehiclename, vehicleid, color1, color2);
    SendClientMessage(playerid, COLOR_GREEN, message);
    
    // Log ���������
    new logmsg[256];
    format(logmsg, sizeof(logmsg), "[ADMIN] %s ���ʡö %s (ID: %d)", getplayername(playerid), vehiclename, vehicleid);
    print(logmsg);
    
    return 1;
}

// �����źöẺ��� /deletevehicle
CMD:deletevehicle(playerid, params[]) {
    if(!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || PlayerIntData[playerid][AdminLevel] < 1) {
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
    format(message, sizeof(message), "źö %s �����!", vehiclename);
    SendClientMessage(playerid, COLOR_GREEN, message);
    
    return 1;
}

// ����觫���öẺ��� /repair
CMD:repair(playerid, params[]) {
    if(!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || PlayerIntData[playerid][AdminLevel] < 1) {
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

// ����觤�������������ʹ�Թ /adminhelp
CMD:adminhelp(playerid, params[]) {
    if(!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || PlayerIntData[playerid][AdminLevel] < 1) {
        SendClientMessage(playerid, COLOR_RED, "��ͼԴ��Ҵ: �س������Է��������觹��!");
        return 1;
    }
    
    ShowAdminHelpDialog(playerid);
    return 1;
}

// ------------------------------ Dialog Admin Help ---------------------------------
// �ʴ� Dialog �����������ѡ����Ѻ�ʹ�Թ
stock ShowAdminHelpDialog(playerid) {
    if(!IsPlayerLoggedIn(playerid) || PlayerIntData[playerid][AdminLevel] < 1) {
        SendClientMessage(playerid, 0xFF0000AA, "��ͼԴ��Ҵ: �س������Է��������觹��!");
        return 0;
    }
    
    new list_content[1024];

    // �ʴ�੾�Ф���觷���������ԧ ����ʵ�������͡
    strcat(list_content, "{00FF00}/vehicle [ID] [��1] [��2]{FFFFFF} - �ʡö\n");
    strcat(list_content, "{00FF00}/deletevehicle{FFFFFF} - źö\n");
    strcat(list_content, "{00FF00}/repair{FFFFFF} - ����ö\n");
    strcat(list_content, "{00FF00}/adminhelp{FFFFFF} - �ʴ��������������");

    ShowPlayerDialog(playerid, DIALOG_ADMIN_HELP, DIALOG_STYLE_LIST,
        "?? �к�����������ʹ�Թ (���͡���ʹ���������´)", list_content, "���͡", "�Դ");
    return 1;
}

// �觢�ͤ����Ը���������ѧ᪷�ͧ������ (੾�Ф�������͡)
stock ShowAdminCommandUsage(playerid, index) {
    switch(index) {
        case 0: { // /vehicle
            SendClientMessage(playerid, COLOR_YELLOW, "�Ը���: /vehicle [����ö] [��1] [��2]");
            SendClientMessage(playerid, COLOR_WHITE,  "������ҧ: /vehicle 411 0 1  |  �ҧ�Ѵ: /v 411 0 1");
            SendClientMessage(playerid, COLOR_GREEN,  "��͡�˹�: �ʹ�Թ����� 1+, ����ö 400-611");
        }
        case 1: { // /deletevehicle
            SendClientMessage(playerid, COLOR_YELLOW, "�Ը���: /deletevehicle  |  �ҧ�Ѵ: /dv");
            SendClientMessage(playerid, COLOR_WHITE,  "�����˵�: ��ͧ��������ö����ͧ���ź");
        }
        case 2: { // /repair
            SendClientMessage(playerid, COLOR_YELLOW, "�Ը���: /repair  |  �ҧ�Ѵ: /fix");
            SendClientMessage(playerid, COLOR_WHITE,  "�����˵�: ��ͧ��������ö���Ы���");
        }
        case 3: { // /adminhelp
            SendClientMessage(playerid, COLOR_YELLOW, "�Ը���: /adminhelp  |  �ҧ�Ѵ: /ahelp, /admin, /a");
            SendClientMessage(playerid, COLOR_WHITE,  "��÷ӧҹ: �Դ˹�Ҥ�������������ʹ�Թ");
        }
        default: {
            SendClientMessage(playerid, COLOR_RED, "��辺�������Ը���ͧ����觷�����͡");
        }
    }
    return 1;
}