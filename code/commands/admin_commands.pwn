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
// ตัวแปรสำหรับติดตามรถที่สร้าง (ประกาศจริงใน main.pwn)
#if !defined MAX_SPAWNED_VEHICLES
    #define MAX_SPAWNED_VEHICLES 100
#endif

#if !defined g_SpawnedVehicles
    new g_SpawnedVehicles[MAX_SPAWNED_VEHICLES];
    new g_SpawnedVehicleCount = 0;
#endif

// ------------------------ Spawned Vehicle Tracking --------------------------
// ฟังก์ชันติดตามรถที่ถูกสร้างขึ้น
stock AddSpawnedVehicle(vehicleid) {
    if(g_SpawnedVehicleCount >= MAX_SPAWNED_VEHICLES) {
        return 0; // เต็มแล้ว
    }
    g_SpawnedVehicles[g_SpawnedVehicleCount] = vehicleid;
    g_SpawnedVehicleCount++;
    return 1;
}

// ฟังก์ชันลบรถออกจากลิสต์ที่ติดตาม
stock RemoveSpawnedVehicle(vehicleid) {
    for(new i = 0; i < g_SpawnedVehicleCount; i++) {
        if(g_SpawnedVehicles[i] == vehicleid) {
            // เลื่อนทุกค่าที่อยู่ข้างหนังมา
            for(new j = i; j < g_SpawnedVehicleCount - 1; j++) {
                g_SpawnedVehicles[j] = g_SpawnedVehicles[j + 1];
            }
            g_SpawnedVehicleCount--;
            return 1;
        }
    }
    return 0;
}

// ฟังก์ชันเช็ครถว่าถูกสร้างโดยคำสั่งหรือไม่
stock IsSpawnedVehicle(vehicleid) {
    for(new i = 0; i < g_SpawnedVehicleCount; i++) {
        if(g_SpawnedVehicles[i] == vehicleid) {
            return 1;
        }
    }
    return 0;
}

// ------------------------------ Stocks -----------------------------------
// ฟังก์ชันแยกพารามิเตอร์
stock SplitParams(const string[], args[][32], maxArgs = sizeof(args)) {
    new argCount = 0;
    new length = strlen(string);
    new start = 0;
    new end = 0;
    
    while(end < length && argCount < maxArgs) {
        // ข้ามช่องว่าง
        while(end < length && string[end] == ' ') end++;
        start = end;
        
        // หาจุดสิ้นสุดของคำถัดไป
        while(end < length && string[end] != ' ') end++;
        
        if(start < end) {
            // จำกัดความยาวสูงสุด 31 ตัวอักษร (เหลือ 1 ตัวสำหรับ '\0')
            if(end - start > 31) {
                end = start + 31;
            }
            strmid(args[argCount], string, start, end, 32); // ตัดเอกเฉพาะส่วนหนึ่ง
            argCount++;
        }
    }
    
    return argCount;
}

// ฟังก์ชันดึงชื่อรถ
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
    
    vehicleid -= 400; // แปลง ID รถเป็น index ของ array
    if(vehicleid < 0 || vehicleid >= sizeof(vNames)) { // ตรวจสอบ index ว่าอยู่ในช่วงที่ถูกต้อง
        format(vehiclename, len, "Unknown");
        return 0;
    }
    
    format(vehiclename, len, "%s", vNames[vehicleid]);
    return 1;
}

// ------------------------------ Short Commands -----------------------------------
// คำสั่งย่อที่เรียกใช้ฟังก์ชันเต็ม

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
// คำสั่งแบบเต็มที่ทำงานจริง

