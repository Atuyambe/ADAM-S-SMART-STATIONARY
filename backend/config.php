<?php
// Database configuration
define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_NAME', 'smart_agri_db');

// External APIs
define('OPENWEATHER_API_KEY', 'YOUR_OPENWEATHER_API_KEY');
define('AFRICASTALKING_API_KEY', 'YOUR_AFRICASTALKING_API_KEY');
define('AFRICASTALKING_USERNAME', 'sandbox');

// Error reporting for development
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Helper function for database connection
function getDbConnection() {
    try {
        $dsn = "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=utf8mb4";
        $options = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ];
        return new PDO($dsn, DB_USER, DB_PASS, $options);
    } catch (PDOException $e) {
        throw new PDOException($e->getMessage(), (int)$e->getCode());
    }
}
?>
