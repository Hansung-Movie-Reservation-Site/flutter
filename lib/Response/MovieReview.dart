class Review {
  final int id;
  final String username;
  final double rating;
  final String review;
  final bool spoiler;
  final String date;
  final int likeCount;
  final bool liked;

  Review({
    required this.id,
    required this.username,
    required this.rating,
    required this.review,
    required this.spoiler,
    required this.date,
    required this.likeCount,
    required this.liked,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
        id: json['id'],
        username: json['username'],
        rating: json['rating'],
        review: json['review'],
        spoiler: json['spoiler'],
        date: json['review_date'],
        likeCount: json['likeCount'],
        liked: json['liked']
    );
  }
}