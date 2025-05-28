import 'package:flutter/material.dart';
import 'package:movie/Common/Localapiservice.dart';
import 'package:movie/Response/MyTheather.dart';
import 'MyCinemaUI.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCinemaScreen extends StatefulWidget {
  @override
  _MyCinemaScreenState createState() => _MyCinemaScreenState();
}

class _MyCinemaScreenState extends State<MyCinemaScreen> {

  SharedPreferences? prefs;
  int user_id = -1;
  Localapiservice localapiservice = new Localapiservice();
  List<MyTheather> myTheatherList = [];

  @override
  void initState() {
    super.initState();
    loadPrefs();
    getMyTheather();
  }
  Future<void> getMyTheather() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs!.getInt("user_id")!;
    });
    print("user_id: "+user_id.toString());
    myTheatherList = await localapiservice.getMyTheather(user_id);
    setState(() {});
    print("myTheatherList.length: "+myTheatherList.length.toString());
    for(var i =0; i<myTheatherList.length; i++){
      print("myTheatherList spot_id: "+myTheatherList[i].spotId.toString());
    }
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
  final Map<String, Map<int, String>> spotData = {
    '서울': {1: '강남', 2: '건대입구', 3: '대학로', 4: '미아'},
    '경기': {5: '남양주', 6: '수원', 7: '동탄', 8: '분당'},
    '인천': {9: '인천논현', 10: '송도', 11: '영종', 12: '검단'},
    '강원': {13: '남춘천', 14: '속초', 15: '원주혁신', 16: '춘천석사'},
    '대구': {17: '대구이시아', 18: '대구신세계', 19: '마산', 20: '창원'},
    '부산': {21: '덕천', 22: '해운대', 23: '부산대', 24: '경상대'},
    '제주': {25: '제주삼화', 26: '서귀포', 27: '제주아라'},
  };

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

          // 영화관 목록 보여주기
          Expanded(
            child: ListView(
              children: spotData.entries.map((entry) {
                String region = entry.key;
                Map<int, String> cinemas = entry.value;

                return ExpansionTile(
                  title: Text(
                    region,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  children: cinemas.entries.map((cinemaEntry) {
                    int spotId = cinemaEntry.key;
                    String cinemaName = cinemaEntry.value;
                    bool isSelected = selectedCinema == cinemaName;

                    return ListTile(
                      title: Text(cinemaName),
                      trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
                      onTap: () {
                        setState(() {
                          selectedCinema = cinemaName;
                        });
                      },
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),

          // 영화관 지정 버튼
          MyCinemaUI.buildSelectButton(context, onCinemaSelected),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
