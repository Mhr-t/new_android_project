import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'reservation_form.dart';
import 'reservation_list.dart';
import 'package:easy_localization/easy_localization.dart';

/// A page for managing reservations, including adding, listing, and showing details.
class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  List<Map<String, String>> _reservations = [];
  final _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    final reservations = await _storage.read(key: 'reservations');
    setState(() {
      if (reservations != null) {
        _reservations = reservations.split('|').map((reservation) {
          final parts = reservation.split('|');
          return {
            'name': parts[0],
            'flight': parts[1],
            'customer': parts[2],
          };
        }).toList();
      }
    });
  }

  Future<void> _addReservation(Map<String, String> reservation) async {
    setState(() {
      _reservations.add(reservation);
    });
    final reservationString = _reservations
        .map((res) => '${res['name']}|${res['flight']}|${res['customer']}')
        .join('|');
    await _storage.write(key: 'reservations', value: reservationString);
  }

  void _deleteReservation(Map<String, String> reservation) async {
    setState(() {
      _reservations.remove(reservation);
    });
    final reservationString = _reservations
        .map((res) => '${res['name']}|${res['flight']}|${res['customer']}')
        .join('|');
    await _storage.write(key: 'reservations', value: reservationString);
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
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                ReservationForm(
                  onAddReservation: _addReservation,
                ),
                Expanded(
                  child: ReservationList(
                    reservations: _reservations,
                    onDeleteReservation: _deleteReservation,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
