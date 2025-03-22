import 'package:flutter/material.dart';
import 'package:movie/mypage/Mypage_login.dart';
import 'ProfileUI.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 35),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyPage_Login()),
            );
          },
        ),
        title: const Text(
          '내 프로필 관리',
          style: TextStyle(fontSize: 27, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            ProfileUI.buildProfileField('이름', '홍길동'),
            const SizedBox(height: 30),
            ProfileUI.buildProfileField('이메일', 'sample@gmail.com'),
            const SizedBox(height: 30),
            ProfileUI.buildProfileField('비밀번호', '1234'),
            const SizedBox(height: 30),
            const Spacer(),
            ProfileUI.buildMemberSettings(context),
          ],
        ),
      ),
    );
  }
}
