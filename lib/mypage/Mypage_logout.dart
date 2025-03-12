import 'package:flutter/material.dart';
import 'package:movie/auth/LoginPage.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyPage_Logout(),
    );
  }
}

class MyPage_Logout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          GestureDetector(
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
          ),
          SizedBox(height: 50),
          _buildDivider(450),
          _buildListItem(
            "내 영화관 지정",
            Icons.location_on,
            onTap: () => _showLoginRequiredDialog(context),
          ),
          _buildDivider(450),
          _buildListItem(
            "예매내역 조회",
            Icons.mobile_friendly,
            onTap: () => _showLoginRequiredDialog(context),
          ),
          _buildDivider(450),
          _buildListItem(
            "결제 취소",
            Icons.error,
            onTap: () => _showLoginRequiredDialog(context),
          ),
          _buildDivider(450),
          Spacer(),
          _buildNavigationBar(),
        ],
      ),
    );
  }

  Widget _buildDivider(double width) {
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

  Widget _buildListItem(String text, IconData leftIcon, {VoidCallback? onTap}) {
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

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("알림"),
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

  Widget _buildNavigationBar() {
    return Container(
      width: double.infinity,
      height: 100,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavigationBarItem("영화 추천"),
          _buildNavigationBarItem("예매"),
          _buildNavigationBarItem("마이 페이지", isActive: true),
        ],
      ),
    );
  }

  Widget _buildNavigationBarItem(String text, {bool isActive = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Icon(
            isActive ? Icons.stars : Icons.stars_outlined,
            size: 30,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 7),
        Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
