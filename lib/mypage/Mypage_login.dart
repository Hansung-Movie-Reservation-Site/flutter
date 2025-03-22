import 'package:flutter/material.dart';
import 'package:movie/mypage/MyCinemaPage.dart';
import 'package:movie/mypage/ReservationPage.dart';
import 'package:movie/mypage/PaymentCancelPage.dart';
import 'package:movie/mypage/MypageUI_login.dart';

// 로그인 상태일 때 나타나는 마이페이지 화면

class MyPage_Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          Center(child: MyPageUI_Login.buildLoginCard(context)),
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


