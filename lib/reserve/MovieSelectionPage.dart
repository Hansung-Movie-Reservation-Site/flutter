import 'package:flutter/material.dart';
import 'MovieSelectionUI.dart';

class MovieselectionPage extends StatelessWidget {
  const MovieselectionPage({super.key, required String selectedCinema, required DateTime selectedDate});

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
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: MovieSelectionUI(),
      ),
    );
  }
}
