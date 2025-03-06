import 'package:flutter/material.dart';
import 'login.dart'; // 로그인 화면 import
import '../Common/ApiService.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _verificationCodeController = TextEditingController();

  // 스프링부트 요청 1: ApiService 생성
  final ApiService _apiService = ApiService();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _verificationCodeError;
  String _verificationMessage = '';
  final String _verificationCode = 'abcdef'; // 인증코드 샘플 데이터

  void _validateFields() {
    setState(() {
      _nameError = _nameController.text.isEmpty ? '이름을 입력하세요' : null;
      _emailError = _emailController.text.isEmpty ? '이메일을 입력하세요' : null;
      _passwordError = _passwordController.text.isEmpty ? '비밀번호를 입력하세요' : null;
      _confirmPasswordError = _confirmPasswordController.text.isEmpty
          ? '비밀번호 확인을 입력하세요'
          : (_passwordController.text != _confirmPasswordController.text
          ? '비밀번호가 일치하지 않습니다'
          : null);
    });
  }

  void _requestVerificationCode() async {
    setState(() {
      if (_emailController.text.isEmpty) {
        _emailError = '이메일을 입력하세요';
        _verificationMessage = '';
        return;
      } else {
        _emailError = null;
        _verificationMessage = '인증 코드가 이메일로 발송되었습니다.';
      }
    });
    final result = await _apiService.sendVerificationEmail("v1/email/send", {"email":_emailController.text});
  }

  void _verifyCode() {
    setState(() {
      if (_verificationCodeController.text.isEmpty) {
        _verificationCodeError = '인증 코드를 입력하세요';
      } else if (_verificationCodeController.text != _verificationCode) {
        _verificationCodeError = '인증 코드가 올바르지 않습니다';
      } else {
        _verificationCodeError = null;
        _verificationMessage = '인증이 완료되었습니다!';
      }
    });
  }

  Future<void> _signUp() async {
    final username = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    _validateFields();
    // _verifyCode();

    if (_nameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _verificationCodeError == null) {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/v1/user/createUser'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "username": username,
          "email": email,
          "password": password,
        }),
      );
      if (response.statusCode == 200) {
        // 회원가입
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('회원가입 성공!'),
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
              title: Text("회원가입 실패"),
              content: Text("에러 코드: ${response.statusCode}"),
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
  }
  Future<void> _EmailCheck() async {
    final verifyCode = _verificationCodeController.text;
    final email = _emailController.text;

    // _verifyCode();

    final response = await http.post(
      Uri.parse('http://localhost:8080/api/v1/email/check'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "email": email,
        "authnum": verifyCode,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        _verificationCodeError = null;
        _verificationMessage = '인증이 완료되었습니다!';
      });
    }
    else {
      setState(() {
        _verificationCodeError = '인증 코드가 올바르지 않습니다';
      });
    }
  }

/*
  void _signUp() {
    _validateFields();
    _verifyCode();

    if (_nameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _verificationCodeError == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

 */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              '회원가입',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // 이름 입력
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '이름',
                errorText: _nameError,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 15),

            // 이메일 입력
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: '이메일',
                errorText: _emailError,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 15),

            // 이메일 인증 버튼
            Row(
              children: [
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    onPressed: _requestVerificationCode,
                    child: const Text('이메일 인증', style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                ),
                const SizedBox(width: 16),
                if (_verificationMessage.isNotEmpty)
                  Text(_verificationMessage, style: const TextStyle(fontSize: 16, color: Colors.green)),
              ],
            ),
            const SizedBox(height: 15),

            // 이메일 인증 코드 입력
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _verificationCodeController,
                    decoration: InputDecoration(
                      labelText: '이메일 인증 코드 입력',
                      errorText: _verificationCodeError,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    onPressed: _EmailCheck,
                    child: const Text('확인', style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // 비밀번호 입력
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                errorText: _passwordError,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 15),

            // 비밀번호 확인 입력
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호 확인',
                errorText: _confirmPasswordError,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 100),

            // 회원가입 버튼
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: _signUp,
                child: const Text('회원가입', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
