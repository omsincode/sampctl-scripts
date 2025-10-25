# Code Style Guide - sampctl-scripts Project

## เหตุผลที่ใช้ snake_case

**เพื่อแยกชื่อให้ชัดเจน ไม่สับสนระหว่างฟังก์ชันของเรากับ SA-MP natives**

- **SA-MP natives**: ใช้ `PascalCase` (เช่น SetPlayerHealth, GetPlayerPos)
- **โค้ดของเรา**: ใช้ `snake_case` (เช่น set_player_data, get_player_info)

---

## หลักการตั้งชื่อ

### 1. ตัวแปร (Variables)
- **Local**: `snake_case`
- **Global**: `g_snake_case` (เติม `g_` ข้างหน้า)

### 2. ฟังก์ชัน (Functions)
- **ฟังก์ชันทั่วไป**: `snake_case`
- **ฟังก์ชันเฉพาะระบบ**: `prefix_snake_case` (เติม prefix ข้างหน้า เช่น `login_`, `register_`, `admin_`)

### 3. Enum และ Array
- **Enum**: `snake_case`
- **Array**: `snake_case`

### 4. Define และ Constant
- ใช้ `UPPER_SNAKE_CASE` (ตัวพิมพ์ใหญ่ทั้งหมด)

### 5. Callbacks
- **SA-MP natives**: ใช้ตามเดิม (`OnPlayerConnect`, `OnPlayerDisconnect`)
- **Custom callbacks**: `on_snake_case` (เติม `on_` ข้างหน้า)

---

## การจัดรูปแบบโค้ด

### Braces
- Opening brace `{` อยู่บรรทัดเดียวกับคำสั่ง

### Spacing
- **ไม่เว้นวรรค** ใน: `if()`, `for()`, `while()`, function calls
- **เว้นวรรค** รอบ operators: `=`, `+`, `-`, `*`, `/`

---

## โครงสร้างไฟล์โดยประมาณ

```pawn
// --------------------------- Include Guard ----------------------------------
// ------------------------------ Includes ------------------------------------
// ------------------------------ Defines -------------------------------------
// ------------------------------ Variables -----------------------------------
// ------------------------------ Functions -----------------------------------
// ------------------------------ Callbacks -----------------------------------
```

---

## สรุป Quick Reference

| ประเภท | รูปแบบ |
|--------|--------|
| **ตัวแปร Local** | `snake_case` |
| **ตัวแปร Global** | `g_snake_case` |
| **ฟังก์ชัน** | `snake_case` หรือ `prefix_snake_case` |
| **Enum/Array** | `snake_case` |
| **Define/Constant** | `UPPER_SNAKE_CASE` |
| **Custom Callback** | `on_snake_case` |
| **SA-MP Natives** | `PascalCase` (ใช้ตามเดิม) |

---

**จัดทำโดย**: omsincode  
**อัพเดทล่าสุด**: October 26, 2025