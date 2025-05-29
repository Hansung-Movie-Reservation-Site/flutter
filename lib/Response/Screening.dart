class Screening {
  final int id;
  final String title;
  final String start;
  final int movieId;
  final String posterImage;

  Screening({
    required this. id,
    required this.title,
    required this.start,
    required this.movieId,
    required this.posterImage,
  });

  factory Screening.fromJson(Map<String, dynamic> json) {
    return Screening(
      id: json['id'],
      title: json['movie']['title'],
      start: json['start'],
      movieId: json['movie']['id'],
      posterImage: json['movie']['posterImage'],
    );
  }
}