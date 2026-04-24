-- ============================================================
--  NexaFlow Business Platform — MySQL Database
--  Compatible with: InfinityFree / phpMyAdmin / MySQL 5.7+
--  Import via: phpMyAdmin → Import → Select this file
-- ============================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

-- ============================================================
-- DATABASE
-- ============================================================
CREATE DATABASE IF NOT EXISTS `nexaflow_db`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `nexaflow_db`;

-- ============================================================
-- TABLE: users
-- ============================================================
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id`           INT(11)      NOT NULL AUTO_INCREMENT,
  `first_name`   VARCHAR(100) NOT NULL,
  `last_name`    VARCHAR(100) NOT NULL DEFAULT '',
  `email`        VARCHAR(255) NOT NULL,
  `password`     VARCHAR(255) NOT NULL COMMENT 'bcrypt hashed',
  `company`      VARCHAR(255) NOT NULL DEFAULT '',
  `role`         ENUM('admin','manager','user') NOT NULL DEFAULT 'user',
  `status`       ENUM('active','inactive','banned') NOT NULL DEFAULT 'active',
  `avatar`       VARCHAR(10)  NOT NULL DEFAULT '',
  `avatar_color` VARCHAR(20)  NOT NULL DEFAULT '#c9a84c',
  `created_at`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE: sessions  (track active login sessions)
-- ============================================================
DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `id`         INT(11)      NOT NULL AUTO_INCREMENT,
  `user_id`    INT(11)      NOT NULL,
  `token`      VARCHAR(512) NOT NULL,
  `ip_address` VARCHAR(45)  NOT NULL DEFAULT '',
  `user_agent` VARCHAR(255) NOT NULL DEFAULT '',
  `expires_at` DATETIME     NOT NULL,
  `created_at` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_token` (`token`(64)),
  CONSTRAINT `fk_sessions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE: tasks
-- ============================================================
DROP TABLE IF EXISTS `tasks`;
CREATE TABLE `tasks` (
  `id`         INT(11)                          NOT NULL AUTO_INCREMENT,
  `user_id`    INT(11)                          NOT NULL,
  `text`       VARCHAR(500)                     NOT NULL,
  `priority`   ENUM('low','medium','high')      NOT NULL DEFAULT 'medium',
  `done`       TINYINT(1)                       NOT NULL DEFAULT 0,
  `created_at` DATETIME                         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME                         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `fk_tasks_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE: activities  (dashboard activity feed)
