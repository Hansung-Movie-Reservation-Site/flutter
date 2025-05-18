import 'package:flutter/material.dart';
import 'MyCinemaUI.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCinemaScreen extends StatefulWidget {
  @override
  _MyCinemaScreenState createState() => _MyCinemaScreenState();
}

class _MyCinemaScreenState extends State<MyCinemaScreen> {

  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  Future<void> loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userCinema = prefs?.getString("user_cinema");
    });
  }

  String? selectedRegion;
  String? selectedCinema;
  String? userCinema; //현재 유저 시네마
  String? selectedRecentCinema;

  // 샘플 데이터
  final Map<String, List<String>> cinemaMap = {
    '서울': ['강남', '건대입구', '대학로', '미아'],
    '경기': ['남양주', '동탄', '분당', '수원'],
    '인천': ['검단', '송도', '영종', '인천논현'],
    '강원': ['남춘천', '속초', '원주혁신', '춘천석사'],
    '대구': ['대구신세계', '대구이시아', '마산', '창원'],
    '부산': ['경상대', '덕천', '부산대', '해운대'],
    '제주': ['서귀포', '제주삼화', '제주아라'],
  };

  // 최근 방문한 영화관 샘플 데이터
  final List<String> recentCinemas = ['건대입구', '대학로'];

  // 영화관 지정 버튼 눌렀을 때 실행할 작업
  Future<void> onCinemaSelected() async {
    if (selectedCinema != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_cinema', selectedCinema!);
      // 영화관 지정 완료 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "$selectedCinema 영화관으로 지정되었습니다.",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
      );
    } else {
      // 영화관이 선택되지 않았을 경우
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("극장을 선택해주세요."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '내 영화관',
          style: TextStyle(fontSize: 27, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          MyCinemaUI.buildCinemaInfo(userCinema), // 선택된 영화관 정보 표시
          const SizedBox(height: 50),

          // 영화관 선택 UI
          MyCinemaUI.buildCinemaSelection(
            cinemaMap: cinemaMap,
            selectedRegion: selectedRegion,
            selectedCinema: selectedCinema,
            recentCinemas: recentCinemas,
            selectedRecentCinema: selectedRecentCinema,
            onRegionSelected: (region) {
              setState(() {
                selectedRegion = region;
                selectedCinema = null;
              });
            },
            onCinemaSelected: (cinema) {
              setState(() {
                selectedCinema = cinema;
                selectedRecentCinema = null;
              });
            },
            onRecentCinemaSelected: (cinema) {
              setState(() {
                selectedRecentCinema = cinema;
                selectedCinema = cinema;
              });
            },

          ),

          const Spacer(),

          // 영화관 지정 버튼
          MyCinemaUI.buildSelectButton(context, onCinemaSelected),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
