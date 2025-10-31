CREATE TABLE IF NOT EXISTS players (
    player_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    player_name VARCHAR(23) NOT NULL UNIQUE,
    player_password VARCHAR(128) NOT NULL,
    player_admin TINYINT UNSIGNED NOT NULL DEFAULT 0,
    player_last_login DATETIME NULL,
    player_registered_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    player_deaths INT UNSIGNED NOT NULL DEFAULT 0,
    player_kills INT UNSIGNED NOT NULL DEFAULT 0,

    player_posx FLOAT NOT NULL DEFAULT 0,
    player_posy FLOAT NOT NULL DEFAULT 0,
    player_posz FLOAT NOT NULL DEFAULT 0,
    player_angle FLOAT NOT NULL DEFAULT 0,
    player_skin SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    player_money INT UNSIGNED NOT NULL DEFAULT 0,
    player_health FLOAT NOT NULL DEFAULT 100,
    player_armour FLOAT NOT NULL DEFAULT 0,
    player_level SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    player_xp INT UNSIGNED NOT NULL DEFAULT 0,
    player_gang INT UNSIGNED NULL DEFAULT NULL,
    player_hunger FLOAT NOT NULL DEFAULT 100,
    player_thirst FLOAT NOT NULL DEFAULT 100,

    INDEX idx_player_level (player_level),
    INDEX idx_player_last_login (player_last_login),
    INDEX idx_player_gang (player_gang)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS gangs (
    gang_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    gang_name VARCHAR(63) NOT NULL UNIQUE,
    gang_leader_id INT UNSIGNED NULL,
    gang_wins INT UNSIGNED NOT NULL DEFAULT 0,
    gang_losses INT UNSIGNED NOT NULL DEFAULT 0,
    gang_draws INT UNSIGNED NOT NULL DEFAULT 0,
    gang_money INT UNSIGNED NOT NULL DEFAULT 0,
    gang_created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_gang_leader (gang_leader_id),
    INDEX idx_gang_wins (gang_wins DESC),
    FOREIGN KEY (gang_leader_id) REFERENCES players(player_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE players 
ADD CONSTRAINT fk_player_gang 
    FOREIGN KEY (player_gang) REFERENCES gangs(gang_id) ON DELETE SET NULL;

CREATE TABLE IF NOT EXISTS houses (
    house_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    house_name VARCHAR(63) NOT NULL UNIQUE,
    house_owner_id INT UNSIGNED NULL,
    house_gang_id INT UNSIGNED NULL,
    house_posx FLOAT NOT NULL DEFAULT 0,
    house_posy FLOAT NOT NULL DEFAULT 0,
    house_posz FLOAT NOT NULL DEFAULT 0,
    house_angle FLOAT NOT NULL DEFAULT 0,

    house_price INT UNSIGNED NOT NULL DEFAULT 0,
    house_created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_house_owner (house_owner_id),
    INDEX idx_house_gang (house_gang_id),
    FOREIGN KEY (house_owner_id) REFERENCES players(player_id) ON DELETE SET NULL,
    FOREIGN KEY (house_gang_id) REFERENCES gangs(gang_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS vehicles (
    vehicle_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    vehicle_owner_id INT UNSIGNED NOT NULL,
    vehicle_game_id SMALLINT UNSIGNED NOT NULL, -- 400-611 in SA-MP
    vehicle_posx FLOAT NOT NULL DEFAULT 0,
    vehicle_posy FLOAT NOT NULL DEFAULT 0,
    vehicle_posz FLOAT NOT NULL DEFAULT 0,
    vehicle_angle FLOAT NOT NULL DEFAULT 0,
    vehicle_health FLOAT NOT NULL DEFAULT 1000,
    vehicle_fuel FLOAT NOT NULL DEFAULT 100,
    vehicle_color1 TINYINT NOT NULL DEFAULT 0,
    vehicle_color2 TINYINT NOT NULL DEFAULT 0,
    vehicle_created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_vehicle_owner (vehicle_owner_id),
    FOREIGN KEY (vehicle_owner_id) REFERENCES players(player_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS weapons (
    weapon_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    weapon_owner_id INT UNSIGNED NOT NULL,
    weapon_game_id TINYINT UNSIGNED NOT NULL, -- 0-46 in SA-MP
    weapon_ammo SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    weapon_created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_weapon_owner (weapon_owner_id),
    FOREIGN KEY (weapon_owner_id) REFERENCES players(player_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS player_items (
    player_item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    player_item_owner_id INT UNSIGNED NOT NULL,
    player_item_type SMALLINT UNSIGNED NOT NULL, -- อ้างอิง enum e_item_type ใน .inc
    player_item_slot TINYINT UNSIGNED NOT NULL DEFAULT 0, -- ช่องเก็บของ 0-19
    player_item_quantity SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    player_item_quality TINYINT UNSIGNED NOT NULL DEFAULT 100,
    player_item_created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_player_owner (player_item_owner_id),
    INDEX idx_item_slot (player_item_owner_id, player_item_slot),
    UNIQUE KEY unique_owner_slot (player_item_owner_id, player_item_slot),
    FOREIGN KEY (player_item_owner_id) REFERENCES players(player_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

