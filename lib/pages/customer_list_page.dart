// lib/pages/customer_list_page.dart
import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/customer_storage.dart';
import 'customer_form_page.dart';

class CustomerListPage extends StatefulWidget {
  @override
  _CustomerListPageState createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  Customer? _customer;

  @override
  void initState() {
    super.initState();
    _loadCustomer();
  }

  void _loadCustomer() async {
    final customer = await CustomerStorage().loadCustomer();
    setState(() {
      _customer = customer;
    });
  }

  void _navigateToFormPage({bool copyPrevious = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerFormPage(
          customer: copyPrevious ? _customer : null,
        ),
      ),
    ).then((_) => _loadCustomer());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _navigateToFormPage(copyPrevious: true);
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _navigateToFormPage(copyPrevious: false);
            },
          ),
        ],
      ),
      body: _customer == null
          ? Center(child: Text('No customer found'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${_customer!.name}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Email: ${_customer!.email}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
