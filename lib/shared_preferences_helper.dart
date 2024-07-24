import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _flightsKey = 'flights';

  Future<void> addFlight(Map<String, dynamic> flight) async {
    final prefs = await SharedPreferences.getInstance();
    final flightsJson = prefs.getStringList(_flightsKey) ?? [];
    final flightJson = jsonEncode(flight);
    flightsJson.add(flightJson);
    await prefs.setStringList(_flightsKey, flightsJson);
  }

  Future<List<Map<String, dynamic>>> getFlights() async {
    final prefs = await SharedPreferences.getInstance();
    final flightsJson = prefs.getStringList(_flightsKey) ?? [];
    return flightsJson.map((json) => jsonDecode(json) as Map<String, dynamic>).toList();
  }

  Future<void> updateFlight(int index, Map<String, dynamic> flight) async {
    final prefs = await SharedPreferences.getInstance();
    final flightsJson = prefs.getStringList(_flightsKey) ?? [];
    flightsJson[index] = jsonEncode(flight);
    await prefs.setStringList(_flightsKey, flightsJson);
  }

  Future<void> deleteFlight(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final flightsJson = prefs.getStringList(_flightsKey) ?? [];
    flightsJson.removeAt(index);
    await prefs.setStringList(_flightsKey, flightsJson);
  }
}
