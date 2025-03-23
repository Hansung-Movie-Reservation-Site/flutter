import 'package:flutter/material.dart';

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
                controller: newNameController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "이름"),
              ),
            ],
          ),
          actions: [
            // 확인 버튼, 완료 네비게이션바 표시
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("이름 변경이 완료되었습니다.", style: TextStyle(color: Colors.black)),
                    backgroundColor: Colors.white,
                    behavior: SnackBarBehavior.floating,
                    elevation: 4,
                  ),
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
    TextEditingController emailController = TextEditingController();
    TextEditingController verificationCodeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("이메일 변경"),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 이메일 입력 필드
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "새 이메일"),
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
                    onPressed: () {
                      // 이메일 인증 로직을 추가
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("이메일 인증 코드가 발송되었습니다.", style: TextStyle(color: Colors.black)),
                          backgroundColor: Colors.white,
                          behavior: SnackBarBehavior.floating,
                          elevation: 4,
                        ),
                      );
                    },
                    child: const Text("이메일 인증"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            // 확인 버튼
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 확인을 눌렀을 때 다이얼로그 닫기
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("이메일 변경이 완료되었습니다.", style: TextStyle(color: Colors.black)),
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
              child: const Text("취소"),
            ),
          ],
        );
      },
    );
  }

  // 비밀번호 변경 다이얼로그
  static void showPasswordChangeDialog(BuildContext context) {
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

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
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "기존 비밀번호"),
              ),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "새 비밀번호"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("비밀번호 변경이 완료되었습니다.", style: TextStyle(color: Colors.black)),
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
