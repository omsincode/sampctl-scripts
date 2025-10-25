# Code Style Guide - sampctl-scripts Project

## Why Use snake_case

**To clearly distinguish between our functions and SA-MP natives**

- **SA-MP natives**: Use `PascalCase` (e.g., SetPlayerHealth, GetPlayerPos)
- **Our code**: Use `snake_case` (e.g., set_player_data, get_player_info)

---

## Naming Conventions

### 1. Variables
- **Local**: `snake_case`
- **Global**: `g_snake_case` (prefix with `g_`)

### 2. Functions
- **General functions**: `snake_case`
- **System-specific functions**: `prefix_snake_case` (prefix with system name, e.g., `login_`, `register_`, `admin_`)

### 3. Enum and Array
- **Enum**: `snake_case`
- **Array**: `snake_case`

### 4. Define and Constant
- Use `UPPER_SNAKE_CASE` (all uppercase)

### 5. Callbacks
- **SA-MP natives**: Use as is (`OnPlayerConnect`, `OnPlayerDisconnect`)
- **Custom callbacks**: `on_snake_case` (prefix with `on_`)

---

## Code Formatting

### Braces
- Opening brace `{` on the same line as statement

### Spacing
- **No space** in: `if()`, `for()`, `while()`, function calls
- **Space** around operators: `=`, `+`, `-`, `*`, `/`

---

## File Structure

```pawn
// --------------------------- Include Guard ----------------------------------
// ------------------------------ Includes ------------------------------------
// ------------------------------ Defines -------------------------------------
// ------------------------------ Variables -----------------------------------
// ------------------------------ Functions -----------------------------------
// ------------------------------ Callbacks -----------------------------------
```

---

## Quick Reference

| Type | Format |
|------|--------|
| **Local Variable** | `snake_case` |
| **Global Variable** | `g_snake_case` |
| **Function** | `snake_case` or `prefix_snake_case` |
| **Enum/Array** | `snake_case` |
| **Define/Constant** | `UPPER_SNAKE_CASE` |
| **Custom Callback** | `on_snake_case` |
| **SA-MP Natives** | `PascalCase` (use as is) |

---

**Created by**: omsincode  
**Last updated**: October 26, 2025