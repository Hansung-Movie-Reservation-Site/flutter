class MyTheather {
  final int id;
  final int spotId;

  MyTheather({
    required this.id,
    required this.spotId,
  });

  factory MyTheather.fromJson(Map<String, dynamic> json) {
    return MyTheather(
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