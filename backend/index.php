<?php
header("Content-Type: application/json");
require_once 'config.php';
require_once 'correlation.php';

$method = $_SERVER['REQUEST_METHOD'];
$request = explode('/', trim($_SERVER['PATH_INFO'] ?? '', '/'));

$engine = new CorrelationEngine();

switch ($request[0]) {
    case 'weather':
        $lat = $_GET['lat'] ?? -0.6067; // Mbarara default
        $lon = $_GET['lon'] ?? 30.6561;
        $data = $engine->fetchWeatherData($lat, $lon);
        echo json_encode(['status' => 'success', 'data' => $data]);
        break;

    case 'risks':
        // Mock rules for demonstration
        $rules = [
            [
                'pest_name' => 'Maize Stalk Borer',
                'min_temp' => 20,
                'max_temp' => 30,
                'min_humidity' => 70,
                'recommendation' => 'Apply Neem extract or recommended biopesticides.',
                'lead_time' => 3
            ],
            [
                'pest_name' => 'Banana Xanthomonas Wilt (BXW)',
                'min_rainfall' => 10,
                'min_humidity' => 75,
                'recommendation' => 'Ensure proper drainage and disinfect tools.',
                'lead_time' => 5
            ]
        ];

        $weather = $engine->fetchWeatherData(-0.6067, 30.6561);
        $risks = $engine->analyzeRisks($weather, $rules);

        echo json_encode([
            'status' => 'success',
            'weather' => $weather,
            'risks' => $risks
        ]);
        break;

    case 'notify':
        // Placeholder for SMS integration using Africa's Talking
        echo json_encode(['status' => 'success', 'message' => 'Notifications queued']);
        break;

    default:
        echo json_encode(['status' => 'error', 'message' => 'Endpoint not found']);
        break;
}
?>
