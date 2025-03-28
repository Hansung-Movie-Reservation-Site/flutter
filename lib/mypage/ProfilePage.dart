import 'package:flutter/material.dart';
import 'package:movie/mypage/Mypage_login.dart';
import 'package:movie/auth/AuthService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ProfileUI.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '알 수 없음';
      email = prefs.getString('email') ?? '알 수 없음';
    });
  }

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
            ProfileUI.buildProfileField('이름', username),
            const SizedBox(height: 30),
            ProfileUI.buildProfileField('이메일', email),
            const SizedBox(height: 30),
            ProfileUI.buildProfileField('내 극장', '건대 입구'),
            const SizedBox(height: 30),
            const Spacer(),
            ProfileUI.buildMemberSettings(context),
          ],
        ),
      ),
    );
  }
}
