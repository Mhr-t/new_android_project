import 'package:flutter/material.dart';
import 'airplane_model.dart';

/// The page that allows the user to add a new airplane.
class AddAirplanePage extends StatefulWidget {
  @override
  _AddAirplanePageState createState() => _AddAirplanePageState();
}

class _AddAirplanePageState extends State<AddAirplanePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _passengersController = TextEditingController();
  final TextEditingController _maxSpeedController = TextEditingController();
  final TextEditingController _rangeController = TextEditingController();

  /// Saves the airplane data and pops the page.
  void _saveAirplane() {
    if (_formKey.currentState!.validate()) {
      Airplane airplane = Airplane(
        id: DateTime.now().millisecondsSinceEpoch,
        type: _typeController.text,
        passengers: int.parse(_passengersController.text),
        maxSpeed: int.parse(_maxSpeedController.text),
        range: int.parse(_rangeController.text),
      );
      Navigator.pop(context, airplane);
    } else {
      _showSnackbar('Please correct the errors in the form');
    }
  }

  /// Displays a Snackbar with a given message.
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Airplane'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _typeController,
                decoration: InputDecoration(labelText: 'Airplane Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter airplane type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passengersController,
                decoration: InputDecoration(labelText: 'Number of Passengers'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of passengers';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _maxSpeedController,
                decoration: InputDecoration(labelText: 'Max Speed'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter max speed';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _rangeController,
                decoration: InputDecoration(labelText: 'Range'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter range';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAirplane,
                child: Text('Save Airplane'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
