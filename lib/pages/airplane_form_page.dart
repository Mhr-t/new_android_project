import 'package:flutter/material.dart';
import '../models/airplane.dart';
import '../services/airplane_storage.dart';

class AirplaneFormPage extends StatefulWidget {
  final Airplane? airplane;
  final int? index;

  AirplaneFormPage({this.airplane, this.index});

  @override
  _AirplaneFormPageState createState() => _AirplaneFormPageState();
}

class _AirplaneFormPageState extends State<AirplaneFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _type;
  late int _numberOfPassengers;
  late int _maxSpeed;
  late int _range;

  final _airplaneStorage = AirplaneStorage(); // Create an instance of AirplaneStorage

  @override
  void initState() {
    super.initState();
    _type = widget.airplane?.type ?? '';
    _numberOfPassengers = widget.airplane?.numberOfPassengers ?? 0;
    _maxSpeed = widget.airplane?.maxSpeed ?? 0;
    _range = widget.airplane?.range ?? 0;
  }

  void _saveAirplane() async {
    if (_formKey.currentState!.validate()) {
      final airplane = Airplane(
        type: _type,
        numberOfPassengers: _numberOfPassengers,
        maxSpeed: _maxSpeed,
        range: _range,
      );

      if (widget.index != null) {
        await _airplaneStorage.deleteLastAirplane(); // Use instance method
      }

      await _airplaneStorage.saveAirplane(airplane); // Use instance method
      Navigator.pop(context);
    }
  }

  void _copyPreviousAirplane() async {
    final lastAirplane = await _airplaneStorage.getLastAirplane(); // Use instance method
    if (lastAirplane != null) {
      setState(() {
        _type = lastAirplane.type;
        _numberOfPassengers = lastAirplane.numberOfPassengers;
        _maxSpeed = lastAirplane.maxSpeed;
        _range = lastAirplane.range;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.airplane == null ? 'Add Airplane' : 'Edit Airplane'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _type,
                decoration: InputDecoration(labelText: 'Type'),
                onChanged: (value) => setState(() => _type = value),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the type' : null,
              ),
              TextFormField(
                initialValue: _numberOfPassengers.toString(),
                decoration: InputDecoration(labelText: 'Number of Passengers'),
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(() => _numberOfPassengers = int.tryParse(value) ?? 0),
                validator: (value) => value == null || int.tryParse(value) == null ? 'Please enter a valid number' : null,
              ),
              TextFormField(
                initialValue: _maxSpeed.toString(),
                decoration: InputDecoration(labelText: 'Max Speed'),
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(() => _maxSpeed = int.tryParse(value) ?? 0),
                validator: (value) => value == null || int.tryParse(value) == null ? 'Please enter a valid number' : null,
              ),
              TextFormField(
                initialValue: _range.toString(),
                decoration: InputDecoration(labelText: 'Range'),
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(() => _range = int.tryParse(value) ?? 0),
                validator: (value) => value == null || int.tryParse(value) == null ? 'Please enter a valid number' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAirplane,
                child: Text('Save Airplane'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _copyPreviousAirplane,
                child: Text('Copy Previous Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
