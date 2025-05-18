class MovieRating {
  final int movieId;
  final double averageRating;

  MovieRating({
    required this.movieId,
    required this.averageRating
  });

  factory MovieRating.fromJson(Map<String, dynamic> json) {
    return MovieRating(
      movieId: json['movieId'],
      averageRating: (json['averageRating'] as num).toDouble(),
    );
  }
}