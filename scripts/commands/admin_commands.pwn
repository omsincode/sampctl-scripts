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

// ------------------------ External Variables --------------------------------
// ต้องประกาศเพื่อให้ใช้งานได้ (ประกาศจริงใน main.pwn)
#if !defined MAX_SPAWNED_VEHICLES
    #define MAX_SPAWNED_VEHICLES 100
#endif

#if !defined g_SpawnedVehicles
    new g_SpawnedVehicles[MAX_SPAWNED_VEHICLES];
    new g_SpawnedVehicleCount = 0;
#endif

// ------------------------ Spawned Vehicle Tracking --------------------------
// ฟังก์ชันเพิ่มรถเข้าระบบติดตาม
stock AddSpawnedVehicle(vehicleid) {
    if(g_SpawnedVehicleCount >= MAX_SPAWNED_VEHICLES) {
        return 0; // เต็มแล้ว
    }
    g_SpawnedVehicles[g_SpawnedVehicleCount] = vehicleid;
    g_SpawnedVehicleCount++;
    return 1;
}

// ฟังก์ชันลบรถออกจากระบบติดตาม
stock RemoveSpawnedVehicle(vehicleid) {
    for(new i = 0; i < g_SpawnedVehicleCount; i++) {
        if(g_SpawnedVehicles[i] == vehicleid) {
            // เลื่อนรายการทั้งหมดมาข้างหน้า
            for(new j = i; j < g_SpawnedVehicleCount - 1; j++) {
                g_SpawnedVehicles[j] = g_SpawnedVehicles[j + 1];
            }
            g_SpawnedVehicleCount--;
            return 1;
        }
    }
    return 0;
}

// ฟังก์ชันเช็คว่ารถเป็นรถที่เสกหรือไม่
stock IsSpawnedVehicle(vehicleid) {
    for(new i = 0; i < g_SpawnedVehicleCount; i++) {
        if(g_SpawnedVehicles[i] == vehicleid) {
            return 1;
        }
    }
    return 0;
}

