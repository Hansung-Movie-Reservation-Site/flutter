class Seat {
  final int seatId;
  final String row;
  final int column;
  final bool reserved;

  Seat({
    required this.seatId,
    required this.row,
    required this.column,
    required this.reserved,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      seatId: json['seatId'],
      row: json['horizontal'],
      column: json['vertical'],
      reserved: json['reserved'],
    );
  }
}