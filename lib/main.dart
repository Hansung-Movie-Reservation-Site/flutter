import 'package:flutter/material.dart';
import 'package:movie/auth/LoginPage.dart';
import 'package:movie/reserve/movieScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        initialRoute: '/', // 기본 화면
        routes: {
        // '/': (context) => const LoginPage(), // 로그인 페이지
          '/': (context) => const MovieScreen()
       // '/movie': (context) => const MovieScreen(), // 영화 예매 페이지
         }
    );
  }
}
