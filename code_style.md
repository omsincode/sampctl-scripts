# Code Style Guide - sampctl-scripts Project

## �˵ؼŷ���� snake_case

**�����¡�������Ѵਹ ����Ѻʹ�����ҧ�ѧ��ѹ�ͧ��ҡѺ SA-MP natives**

- **SA-MP natives**: �� `PascalCase` (�� SetPlayerHealth, GetPlayerPos)
- **�鴢ͧ���**: �� `snake_case` (�� set_player_data, get_player_info)

---

## ��ѡ��õ�駪���

### 1. ����� (Variables)
- **Local**: `snake_case`
- **Global**: `g_snake_case` (��� `g_` ��ҧ˹��)

### 2. �ѧ��ѹ (Functions)
- **�ѧ��ѹ�����**: `snake_case`
- **�ѧ��ѹ੾���к�**: `prefix_snake_case` (��� prefix ��ҧ˹�� �� `login_`, `register_`, `admin_`)

### 3. Enum ��� Array
- **Enum**: `snake_case`
- **Array**: `snake_case`

### 4. Define ��� Constant
- �� `UPPER_SNAKE_CASE` (��Ǿ�����˭������)

### 5. Callbacks
- **SA-MP natives**: ������� (`OnPlayerConnect`, `OnPlayerDisconnect`)
- **Custom callbacks**: `on_snake_case` (��� `on_` ��ҧ˹��)

---

## ��èѴ�ٻẺ��

### Braces
- Opening brace `{` �����÷Ѵ���ǡѺ�����

### Spacing
- **��������ä** �: `if()`, `for()`, `while()`, function calls
- **�����ä** �ͺ operators: `=`, `+`, `-`, `*`, `/`

---

## �ç���ҧ����»���ҳ

```pawn
// --------------------------- Include Guard ----------------------------------
// ------------------------------ Includes ------------------------------------
// ------------------------------ Defines -------------------------------------
// ------------------------------ Variables -----------------------------------
// ------------------------------ Functions -----------------------------------
// ------------------------------ Callbacks -----------------------------------
```

---

## ��ػ Quick Reference

| ������ | �ٻẺ |
|--------|--------|
| **����� Local** | `snake_case` |
| **����� Global** | `g_snake_case` |
| **�ѧ��ѹ** | `snake_case` ���� `prefix_snake_case` |
| **Enum/Array** | `snake_case` |
| **Define/Constant** | `UPPER_SNAKE_CASE` |
| **Custom Callback** | `on_snake_case` |
| **SA-MP Natives** | `PascalCase` (�������) |

---

**�Ѵ����**: omsincode  
**�Ѿഷ����ش**: October 26, 2025