import 'package:flutter/material.dart';
import 'package:movie/mypage/MypageUI_logout.dart';

import '../Common/navbar.dart';

// 로그아웃 상태일 때 나타나는 마이페이지
class MyPage_Logout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            Center(child: MyPageUI_Logout.buildLogoutCard(context)),
            SizedBox(height: 30),
            MyPageUI_Logout.buildDivider(450),
            MyPageUI_Logout.buildListItem("내 영화관 지정", Icons.location_on,
                onTap: () => MyPageUI_Logout.showLoginRequiredDialog(context)),
            MyPageUI_Logout.buildDivider(450),
            MyPageUI_Logout.buildListItem("예매내역 조회", Icons.mobile_friendly,
                onTap: () => MyPageUI_Logout.showLoginRequiredDialog(context)),
            MyPageUI_Logout.buildDivider(450),
            MyPageUI_Logout.buildListItem("결제 취소", Icons.error,
                onTap: () => MyPageUI_Logout.showLoginRequiredDialog(context)),
            MyPageUI_Logout.buildDivider(450),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
