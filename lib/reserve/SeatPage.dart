import 'package:flutter/material.dart';
import 'SeatUI.dart';

class SeatSelectionPage extends StatelessWidget {
  final String movieTitle;
  final String theater;
  final String time;
  final DateTime date;
  final int generalCount;
  final int youthCount;
  final int screeningId;

  const SeatSelectionPage({
    super.key,
    required this.movieTitle,
    required this.theater,
    required this.time,
    required this.date,
    required this.generalCount,
    required this.youthCount,
    required this.screeningId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SeatSelectionUI(
        movieTitle: movieTitle,
        theater: theater,
        date: date,
        time: time,
        generalCount: generalCount,
        youthCount: youthCount,
        screeningId: screeningId,
      ),
    );
  }
}
