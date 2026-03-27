<?php
require_once 'config.php';

class CorrelationEngine {
    /**
     * Rule-based Advisory Engine
     *
     * Uses expert-validated threshold logic to correlate weather data with pest/disease risks.
     * Example logic: IF humidity > threshold AND temp > threshold THEN Risk = High.
     *
     * @param array $weatherData Current and forecast weather
     * @param array $rules Expert-validated pest risk rules from database
     * @return array Detected risks
     */
    public function analyzeRisks($weatherData, $rules) {
        $risks = [];

        foreach ($rules as $rule) {
            $isRisk = true;

            // Check temperature condition
            if (isset($rule['min_temp']) && $weatherData['temp'] < $rule['min_temp']) $isRisk = false;
            if (isset($rule['max_temp']) && $weatherData['temp'] > $rule['max_temp']) $isRisk = false;

            // Check humidity condition
            if (isset($rule['min_humidity']) && $weatherData['humidity'] < $rule['min_humidity']) $isRisk = false;

            // Check rainfall condition
            if (isset($rule['min_rainfall']) && $weatherData['rainfall'] < $rule['min_rainfall']) $isRisk = false;

            if ($isRisk) {
                $risks[] = [
                    'pest_name' => $rule['pest_name'],
                    'risk_level' => 'High',
                    'recommendation' => $rule['recommendation'],
                    'lead_time' => $rule['lead_time'] . ' days'
                ];
            }
        }

        return $risks;
    }

    /**
     * Fetches weather from external API (OpenWeatherMap)
     */
    public function fetchWeatherData($lat, $lon) {
        // Placeholder for real API call
        // $url = "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=" . OPENWEATHER_API_KEY;
        // return json_decode(file_get_contents($url), true);

        // Mock data for Kyera Farm
        return [
            'temp' => 28.5,
            'humidity' => 82,
            'rainfall' => 15.0,
            'description' => 'Light rain'
        ];
    }
}
?>
