import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'reservation_form.dart';
import 'reservation_list.dart';
import 'package:easy_localization/easy_localization.dart';

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
    final reservations = prefs.getString('reservations');
    setState(() {
      if (reservations != null) {
        _reservations = (json.decode(reservations) as List)
            .map((item) => Map<String, String>.from(item))
            .toList();
      }
    });
  }

  Future<void> _addReservation(Map<String, String> reservation) async {
    setState(() {
      _reservations.add(reservation);
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('reservations', json.encode(_reservations));
  }

  void _deleteReservation(Map<String, String> reservation) async {
    setState(() {
      _reservations.remove(reservation);
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('reservations', json.encode(_reservations));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('reservation_page_title')),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              _showInstructionsDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              _showLanguageDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ReservationForm(onAddReservation: _addReservation),
          Expanded(
            child: ReservationList(
              reservations: _reservations,
              onDeleteReservation: _deleteReservation,
            ),
          ),
        ],
      ),
    );
  }

  void _showInstructionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Instructions').tr(),
          content: Text('Here is how to use the Reservation Page:\n\n'
              '1. Use the form at the top to add new reservations.\n'
              '2. View the list of reservations below.\n'
              '3. Tap on an item to view details.\n'
              '4. Swipe left or tap the delete icon to remove a reservation.\n'
              '5. Change the language using the language button in the AppBar.'),
          actions: [
            TextButton(
              child: Text('OK').tr(),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Language').tr(),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('English (US)'),
                onTap: () {
                  context.setLocale(Locale('en', 'US'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('English (UK)'),
                onTap: () {
                  context.setLocale(Locale('en', 'GB'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Français'),
                onTap: () {
                  context.setLocale(Locale('fr', 'FR'));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
