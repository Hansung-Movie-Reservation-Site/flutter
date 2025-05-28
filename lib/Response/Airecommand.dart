class Airecommendation {
  final int id;
  final int movieId;
  final String reason;

  Airecommendation({
    required this.id,
    required this.movieId,
    required this.reason,
  });

  factory Airecommendation.fromJson(Map<String, dynamic> json) {
    return Airecommendation(
      id: json['id'],
      movieId: json['movieId'],
      reason: json['reason'],
    );
  }
}
