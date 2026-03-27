-- Database schema for Smart Agricultural Advisory Application

CREATE DATABASE IF NOT EXISTS smart_agri_db;
USE smart_agri_db;

-- Table for users (farmers and extension officers)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    user_type ENUM('farmer', 'officer') NOT NULL,
    district VARCHAR(50) DEFAULT 'Mbarara',
    farm_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for crops
CREATE TABLE IF NOT EXISTS crops (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT
);

-- Table for pests and diseases
CREATE TABLE IF NOT EXISTS pests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    crop_id INT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    FOREIGN KEY (crop_id) REFERENCES crops(id)
);

-- Table for weather-pest correlation rules
CREATE TABLE IF NOT EXISTS correlation_rules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pest_id INT,
    min_temp DECIMAL(4,2),
    max_temp DECIMAL(4,2),
    min_humidity INT,
    min_rainfall DECIMAL(5,2),
    recommendation TEXT NOT NULL,
    lead_time INT COMMENT 'Lead time in days for preventive action',
    FOREIGN KEY (pest_id) REFERENCES pests(id)
);

-- Table for alerts generated
CREATE TABLE IF NOT EXISTS alerts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    pest_id INT,
    risk_level ENUM('Low', 'Medium', 'High') DEFAULT 'Medium',
    message TEXT NOT NULL,
    is_sent BOOLEAN DEFAULT FALSE,
    sent_at DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (pest_id) REFERENCES pests(id)
);

-- Initial data seed
INSERT INTO crops (name) VALUES ('Maize'), ('Beans'), ('Banana');

INSERT INTO pests (crop_id, name) VALUES
(1, 'Maize Stalk Borer'),
(3, 'Banana Xanthomonas Wilt (BXW)');

INSERT INTO correlation_rules (pest_id, min_temp, max_temp, min_humidity, recommendation, lead_time)
VALUES (1, 20, 30, 70, 'Apply Neem extract or recommended biopesticides.', 3);

INSERT INTO correlation_rules (pest_id, min_rainfall, min_humidity, recommendation, lead_time)
VALUES (2, 10.00, 75, 'Ensure proper drainage and disinfect tools.', 5);
