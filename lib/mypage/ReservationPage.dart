import 'package:flutter/material.dart';
import 'package:movie/mypage/Mypage_login.dart';
import 'package:movie/mypage/ReservationUI.dart';

// 우선 샘플 데이터로 화면 구성, API 연동 추가 예정

class ReservationScreen extends StatelessWidget {
  final List<Map<String, String>> reservations = [
    {
      "title": "어벤져스: 엔드게임",
      "date": "2025-03-25",
      "theater": "CGV 강남",
      "people": "2명"
    },
    {
      "title": "인셉션",
      "date": "2025-03-26",
      "theater": "롯데시네마 홍대",
      "people": "3명"
    },
    {
      "title": "어벤져스: 엔드게임",
      "date": "2025-03-25",
      "theater": "CGV 강남",
      "people": "2명"
    },
    {
      "title": "어벤져스: 엔드게임",
      "date": "2025-03-25",
      "theater": "CGV 강남",
      "people": "2명"
    },
    {
      "title": "어벤져스: 엔드게임",
      "date": "2025-03-25",
      "theater": "CGV 강남",
      "people": "2명"
    },
    {
      "title": "어벤져스: 엔드게임",
      "date": "2025-03-25",
      "theater": "CGV 강남",
      "people": "2명"
    },
    {
      "title": "어벤져스: 엔드게임",
      "date": "2025-03-25",
      "theater": "CGV 강남",
      "people": "2명"
    },
  ];

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
        title: Text(
          '예매 내역',
          style: TextStyle(
            fontSize: 27,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReservationUI(reservations: reservations),
      ),
    );
  }
}