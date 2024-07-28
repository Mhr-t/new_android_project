// lib/models/customer.dart
class Customer {
  final String name;
  final String email;

  Customer({
    required this.name,
    required this.email,
  });

  // Convert a Customer instance to a Map.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }

  // Create a Customer instance from a Map.
  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }
}
