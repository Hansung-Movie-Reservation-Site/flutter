import 'package:flutter/material.dart';
import '../Common/navbar.dart';
import 'TheaterUI.dart';
///영화 예매 1단계
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
      bottomNavigationBar: const NavBar(),
    );
  }
}