// คำสั่งลบรถที่สร้างทั้งหมด (เฉพาะรถที่แอดมินสร้าง) /clearspawnedvehicles
CMD:clearspawnedvehicles(playerid, params[]) {
    if(!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || player_info[playerid][player_admin_level] < 2) {
        SendClientMessage(playerid, COLOR_RED, "ข้อผิดพลาด: คุณต้องเป็นแอดมินระดับ 2 ขึ้นไป!");
        return 1;
    }
    
    new deletedCount = 0;
    new skipCount = 0;
    
    // วนลูปลบรถที่สร้างทั้งหมด (จากด้านหลังเพื่อหลีกเลี่ยง index ผิด)
    for(new i = g_SpawnedVehicleCount - 1; i >= 0; i--) {
        new vehicleid = g_SpawnedVehicles[i];
        
        // เช็คว่ามีคนในรถไหม
        new hasPassenger = 0;
        for(new p = 0; p < MAX_PLAYERS; p++) {
            if(IsPlayerConnected(p) && IsPlayerInVehicle(p, vehicleid)) {
                hasPassenger = 1;
                break;
            }
        }
        
        // ถ้าไม่มีคนใน ก็ลบรถ
        if(!hasPassenger) {
            DestroyVehicle(vehicleid);
            RemoveSpawnedVehicle(vehicleid);
            deletedCount++;
        } else {
            skipCount++;
        }
    }
    
    // ส่งข้อความแจ้งผู้เล่น
    new message[128];
    format(message, sizeof(message), "ลบรถที่สร้างเสร็จ: %d คัน | ข้าม (มีผู้โดยสาร): %d คัน", deletedCount, skipCount);
    SendClientMessage(playerid, COLOR_GREEN, message);
    
    // Log ไว้ในคอนโซล
    new logmsg[256];
    format(logmsg, sizeof(logmsg), "[ADMIN] %s ใช้คำสั่งลบรถที่สร้าง ลบไป %d คัน", getplayername(playerid), deletedCount);
    print(logmsg);
    
    return 1;
}

// คำสั่งสร้างรถแบบเต็ม /vehicle
CMD:vehicle(playerid, params[]) {
    // ต้องเป็นแอดมินระดับ 1 ขึ้นไปถึงใช้ได้
    if(!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || player_info[playerid][player_admin_level] < 1) {
        SendClientMessage(playerid, COLOR_RED, "ข้อผิดพลาด: คุณไม่มีสิทธิ์ใช้คำสั่งนี้!");
        return 1;
    }
    
    new vehicleid, color1 = -1, color2 = -1;
    
    // ตรวจสอบพารามิเตอร์
    if(strlen(params) == 0) {
        SendClientMessage(playerid, COLOR_YELLOW, "วิธีใช้: /vehicle [ไอดีรถ] [สี1] [สี2]");
        SendClientMessage(playerid, COLOR_WHITE, "ตัวอย่าง: /vehicle 411 (/v 411) - สร้างรถ Infernus");
        SendClientMessage(playerid, COLOR_WHITE, "ตัวอย่าง: /vehicle 411 0 1 - สร้างรถ Infernus สีดำ-ขาว");
        return 1;
    }
    
    new args[3][32];
    new argCount = SplitParams(params, args);
    
    vehicleid = strval(args[0]);
    if(argCount > 1) color1 = strval(args[1]); // สีแรก
    if(argCount > 2) color2 = strval(args[2]); // สีสอง
    
    // ตรวจสอบไอดีรถว่าถูกต้องหรือไม่ (400-611)
    if(vehicleid < 400 || vehicleid > 611) {
        SendClientMessage(playerid, COLOR_RED, "ข้อผิดพลาด: ไอดีรถไม่ถูกต้อง! (400-611)");
        return 1;
    }
    
    // ใช้ค่าสุ่มถ้าไม่ระบุสี
    if(color1 == -1) color1 = random(256); // สีแรก
    if(color2 == -1) color2 = random(256); // สีสอง
    
    // ดึงตำแหน่งผู้เล่น
    new Float:x, Float:y, Float:z, Float:angle;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, angle);
    
    // สร้างรถใหม่
    new vehicleobj = CreateVehicle(vehicleid, x + 3.0, y, z, angle, color1, color2, -1);
    
    if(vehicleobj == INVALID_VEHICLE_ID) { // ถ้าสร้างรถไม่สำเร็จ
        SendClientMessage(playerid, COLOR_RED, "ข้อผิดพลาด: ไม่สามารถสร้างรถได้!");
        return 1;
    }
    
    // เพิ่มรถลงลิสต์ที่ติดตาม
    AddSpawnedVehicle(vehicleobj);
    
    // นั่งผู้เล่นลงรถ
    PutPlayerInVehicle(playerid, vehicleobj, 0);
    
    // ส่งข้อความตอบกลับ
    new message[128], vehiclename[32];
    GetVehicleName(vehicleid, vehiclename, sizeof(vehiclename));
    format(message, sizeof(message), "สร้างรถ %s (ID: %d) เรียบร้อย! สี: %d-%d", vehiclename, vehicleid, color1, color2);
    SendClientMessage(playerid, COLOR_GREEN, message);
    
    // Log ไว้ในคอนโซล
    new logmsg[256];
    format(logmsg, sizeof(logmsg), "[ADMIN] %s สร้างรถ %s (ID: %d)", getplayername(playerid), vehiclename, vehicleid);
    print(logmsg);
    
    return 1;
}

