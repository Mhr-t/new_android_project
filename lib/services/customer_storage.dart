// lib/services/customer_storage.dart
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'dart:convert';
import '../models/customer.dart';

class CustomerStorage {
  static const String _customerKey = 'last_customer';
  final _prefs = EncryptedSharedPreferences();

  Future<void> saveCustomer(Customer customer) async {
    final jsonString = json.encode(customer.toMap());
    await _prefs.setString(_customerKey, jsonString);
  }

  Future<Customer?> loadCustomer() async {
    final jsonString = await _prefs.getString(_customerKey);
    if (jsonString != null) {
      final map = json.decode(jsonString) as Map<String, dynamic>;
      return Customer.fromMap(map);
    }
    return null;
  }

  Future<void> deleteCustomer() async {
    await _prefs.remove(_customerKey);
  }
}
