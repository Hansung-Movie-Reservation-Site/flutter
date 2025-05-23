import 'package:flutter/material.dart';

class SignupUI extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController verificationCodeController;

  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? verificationCodeError;
  final String verificationMessage;

  final VoidCallback onVerificationCode;
  final VoidCallback onVerifyCode;
  final VoidCallback onSignUp;

  const SignupUI({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.verificationCodeController,
    this.nameError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.verificationCodeError,
    required this.verificationMessage,
    required this.onVerificationCode,
    required this.onVerifyCode,
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
                  _buildInputField(controller: nameController, label: '이름', errorText: nameError),
                  const SizedBox(height: 15),
                  _buildInputField(controller: emailController, label: '이메일', errorText: emailError),
                  const SizedBox(height: 15),

                  // 이메일 인증 버튼
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                            onPressed: onVerificationCode,
                            child: const Text('이메일 인증', style: TextStyle(fontSize: 16, color: Colors.black)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (verificationMessage.isNotEmpty)
                        Expanded(
                          flex: 5,
                          child: Text(
                            verificationMessage,
                            style: const TextStyle(fontSize: 14, color: Colors.green),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // 이메일 인증 코드 입력
                  Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: _buildInputField(
                          controller: verificationCodeController,
                          label: '이메일 인증 코드 입력',
                          errorText: verificationCodeError,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                            onPressed: onVerifyCode,
                            child: const Text('확인', style: TextStyle(fontSize: 16, color: Colors.black)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildInputField(
                    controller: passwordController,
                    label: '비밀번호',
                    errorText: passwordError,
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),
                  _buildInputField(
                    controller: confirmPasswordController,
                    label: '비밀번호 확인',
                    errorText: confirmPasswordError,
                    obscureText: true,
                  ),
                  const SizedBox(height: 40),

                  // 회원가입 버튼
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: onSignUp,
                      child: const Text('회원가입', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 50),
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
    String? errorText,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