// ------------------------------ Stocks -----------------------------------
// ฟังก์ชันช่วยแยกพารามิเตอร์
stock SplitParams(const string[], args[][32], maxArgs = sizeof(args)) {
    new argCount = 0;
    new length = strlen(string);
    new start = 0;
    new end = 0;
    
    while(end < length && argCount < maxArgs) {
        // ข้ามช่องว่าง
        while(end < length && string[end] == ' ') end++;
        start = end;
        
        // หาจุดสิ้นสุดของพารามิเตอร์
        while(end < length && string[end] != ' ') end++;
        
        if(start < end) {
            // จำกัดความยาวสูงสุด 31 ตัวอักษร (เผื่อ 1 ตัวสำหรับ '\0')
            if(end - start > 31) {
                end = start + 31;
            }
            strmid(args[argCount], string, start, end, 32); // คัดลอกเฉพาะช่วงที่กำหนด
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
    if(vehicleid < 0 || vehicleid >= sizeof(vNames)) { // ตรวจสอบ index ให้อยู่ในช่วงที่ถูกต้อง
        format(vehiclename, len, "Unknown");
        return 0;
    }
    
    format(vehiclename, len, "%s", vNames[vehicleid]);
    return 1;
}

// ------------------------------ Short Commands -----------------------------------
// คำสั่งแบบสั้นที่เรียกใช้คำสั่งเต็ม

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
// คำสั่งแบบเต็มพร้อมฟังก์ชันการทำงานทั้งหมด

// คำสั่งลบรถที่เสกทั้งหมด (เฉพาะรถที่ไม่มีคนนั่ง) /clearspawnedvehicles
CMD:clearspawnedvehicles(playerid, params[]) {
    if(!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || PlayerIntData[playerid][AdminLevel] < 2) {
        SendClientMessage(playerid, COLOR_RED, "ข้อผิดพลาด: คุณต้องเป็นแอดมินเลเวล 2 ขึ้นไป!");
        return 1;
    }
    
    new deletedCount = 0;
    new skipCount = 0;
    
    // วนลูปลบรถที่เสกทั้งหมด (จากท้ายไปหน้าเพื่อไม่ให้ index เปลี่ยน)
    for(new i = g_SpawnedVehicleCount - 1; i >= 0; i--) {
        new vehicleid = g_SpawnedVehicles[i];
        
        // เช็คว่ามีคนนั่งในรถหรือไม่
        new hasPassenger = 0;
        for(new p = 0; p < MAX_PLAYERS; p++) {
            if(IsPlayerConnected(p) && IsPlayerInVehicle(p, vehicleid)) {
                hasPassenger = 1;
                break;
            }
        }
        
        // ถ้าไม่มีคนนั่ง ให้ลบรถ
        if(!hasPassenger) {
            DestroyVehicle(vehicleid);
            RemoveSpawnedVehicle(vehicleid);
            deletedCount++;
        } else {
            skipCount++;
        }
    }
    
    // ส่งข้อความแจ้งผลลัพธ์
    new message[128];
    format(message, sizeof(message), "ลบรถที่เสกสำเร็จ: %d คัน | ข้าม (มีผู้โดยสาร): %d คัน", deletedCount, skipCount);
    SendClientMessage(playerid, COLOR_GREEN, message);
    
    // Log การใช้คำสั่ง
    new logmsg[256];
    format(logmsg, sizeof(logmsg), "[ADMIN] %s ได้ใช้คำสั่งลบรถที่เสก ลบได้ %d คัน", getplayername(playerid), deletedCount);
    print(logmsg);
    
    return 1;
}

// คำสั่งเสกรถแบบเต็ม /vehicle
CMD:vehicle(playerid, params[]) {
    // เช็คว่าเป็นแอดมินระดับ 1 ขึ้นไปหรือไม่
    if(!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || PlayerIntData[playerid][AdminLevel] < 1) {
        SendClientMessage(playerid, COLOR_RED, "ข้อผิดพลาด: คุณไม่มีสิทธิ์ใช้คำสั่งนี้!");
        return 1;
    }
    
    new vehicleid, color1 = -1, color2 = -1;
    
    // ตรวจสอบพารามิเตอร์
    if(strlen(params) == 0) {
        SendClientMessage(playerid, COLOR_YELLOW, "วิธีใช้: /vehicle [รหัสรถ] [สี1] [สี2]");
        SendClientMessage(playerid, COLOR_WHITE, "ตัวอย่าง: /vehicle 411 (/v 411) - เสกรถ Infernus");
        SendClientMessage(playerid, COLOR_WHITE, "ตัวอย่าง: /vehicle 411 0 1 - เสกรถ Infernus สีดำ-ขาว");
        return 1;
    }
    
    new args[3][32];
    new argCount = SplitParams(params, args);
    
    vehicleid = strval(args[0]);
    if(argCount > 1) color1 = strval(args[1]); // สีหลัก
    if(argCount > 2) color2 = strval(args[2]); // สีรอง
    
    // ตรวจสอบรหัสรถว่าถูกต้องหรือไม่ (400-611)
    if(vehicleid < 400 || vehicleid > 611) {
        SendClientMessage(playerid, COLOR_RED, "ข้อผิดพลาด: รหัสรถไม่ถูกต้อง! (400-611)");
        return 1;
    }
    
    // ตั้งค่าสีเริ่มต้นถ้าไม่ได้ระบุ
    if(color1 == -1) color1 = random(256); // สุ่มสีหลัก
    if(color2 == -1) color2 = random(256); // สุ่มสีรอง
    
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
    
    // เพิ่มรถเข้าระบบติดตาม
    AddSpawnedVehicle(vehicleobj);
    
    // ใส่ผู้เล่นเข้ารถ
    PutPlayerInVehicle(playerid, vehicleobj, 0);
    
    // ส่งข้อความแจ้งเตือน
    new message[128], vehiclename[32];
    GetVehicleName(vehicleid, vehiclename, sizeof(vehiclename));
    format(message, sizeof(message), "เสกรถ %s (ID: %d) สำเร็จ! สี: %d-%d", vehiclename, vehicleid, color1, color2);
    SendClientMessage(playerid, COLOR_GREEN, message);
    
    // Log การใช้คำสั่ง
    new logmsg[256];
    format(logmsg, sizeof(logmsg), "[ADMIN] %s ได้เสกรถ %s (ID: %d)", getplayername(playerid), vehiclename, vehicleid);
    print(logmsg);
    
    return 1;
}

// คำสั่งลบรถแบบเต็ม /deletevehicle
CMD:deletevehicle(playerid, params[]) {
    if(!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || PlayerIntData[playerid][AdminLevel] < 1) {
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
    format(message, sizeof(message), "ลบรถ %s สำเร็จ!", vehiclename);
    SendClientMessage(playerid, COLOR_GREEN, message);
    
    return 1;
}

// คำสั่งซ่อมรถแบบเต็ม /repair
CMD:repair(playerid, params[]) {
    if(!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || PlayerIntData[playerid][AdminLevel] < 1) {
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

// คำสั่งความช่วยเหลือแอดมิน /adminhelp
CMD:adminhelp(playerid, params[]) {
    if(!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || PlayerIntData[playerid][AdminLevel] < 1) {
        SendClientMessage(playerid, COLOR_RED, "ข้อผิดพลาด: คุณไม่มีสิทธิ์ใช้คำสั่งนี้!");
        return 1;
    }
    
    ShowAdminHelpDialog(playerid);
    return 1;
}

// หมายเหตุ: CMD:giveitem ถูกย้ายไปที่ inventory_systems.pwn แล้ว

// ------------------------------ Dialog Admin Help ---------------------------------
// แสดง Dialog ช่วยเหลือหลักสำหรับแอดมิน
stock ShowAdminHelpDialog(playerid) {
    if(!IsPlayerLoggedIn(playerid) || PlayerIntData[playerid][AdminLevel] < 1) {
        SendClientMessage(playerid, 0xFF0000AA, "ข้อผิดพลาด: คุณไม่มีสิทธิ์ใช้คำสั่งนี้!");
        return 0;
    }
    
    new list_content[1024];

    // แสดงเฉพาะคำสั่งที่มีอยู่จริง เป็นลิสต์ให้เลือก
    strcat(list_content, "{00FF00}/vehicle [ID] [สี1] [สี2]{FFFFFF} - เสกรถ\n");
    strcat(list_content, "{00FF00}/deletevehicle{FFFFFF} - ลบรถ\n");
    strcat(list_content, "{00FF00}/clearspawnedvehicles{FFFFFF} - ลบรถที่เสกทั้งหมด (ไม่มีคนนั่ง)\n");
    strcat(list_content, "{00FF00}/repair{FFFFFF} - ซ่อมรถ\n");
    strcat(list_content, "{00FF00}/giveitem [ID] [ItemIndex] [จำนวน]{FFFFFF} - ให้ไอเท็ม\n");
    strcat(list_content, "{00FF00}/createitem [ชื่อ] [น้ำหนัก] [คำอธิบาย]{FFFFFF} - สร้างไอเท็มใหม่\n");
    strcat(list_content, "{00FF00}/reloaditems{FFFFFF} - โหลดไอเท็มใหม่\n");
    strcat(list_content, "{00FF00}/itemlist{FFFFFF} - แสดงรายการไอเท็ม\n");
    strcat(list_content, "{00FF00}/adminhelp{FFFFFF} - แสดงความช่วยเหลือ");

    ShowPlayerDialog(playerid, DIALOG_ADMIN_HELP, DIALOG_STYLE_LIST,
        "?? ระบบช่วยเหลือแอดมิน (เลือกเพื่อดูรายละเอียด)", list_content, "เลือก", "ปิด");
    return 1;
}

// ส่งข้อความวิธีใช้คำสั่งไปยังแชทของผู้เล่น (เฉพาะคนที่เลือก)
stock ShowAdminCommandUsage(playerid, index) {
    switch(index) {
        case 0: { // /vehicle
            SendClientMessage(playerid, COLOR_YELLOW, "วิธีใช้: /vehicle [รหัสรถ] [สี1] [สี2]");
            SendClientMessage(playerid, COLOR_WHITE,  "ตัวอย่าง: /vehicle 411 0 1  |  ทางลัด: /v 411 0 1");
            SendClientMessage(playerid, COLOR_GREEN,  "ข้อกำหนด: แอดมินเลเวล 1+, รหัสรถ 400-611");
        }
        case 1: { // /deletevehicle
            SendClientMessage(playerid, COLOR_YELLOW, "วิธีใช้: /deletevehicle  |  ทางลัด: /dv");
            SendClientMessage(playerid, COLOR_WHITE,  "หมายเหตุ: ต้องนั่งอยู่ในรถที่ต้องการลบ");
        }
        case 2: { // /clearspawnedvehicles
            SendClientMessage(playerid, COLOR_YELLOW, "วิธีใช้: /clearspawnedvehicles  |  ทางลัด: /clearveh, /cveh");
            SendClientMessage(playerid, COLOR_WHITE,  "หมายเหตุ: ลบรถที่เสกจากคำสั่งทั้งหมด (เฉพาะรถที่ไม่มีคนนั่ง)");
            SendClientMessage(playerid, COLOR_GREEN,  "ข้อกำหนด: แอดมินเลเวล 2+");
        }
        case 3: { // /repair
            SendClientMessage(playerid, COLOR_YELLOW, "วิธีใช้: /repair  |  ทางลัด: /fix");
            SendClientMessage(playerid, COLOR_WHITE,  "หมายเหตุ: ต้องนั่งอยู่ในรถที่จะซ่อม");
        }
        case 4: { // /giveitem
            SendClientMessage(playerid, COLOR_YELLOW, "วิธีใช้: /giveitem [PlayerID] [ItemIndex] [จำนวน]");
            SendClientMessage(playerid, COLOR_WHITE,  "ตัวอย่าง: /giveitem 0 1 5  (ให้ไอเท็ม index 1 จำนวน 5 ชิ้นแก่ผู้เล่น ID 0)");
            SendClientMessage(playerid, COLOR_GREEN,  "ข้อกำหนด: แอดมินเลเวล 3+");
        }
        case 5: { // /createitem
            SendClientMessage(playerid, COLOR_YELLOW, "วิธีใช้: /createitem [ชื่อไอเท็ม] [น้ำหนัก] [คำอธิบาย]");
            SendClientMessage(playerid, COLOR_WHITE,  "ตัวอย่าง: /createitem Sword 2.5 ดาบเหล็กคมกริบ");
            SendClientMessage(playerid, COLOR_GREEN,  "ข้อกำหนด: แอดมินเลเวล 5+");
        }
        case 6: { // /reloaditems
            SendClientMessage(playerid, COLOR_YELLOW, "วิธีใช้: /reloaditems");
            SendClientMessage(playerid, COLOR_WHITE,  "หมายเหตุ: โหลดข้อมูลไอเท็มใหม่จากฐานข้อมูล");
            SendClientMessage(playerid, COLOR_GREEN,  "ข้อกำหนด: แอดมินเลเวล 5+");
        }
        case 7: { // /itemlist
            SendClientMessage(playerid, COLOR_YELLOW, "วิธีใช้: /itemlist");
            SendClientMessage(playerid, COLOR_WHITE,  "หมายเหตุ: แสดงรายการไอเท็มทั้งหมดในระบบ (สูงสุด 50 รายการ)");
            SendClientMessage(playerid, COLOR_GREEN,  "ข้อกำหนด: แอดมินเลเวล 1+");
        }
        case 8: { // /adminhelp
            SendClientMessage(playerid, COLOR_YELLOW, "วิธีใช้: /adminhelp  |  ทางลัด: /ahelp, /admin, /a");
            SendClientMessage(playerid, COLOR_WHITE,  "การทำงาน: เปิดหน้าความช่วยเหลือแอดมิน");
        }
        default: {
            SendClientMessage(playerid, COLOR_RED, "ไม่พบข้อมูลวิธีใช้ของคำสั่งที่เลือก");
        }
    }
    return 1;
}