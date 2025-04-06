import 'package:flutter/material.dart';
import 'package:movie/auth/AuthService.dart';
import 'package:movie/auth/SignupFeatures.dart';
import 'package:movie/Common/ApiService.dart';

class ProfileUI {

  // 프로필 필드 (이름, 이메일, 비밀번호)
  static Widget buildProfileField(String label, String value) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: Colors.white,
        border: Border.all(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(width: 20),
            Text(
              value,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // 이름, 이메일, 비밀번호 변경 & 회원탈퇴 버튼
  static Widget buildMemberSettings(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 이름 변경 | 이메일 변경 | 비밀번호 변경
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => showNameChangeDialog(context),
                child: const Text(
                  '이름 변경',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              const SizedBox(width: 10),
              const Text('|', style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => showEmailChangeDialog(context),
                child: const Text(
                  '이메일 변경',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              const SizedBox(width: 10),
              const Text('|', style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => showPasswordChangeDialog(context),
                child: const Text(
                  '비밀번호 변경',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // 회원 탈퇴
          GestureDetector(
            onTap: () => showAccountDeletionDialog(context),
            child: const Text(
              '회원탈퇴',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // 이름 변경 다이얼로그
  static void showNameChangeDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController newNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("이름 변경"),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                obscureText: false,
                decoration: const InputDecoration(labelText: "현재 이메일"),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "현재 비밀번호"),
              ),
              TextField(
                controller: newNameController,
                obscureText: false,
                decoration: const InputDecoration(labelText: "바꿀 이름"),
              ),
            ],
          ),
          actions: [
            // 확인 버튼, 완료 네비게이션바 표시
            TextButton(
              onPressed: () {
                AuthService.changeName( //변경 즉시 갱신되게 하고 싶은데 알아보는중
                  context: context,
                  password: passwordController.text,
                  after: newNameController.text,
                );
              },
              child: const Text("확인"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("취소"),
            ),
          ],
        );
      },
    );
  }

// 이메일 변경 다이얼로그
  static void showEmailChangeDialog(BuildContext context) {
    TextEditingController passwordController = TextEditingController();
    TextEditingController newEmailController = TextEditingController();
    TextEditingController verificationCodeController = TextEditingController();
    bool EmailCheck = false;
    final ApiService _apiService = ApiService();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("이메일 변경"),
              backgroundColor: Colors.white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "현재 비밀번호"),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: newEmailController,
                          decoration: const InputDecoration(labelText: "새 이메일"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          if (newEmailController != null)
                          {
                            await _apiService.sendVerificationEmail("v1/email/send", {"email": newEmailController.text});
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("인증번호가 전송되었습니다.", style: TextStyle(color: Colors.black)),
                                backgroundColor: Colors.white,
                                behavior: SnackBarBehavior.floating,
                                elevation: 4,
                              ),
                            );
                          }
                          else
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("이메일을 입력해 주세요.", style: TextStyle(color: Colors.black)),
                                backgroundColor: Colors.white,
                                behavior: SnackBarBehavior.floating,
                                elevation: 4,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        child: const Text("전송"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // 이메일 인증 버튼
                  Row(
                    children: [
                      // 인증 코드 입력 필드
                      Expanded(
                        child: TextField(
                          controller: verificationCodeController,
                          decoration: const InputDecoration(labelText: "인증 코드"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // 이메일 인증 버튼
                      ElevatedButton(
                        onPressed: () async {
                          bool isVerified = await SignupFeautures.emailCheck(
                            email: newEmailController.text,
                            verifyCode: verificationCodeController.text,
                          );
                          setState(() {
                            EmailCheck = isVerified;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(EmailCheck ? "인증되었습니다." : "인증번호가 틀렸습니다."),
                              backgroundColor: Colors.white,
                            )
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        child: const Text("인증"),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: EmailCheck ? () {
                    AuthService.changeEmail(
                      context: context,
                      password: passwordController.text,
                      after: newEmailController.text,
                    );
                  } : null, //EmailCheck가 false면 확인 버튼 안눌림
                  child: const Text("확인"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("취소"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 비밀번호 변경 다이얼로그
  static void showPasswordChangeDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("비밀번호 변경"),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                obscureText: false,
                decoration: const InputDecoration(labelText: "현재 이메일"),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "기존 비밀번호"),
              ),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "새 비밀번호"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                AuthService.changePassword(
                  context: context,
                  // email: emailController.text,
                  password: passwordController.text,
                  after: newPasswordController.text,
                );
              },
              child: const Text("확인"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("취소"),
            ),
          ],
        );
      },
    );
  }

  // 회원 탈퇴 다이얼로그
  static void showAccountDeletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("탈퇴 확인"),
          content: const Text("정말 탈퇴 하시겠습니까?"),
          actions: [
            // 확인 버튼, 완료 네비게이션바 표시
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("회원탈퇴가 완료되었습니다.", style: TextStyle(color: Colors.black)),
                    backgroundColor: Colors.white,
                    behavior: SnackBarBehavior.floating,
                    elevation: 4,
                  ),
                );
              },
              child: const Text("확인"),
            ),
            // 취소 버튼
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: const Text("아니요"),
            ),
          ],
        );
      },
    );
  }
}
