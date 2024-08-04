import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'localization.dart';
import 'shared_preferences_helper.dart';
import 'add_edit_flight_screen.dart';

class FlightListScreen extends StatefulWidget {
  final ValueChanged<Locale> onLocaleChange;

  const FlightListScreen({required this.onLocaleChange, super.key});

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

  void _changeLanguage(String languageCode) {
    Locale newLocale = Locale(languageCode);
    widget.onLocaleChange(newLocale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Localization.of(context).translate('title')),
        actions: [
          DropdownButton<Locale>(
            value: Localizations.localeOf(context),
            icon: const Icon(Icons.language, color: Colors.blue),
            dropdownColor: Colors.cyan,
            items: const [
              DropdownMenuItem(
                value: Locale('en'),
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: Locale('fr'),
                child: Text('Français'),
              ),
            ],
            onChanged: (Locale? locale) {
              if (locale != null) _changeLanguage(locale.languageCode);
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('images/images.jpe'
              'g', fit: BoxFit.cover), // Ensure the correct path
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _flights,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('${Localization.of(context).translate('error')} ${snapshot.error}'),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text(Localization.of(context).translate('noFlightsAvailable')));
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final flight = snapshot.data![index];
                  final departureTime = DateFormat('yyyy-MM-dd – HH:mm').format(DateTime.parse(flight['departureTime']));
                  final arrivalTime = DateFormat('yyyy-MM-dd – HH:mm').format(DateTime.parse(flight['arrivalTime']));

                  return Hero(
                    tag: 'flight_$index',
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text('${flight['departureCity']} to ${flight['destinationCity']}'),
                        subtitle: Text(
                          '${Localization.of(context).translate('departureTime')}: $departureTime\n${Localization.of(context).translate('arrivalTime')}: $arrivalTime',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
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
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
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
