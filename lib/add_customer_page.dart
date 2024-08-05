import 'package:flutter/material.dart';
import 'customer_model.dart';
import 'encrypted_preferences.dart';

class AddCustomerPage extends StatefulWidget {
  final Customer? customer;
  final bool isUpdate;
  final Function(Customer) onSave;

  const AddCustomerPage({Key? key, this.customer, this.isUpdate = false, required this.onSave}) : super(key: key);

  @override
  _AddCustomerPageState createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _encryptedPreferences = EncryptedPreferences();

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate && widget.customer != null) {
      _firstNameController.text = widget.customer!.firstName;
      _lastNameController.text = widget.customer!.lastName;
      _addressController.text = widget.customer!.address;
      _birthdayController.text = widget.customer!.birthday;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  void _saveCustomer() async {
    try {
      if (_formKey.currentState!.validate()) {
        final customer = Customer(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          address: _addressController.text,
          birthday: _birthdayController.text,
        );

        print('Saving customer: ${customer.toMap()}');

        await _encryptedPreferences.saveCustomerData(
          _firstNameController.text,
          _lastNameController.text,
          _addressController.text,
          _birthdayController.text,
        );
        widget.onSave(customer);
        Navigator.pop(context, true);
      }
    } catch (e) {
      print('Error saving customer: $e');
    }
  }

  void _loadPreviousCustomer() async {
    try {
      final data = await _encryptedPreferences.getCustomerData();
      print('Loaded previous customer: $data'); // Debugging print statement
      setState(() {
        _firstNameController.text = data['firstName']!;
        _lastNameController.text = data['lastName']!;
        _addressController.text = data['address']!;
        _birthdayController.text = data['birthday']!;
      });
    } catch (e) {
      print('Error loading previous customer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isUpdate ? 'Update Customer' : 'Add Customer'),
        actions: widget.isUpdate
            ? [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              widget.onSave(Customer(
                firstName: '',
                lastName: '',
                address: '',
                birthday: '',
              ));
              Navigator.pop(context);
            },
          ),
        ]
            : [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) => value!.isEmpty ? 'Please enter first name' : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) => value!.isEmpty ? 'Please enter last name' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) => value!.isEmpty ? 'Please enter address' : null,
              ),
              TextFormField(
                controller: _birthdayController,
                decoration: InputDecoration(labelText: 'Birthday'),
                validator: (value) => value!.isEmpty ? 'Please enter birthday' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCustomer,
                child: Text(widget.isUpdate ? 'Update' : 'Submit'),
              ),
              ElevatedButton(
                onPressed: _loadPreviousCustomer,
                child: Text('Load Previous Customer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
