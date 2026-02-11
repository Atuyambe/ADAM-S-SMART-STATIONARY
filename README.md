# Smart Agricultural Advisory Application

This project is a Smart Agricultural Advisory Application designed for Kyera Agricultural Farm in Mbarara District, Uganda. It integrates localized weather forecasts with predictive pest and disease management advisories to enable preventive decision-making among farmers.

## Project Structure

- `proposal.tex`: The research proposal document (LaTeX format).
- `backend/`: PHP REST API and Correlation Engine.
  - `config.php`: Configuration for database and external APIs.
  - `correlation.php`: Core logic for weather-pest correlation.
  - `index.php`: API endpoints.
- `mobile/`: Flutter-based mobile application.
  - `lib/main.dart`: Main application entry and dashboard UI.
  - `pubspec.yaml`: Flutter dependencies.
- `database/`: Database schema and initial data.
  - `schema.sql`: SQL script to set up the database.

## Prerequisites

- **Backend**: PHP 7.4+ and MySQL.
- **Mobile**: Flutter SDK.
- **APIs**:
  - [OpenWeatherMap API Key](https://openweathermap.org/api)
  - [Africa's Talking API Key](https://africastalking.com/) (for SMS)

## Setup Instructions

### 1. Database Setup
1. Import the database schema:
   ```bash
   mysql -u root -p < database/schema.sql
   ```

### 2. Backend Setup
1. Move the `backend` folder to your web server (e.g., `/var/www/html/` or use PHP's built-in server).
2. Edit `backend/config.php` and provide your database credentials and API keys.
3. Start the server:
   ```bash
   cd backend
   php -S localhost:8000
   ```

### 3. Mobile App Setup
1. Navigate to the `mobile` directory:
   ```bash
   cd mobile
   ```
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

## Core Features implemented
- **Correlation Engine**: Logic that takes weather data (temperature, humidity, rainfall) and compares it against pest outbreak rules.
- **REST API**: Endpoints for weather data and risk assessment.
- **Dashboard**: A Flutter-based UI that displays current weather and preventive alerts based on the Correlation Engine's analysis.

## Roadmap
1. Integrate real-time weather from OpenWeatherMap API.
2. Implement SMS notification system using Africa's Talking API.
3. Add a dashboard for extension officers to manage correlation rules.
4. Improve pest risk models based on historical field data from Kyera Farm.
