-- Schema upgraded for better consistency, defaults, and extensibility
-- Character set chosen: utf8mb4 for full unicode (Thai + emoji)

CREATE TABLE IF NOT EXISTS players (
    player_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    player_name VARCHAR(24) NOT NULL UNIQUE,
    player_password VARCHAR(128) NOT NULL,
    player_admin TINYINT UNSIGNED NOT NULL DEFAULT 0,
    player_last_login DATETIME NULL,
    player_posx FLOAT NOT NULL DEFAULT 0,
    player_posy FLOAT NOT NULL DEFAULT 0,
    player_posz FLOAT NOT NULL DEFAULT 0,
    player_angle FLOAT NOT NULL DEFAULT 0,
    player_skin SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    player_money INT NOT NULL DEFAULT 0,
    player_health TINYINT UNSIGNED NOT NULL DEFAULT 100,
    player_armour TINYINT UNSIGNED NOT NULL DEFAULT 0,
    player_level SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    player_xp INT UNSIGNED NOT NULL DEFAULT 0,
    player_gang INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX idx_player_gang (player_gang),
    INDEX idx_player_level (player_level)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Each player has exactly one inventory row (optional uniqueness)
CREATE TABLE IF NOT EXISTS inventory (
    inventory_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    inventory_owner INT UNSIGNED NOT NULL UNIQUE,
    CONSTRAINT fk_inventory_owner FOREIGN KEY (inventory_owner)
        REFERENCES players(player_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS items (
    item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(63) NOT NULL,
    item_description VARCHAR(255) NOT NULL,
    item_weight FLOAT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Junction table: many items per inventory
CREATE TABLE IF NOT EXISTS inventory_items (
    inventory_id INT UNSIGNED NOT NULL,
    item_id INT UNSIGNED NOT NULL,
    quantity INT UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (inventory_id, item_id),
    CONSTRAINT fk_inv_items_inventory FOREIGN KEY (inventory_id)
        REFERENCES inventory(inventory_id) ON DELETE CASCADE,
    CONSTRAINT fk_inv_items_item FOREIGN KEY (item_id)
        REFERENCES items(item_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ข้อมูลไอเท็มตัวอย่าง (สามารถแก้ไขได้ตามต้องการ)
INSERT INTO items (item_name, item_description, item_weight) VALUES
('ขนมปัง', 'ขนมปังสำหรับเพิ่มพลังชีวิต', 0.2),
('น้ำดื่ม', 'ขวดน้ำดื่มสะอาด', 0.5),
('ยาพอก', 'ยาสำหรับรักษาบาดแผล', 0.1),
('กระเป๋าเก็บของ', 'กระเป๋าสำหรับเก็บของ', 1.0),
('ไฟฉาย', 'ไฟฉายสำหรับส่องทาง', 0.3),
('มือถือ', 'โทรศัพท์มือถือสำหรับติดต่อสื่อสาร', 0.2),
('กุญแจรถ', 'กุญแจสำหรับเปิดรถยนต์', 0.05),
('เงินสด', 'เงินสดที่สามารถใช้จ่ายได้', 0.0),
('ปืน Desert Eagle', 'ปืนพกขนาด .50 AE', 1.8),
('กระสุนปืน', 'กระสุนสำหรับปืน', 0.5),
('เสื้อกันกระสุน', 'เสื้อป้องกันกระสุน', 3.5),
('ชุดเครื่องมือช่าง', 'เครื่องมือซ่อมรถ', 5.0),
('สายกู้ไฟ', 'สายสำหรับกู้ไฟรถ', 2.0),
('ยางอะไหล่', 'ยางรถยนต์อะไหล่', 8.0),
('กล้องถ่ายรูป', 'กล้องสำหรับถ่ายภาพ', 0.8),
('GPS', 'เครื่องนำทาง GPS', 0.3),
('เชือก', 'เชือกยาว 10 เมตร', 1.5),
('ไม้เบสบอล', 'ไม้เบสบอลไม้', 1.2),
('หน้ากากอนามัย', 'หน้ากากป้องกันฝุ่น', 0.05),
('กระเป๋าเงิน', 'กระเป๋าสำหรับเก็บเงิน', 0.1)
ON DUPLICATE KEY UPDATE item_name=item_name;