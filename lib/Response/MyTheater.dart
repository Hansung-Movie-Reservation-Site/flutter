class MyTheater {
  final int id;
  final int spotId;

  MyTheater({
    required this.id,
    required this.spotId,
  });

  factory MyTheater.fromJson(Map<String, dynamic> json) {
    return MyTheater(
      id: json['id'],
      spotId: json['spot_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spot_id': spotId,
    };
  }
}