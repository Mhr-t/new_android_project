import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ReservationList extends StatelessWidget {
  final List<Map<String, String>> reservations;

  ReservationList({required this.reservations});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final reservation = reservations[index];
        return ListTile(
          title: Text(reservation['name']!),
          subtitle: Text('Flight: ${reservation['flight']} - Customer: ${reservation['customer']}'),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(tr('reservation_details')),
                  content: Text(
                    '${tr('name')}: ${reservation['name']}\n'
                        '${tr('flight')}: ${reservation['flight']}\n'
                        '${tr('customer')}: ${reservation['customer']}',
                  ),
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
        );
      },
    );
  }
}
