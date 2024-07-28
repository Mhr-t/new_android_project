// lib/pages/customer_form_page.dart
import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/customer_storage.dart';

class CustomerFormPage extends StatefulWidget {
  final Customer? customer;

  CustomerFormPage({this.customer});

  @override
  _CustomerFormPageState createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends State<CustomerFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _name = widget.customer!.name;
      _email = widget.customer!.email;
    } else {
      _name = '';
      _email = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer == null ? 'Add Customer' : 'Edit Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) => _name = value,
                validator: (value) => value == null || value.isEmpty ? 'Please enter the name' : null,
              ),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (value) => _email = value,
                validator: (value) => value == null || !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value) ? 'Please enter a valid email' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final customer = Customer(
                      name: _name,
                      email: _email,
                    );
                    CustomerStorage().saveCustomer(customer);
                    Navigator.pop(context);
                  }
                },
                child: Text('Save Customer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
