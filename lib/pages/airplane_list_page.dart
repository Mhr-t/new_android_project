import 'package:flutter/material.dart';
import '../models/airplane.dart';
import '../services/airplane_storage.dart';
import 'airplane_form_page.dart';

class AirplaneListPage extends StatefulWidget {
  @override
  _AirplaneListPageState createState() => _AirplaneListPageState();
}

class _AirplaneListPageState extends State<AirplaneListPage> {
  List<Airplane> _airplanes = [];
  final _airplaneStorage = AirplaneStorage(); // Create an instance of AirplaneStorage

  @override
  void initState() {
    super.initState();
    _loadAirplanes();
  }

  void _loadAirplanes() async {
    final airplanes = await _airplaneStorage.loadAirplanes(); // Use instance method
    setState(() {
      _airplanes = airplanes;
    });
  }

  void _deleteAirplane(int index) async {
    await _airplaneStorage.deleteAirplane(index); // Use instance method
    _loadAirplanes();
  }

  void _navigateToFormPage([Airplane? airplane, int? index]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AirplaneFormPage(
          airplane: airplane,
          index: index,
        ),
      ),
    ).then((_) => _loadAirplanes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airplane List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _navigateToFormPage(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _airplanes.length,
        itemBuilder: (context, index) {
          final airplane = _airplanes[index];
          return ListTile(
            title: Text(airplane.type),
            subtitle: Text('Passengers: ${airplane.numberOfPassengers}'),
            onTap: () => _navigateToFormPage(airplane, index),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteAirplane(index),
            ),
          );
        },
      ),
    );
  }
}
