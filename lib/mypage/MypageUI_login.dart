import 'package:flutter/material.dart';
import 'package:movie/mypage/ProfilePage.dart';
import '../Common/DialogMaker.dart';

// 로그인 마이페이지 UI
// 네비게이션바 : 현성님이 만들면 추가할 예정

class MyPageUI_Login {

  static Widget buildLoginCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
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
                '(사용자이름) 님 안녕하세요!',  // API 연동으로 로그인한 사용자 이름 나타나게 할 예정
                style: TextStyle(
                  fontSize: 17,
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

  // 목록
  static Widget buildListItem(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 450,
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black),
            SizedBox(width: 10),
            Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
            Icon(Icons.navigate_next, size: 24, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // 목록 구분선
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

  // 로그아웃 버튼
  static Widget buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DialogMaker.dialog(
          context, // Pass the context here
          '로그아웃 확인',
          '로그아웃 하시겠습니까?',
        );
      },
      child: Container(
        width: 450,
        height: 60,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.directions_walk,
                  size: 25,
                  color: Colors.grey,
                ),
                SizedBox(height: 5),
                Text(
                  '로그아웃',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

