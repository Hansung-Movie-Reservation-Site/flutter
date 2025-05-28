import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:movie/Common/ApiService.dart';
import 'package:movie/auth/LoginUI.dart';
import 'package:movie/mypage/Mypage_logout.dart';
import 'package:movie/auth/SignupPage.dart';
import 'package:movie/auth/LoginFeatures.dart';
import 'package:movie/Common/navbar.dart';
import 'package:movie/providers/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Apiservicev2.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Apiservicev2 apiServicev2 = Apiservicev2();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
              const SizedBox(height: 50),

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
                onLogin: () async {
                  //LoginFeatures.login(
                  await apiServicev2.login(
                    context: context,
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                },
                onSocialLogin: () async {
                  final url = Uri.parse('https://hs-cinemagix.duckdns.org/oauth2/authorization/google');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('구글 로그인 페이지를 열 수 없습니다.')),
                    );
                  }
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
