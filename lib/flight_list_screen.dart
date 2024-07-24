import 'package:flutter/material.dart';
import 'add_edit_flight_screen.dart';
import 'shared_preferences_helper.dart';

class FlightListScreen extends StatefulWidget {
  const FlightListScreen({super.key});

  @override
  _FlightListScreenState createState() => _FlightListScreenState();
}

class _FlightListScreenState extends State<FlightListScreen> {
  final SharedPreferencesHelper _prefsHelper = SharedPreferencesHelper();
  late Future<List<Map<String, dynamic>>> _flights;

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  void _loadFlights() {
    setState(() {
      _flights = _prefsHelper.getFlights();
    });
  }

  void _onFlightUpdated() {
    _loadFlights();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _flights,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No flights available.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final flight = snapshot.data![index];
              return ListTile(
                title: Text('${flight['departureCity']} to ${flight['destinationCity']}'),
                subtitle: Text('Departure: ${flight['departureTime']}, Arrival: ${flight['arrivalTime']}'),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditFlightScreen(
                        flight: flight,
                        index: index,
                        onFlightUpdated: _onFlightUpdated,
                      ),
                    ),
                  );
                  _onFlightUpdated();
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditFlightScreen(
                onFlightUpdated: _onFlightUpdated,
              ),
            ),
          );
          _onFlightUpdated();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
