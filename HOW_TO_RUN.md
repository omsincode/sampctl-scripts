# Running the Server

## ปัญหาที่พบ

`sampctl run` จะเกิด panic error (nil pointer dereference) หลังจากโหลด gamemode สำเร็จ ซึ่งเป็นบั๊กของตัว sampctl เอง ไม่ใช่ปัญหาของโค้ด

## วิธีแก้ไข

### แนะนำ: รันเซิร์ฟเวอร์โดยตรง

```powershell
# Build โค้ดก่อน
sampctl build

# จากนั้นรันเซิร์ฟเวอร์โดยตรงแทน
.\samp-server.exe
```

### ทางเลือก: ใช้ sampctl (มีโอกาสเกิด panic)

```powershell
sampctl run
# เซิร์ฟเวอร์จะทำงานได้ปกติ แต่ sampctl จะ panic ตอนจบ
```

## สถานะปัจจุบัน

? **การ compile สำเร็จ** - Build successful with 0 problems  
? **Plugins โหลดสำเร็จ**
- mysql: R41-4
- sscanf: 2.13.8

? **Database เชื่อมต่อสำเร็จ** - MySQL successfully connected  
? **Gamemode ทำงานได้** - GameMode loaded successfully  
? **Autosave ทำงาน** - Started interval every 300000 ms (5 minutes)

?? **คำเตือนที่ไม่สำคัญ:**
```
AllowAdminTeleport() : function is deprecated. Please see OnPlayerClickMap()
```
- ฟังก์ชันนี้ยังใช้ได้ แค่ถูก deprecated ไปแล้ว
- แนะนำเปลี่ยนเป็น `OnPlayerClickMap()` callback แทนในอนาคต

## คำสั่งที่มีประโยชน์

```powershell
# Build โค้ด
sampctl build

# ดาวน์โหลด dependencies
sampctl ensure

# รันเซิร์ฟเวอร์ (ใช้วิธีโดยตรงแทน)
.\samp-server.exe

# ดูข้อมูลแพ็กเกจ
sampctl package info

# เพิ่ม version tag
sampctl package release
```

## สรุป

เซิร์ฟเวอร์ของคุณ**ทำงานได้ปกติสมบูรณ์**แล้ว! แค่ต้องรันด้วย `.\samp-server.exe` โดยตรง แทนที่จะใช้ `sampctl run` เพื่อหลีกเลี่ยงบั๊กของ sampctl
