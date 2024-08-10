import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'reservation_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airlines').tr(),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReservationPage()),
                );
              },
              child: Text('Go to Reservation Page').tr(),
            ),
          ],
        ),
      ),
    );
  }

  void _showInstructionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Instructions').tr(),
          content: Text('Here is how to use the app:\n\n'
              '1. To add reservations, go to the Reservation Page.\n'
              '2. Use the form to input reservation details.\n'
              '3. View and manage reservations in the list.\n'
              '4. Change the language using the language button in the AppBar.'),
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
