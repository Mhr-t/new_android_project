import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ReservationList extends StatelessWidget {
  final List<Map<String, String>> reservations;
  final Function(Map<String, String>) onDeleteReservation;

  ReservationList({
    required this.reservations,
    required this.onDeleteReservation,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final reservation = reservations[index];
        return ListTile(
          title: Text('${reservation['name']} - ${reservation['flight']}'),
          subtitle: Text('Customer: ${reservation['customer']}'),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(tr('confirm_delete')),
                    content: Text(tr('are_you_sure')),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(tr('cancel')),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onDeleteReservation(reservation);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(tr('reservation_deleted'))),
                          );
                        },
                        child: Text(tr('delete')),
                      ),
                    ],
                  );
                },
              );
            },
          ),
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
