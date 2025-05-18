import 'Region.dart';

class Spot {
  final int id;
  final String name;
  final Region region;

  Spot({required this.id, required this.name, required this.region});

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      id: json['id'],
      name: json['name'],
      region: Region.fromJson(json['region']),
    );
  }
}