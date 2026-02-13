from flask import Flask, render_template, request, jsonify
import sqlite3
import requests
from datetime import datetime

app = Flask(__name__)

# --- Configuration ---
DB_NAME = "kyera_farm.db"
OPENWEATHER_API_KEY = "YOUR_API_KEY"  # Replace with actual key
MBARARA_LAT = -0.6067
MBARARA_LON = 30.6561

# --- Database Setup ---
def init_db():
    conn = sqlite3.connect(DB_NAME)
    c = conn.cursor()

    # Create tables if they don't exist
    c.execute('''CREATE TABLE IF NOT EXISTS users
                 (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT UNIQUE, device_type TEXT)''')
    c.execute('''CREATE TABLE IF NOT EXISTS rules
                 (id INTEGER PRIMARY KEY AUTOINCREMENT, pest_name TEXT, min_temp REAL, max_temp REAL,
                  min_humidity REAL, min_rainfall REAL, recommendation TEXT, lead_time INTEGER)''')

    # Seed Rules only if empty
    c.execute('SELECT COUNT(*) FROM rules')
    if c.fetchone()[0] == 0:
        rules = [
            ('Maize Stalk Borer', 20.0, 30.0, 70.0, 0.0, 'Apply Neem extract biopesticide.', 3),
            ('Banana Xanthomonas Wilt', 15.0, 35.0, 75.0, 10.0, 'Disinfect tools and remove infected buds.', 5)
        ]
        c.executemany('INSERT INTO rules (pest_name, min_temp, max_temp, min_humidity, min_rainfall, recommendation, lead_time) VALUES (?,?,?,?,?,?,?)', rules)

    conn.commit()
    conn.close()

# --- Logic Engine ---
def get_weather_and_rules():
    # Mock weather for demonstration (In production, use requests to OpenWeather)
    weather = {
        'temp': 26.5,
        'humidity': 82,
        'rainfall': 12.0,
        'description': 'Showers'
    }

    conn = sqlite3.connect(DB_NAME)
    conn.row_factory = sqlite3.Row
    c = conn.cursor()
    c.execute('SELECT * FROM rules')
    rules = c.fetchall()

    risks = []
    for rule in rules:
        is_risk = True
        if rule['min_temp'] and weather['temp'] < rule['min_temp']: is_risk = False
        if rule['max_temp'] and weather['temp'] > rule['max_temp']: is_risk = False
        if rule['min_humidity'] and weather['humidity'] < rule['min_humidity']: is_risk = False
        if rule['min_rainfall'] and weather['rainfall'] < rule['min_rainfall']: is_risk = False

        if is_risk:
            risks.append(dict(rule))

    conn.close()
    return weather, risks

# --- Routes ---
@app.route('/')
def dashboard():
    weather, risks = get_weather_and_rules()
    conn = sqlite3.connect(DB_NAME)
    conn.row_factory = sqlite3.Row
    users = conn.execute('SELECT * FROM users').fetchall()
    conn.close()
    return render_template('index.html', weather=weather, risks=risks, users=users)

@app.route('/sms/incoming', methods=['POST'])
def sms_webhook():
    phone = request.form.get('from')
    text = request.form.get('text', '')

    if text.upper().startswith('JOIN'):
        name = text[5:].strip()
        try:
            conn = sqlite3.connect(DB_NAME)
            conn.execute('INSERT INTO users (name, phone, device_type) VALUES (?, ?, ?)',
                         (name, phone, 'Feature Phone'))
            conn.commit()
            conn.close()
            return jsonify({"status": "success", "message": f"Welcome {name}, you are registered for SMS alerts."})
        except Exception as e:
            return jsonify({"status": "error", "message": str(e)})

    return jsonify({"status": "ignored"})

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=5000, debug=True)
