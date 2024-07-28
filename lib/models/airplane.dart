// lib/models/airplane.dart
class Airplane {
  final String type;
  final int numberOfPassengers;
  final int maxSpeed;
  final int range;

  Airplane({
    required this.type,
    required this.numberOfPassengers,
    required this.maxSpeed,
    required this.range,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'numberOfPassengers': numberOfPassengers,
    'maxSpeed': maxSpeed,
    'range': range,
  };

  factory Airplane.fromJson(Map<String, dynamic> json) => Airplane(
    type: json['type'],
    numberOfPassengers: json['numberOfPassengers'],
    maxSpeed: json['maxSpeed'],
    range: json['range'],
  );
}
