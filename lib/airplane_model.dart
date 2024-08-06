/// Model class representing an airplane.
class Airplane {
  int id;
  String type;
  int passengers;
  int maxSpeed;
  int range;

  Airplane({required this.id, required this.type, required this.passengers, required this.maxSpeed, required this.range});

  /// Converts the airplane object to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'passengers': passengers,
      'maxSpeed': maxSpeed,
      'range': range,
    };
  }

  /// Creates an airplane object from a map.
  factory Airplane.fromMap(Map<String, dynamic> map) {
    return Airplane(
      id: map['id'],
      type: map['type'],
      passengers: map['passengers'],
      maxSpeed: map['maxSpeed'],
      range: map['range'],
    );
  }
}
