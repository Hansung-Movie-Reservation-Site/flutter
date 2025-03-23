import 'package:flutter/material.dart';

class MyCinemaUI {
  static Widget buildCinemaInfo(String? selectedCinema) {
    return Container(
      width: 360,
      height: 78,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 10,
            left: 0,
            child: Text(
              '현재 지정된 내 영화관은',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Roboto',
                fontSize: 22,
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 140,
            child: Text(
              '$selectedCinema',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Roboto',
                fontSize: 22,
                fontWeight: FontWeight.normal,
                height: 1.27,
              ),
            ),
          ),
          Positioned(
            top: 50, // 아래로 살짝 내려줌
            left: 240, // 오른쪽으로 살짝 치우침
            child: Text(
              '지점 입니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Roboto',
                fontSize: 22,
                fontWeight: FontWeight.normal,
                height: 1.27,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 영화관 선택 UI (샘플 데이터)
  static Widget buildCinemaSelection(
      List<String> cinemas, String? selectedCinema, Function(String) onCinemaSelected) {
    return Container(
      width: 367.57,
      height: 131,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '극장 선택',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Color.fromRGBO(29, 27, 32, 1),
              fontFamily: 'Roboto',
              fontSize: 18,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
              height: 1.5555555555555556,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 344,
            height: 40.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: cinemas.map((cinema) {
                return GestureDetector(
                  onTap: () {
                    onCinemaSelected(cinema);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selectedCinema == cinema
                            ? Color.fromRGBO(228, 0, 0, 1)
                            : Color.fromRGBO(0, 0, 0, 1),
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Center(
                      child: Text(
                        cinema,
                        style: TextStyle(
                          color: selectedCinema == cinema
                              ? Color.fromRGBO(238, 0, 0, 1)
                              : Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // 영화관 지정 버튼 UI
  static Widget buildSelectButton(VoidCallback onPressed) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SizedBox(
          width: 150,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: onPressed,
            child: const Text(
              '영화관 지정',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
