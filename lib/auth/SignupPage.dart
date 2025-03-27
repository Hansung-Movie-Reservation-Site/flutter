import 'package:flutter/material.dart';
import 'SignupUI.dart';
import 'package:movie/auth/SignupFeatures.dart';
import 'LoginPage.dart';
import '../Common/ApiService.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _verificationCodeController = TextEditingController();

  final ApiService _apiService = ApiService();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _verificationCodeError;
  String _verificationMessage = '';

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

  // 이메일 인증 코드 전송
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
    await _apiService.sendVerificationEmail("v1/user/verifyEmail", {"email": _emailController.text});
  }

  // 이메일 인증 코드 확인
  void _verifyCode() async {
    bool isVerified = await SignupFeautures.emailCheck(
      email: _emailController.text,
      verifyCode: _verificationCodeController.text,
    );
    setState(() {
      if (isVerified) {
        _verificationCodeError = null;
        _verificationMessage = '인증이 완료되었습니다!';
      } else {
        _verificationCodeError = '인증 코드가 올바르지 않습니다';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),  // 뒤로가기 버튼
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                '회원가입',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              SignupUI(
                nameController: _nameController,
                emailController: _emailController,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
                verificationCodeController: _verificationCodeController,
                nameError: _nameError,
                emailError: _emailError,
                passwordError: _passwordError,
                confirmPasswordError: _confirmPasswordError,
                verificationCodeError: _verificationCodeError,
                verificationMessage: _verificationMessage,
                onVerificationCode: _requestVerificationCode,
                onVerifyCode: _verifyCode,
                onSignUp: () {
                  SignupFeautures.signup(
                      context: context,
                      username: _nameController.text,
                      email: _emailController.text,
                      password: _passwordController.text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}