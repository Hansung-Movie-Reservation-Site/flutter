import 'package:flutter/material.dart';
import 'package:movie/mypage/Mypage_login.dart';
import 'package:movie/mypage/PaymentCancelUI.dart';

// 우선 샘플 데이터로 화면 구성, API 연동 추가 예정

class PaymentCancelScreen extends StatelessWidget {
  final List<Map<String, String>> paymentcancel = [
    {
      "title": "어벤져스: 엔드게임",
      "date": "2025-03-25",
      "theater": "CGV 강남",
      "price": "15000"
    },
    {
      "title": "인셉션",
      "date": "2025-03-26",
      "theater": "롯데시네마 홍대",
      "price": "30000"
    },
    {
      "title": "어벤져스: 엔드게임",
      "date": "2025-03-25",
      "theater": "CGV 강남",
      "price": "15000"
    },
    {
      "title": "어벤져스: 엔드게임",
      "date": "2025-03-25",
      "theater": "CGV 강남",
      "price": "60000"
    },
    {
      "title": "어벤져스: 엔드게임",
      "date": "2025-03-25",
      "theater": "CGV 강남",
      "price": "15000"
    },
    {
      "title": "어벤져스: 엔드게임",
      "date": "2025-03-25",
      "theater": "CGV 강남",
      "price": "15000"
    },
    {
      "title": "어벤져스: 엔드게임",
      "date": "2025-03-25",
      "theater": "CGV 강남",
      "price": "15000"
    },
    {
      "title": "어벤져스: 엔드게임",
      "date": "2025-03-25",
      "theater": "CGV 강남",
      "price": "15000"
    },
    {
      "title": "어벤져스: 엔드게임",
      "date": "2025-03-25",
      "theater": "CGV 강남",
      "price": "45000"
    },
    {
      "title": "어벤져스: 엔드게임",
      "date": "2025-03-25",
      "theater": "CGV 강남",
      "price": "15000"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // AppBar height
        child: AppBar(
          backgroundColor: Colors.white, // Ensure it's always white
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 35),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyPage_Login()),
              );
            },
          ),
          title: Text(
            '결제 취소',
            style: TextStyle(
              fontSize: 27,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PaymentCancelUI(paymentcancel: paymentcancel),
      ),
    );
  }
}