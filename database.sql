-- ==========================================================
-- OmniStore Enterprise Management System v3.0
-- MySQL / MariaDB Database Schema & Seed Data for XAMPP
-- ==========================================================

CREATE DATABASE IF NOT EXISTS `omnistore` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `omnistore`;

-- Disable foreign key checks during table creation
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------------------------------------
-- 1. Table structure for `accounts`
-- ----------------------------------------------------------
DROP TABLE IF EXISTS `accounts`;
CREATE TABLE `accounts` (
  `id` VARCHAR(36) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL UNIQUE,
  `password` VARCHAR(255) DEFAULT '123456',
  `role` ENUM('Admin', 'Manager', 'Cashier') NOT NULL DEFAULT 'Cashier',
  `status` ENUM('Active', 'Suspended', 'Inactive') NOT NULL DEFAULT 'Active',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------
-- 2. Table structure for `inventory`
-- ----------------------------------------------------------
DROP TABLE IF EXISTS `inventory`;
CREATE TABLE `inventory` (
  `id` VARCHAR(36) NOT NULL,
  `sku` VARCHAR(100) NOT NULL UNIQUE,
  `name` VARCHAR(255) NOT NULL,
  `category` VARCHAR(100) DEFAULT 'General',
  `price` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `cost_price` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `stock` INT NOT NULL DEFAULT 0,
  `min_stock_alert` INT NOT NULL DEFAULT 5,
  `expiry_date` VARCHAR(50) DEFAULT 'N/A',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------
-- 3. Table structure for `suppliers`
-- ----------------------------------------------------------
DROP TABLE IF EXISTS `suppliers`;
CREATE TABLE `suppliers` (
  `id` VARCHAR(36) NOT NULL,
  `company_name` VARCHAR(255) NOT NULL,
  `contact_person` VARCHAR(255) DEFAULT NULL,
  `phone` VARCHAR(50) DEFAULT NULL,
  `category` VARCHAR(100) DEFAULT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------
-- 4. Table structure for `transactions`
-- ----------------------------------------------------------
DROP TABLE IF EXISTS `transactions`;
CREATE TABLE `transactions` (
  `id` VARCHAR(36) NOT NULL,
  `ref_number` VARCHAR(100) NOT NULL,
  `payment_method` VARCHAR(50) DEFAULT 'Cash',
  `items_summary` TEXT DEFAULT NULL,
  `total_amount` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `items_count` INT NOT NULL DEFAULT 1,
  `processed_by` VARCHAR(255) NOT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_ref_number` (`ref_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------
-- 5. Table structure for `transaction_items`
-- ----------------------------------------------------------
DROP TABLE IF EXISTS `transaction_items`;
CREATE TABLE `transaction_items` (
  `id` VARCHAR(36) NOT NULL,
  `transaction_id` VARCHAR(36) NOT NULL,
  `inventory_id` VARCHAR(36) DEFAULT NULL,
  `product_name` VARCHAR(255) NOT NULL,
  `quantity` INT NOT NULL DEFAULT 1,
  `unit_price` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `subtotal` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_trx_items_trx` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_trx_items_inv` FOREIGN KEY (`inventory_id`) REFERENCES `inventory` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------
-- 6. Table structure for `payroll`
-- ----------------------------------------------------------
DROP TABLE IF EXISTS `payroll`;
CREATE TABLE `payroll` (
  `id` VARCHAR(36) NOT NULL,
  `employee_id` VARCHAR(36) DEFAULT NULL,
  `employee_name` VARCHAR(255) NOT NULL,
  `hourly_rate` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `worked_hours` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `gross_salary` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `deductions` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `net_salary` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `payroll_period` VARCHAR(100) DEFAULT NULL,
  `status` VARCHAR(50) DEFAULT 'Paid',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_payroll_account` FOREIGN KEY (`employee_id`) REFERENCES `accounts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------
-- 7. Table structure for `system_logs`
-- ----------------------------------------------------------
DROP TABLE IF EXISTS `system_logs`;
CREATE TABLE `system_logs` (
  `id` VARCHAR(36) NOT NULL,
  `time_stamp` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `user_name` VARCHAR(255) NOT NULL,
  `module` VARCHAR(100) NOT NULL,
  `action_details` TEXT NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- ==========================================================
-- DEFAULT SEED DATA
-- ==========================================================

-- Seed Accounts
INSERT INTO `accounts` (`id`, `name`, `email`, `password`, `role`, `status`, `created_at`) VALUES
('1', 'Cyles Todd G. Matuguina', 'cyles@omnistore.io', '123456', 'Admin', 'Active', '2026-10-23 05:54:00'),
('2', 'blake', 'blake@omnistore.io', '123456', 'Cashier', 'Active', '2026-10-23 05:54:00'),
('3', 'Errol E. Areglo', 'errol@omnistore.io', '123456', 'Manager', 'Active', '2026-10-23 05:54:00'),
('4', 'Von Pierre P. Pilapil', 'von@omnistore.io', '123456', 'Admin', 'Active', '2026-10-23 05:54:00');

-- Seed Inventory
INSERT INTO `inventory` (`id`, `sku`, `name`, `category`, `price`, `cost_price`, `stock`, `min_stock_alert`, `expiry_date`, `created_at`) VALUES
('1', '4800101', 'Wireless Ergonomic Mouse', 'Peripherals', 650.00, 420.00, 45, 10, '2027-12-31', NOW()),
('2', '4800102', 'Mechanical Gaming Keyboard', 'Peripherals', 1850.00, 1200.00, 4, 10, '2028-06-30', NOW()),
('3', '4800103', '27-inch IPS Monitor', 'Displays', 8499.00, 6500.00, 12, 5, 'N/A', NOW());

-- Seed Suppliers
INSERT INTO `suppliers` (`id`, `company_name`, `contact_person`, `phone`, `category`, `created_at`) VALUES
('1', 'TechSupply Phils Inc.', 'Juan Dela Cruz', '09171234567', 'Electronics', NOW()),
('2', 'Omni Hardware Ltd', 'Maria Santos', '09189876543', 'Peripherals', NOW());

-- Seed Transactions
INSERT INTO `transactions` (`id`, `ref_number`, `payment_method`, `items_summary`, `total_amount`, `items_count`, `processed_by`, `created_at`) VALUES
('1', 'TRX-98214', 'Cash', 'Wireless Ergonomic Mouse (x2)', 1456.00, 2, 'Von Pierre P. Pilapil', NOW());

-- Seed Payroll
INSERT INTO `payroll` (`id`, `employee_id`, `employee_name`, `hourly_rate`, `worked_hours`, `gross_salary`, `deductions`, `net_salary`, `payroll_period`, `status`, `created_at`) VALUES
('1', '1', 'Cyles Todd G. Matuguina', 120.00, 80.00, 9600.00, 850.00, 8750.00, 'Current Semi-Monthly', 'Paid', NOW()),
('2', '3', 'Errol E. Areglo', 110.00, 80.00, 8800.00, 780.00, 8020.00, 'Current Semi-Monthly', 'Paid', NOW());

-- Seed System Logs
INSERT INTO `system_logs` (`id`, `time_stamp`, `user_name`, `module`, `action_details`) VALUES
('1', NOW(), 'System', 'Setup', 'Database schema initialized and seed records imported successfully.');
