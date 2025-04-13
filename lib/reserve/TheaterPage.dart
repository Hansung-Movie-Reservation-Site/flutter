import 'package:flutter/material.dart';
import 'TheaterUI.dart';

class TheaterPage extends StatelessWidget {
  const TheaterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: TheaterUI(),
      ),
    );
  }
}
