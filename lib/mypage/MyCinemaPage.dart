import 'package:flutter/material.dart';
import 'package:movie/Common/Localapiservice.dart';
import 'package:movie/Response/MyTheater.dart';
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
  List<MyTheater> myTheaterList = [];
  List<MyTheater> selectedCinemas = []; // 여러 개 선택 가능하도록

  @override
  void initState() {
    super.initState();
    getMyTheater();
    loadPrefs();
  }
  Future<void> getMyTheater() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs!.getInt("user_id")!;
    });
    print("user_id: "+user_id.toString());
    selectedCinemas = await localapiservice.getMyTheater(user_id);
    setState(() {});
  }

  Future<void> loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    // setState(() {
    //     selectedCinemas = myTheaterList;
    // });
  }

  String? selectedRegion;
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
    if (selectedCinemas.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> jsonList = selectedCinemas.map((e) => e.toJson().toString()).toList();
      await prefs.setStringList('user_cinema_list', jsonList);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${selectedCinemas.map((e) => e.spotId).join(', ')} 영화관으로 지정되었습니다.",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
      );
    } else {
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
          selectedCinemas.length != 0 ? MyCinemaUI.buildCinemaInfo(selectedCinemas, spotData): Text("내 영화관이 없습니다."),// 선택된 영화관 정보 표시
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

                  bool isSelected = selectedCinemas.any((e) => e.spotId == spotId);

                  return ListTile(
                    title: Text(cinemaName),
                    trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedCinemas.removeWhere((e) => e.spotId == spotId);
                        } else {
                          // id는 myTheaterList에서 찾아서 지정
                          MyTheater? found = myTheaterList.firstWhere(
                                (t) => t.spotId == spotId,
                            orElse: () => MyTheater(id: -1, spotId: spotId),
                          );
                          selectedCinemas.add(found);
                        }
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