// คำสั่งลบรถแบบเต็ม /deletevehicle
CMD:deletevehicle(playerid, params[]) {
    if(!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || player_info[playerid][player_admin_level] < 1) {
        SendClientMessage(playerid, COLOR_RED, "ข้อผิดพลาด: คุณไม่มีสิทธิ์ใช้คำสั่งนี้!");
        return 1;
    }
    
    if(!IsPlayerInAnyVehicle(playerid)) { // ตรวจสอบว่าผู้เล่นอยู่ในรถหรือไม่
        SendClientMessage(playerid, COLOR_RED, "ข้อผิดพลาด: คุณต้องอยู่ในรถเพื่อลบรถ!");
        return 1;
    }
    
    new vehicleobj = GetPlayerVehicleID(playerid);
    new vehiclemodel = GetVehicleModel(vehicleobj);
    new vehiclename[32];
    GetVehicleName(vehiclemodel, vehiclename, sizeof(vehiclename));
    
    DestroyVehicle(vehicleobj); // ลบรถ
    
    new message[128];
    format(message, sizeof(message), "ลบรถ %s เรียบร้อย!", vehiclename);
    SendClientMessage(playerid, COLOR_GREEN, message);
    
    return 1;
}

// คำสั่งซ่อมรถแบบเต็ม /repair
CMD:repair(playerid, params[]) {
    if(!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || player_info[playerid][player_admin_level] < 1) {
        SendClientMessage(playerid, COLOR_RED, "ข้อผิดพลาด: คุณไม่มีสิทธิ์ใช้คำสั่งนี้!");
        return 1;
    }
    
    if(!IsPlayerInAnyVehicle(playerid)) { // ตรวจสอบว่าผู้เล่นอยู่ในรถหรือไม่
        SendClientMessage(playerid, COLOR_RED, "ข้อผิดพลาด: คุณต้องอยู่ในรถเพื่อซ่อมรถ!");
        return 1;
    }
    
    new vehicleobj = GetPlayerVehicleID(playerid);
    RepairVehicle(vehicleobj); // ซ่อมรถ
    
    SendClientMessage(playerid, COLOR_GREEN, "ซ่อมรถเรียบร้อยแล้ว!");
    
    return 1;
}

// คำสั่งแสดงความช่วยเหลือแอดมิน /adminhelp
CMD:adminhelp(playerid, params[]) {
    if(!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || player_info[playerid][player_admin_level] < 1) {
        SendClientMessage(playerid, COLOR_RED, "ข้อผิดพลาด: คุณไม่มีสิทธิ์ใช้คำสั่งนี้!");
        return 1;
    }
    
    ShowAdminHelpDialog(playerid);
    return 1;
}

