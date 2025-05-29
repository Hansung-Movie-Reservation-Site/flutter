class OrderSummary {
  final int id;
  final String title;
  final String date;
  final String theater;
  final int price;
  final String tid; // 결제 상태
  final String? posterImage;

  OrderSummary({
    required this.id,
    required this.title,
    required this.date,
    required this.theater,
    required this.price,
    required this.tid,
    this.posterImage,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    return OrderSummary(
      id: json['id'],
      title: json['screening']['movie']['title'],
      date: json['screening']['date'],
      theater: json['screening']['room']['spot']['name'],
      price: json['totalAmount'],
      tid: json['tid'] ?? '',
      posterImage: json['screening']['movie']['posterImage'],
    );
  }
}
