class Customer {
  final String firstName;
  final String lastName;
  final String address;
  final String birthday;

  Customer({
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.birthday,
  });

  Map<String, String> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'birthday': birthday,
    };
  }

  static Customer fromMap(Map<String, String> map) {
    return Customer(
      firstName: map['firstName']!,
      lastName: map['lastName']!,
      address: map['address']!,
      birthday: map['birthday']!,
    );
  }
}
