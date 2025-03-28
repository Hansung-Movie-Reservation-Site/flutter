import 'package:flutter/material.dart';
import 'package:movie/mypage/MyCinemaPage.dart';
import 'package:movie/mypage/ProfilePage.dart';
import 'package:movie/mypage/ReservationPage.dart';
import 'package:movie/mypage/PaymentCancelPage.dart';
import 'package:movie/mypage/MypageUI_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 로그인 상태일 때 나타나는 마이페이지 화면

class MyPage_Login extends StatefulWidget {
  const MyPage_Login({super.key});

  @override
  _MyPage_LoginState createState() => _MyPage_LoginState();
}

class _MyPage_LoginState extends State<MyPage_Login> {
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
}

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedUsername = prefs.getString('username') ?? '알수없음';

    // 화면이 렌더링된 후에 username 값이 알수 없음이면 로그아웃 페이지로 이동
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (storedUsername == '알수없음') {
        Navigator.pushReplacementNamed(context, '/MyPage_Logout');
      } else {
        setState(() {
          username = storedUsername;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          Center(child: MyPageUI_Login.buildLoginCard(context, username)),
          SizedBox(height: 50),
          MyPageUI_Login.buildDivider(450),
          MyPageUI_Login.buildListItem("내 영화관 지정", Icons.location_on, () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyCinemaScreen()))),
          MyPageUI_Login.buildDivider(450),
          MyPageUI_Login.buildListItem("예매내역 조회", Icons.mobile_friendly, () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReservationScreen()))),
          MyPageUI_Login.buildDivider(450),
          MyPageUI_Login.buildListItem("결제 취소", Icons.error, () => Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentCancelScreen()))),
          MyPageUI_Login.buildDivider(450),
          MyPageUI_Login.buildLogoutButton(context),
        ],
      ),
    );
  }
}


