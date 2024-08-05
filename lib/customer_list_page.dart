import 'package:flutter/material.dart';
import 'customer_model.dart';
import 'add_customer_page.dart';

class CustomerListPage extends StatefulWidget {
  @override
  _CustomerListPageState createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  List<Customer> _customers = [];

  void _addOrUpdateCustomer(Customer customer) {
    setState(() {
      final index = _customers.indexWhere((c) =>
      c.firstName == customer.firstName &&
          c.lastName == customer.lastName &&
          c.address == customer.address &&
          c.birthday == customer.birthday
      );

      if (index != -1) {
        _customers[index] = customer;
      } else {
        _customers.add(customer);
      }

      print('Customer List: $_customers'); // Debugging print statement
    });
  }

  void _deleteCustomer(Customer customer) {
    setState(() {
      _customers.remove(customer);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCustomerPage(
                    onSave: _addOrUpdateCustomer,
                  ),
                ),
              );
              if (result == true) {
                setState(() {});
              }
            },
          ),
        ],
      ),
      body: _customers.isEmpty
          ? Center(child: Text('No customers found.'))
          : ListView.builder(
        itemCount: _customers.length,
        itemBuilder: (context, index) {
          final customer = _customers[index];
          return ListTile(
            title: Text('${customer.firstName} ${customer.lastName}'),
            subtitle: Text(customer.address),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCustomerPage(
                    customer: customer,
                    isUpdate: true,
                    onSave: _addOrUpdateCustomer,
                  ),
                ),
              );
              if (result == true) {
                setState(() {});
              }
            },
          );
        },
      ),
    );
  }
}
