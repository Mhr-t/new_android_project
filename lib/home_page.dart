import 'package:flutter/material.dart';
import 'reservation_page.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airlines').tr(),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReservationPage()),
            );
          },
          child: Text('Go to Reservation Page').tr(),
        ),
      ),
    );
  }
}
