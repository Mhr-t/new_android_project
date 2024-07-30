import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'shared_preferences_helper.dart';

class AddEditFlightScreen extends StatefulWidget {
  final Map<String, dynamic>? flight;
  final int? index;
  final VoidCallback? onFlightUpdated;

  const AddEditFlightScreen({this.flight, this.index, this.onFlightUpdated, super.key});

  @override
  _AddEditFlightScreenState createState() => _AddEditFlightScreenState();
}

class _AddEditFlightScreenState extends State<AddEditFlightScreen> {
  final _formKey = GlobalKey<FormState>();
  late String departureCity, destinationCity;
  late DateTime departureTime, arrivalTime;
  final SharedPreferencesHelper _prefsHelper = SharedPreferencesHelper();

  @override
  void initState() {
    super.initState();
    if (widget.flight != null) {
      departureCity = widget.flight!['departureCity'];
      destinationCity = widget.flight!['destinationCity'];
      departureTime = DateTime.parse(widget.flight!['departureTime']);
      arrivalTime = DateTime.parse(widget.flight!['arrivalTime']);
    } else {
      departureCity = '';
      destinationCity = '';
      departureTime = DateTime.now();
      arrivalTime = DateTime.now().add(Duration(hours: 1));
    }
  }

  void _saveFlight() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final flight = {
        'departureCity': departureCity,
        'destinationCity': destinationCity,
        'departureTime': departureTime.toIso8601String(),
        'arrivalTime': arrivalTime.toIso8601String(),
      };
      if (widget.flight != null) {
        await _prefsHelper.updateFlight(widget.index!, flight);
      } else {
        await _prefsHelper.addFlight(flight);
      }
      widget.onFlightUpdated?.call();
      Navigator.pop(context);
    }
  }

  void _deleteFlight() async {
    if (widget.flight != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Delete Flight'),
          content: Text(
            'Are you sure you want to delete this flight?\n\n'
                'Departure City: $departureCity\n'
                'Destination City: $destinationCity\n'
                'Departure Time: ${DateFormat('yyyy-MM-dd – kk:mm').format(departureTime)}\n'
                'Arrival Time: ${DateFormat('yyyy-MM-dd – kk:mm').format(arrivalTime)}',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await _prefsHelper.deleteFlight(widget.index!);
                widget.onFlightUpdated?.call();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Image.asset('images/4476373.png', width: 24, height: 24),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _selectDateTime(BuildContext context, bool isDeparture) async {
    final initialDateTime = isDeparture ? departureTime : arrivalTime;
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ).then((date) {
      if (date != null) {
        return showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(initialDateTime),
        ).then((time) {
          if (time != null) {
            return DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
          }
          return null;
        });
      }
      return null;
    });

    if (pickedDateTime != null) {
      setState(() {
        if (isDeparture) {
          departureTime = pickedDateTime;
        } else {
          arrivalTime = pickedDateTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.flight != null ? 'Edit Flight' : 'Add Flight'),
        actions: widget.flight != null
            ? [
          IconButton(
            icon: Image.asset('images/4476373.png', width: 24, height: 24),
            onPressed: _deleteFlight,
          ),
        ]
            : null,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('images/images.jpeg', fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.flight != null ? 'Edit Flight Details' : 'Add New Flight',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: departureCity,
                    decoration: InputDecoration(
                      labelText: 'Departure City',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.departure_board),
                    ),
                    onSaved: (value) => departureCity = value!,
                    validator: (value) => value!.isEmpty ? 'Please enter departure city' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: destinationCity,
                    decoration: InputDecoration(
                      labelText: 'Destination City',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.flight_land),
                    ),
                    onSaved: (value) => destinationCity = value!,
                    validator: (value) => value!.isEmpty ? 'Please enter destination city' : null,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _selectDateTime(context, true),
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Departure Time',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        controller: TextEditingController(
                          text: DateFormat('yyyy-MM-dd – kk:mm').format(departureTime),
                        ),
                        validator: (value) => value!.isEmpty ? 'Please enter departure time' : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _selectDateTime(context, false),
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Arrival Time',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        controller: TextEditingController(
                          text: DateFormat('yyyy-MM-dd – kk:mm').format(arrivalTime),
                        ),
                        validator: (value) => value!.isEmpty ? 'Please enter arrival time' : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveFlight,
                    child: Text(widget.flight != null ? 'Update Flight' : 'Add Flight'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
