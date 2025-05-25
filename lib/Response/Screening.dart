class Screening {
  final int id;
  final String title;
  final String start;

  Screening({
    required this. id,
    required this.title,
    required this.start
  });

  factory Screening.fromJson(Map<String, dynamic> json) {
    return Screening(
      id: json['id'],
      title: json['movie']['title'],
      start: json['start'],
    );
  }
}