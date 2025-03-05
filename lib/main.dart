import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie/auth/login.dart';
import 'package:movie/providers/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return authProvider.isLoggedIn ? const HomeScreen() : const LoginScreen();
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('홈 화면'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Text(  // 로그인 상태 표시하기 위한 임시 텍스트
                  authProvider.isLoggedIn ? '로그인 상태: 로그인' : '로그인 상태: 로그아웃',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                );
              },
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          '로그인 성공! 홈 화면입니다.',
          style: TextStyle(fontSize: 20, color: Colors.black54),
        ),
      ),
    );
  }
}
