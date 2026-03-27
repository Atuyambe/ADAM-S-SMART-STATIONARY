import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const SmartAgriApp());
}

class SmartAgriApp extends StatelessWidget {
  const SmartAgriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Agri Advisory',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic>? weatherData;
  List<dynamic> risks = [];
  bool isLoading = true;

  // Configuration: Change this to your backend IP address.
  // Use 'http://10.0.2.2:8000/risks' for Android Emulator.
  // Use your machine's local IP (e.g., 'http://192.168.1.10:8000/risks') for physical devices.
  final String apiUrl = 'http://localhost:8000/risks';

  @override
  void initState() {
    super.initState();
    fetchRisks();
  }

  Future<void> fetchRisks() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          weatherData = data['weather'];
          risks = data['risks'];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      // In a real app, show error to user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kyera Farm Advisory'),
        actions: [
          IconButton(onPressed: fetchRisks, icon: const Icon(Icons.refresh))
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWeatherCard(),
                  const SizedBox(height: 20),
                  const Text(
                    'Preventive Alerts',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (risks.isEmpty)
                    const Text('No immediate risks detected.')
                  else
                    ...risks.map((risk) => _buildRiskCard(risk)).toList(),
                ],
              ),
            ),
    );
  }

  Widget _buildWeatherCard() {
    if (weatherData == null) return const SizedBox();
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${weatherData!['temp']}°C',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Text(weatherData!['description']),
              ],
            ),
            Column(
              children: [
                const Icon(Icons.water_drop, color: Colors.blue),
                Text('${weatherData!['humidity']}% Humid'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRiskCard(Map<String, dynamic> risk) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.warning, color: Colors.orange),
        title: Text(risk['pest_name'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(risk['recommendation']),
            const SizedBox(height: 4),
            Text(
              'Lead time: ${risk['lead_time']}',
              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
