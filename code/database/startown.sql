CREATE TABLE IF NOT EXISTS players 
(
    player_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    player_name VARCHAR(24) NOT NULL UNIQUE,
    player_password VARCHAR(128) NOT NULL,
    player_admin TINYINT UNSIGNED NOT NULL DEFAULT 0,
    player_last_login DATETIME NULL,
    player_registered_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    player_posx FLOAT NOT NULL DEFAULT 0,
    player_posy FLOAT NOT NULL DEFAULT 0,
    player_posz FLOAT NOT NULL DEFAULT 0,
    player_angle FLOAT NOT NULL DEFAULT 0,
    player_skin SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    player_money INT NOT NULL DEFAULT 0,
    player_health FLOAT NOT NULL DEFAULT 100,
    player_armour FLOAT NOT NULL DEFAULT 0,
    player_level SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    player_xp INT UNSIGNED NOT NULL DEFAULT 0,
    player_gang INT NOT NULL DEFAULT 0,
    player_hunger FLOAT NOT NULL DEFAULT 100,
    player_thirst FLOAT NOT NULL DEFAULT 100,

    INDEX idx_player_gang (player_gang),
    INDEX idx_player_level (player_level),
    INDEX idx_player_last_login (player_last_login)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS items (
    item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    item_owner_id INT UNSIGNED NOT NULL,
    item_name VARCHAR(63) NOT NULL,
    item_description VARCHAR(255) NOT NULL,
    item_quality TINYINT UNSIGNED NOT NULL DEFAULT 0,
    item_created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_item_owner (item_owner_id),
    INDEX idx_item_name (item_name),
    FOREIGN KEY (item_owner_id) REFERENCES players(player_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
