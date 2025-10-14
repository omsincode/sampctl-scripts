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

-- �����������������ҧ (����ö���������ͧ���)
INSERT INTO items (item_name, item_description, item_weight) VALUES
('����ѧ', '����ѧ����Ѻ������ѧ���Ե', 0.2),
('��Ӵ���', '�Ǵ��Ӵ������Ҵ', 0.5),
('�Ҿ͡', '������Ѻ�ѡ�ҺҴ��', 0.1),
('�������红ͧ', '����������Ѻ�红ͧ', 1.0),
('俩��', '俩������Ѻ��ͧ�ҧ', 0.3),
('��Ͷ��', '���Ѿ����Ͷ������Ѻ�Դ����������', 0.2),
('�ح�ö', '�ح�����Ѻ�Դö¹��', 0.05),
('�Թʴ', '�Թʴ�������ö�������', 0.0),
('�׹ Desert Eagle', '�׹����Ҵ .50 AE', 1.8),
('����ع�׹', '����ع����Ѻ�׹', 0.5),
('����͡ѹ����ع', '����ͻ�ͧ�ѹ����ع', 3.5),
('�ش����ͧ��ͪ�ҧ', '����ͧ��ͫ���ö', 5.0),
('��¡���', '�������Ѻ����ö', 2.0),
('�ҧ������', '�ҧö¹��������', 8.0),
('���ͧ�����ٻ', '���ͧ����Ѻ�����Ҿ', 0.8),
('GPS', '����ͧ�ӷҧ GPS', 0.3),
('��͡', '��͡��� 10 ����', 1.5),
('����ʺ��', '����ʺ�����', 1.2),
('˹�ҡҡ͹����', '˹�ҡҡ��ͧ�ѹ���', 0.05),
('�������Թ', '����������Ѻ���Թ', 0.1)
ON DUPLICATE KEY UPDATE item_name=item_name;