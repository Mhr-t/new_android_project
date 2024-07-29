import 'package:flutter/material.dart';

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
                  title: Text('Reservation Details'),
                  content: Text(
                    'Name: ${reservation['name']}\n'
                        'Flight: ${reservation['flight']}\n'
                        'Customer: ${reservation['customer']}',
                  ),
                  actions: [
                    TextButton(
                      child: Text('OK'),
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
