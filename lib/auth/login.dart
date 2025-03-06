import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Provider import
import 'package:movie/main.dart'; // HomeScreen을 가져옴
import 'package:movie/mypage/mypage.dart'; // mypage.dart import
import 'package:movie/auth/signup.dart';
import 'package:movie/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  // 샘플 유저 데이터
  final Map<String, String> sampleUser = {
    'email': 'test@example.com',
    'password': '123456'
  };

  Future<void> login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final response = await http.post(
      Uri.parse('http://localhost:8080/api/v1/user/login'), // 백엔드 API URL
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      // 로그인 성공
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('로그인 성공!'),
            content: Text('확인 코드: ${response.statusCode}'),
            actions: <Widget>[
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    else {
      // 실패 처리: 서버에서 반환된 에러 코드 표시
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('로그인 실패'),
            content: Text('에러 코드: ${response.statusCode}'),
            actions: <Widget>[
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

/*
  void _login() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email == sampleUser['email'] && password == sampleUser['password']) {
      // 로그인 성공 시 AuthProvider의 상태 변경
      Provider.of<AuthProvider>(context, listen: false).login();

      // 홈 화면으로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // 로그인 실패
      setState(() {
        _errorMessage = '이메일과 비밀번호를 확인하세요';
      });
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // MyPageScreen으로 이동
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyPageScreen()),
            );
          },
        ),
        // title 삭제 (로그인 글씨 제거)
        automaticallyImplyLeading: false, // 자동으로 AppBar title을 설정하지 않도록
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40), // 상단 여백 추가

              const SizedBox(height: 120), // 로그인 폼과의 간격 추가

              // 로그인 안내 문구
              const Text(
                '회원 서비스 이용을 위해\n로그인이 필요합니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 32),

              // 이메일 입력 필드
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: '이메일을 입력해 주세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 비밀번호 입력 필드
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호를 입력해 주세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 로그인 버튼
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: login,
                  child: const Text(
                    '로그인',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              // 에러 메시지 (로그인 실패 시 표시)
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),

              const SizedBox(height: 150), // 여백 조정

              // 회원가입 안내 문구
              const Text(
                '아직 회원이 아니신가요?',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 8),


              // 로그인 화면에서 회원가입 버튼 누를 때 SignupScreen으로 이동
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    // 회원가입 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: const Text(
                    '회원가입',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

