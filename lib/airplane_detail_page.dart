import 'package:flutter/material.dart';
import 'package:your_app_name/models/airplane_model.dart';

class AirplaneDetailPage extends StatefulWidget {
  final Airplane airplane;
  final Function(Airplane) onUpdate;
  final Function(int) onDelete;

  AirplaneDetailPage({
    required this.airplane,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  _AirplaneDetailPageState createState() => _AirplaneDetailPageState();
}

class _AirplaneDetailPageState extends State<AirplaneDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _typeController;
  late TextEditingController _passengersController;
  late TextEditingController _maxSpeedController;
  late TextEditingController _rangeController;

  @override
  void initState() {
    super.initState();
    _typeController = TextEditingController(text: widget.airplane.type);
    _passengersController = TextEditingController(text: widget.airplane.passengers.toString());
    _maxSpeedController = TextEditingController(text: widget.airplane.maxSpeed.toString());
    _rangeController = TextEditingController(text: widget.airplane.range.toString());
  }

  void _updateAirplane() {
    if (_formKey.currentState!.validate()) {
      Airplane updatedAirplane = Airplane(
        id: widget.airplane.id,
        type: _typeController.text,
        passengers: int.parse(_passengersController.text),
        maxSpeed: int.parse(_maxSpeedController.text),
        range: int.parse(_rangeController.text),
      );
      widget.onUpdate(updatedAirplane);
      Navigator.pop(context);
    }
  }

  void _deleteAirplane() {
    widget.onDelete(widget.airplane.id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airplane Details'),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _updateAirplane,
                    child: Text('Update'),
                  ),
                  ElevatedButton(
                    onPressed: _deleteAirplane,
                    child: Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
