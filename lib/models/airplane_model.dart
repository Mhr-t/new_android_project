class Airplane {
  int id;
  String type;
  int passengers;
  int maxSpeed;
  int range;

  Airplane({required this.id, required this.type, required this.passengers, required this.maxSpeed, required this.range});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'passengers': passengers,
      'maxSpeed': maxSpeed,
      'range': range,
    };
  }

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