-- ============================================================
DROP TABLE IF EXISTS `activities`;
CREATE TABLE `activities` (
  `id`           INT(11)      NOT NULL AUTO_INCREMENT,
  `type`         VARCHAR(50)  NOT NULL DEFAULT 'info',
  `icon`         VARCHAR(10)  NOT NULL DEFAULT '📌',
  `title`        VARCHAR(255) NOT NULL,
  `amount`       VARCHAR(50)  NOT NULL DEFAULT '',
  `amount_class` VARCHAR(20)  NOT NULL DEFAULT '',
  `created_at`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE: audit_logs
-- ============================================================
DROP TABLE IF EXISTS `audit_logs`;
CREATE TABLE `audit_logs` (
  `id`         INT(11)                            NOT NULL AUTO_INCREMENT,
  `level`      ENUM('INFO','WARN','ERROR','SUCCESS') NOT NULL DEFAULT 'INFO',
  `message`    VARCHAR(500)                       NOT NULL,
  `user_id`    INT(11)                            DEFAULT NULL,
  `created_at` DATETIME                           NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_level` (`level`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE: projects
-- ============================================================
DROP TABLE IF EXISTS `projects`;
CREATE TABLE `projects` (
  `id`          INT(11)                                       NOT NULL AUTO_INCREMENT,
  `owner_id`    INT(11)                                       NOT NULL,
  `name`        VARCHAR(255)                                  NOT NULL,
  `description` TEXT                                          DEFAULT NULL,
  `status`      ENUM('active','paused','completed','archived') NOT NULL DEFAULT 'active',
  `created_at`  DATETIME                                      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`  DATETIME                                      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_owner` (`owner_id`),
  CONSTRAINT `fk_projects_user` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE: revenue_chart  (weekly revenue data for dashboard chart)
-- ============================================================
DROP TABLE IF EXISTS `revenue_chart`;
CREATE TABLE `revenue_chart` (
  `id`         INT(11)      NOT NULL AUTO_INCREMENT,
  `day_label`  VARCHAR(10)  NOT NULL,
  `amount_k`   DECIMAL(8,2) NOT NULL DEFAULT 0.00 COMMENT 'Amount in thousands USD',
  `week_start` DATE         NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_week` (`week_start`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- SEED DATA
-- ============================================================

-- ---- USERS --------------------------------------------------
-- Passwords are bcrypt hashed (cost 10)
-- admin@nexaflow.com  → admin123
-- all others         → user1234
INSERT INTO `users`
  (`first_name`, `last_name`, `email`, `password`, `company`, `role`, `status`, `avatar`, `avatar_color`, `created_at`)
VALUES
  ('Super',  'Admin',  'admin@nexaflow.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhy2', 'NexaFlow Inc.',  'admin',   'active',   'SA', '#e06c6c', DATE_SUB(NOW(), INTERVAL 120 DAY)),
  ('John',   'Doe',    'john@demo.com',      '$2a$10$jQz8OtKX4v5V7OyBf9lXy.QmNsLiPVKpO8JvHuSk0X4CqMJr4JM.m', 'Demo Corp',      'user',    'active',   'JD', '#c9a84c', DATE_SUB(NOW(), INTERVAL 90  DAY)),
  ('Sarah',  'Chen',   'sarah@acme.com',     '$2a$10$jQz8OtKX4v5V7OyBf9lXy.QmNsLiPVKpO8JvHuSk0X4CqMJr4JM.m', 'Acme Ltd',       'manager', 'active',   'SC', '#6ccea0', DATE_SUB(NOW(), INTERVAL 60  DAY)),
  ('Mike',   'Torres', 'mike@startup.io',    '$2a$10$jQz8OtKX4v5V7OyBf9lXy.QmNsLiPVKpO8JvHuSk0X4CqMJr4JM.m', 'StartupIO',      'user',    'active',   'MT', '#6ca8e0', DATE_SUB(NOW(), INTERVAL 45  DAY)),
  ('Priya',  'Patel',  'priya@techco.in',    '$2a$10$jQz8OtKX4v5V7OyBf9lXy.QmNsLiPVKpO8JvHuSk0X4CqMJr4JM.m', 'TechCo',         'user',    'active',   'PP', '#a78bfa', DATE_SUB(NOW(), INTERVAL 40  DAY)),
  ('James',  'Wright', 'james@nexaflow.com', '$2a$10$jQz8OtKX4v5V7OyBf9lXy.QmNsLiPVKpO8JvHuSk0X4CqMJr4JM.m', 'NexaFlow Inc.',  'manager', 'active',   'JW', '#e8a87c', DATE_SUB(NOW(), INTERVAL 35  DAY)),
  ('Elena',  'Russo',  'elena@design.eu',    '$2a$10$jQz8OtKX4v5V7OyBf9lXy.QmNsLiPVKpO8JvHuSk0X4CqMJr4JM.m', 'DesignEU',       'user',    'inactive', 'ER', '#a78bfa', DATE_SUB(NOW(), INTERVAL 30  DAY)),
  ('David',  'Kim',    'david@corp.kr',      '$2a$10$jQz8OtKX4v5V7OyBf9lXy.QmNsLiPVKpO8JvHuSk0X4CqMJr4JM.m', 'Corp KR',        'user',    'active',   'DK', '#6ca8e0', DATE_SUB(NOW(), INTERVAL 25  DAY)),
  ('Omar',   'Hassan', 'omar@biznet.ae',     '$2a$10$jQz8OtKX4v5V7OyBf9lXy.QmNsLiPVKpO8JvHuSk0X4CqMJr4JM.m', 'BizNet AE',      'user',    'banned',   'OH', '#6b6870', DATE_SUB(NOW(), INTERVAL 20  DAY));

-- ---- TASKS (for user_id = 2 = john@demo.com) ----------------
INSERT INTO `tasks` (`user_id`, `text`, `priority`, `done`, `created_at`) VALUES
  (2, 'Finalize Q3 financial report',        'high',   1, DATE_SUB(NOW(), INTERVAL 5 DAY)),
  (2, 'Review team performance metrics',     'medium', 0, DATE_SUB(NOW(), INTERVAL 4 DAY)),
  (2, 'Update onboarding documentation',     'low',    0, DATE_SUB(NOW(), INTERVAL 3 DAY)),
  (2, 'Schedule investor call for October',  'high',   0, DATE_SUB(NOW(), INTERVAL 2 DAY)),
  (2, 'Deploy v2.4.1 hotfix to production',  'high',   1, DATE_SUB(NOW(), INTERVAL 1 DAY)),
  (3, 'Prepare client presentation deck',    'high',   0, DATE_SUB(NOW(), INTERVAL 3 DAY)),
  (3, 'Review new design proposals',         'medium', 0, DATE_SUB(NOW(), INTERVAL 2 DAY));

-- ---- ACTIVITIES ---------------------------------------------
INSERT INTO `activities` (`type`, `icon`, `title`, `amount`, `amount_class`, `created_at`) VALUES
  ('payment',  '💰', 'Payment received from Acme Corp',     '+$4,200', 'up',   DATE_SUB(NOW(), INTERVAL 2  HOUR)),
  ('user',     '👤', 'New user registered',                 '+1',      'blue', DATE_SUB(NOW(), INTERVAL 4  HOUR)),
  ('project',  '📦', 'Project "Beta Launch" updated',       'Active',  'gold', DATE_SUB(NOW(), INTERVAL 1  DAY)),
  ('alert',    '⚠️', 'Server usage spike detected',        'Alert',   'down', DATE_SUB(NOW(), INTERVAL 1  DAY)),
  ('complete', '✅', 'Sprint #12 completed',                'Done',    'up',   DATE_SUB(NOW(), INTERVAL 2  DAY)),
  ('payment',  '💰', 'Invoice #1042 paid by StartupIO',    '+$2,800', 'up',   DATE_SUB(NOW(), INTERVAL 3  DAY)),
  ('user',     '🔒', 'Admin updated user permissions',      'Info',    'gold', DATE_SUB(NOW(), INTERVAL 4  DAY));

-- ---- AUDIT LOGS ---------------------------------------------
INSERT INTO `audit_logs` (`level`, `message`, `created_at`) VALUES
  ('WARN',    'High memory usage threshold crossed on node-02',            DATE_SUB(NOW(), INTERVAL 90  MINUTE)),
  ('INFO',    'User #8821 verified email address',                         DATE_SUB(NOW(), INTERVAL 122 MINUTE)),
  ('ERROR',   'Failed payment attempt — card declined for sub #4412',      DATE_SUB(NOW(), INTERVAL 138 MINUTE)),
  ('SUCCESS', 'Scheduled backup completed successfully',                   DATE_SUB(NOW(), INTERVAL 229 MINUTE)),
  ('INFO',    'Deploy v2.5.0 pushed to production',                        DATE_SUB(NOW(), INTERVAL 290 MINUTE)),
  ('WARN',    'Rate limit hit on /api/v2/export by user #301',             DATE_SUB(NOW(), INTERVAL 410 MINUTE)),
  ('INFO',    'Daily analytics snapshot generated',                        DATE_SUB(NOW(), INTERVAL 480 MINUTE)),
  ('SUCCESS', 'Database backup completed — 3.2 GB archived',              DATE_SUB(NOW(), INTERVAL 600 MINUTE)),
  ('INFO',    'New user registered: sarah@acme.com',                       DATE_SUB(NOW(), INTERVAL 2   DAY)),
  ('INFO',    'New user registered: admin@nexaflow.com',                   DATE_SUB(NOW(), INTERVAL 120 DAY));

-- ---- PROJECTS -----------------------------------------------
INSERT INTO `projects` (`owner_id`, `name`, `description`, `status`, `created_at`) VALUES
  (1, 'Platform v2.5 Launch',     'Major release with dashboard redesign and new API endpoints', 'active',    DATE_SUB(NOW(), INTERVAL 30 DAY)),
  (2, 'Q3 Client Onboarding',     'Onboard 10 new enterprise clients for Q3',                   'active',    DATE_SUB(NOW(), INTERVAL 25 DAY)),
  (3, 'Brand Refresh 2025',       'Update all brand assets and UI design system',               'active',    DATE_SUB(NOW(), INTERVAL 20 DAY)),
  (2, 'Mobile App Beta',          'Internal beta testing for the NexaFlow mobile app',          'paused',    DATE_SUB(NOW(), INTERVAL 15 DAY)),
  (1, 'Security Audit 2024',      'Annual security audit and penetration testing',              'completed', DATE_SUB(NOW(), INTERVAL 60 DAY)),
  (4, 'StartupIO Integration',    'Custom API integration for StartupIO client',                'active',    DATE_SUB(NOW(), INTERVAL 10 DAY));

-- ---- REVENUE CHART (last 2 weeks) ---------------------------
INSERT INTO `revenue_chart` (`day_label`, `amount_k`, `week_start`) VALUES
  ('Mon', 65.00, DATE_SUB(CURDATE(), INTERVAL 14 DAY)),
  ('Tue', 82.00, DATE_SUB(CURDATE(), INTERVAL 14 DAY)),
  ('Wed', 54.00, DATE_SUB(CURDATE(), INTERVAL 14 DAY)),
  ('Thu', 91.00, DATE_SUB(CURDATE(), INTERVAL 14 DAY)),
  ('Fri', 78.00, DATE_SUB(CURDATE(), INTERVAL 14 DAY)),
  ('Sat', 110.0, DATE_SUB(CURDATE(), INTERVAL 14 DAY)),
  ('Sun', 88.00, DATE_SUB(CURDATE(), INTERVAL 14 DAY)),
  ('Mon', 72.00, DATE_SUB(CURDATE(), INTERVAL 7  DAY)),
  ('Tue', 95.00, DATE_SUB(CURDATE(), INTERVAL 7  DAY)),
  ('Wed', 61.00, DATE_SUB(CURDATE(), INTERVAL 7  DAY)),
  ('Thu', 108.0, DATE_SUB(CURDATE(), INTERVAL 7  DAY)),
  ('Fri', 84.00, DATE_SUB(CURDATE(), INTERVAL 7  DAY)),
  ('Sat', 120.0, DATE_SUB(CURDATE(), INTERVAL 7  DAY)),
  ('Sun', 97.00, DATE_SUB(CURDATE(), INTERVAL 7  DAY));


-- ============================================================
-- USEFUL VIEWS (optional — makes querying easier)
-- ============================================================

-- Active users summary
CREATE OR REPLACE VIEW `v_active_users` AS
  SELECT id, first_name, last_name, email, company, role, avatar, avatar_color, created_at
  FROM users
  WHERE status = 'active'
  ORDER BY created_at DESC;

-- Dashboard stats snapshot
CREATE OR REPLACE VIEW `v_dashboard_stats` AS
  SELECT
    (SELECT COUNT(*) FROM users WHERE status != 'banned')     AS total_users,
    (SELECT COUNT(*) FROM users WHERE status = 'active')      AS active_users,
    (SELECT COUNT(*) FROM tasks WHERE done = 0)               AS pending_tasks,
    (SELECT COUNT(*) FROM tasks WHERE done = 1)               AS completed_tasks,
    (SELECT COUNT(*) FROM projects WHERE status = 'active')   AS active_projects,
    (SELECT COUNT(*) FROM audit_logs WHERE level = 'ERROR'
       AND created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR))   AS errors_24h;


-- ============================================================
-- QUICK REFERENCE
-- ============================================================
-- Tables   : users, sessions, tasks, activities, audit_logs, projects, revenue_chart
-- Views    : v_active_users, v_dashboard_stats
--
-- Login credentials:
--   Admin  →  admin@nexaflow.com  /  admin123
--   User   →  john@demo.com       /  user1234
--   Others →  (email)             /  user1234
--
-- To connect from PHP (InfinityFree):
--   $host = 'sql.yourinfinityfree.net';
--   $db   = 'if0_xxxxxxx_nexaflow_db';
--   $user = 'if0_xxxxxxx';
--   $pass = 'yourpassword';
--   $pdo  = new PDO("mysql:host=$host;dbname=$db;charset=utf8mb4", $user, $pass);
-- ============================================================
