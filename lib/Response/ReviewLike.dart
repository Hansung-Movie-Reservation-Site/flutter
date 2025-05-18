class ReviewLike {
  final int likeCount;
  final int reviewId;

  ReviewLike({
    required this.likeCount,
    required this.reviewId
  });

  factory ReviewLike.fromJson(Map<String, dynamic> json) {
    return ReviewLike(
      likeCount: json['likeCount'],
      reviewId: (json['reviewId'] as num).toInt(),
    );
  }
}