import 'package:flutter/material.dart';

class LoginUI extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String errorMessage;
  final VoidCallback onLogin;
  final VoidCallback onSignUp;

  const LoginUI({
    required this.emailController,
    required this.passwordController,
    required this.errorMessage,
    required this.onLogin,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 이메일 입력 필드
        _buildInputField(
          controller: emailController,
          label: '이메일을 입력해 주세요',
          obscureText: false,
        ),
        const SizedBox(height: 16),

        // 비밀번호 입력 필드
        _buildInputField(
          controller: passwordController,
          label: '비밀번호를 입력해 주세요',
          obscureText: true,
        ),
        const SizedBox(height: 24),

        // 로그인 버튼
        _buildLoginButton(onLogin),

        // 에러 메시지 (로그인 실패 시 표시)
        if (errorMessage.isNotEmpty)
          _buildErrorMessage(errorMessage),

        const SizedBox(height: 150), // 여백 조정

        // 회원가입 안내 문구
        const Text(
          '아직 회원이 아니신가요?',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 8),

        // 회원가입 버튼
        _buildSignUpButton(onSignUp),
      ],
    );
  }

  // Reusable method for creating input fields
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Reusable method for creating the login button
  Widget _buildLoginButton(VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: onPressed,
        child: const Text(
          '로그인',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  // Reusable method for displaying error messages
  Widget _buildErrorMessage(String message) {
    return Text(
      message,
      style: const TextStyle(color: Colors.red, fontSize: 14),
    );
  }

  // Reusable method for creating the sign-up button
  Widget _buildSignUpButton(VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[400],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: onPressed,
        child: const Text(
          '회원가입',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }
}