// ------------------------------ Dialog Admin Help ---------------------------------
// แสดง Dialog พร้อมรายการคำสั่งสำหรับแอดมิน
stock ShowAdminHelpDialog(playerid) {
    if(!IsPlayerLoggedIn(playerid) || player_info[playerid][player_admin_level] < 1) {
        SendClientMessage(playerid, 0xFF0000AA, "ข้อผิดพลาด: คุณไม่มีสิทธิ์ใช้คำสั่งนี้!");
        return 0;
    }
    
    new list_content[1024];

    // แสดงเฉพาะคำสั่งที่เกี่ยวข้อง แต่สามารถขยายเพิ่ม
    strcat(list_content, "{00FF00}/vehicle [ID] [สี1] [สี2]{FFFFFF} - สร้างรถ\n");
    strcat(list_content, "{00FF00}/deletevehicle{FFFFFF} - ลบรถ\n");
    strcat(list_content, "{00FF00}/clearspawnedvehicles{FFFFFF} - ลบรถที่สร้างทั้งหมด (ไม่มีคนใน)\n");
    strcat(list_content, "{00FF00}/repair{FFFFFF} - ซ่อมรถ\n");
    strcat(list_content, "{00FF00}/giveitem [ID] [ItemIndex] [จำนวน]{FFFFFF} - ให้ไอเทม\n");
    strcat(list_content, "{00FF00}/createitem [ชื่อ] [น้ำหนัก] [คำอธิบาย]{FFFFFF} - สร้างไอเทมใหม่\n");
    strcat(list_content, "{00FF00}/reloaditems{FFFFFF} - โหลดไอเทมใหม่\n");
    strcat(list_content, "{00FF00}/itemlist{FFFFFF} - แสดงรายการไอเทม\n");
    strcat(list_content, "{00FF00}/adminhelp{FFFFFF} - แสดงความช่วยเหลือนี้");

    ShowPlayerDialog(playerid, DIALOG_ADMIN_HELP, DIALOG_STYLE_LIST,
        "คู่มือคำสั่งแอดมิน (เลือกเพื่ือดูรายละเอียด)", list_content, "เลือก", "ปิด");
    return 1;
}

