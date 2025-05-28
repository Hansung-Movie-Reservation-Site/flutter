import 'package:flutter/material.dart';

class LoginUI extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String errorMessage;
  final VoidCallback onLogin;
  final VoidCallback onSocialLogin;
  final VoidCallback onSignUp;

  const LoginUI({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.errorMessage,
    required this.onLogin,
    required this.onSocialLogin,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth > 400 ? 400 : constraints.maxWidth * 0.9;

        return Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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

                  const SizedBox(height: 20),

                  _buildSocialLoginButton(onSocialLogin),

                  const SizedBox(height: 50),
                  // 에러 메시지
                  if (errorMessage.isNotEmpty)
                    _buildErrorMessage(errorMessage),

                  const SizedBox(height: 30),

                  const Center(
                    child: Text(
                      '아직 회원이 아니신가요?',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 회원가입 버튼
                  _buildSignUpButton(onSignUp),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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

  Widget _buildLoginButton(VoidCallback onPressed) {
    return SizedBox(
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
  // 소셜 버튼
  Widget _buildSocialLoginButton(VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: onPressed,
        child: const Text(
          '소셜 로그인',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  // 에러 메세지
  Widget _buildErrorMessage(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red, fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSignUpButton(VoidCallback onPressed) {
    return SizedBox(
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
