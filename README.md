# Smart Agricultural Advisory Application (Unified System)

This project is a **Unified Smart Agricultural Advisory Application** designed for Kyera Agricultural Farm. It combines a Web Dashboard for smartphone users and an SMS logic engine for feature phone users into a single Python application.

## Project Structure

- `unified_app/`: The core Python application.
  - `app.py`: Flask application handling logic, database, and endpoints.
  - `templates/index.html`: Web Dashboard UI.
  - `kyera_farm.db`: SQLite database (auto-generated).
- `proposal.tex`: The research proposal document (LaTeX).
- `database/`: (Legacy) Previous SQL schema.
- `backend/`, `mobile/`: (Legacy) Previous multi-scaffold components.

## Prerequisites

- Python 3.x
- Flask
- Requests

## Setup Instructions (Kali Linux / Ubuntu)

1. **Navigate to the app directory**:
   ```bash
   cd "unified_app"
   ```

2. **Install dependencies**:
   ```bash
   pip install flask requests
   ```

3. **Run the application**:
   ```bash
   python3 app.py
   ```
   The system will automatically initialize the database on the first run.

4. **Access the Dashboard**:
   Open your browser and go to: `http://127.0.0.1:5000`

## Testing the SMS Logic
You can simulate an incoming SMS from a feature phone user by using `curl` in your terminal:

```bash
curl -X POST -d "from=+256770000000&text=JOIN Adam" http://127.0.0.1:5000/sms/incoming
```
After running this, refresh the dashboard to see "Adam" added to the registered farmers list.

## Core Features
- **Unified Engine**: A single logic source for weather data and pest risk rules.
- **Hybrid Alerting**: Supports both visual alerts (Web) and text-based alerts (SMS).
- **Rule-based Logic**: Expert-validated thresholds trigger preventive advisories.
