
import 'dart:ffi';

class Reviews {
  final String user;
  final double rate;
  final String review;
  final String title;
  final bool spoiler;
  final String poster;

  Reviews({
    required this.user,
    required this.rate,
    required this.review,
    required this.title,
    required this.spoiler,
    required this.poster
  });

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return Reviews(
      user: json['user'] as String,
      rate: json['rate'] as double,
      review: json['review'] as String,
      title: json['title'] as String,
      spoiler: json['spoiler'] as bool,
      poster: json['poster'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'rate': rate,
      'review': review,
      'title': title,
      'spoiler': spoiler,
      'poster': poster
    };
  }
}
