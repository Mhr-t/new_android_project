import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'reservation_form.dart';
import 'reservation_list.dart';
import 'package:easy_localization/easy_localization.dart';

// Sample data for flights and customers
final List<String> flights = ['Flight 1', 'Flight 2', 'Flight 3'];
final List<String> customers = ['Customer 1', 'Customer 2', 'Customer 3'];

class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  List<Map<String, String>> _reservations = [];

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    final prefs = await SharedPreferences.getInstance();
    final reservations = prefs.getStringList('reservations') ?? [];
    setState(() {
      _reservations = reservations.map((reservation) {
        final parts = reservation.split('|');
        return {
          'name': parts[0],
          'flight': parts[1],
          'customer': parts[2],
        };
      }).toList();
    });
  }

  Future<void> _addReservation(Map<String, String> reservation) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _reservations.add(reservation);
    });
    final reservationString = _reservations
        .map((res) => '${res['name']}|${res['flight']}|${res['customer']}')
        .toList();
    await prefs.setStringList('reservations', reservationString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('title')),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(tr('instructions')),
                    content: Text(tr('instructions')),
                    actions: [
                      TextButton(
                        child: Text(tr('ok')),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ReservationForm(
            onAddReservation: _addReservation,
          ),
          Expanded(
            child: ReservationList(reservations: _reservations),
          ),
        ],
      ),
    );
  }
}
