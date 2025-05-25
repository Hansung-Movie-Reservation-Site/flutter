class Recommendmovie {
  final int movieId;
  final String title;
  final String posterImage;
  final String reason;

  Recommendmovie({
    required this.movieId,
    required this.title,
    required this.posterImage,
    required this.reason,
  });

  factory Recommendmovie.fromJson(Map<String, dynamic> json) {
    return Recommendmovie(
      movieId: json['movieId'],
      title: json['title'],
      posterImage: json['posterImage'],
      reason: json['reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movieId': movieId,
      'title': title,
      'posterImage': posterImage,
      'reason': reason,
    };
  }
}
