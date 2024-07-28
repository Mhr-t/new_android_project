import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/airplane.dart';

class AirplaneStorage {
  static const String _airplaneKey = 'airplanes';

  Future<List<Airplane>> loadAirplanes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_airplaneKey) ?? '[]';
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Airplane.fromJson(json)).toList();
  }

  Future<void> saveAirplane(Airplane airplane) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(airplane.toJson());
    List<Airplane> airplanes = await loadAirplanes();
    airplanes.add(airplane);
    final newJsonString = json.encode(airplanes.map((a) => a.toJson()).toList());
    await prefs.setString(_airplaneKey, newJsonString);
  }

  Future<void> deleteAirplane(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<Airplane> airplanes = await loadAirplanes();
    if (index >= 0 && index < airplanes.length) {
      airplanes.removeAt(index);
      final newJsonString = json.encode(airplanes.map((a) => a.toJson()).toList());
      await prefs.setString(_airplaneKey, newJsonString);
    }
  }

  Future<void> deleteLastAirplane() async {
    final prefs = await SharedPreferences.getInstance();
    List<Airplane> airplanes = await loadAirplanes();
    if (airplanes.isNotEmpty) {
      airplanes.removeLast();
      final newJsonString = json.encode(airplanes.map((a) => a.toJson()).toList());
      await prefs.setString(_airplaneKey, newJsonString);
    }
  }

  Future<Airplane?> getLastAirplane() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_airplaneKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      if (jsonList.isNotEmpty) {
        final lastJson = jsonList.last;
        return Airplane.fromJson(lastJson);
      }
    }
    return null;
  }
}
