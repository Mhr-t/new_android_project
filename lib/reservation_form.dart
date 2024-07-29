import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

// Sample data for flights and customers
final List<String> flights = ['Flight 1', 'Flight 2', 'Flight 3'];
final List<String> customers = ['Customer 1', 'Customer 2', 'Customer 3'];

class ReservationForm extends StatefulWidget {
  final Function(Map<String, String>) onAddReservation;

  ReservationForm({required this.onAddReservation});

  @override
  _ReservationFormState createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  final _formKey = GlobalKey<FormState>();
  final _reservationNameController = TextEditingController();
  String _selectedFlight = flights[0];
  String _selectedCustomer = customers[0];

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final reservation = {
        'name': _reservationNameController.text,
        'flight': _selectedFlight,
        'customer': _selectedCustomer,
      };
      widget.onAddReservation(reservation);
      _reservationNameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _reservationNameController,
              decoration: InputDecoration(labelText: tr('reservation_name')),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return tr('enter_reservation_name');
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _selectedCustomer,
              decoration: InputDecoration(labelText: tr('select_customer')),
              onChanged: (value) {
                setState(() {
                  _selectedCustomer = value!;
                });
              },
              items: customers.map((customer) {
                return DropdownMenuItem(
                  value: customer,
                  child: Text(customer),
                );
              }).toList(),
            ),
            DropdownButtonFormField<String>(
              value: _selectedFlight,
              decoration: InputDecoration(labelText: tr('select_flight')),
              onChanged: (value) {
                setState(() {
                  _selectedFlight = value!;
                });
              },
              items: flights.map((flight) {
                return DropdownMenuItem(
                  value: flight,
                  child: Text(flight),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(tr('add_reservation')),
            ),
          ],
        ),
      ),
    );
  }
}
