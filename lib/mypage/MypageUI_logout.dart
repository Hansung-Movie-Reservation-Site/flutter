import 'package:flutter/material.dart';
import 'package:movie/auth/LoginPage.dart';

// 로그아웃 마이페이지 UI
// 네비게이션바 : 현성님이 만들면 추가할 예정

class MyPageUI_Logout {

  static Widget buildLogoutCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      child: Container(
        width: 450,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Color.fromRGBO(142, 142, 147, 1),
            width: 1,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(Icons.account_circle, size: 60, color: Colors.grey),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                '회원서비스 이용을 위해 로그인이 필요합니다',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildDivider(double width) {
    return Container(
      width: width,
      child: Divider(
        color: Color.fromRGBO(142, 142, 147, 1),
        thickness: 1,
        endIndent: 0,
        indent: 0,
      ),
    );
  }

  // 목록
  static Widget buildListItem(String text, IconData leftIcon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 450,
        height: 60,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(leftIcon, size: 24, color: Colors.black),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
            Icon(Icons.navigate_next, size: 24, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // 로그인 필요 다이얼로그
  static void showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("알림"),
          backgroundColor: Colors.white,
          content: Text("로그인이 필요한 서비스입니다."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("확인"),
            ),
          ],
        );
      },
    );
  }
}
