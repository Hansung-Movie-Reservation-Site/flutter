import 'package:flutter/material.dart';
import 'package:movie/auth/LoginPage.dart';
import 'package:movie/Common/navbar.dart';
import 'package:movie/Recommend/recommendpage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductListPage(),
    );
  }
}
