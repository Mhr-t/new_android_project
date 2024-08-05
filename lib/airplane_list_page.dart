import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:your_app_name/add_airplane_page.dart';
import 'package:your_app_name/airplane_detail_page.dart';
import 'package:your_app_name/models/airplane_model.dart';
import 'package:your_app_name/utils/encrypted_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AirplaneListPage extends StatefulWidget {
  @override
  _AirplaneListPageState createState() => _AirplaneListPageState();
}

class _AirplaneListPageState extends State<AirplaneListPage> {
  List<Airplane> _airplaneList = [];
  List<Airplane> _filteredAirplaneList = [];
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _loadAirplanes();
    _loadSearchText();
    _searchController.addListener(_filterAirplanes);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterAirplanes);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAirplanes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String airplanesJson = prefs.getString('airplaneList') ?? '[]';
    List<dynamic> airplaneListMap = jsonDecode(airplanesJson);
    List<Airplane> airplanes = airplaneListMap.map((map) => Airplane.fromMap(map)).toList();
    setState(() {
      _airplaneList = airplanes;
      _filteredAirplaneList = airplanes;
    });
  }

  Future<void> _saveAirplanes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String airplanesJson = jsonEncode(_airplaneList.map((airplane) => airplane.toMap()).toList());
    prefs.setString('airplaneList', airplanesJson);
  }

  Future<void> _loadSearchText() async {
    String? searchText = await EncryptedPreferences.readValue('searchText');
    setState(() {
      _searchText = searchText ?? "";
      _searchController.text = _searchText;
    });
  }

  Future<void> _saveSearchText(String text) async {
    await EncryptedPreferences.writeValue('searchText', text);
  }

  void _filterAirplanes() {
    setState(() {
      _searchText = _searchController.text.toLowerCase();
      _saveSearchText(_searchText);
      _filteredAirplaneList = _airplaneList.where((airplane) {
        return airplane.type.toLowerCase().contains(_searchText);
      }).toList();
    });
  }

  void _addAirplane(Airplane airplane) {
    setState(() {
      _airplaneList.add(airplane);
      _filteredAirplaneList = _airplaneList;
    });
    _saveAirplanes();
  }

  void _updateAirplane(Airplane updatedAirplane) {
    setState(() {
      int index = _airplaneList.indexWhere((airplane) => airplane.id == updatedAirplane.id);
      if (index != -1) {
        _airplaneList[index] = updatedAirplane;
        _filteredAirplaneList = _airplaneList;
      }
    });
    _saveAirplanes();
  }

  void _deleteAirplane(int id) {
    setState(() {
      _airplaneList.removeWhere((airplane) => airplane.id == id);
      _filteredAirplaneList = _airplaneList;
    });
    _saveAirplanes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airplane List'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _showInstructions,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Airplanes',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchText = "";
                      _saveSearchText("");
                      _filteredAirplaneList = _airplaneList;
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredAirplaneList.length,
              itemBuilder: (context, index) {
                Airplane airplane = _filteredAirplaneList[index];
                return ListTile(
                  title: Text(airplane.type),
                  subtitle: Text('Passengers: ${airplane.passengers}, Speed: ${airplane.maxSpeed}, Range: ${airplane.range}'),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AirplaneDetailPage(
                          airplane: airplane,
                          onUpdate: _updateAirplane,
                          onDelete: _deleteAirplane,

                        ),
                      ),
                    );
                    _loadAirplanes();
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAirplanePage(),
            ),
          );

          if (result != null && result is Airplane) {
            _addAirplane(result);
          }
        },
      ),
    );
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Instructions'),
          content: Text('Here are the instructions on how to use the interface...'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
