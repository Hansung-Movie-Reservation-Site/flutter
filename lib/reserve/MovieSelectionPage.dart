import 'package:flutter/material.dart';
import 'MovieSelectionUI.dart';

class MovieselectionPage extends StatelessWidget {
  final String selectedCinema;
  final DateTime selectedDate;

  const MovieselectionPage({
    super.key,
    required this.selectedCinema,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '영화 예매',
          style: TextStyle(fontSize: 27, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: MovieSelectionUI(
          selectedCinema: selectedCinema,
          selectedDate: selectedDate,
        ),
      ),
    );
  }
}
