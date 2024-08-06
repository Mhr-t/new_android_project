import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'airplane_list_page.dart';

class HomePage extends StatelessWidget {
  final Function(Locale) changeLocale;

  HomePage({required this.changeLocale});

  @override
  Widget build(BuildContext context) {
    var localizations = Localizations.of<AppLocalizations>(context, AppLocalizations);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.translate('airlines') ?? 'Airlines'),
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(localizations?.translate('choose_language') ?? 'Choose Language'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text('English'),
                          onTap: () {
                            changeLocale(Locale('en', 'US'));
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: Text('Français'),
                          onTap: () {
                            changeLocale(Locale('fr', 'FR'));
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AirplaneListPage()),
            );
          },
          child: Text(localizations?.translate('go_to_airplane_list') ?? 'Go to Airplane List'),
        ),
      ),
    );
  }
}
