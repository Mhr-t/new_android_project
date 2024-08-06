import 'package:flutter/material.dart';
import 'localization.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<Locale> onLocaleChange;

  const HomeScreen({required this.onLocaleChange, super.key});

  void _navigateToFlights(BuildContext context) {
    Navigator.pushNamed(context, '/flights');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Localization.of(context).translate('homeTitle')),
        actions: [
          DropdownButton<Locale>(
            value: Localizations.localeOf(context),
            icon: const Icon(Icons.language, color: Colors.blue),
            dropdownColor: Colors.cyan,
            items: const [
              DropdownMenuItem(
                value: Locale('en'),
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: Locale('fr'),
                child: Text('Français'),
              ),
            ],
            onChanged: (Locale? locale) {
              if (locale != null) onLocaleChange(locale);
            },
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _navigateToFlights(context),
          child: Text(Localization.of(context).translate('goToFlights')),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
        ),
      ),
    );
  }
}
