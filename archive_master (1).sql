-- =========================================================
-- Archive Master Project (Fixed Version)
-- =========================================================

-- 1. Create Database
CREATE DATABASE IF NOT EXISTS archive_master;
USE archive_master;

-- =======================
-- 2. Tables
-- =======================
-- Drop if already exists (for clean setup)
DROP TABLE IF EXISTS delete_log;
DROP TABLE IF EXISTS archive_orders;
DROP TABLE IF EXISTS orders;

-- Orders table (main data)
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100),
    amount DECIMAL(10,2),
    created_at DATETIME DEFAULT NOW()
);

-- Archive table
CREATE TABLE archive_orders (
    order_id INT,
    customer_name VARCHAR(100),
    amount DECIMAL(10,2),
    created_at DATETIME,
    archived_at DATETIME DEFAULT NOW()
);

-- Delete log table
CREATE TABLE delete_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    deleted_at DATETIME DEFAULT NOW()
);

-- =======================
-- 3. Function
-- =======================
DELIMITER $$
CREATE FUNCTION days_diff(order_date DATETIME)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(NOW(), order_date);
END$$
DELIMITER ;

-- =======================
-- 4. Procedure
-- =======================
DELIMITER $$
CREATE PROCEDURE archive_and_delete()
BEGIN
    -- Archive old records
    INSERT INTO archive_orders (order_id, customer_name, amount, created_at)
    SELECT order_id, customer_name, amount, created_at
    FROM orders
    WHERE days_diff(created_at) > 30;

    -- Delete them from orders
    DELETE FROM orders
    WHERE days_diff(created_at) > 30;
END$$
DELIMITER ;

-- =======================
-- 5. Trigger
-- =======================
DELIMITER $$
CREATE TRIGGER before_order_delete
BEFORE DELETE ON orders
FOR EACH ROW
BEGIN
    INSERT INTO delete_log (order_id)
    VALUES (OLD.order_id);
END$$
DELIMITER ;

-- =======================
-- 6. Event
-- =======================
DELIMITER $$
CREATE EVENT IF NOT EXISTS event_archive_orders
ON SCHEDULE EVERY 30 DAY
DO
    CALL archive_and_delete();
$$
DELIMITER ;

-- =======================
-- 7. Sample Data
-- =======================
INSERT INTO orders (customer_name, amount, created_at) VALUES
('Ravi Kumar', 1200.50, NOW() - INTERVAL 40 DAY),
('Anita Sharma', 800.00, NOW() - INTERVAL 35 DAY),
('John Doe', 1500.75, NOW() - INTERVAL 20 DAY),
('Priya Singh', 950.00, NOW() - INTERVAL 5 DAY),
('David Lee', 2100.25, NOW() - INTERVAL 60 DAY);
