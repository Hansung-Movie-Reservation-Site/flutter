import 'package:flutter/material.dart';
import 'MyCinemaUI.dart';
import 'package:movie/mypage/Mypage_login.dart';

class MyCinemaScreen extends StatefulWidget {
  @override
  _MyCinemaScreenState createState() => _MyCinemaScreenState();
}

class _MyCinemaScreenState extends State<MyCinemaScreen> {
  String? selectedCinema = "건대입구"; // 기본 지정 영화관

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
          '내 영화관',
          style: TextStyle(
            fontSize: 27,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          MyCinemaUI.buildCinemaInfo(selectedCinema), // 영화관 정보 UI
          SizedBox(height: 20), // Adjust space between info and cinema selection
          MyCinemaUI.buildCinemaSelection(
            ['서울', '경기', '인천', '강원', '대구', '부산', '제주'], // Sample data
            selectedCinema,
                (cinema) {
              setState(() {
                selectedCinema = cinema;
              });
            },
          ),
          Spacer(),
          MyCinemaUI.buildSelectButton(() {
            // Handle the button press (e.g., save selected cinema)
            print('영화관 지정: $selectedCinema');
          }),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
