class Review {
  final int id;
  final double rating;
  final String review;
  final String username;
  final bool spoiler;
  final String date;

  Review({
    required this.id,
    required this.rating,
    required this.review,
    required this.username,
    required this.spoiler,
    required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      rating: json['rating'],
      review: json['review'],
      username: json['username'],
      spoiler: json['spoiler'],
      date: json['review_date']
    );
  }
}