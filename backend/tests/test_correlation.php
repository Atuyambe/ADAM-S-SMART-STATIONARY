<?php
require_once 'backend/correlation.php';

$engine = new CorrelationEngine();

$weather = [
    'temp' => 25,
    'humidity' => 80,
    'rainfall' => 5,
    'description' => 'Normal'
];

$rules = [
    [
        'pest_name' => 'Maize Stalk Borer',
        'min_temp' => 20,
        'max_temp' => 30,
        'min_humidity' => 70,
        'recommendation' => 'Apply Neem extract',
        'lead_time' => 3
    ]
];

$risks = $engine->analyzeRisks($weather, $rules);

if (count($risks) === 1 && $risks[0]['pest_name'] === 'Maize Stalk Borer') {
    echo "Test Passed: Risk detected correctly.\n";
} else {
    echo "Test Failed: Risk not detected.\n";
    print_r($risks);
    exit(1);
}

$weather['temp'] = 15; // Too cold
$risks = $engine->analyzeRisks($weather, $rules);

if (count($risks) === 0) {
    echo "Test Passed: No risk detected correctly for low temperature.\n";
} else {
    echo "Test Failed: Risk detected incorrectly for low temperature.\n";
    exit(1);
}
?>
