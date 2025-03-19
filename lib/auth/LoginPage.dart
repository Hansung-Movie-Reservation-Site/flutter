import 'package:flutter/material.dart';
import 'package:movie/auth/LoginUI.dart';
import 'package:movie/mypage/Mypage_logout.dart';
import 'package:movie/auth/SignupPage.dart';
import 'package:movie/auth/LoginFeatures.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyPage_Logout()),
            );
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 160),

              // 로그인 안내 문구
              const Text(
                '회원 서비스 이용을 위해\n로그인이 필요합니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),

              LoginUI(
                emailController: _emailController,
                passwordController: _passwordController,
                errorMessage: _errorMessage,
                onLogin: () {
                  LoginFeatures.login(
                    context: context,
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                },
                onSignUp: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}