// ส่งข้อความแนะนำวิธีใช้งานคำสั่ง (เฉพาะคำสั่งเลือก)
stock ShowAdminCommandUsage(playerid, index) {
    switch(index) {
        case 0: { // /vehicle
            SendClientMessage(playerid, COLOR_YELLOW, "วิธีใช้: /vehicle [ไอดีรถ] [สี1] [สี2]");
            SendClientMessage(playerid, COLOR_WHITE,  "ตัวอย่าง: /vehicle 411 0 1  |  ทางลัด: /v 411 0 1");
            SendClientMessage(playerid, COLOR_GREEN,  "เงื่อนไข: แอดมินระดับ 1+, ไอดีรถ 400-611");
        }
        case 1: { // /deletevehicle
            SendClientMessage(playerid, COLOR_YELLOW, "วิธีใช้: /deletevehicle  |  ทางลัด: /dv");
            SendClientMessage(playerid, COLOR_WHITE,  "หมายเหตุ: ต้องอยู่ในรถที่ต้องการลบ");
        }
        case 2: { // /clearspawnedvehicles
            SendClientMessage(playerid, COLOR_YELLOW, "๏ฟฝิธ๏ฟฝ๏ฟฝ๏ฟฝ: /clearspawnedvehicles  |  ๏ฟฝาง๏ฟฝัด: /clearveh, /cveh");
            SendClientMessage(playerid, COLOR_WHITE,  "๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝหต๏ฟฝ: ลบรถ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝสก๏ฟฝาก๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ่งท๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ (เฉพ๏ฟฝ๏ฟฝรถ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝีค๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ)");
            SendClientMessage(playerid, COLOR_GREEN,  "๏ฟฝ๏ฟฝอก๏ฟฝหน๏ฟฝ: ๏ฟฝอด๏ฟฝิน๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ 2+");
        }
        case 3: { // /repair
            SendClientMessage(playerid, COLOR_YELLOW, "๏ฟฝิธ๏ฟฝ๏ฟฝ๏ฟฝ: /repair  |  ๏ฟฝาง๏ฟฝัด: /fix");
            SendClientMessage(playerid, COLOR_WHITE,  "๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝหต๏ฟฝ: ๏ฟฝ๏ฟฝอง๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝรถ๏ฟฝ๏ฟฝ๏ฟฝะซ๏ฟฝ๏ฟฝ๏ฟฝ");
        }
        case 4: { // /giveitem
            SendClientMessage(playerid, COLOR_YELLOW, "๏ฟฝิธ๏ฟฝ๏ฟฝ๏ฟฝ: /giveitem [PlayerID] [ItemIndex] [๏ฟฝำนวน]");
            SendClientMessage(playerid, COLOR_WHITE,  "๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝาง: /giveitem 0 1 5  (๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ index 1 ๏ฟฝำนวน 5 ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ ID 0)");
            SendClientMessage(playerid, COLOR_GREEN,  "๏ฟฝ๏ฟฝอก๏ฟฝหน๏ฟฝ: ๏ฟฝอด๏ฟฝิน๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ 3+");
        }
        case 5: { // /createitem
            SendClientMessage(playerid, COLOR_YELLOW, "๏ฟฝิธ๏ฟฝ๏ฟฝ๏ฟฝ: /createitem [๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ] [๏ฟฝ๏ฟฝ๏ฟฝหนัก] [๏ฟฝ๏ฟฝอธิบ๏ฟฝ๏ฟฝ]");
            SendClientMessage(playerid, COLOR_WHITE,  "๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝาง: /createitem Sword 2.5 ๏ฟฝาบ๏ฟฝ๏ฟฝ๏ฟฝ็กค๏ฟฝ๏ฟฝ๏ฟฝิบ");
            SendClientMessage(playerid, COLOR_GREEN,  "๏ฟฝ๏ฟฝอก๏ฟฝหน๏ฟฝ: ๏ฟฝอด๏ฟฝิน๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ 5+");
        }
        case 6: { // /reloaditems
            SendClientMessage(playerid, COLOR_YELLOW, "๏ฟฝิธ๏ฟฝ๏ฟฝ๏ฟฝ: /reloaditems");
            SendClientMessage(playerid, COLOR_WHITE,  "๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝหต๏ฟฝ: ๏ฟฝ๏ฟฝลด๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝาก๏ฟฝาน๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ");
            SendClientMessage(playerid, COLOR_GREEN,  "๏ฟฝ๏ฟฝอก๏ฟฝหน๏ฟฝ: ๏ฟฝอด๏ฟฝิน๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ 5+");
        }
        case 7: { // /itemlist
            SendClientMessage(playerid, COLOR_YELLOW, "๏ฟฝิธ๏ฟฝ๏ฟฝ๏ฟฝ: /itemlist");
            SendClientMessage(playerid, COLOR_WHITE,  "๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝหต๏ฟฝ: ๏ฟฝสด๏ฟฝ๏ฟฝ๏ฟฝยก๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝะบ๏ฟฝ (๏ฟฝูง๏ฟฝุด 50 ๏ฟฝ๏ฟฝยก๏ฟฝ๏ฟฝ)");
            SendClientMessage(playerid, COLOR_GREEN,  "๏ฟฝ๏ฟฝอก๏ฟฝหน๏ฟฝ: ๏ฟฝอด๏ฟฝิน๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ 1+");
        }
        case 8: { // /adminhelp
            SendClientMessage(playerid, COLOR_YELLOW, "๏ฟฝิธ๏ฟฝ๏ฟฝ๏ฟฝ: /adminhelp  |  ๏ฟฝาง๏ฟฝัด: /ahelp, /admin, /a");
            SendClientMessage(playerid, COLOR_WHITE,  "๏ฟฝ๏ฟฝรทำงาน: ๏ฟฝิดหน๏ฟฝาค๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝอด๏ฟฝิน");
        }
        default: {
            SendClientMessage(playerid, COLOR_RED, "๏ฟฝ๏ฟฝ่พบ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝิธ๏ฟฝ๏ฟฝ๏ฟฝอง๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ่งท๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝ๏ฟฝอก");
        }
    }
    return 1;
}
