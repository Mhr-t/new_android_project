import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// A page displaying a list of reservations with the option to delete them.
class ReservationListPage extends StatelessWidget {
  final List<Map<String, String>> reservations;
  final Function(Map<String, String>) onDeleteReservation;

  ReservationListPage({
    required this.reservations,
    required this.onDeleteReservation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('reservation_list')),
      ),
      body: ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (BuildContext context, int index) {
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
          );
        },
      ),
    );
  }
}
