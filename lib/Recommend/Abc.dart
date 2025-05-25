import 'package:animations/animations.dart'; // animations 패키지 import

import 'package:flutter/cupertino.dart'; // Cupertino 패키지 import
import 'package:flutter/foundation.dart'; // Flutter 기본 패키지 import
import 'package:flutter/material.dart'; // Material 패키지 import
import 'package:flutter/widgets.dart'; // Flutter 위젯 패키지 import

// SharedAxisScreen 클래스 선언
class SharedAxisScreen extends StatefulWidget {
  static String routeURL = "sharedaxis";
  static String routeName = "sharedaxis";
  const SharedAxisScreen({super.key});

  @override
  State<SharedAxisScreen> createState() => _SharedAxisScreenState();
}

// SharedAxisScreen의 State 클래스 선언
class _SharedAxisScreenState extends State<SharedAxisScreen> {
  int _currentImage = 1; // 현재 이미지 인덱스

  // 이미지 변경 함수
  void _goToImange(int newImage) {
    setState(() {
      _currentImage = newImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shared Axis"), // 앱바 타이틀
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,  // 원하는 높이 지정
            width: double.infinity, // 너비는 가득 채우기 (또는 원하는 너비)
            child: PageTransitionSwitcher(
              transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
                  SharedAxisTransition(
                    animation: primaryAnimation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.horizontal,
                    child: child,
                  ),
              child: Text(1.toString()),
            ),
          ),
          const SizedBox(
            height: 50, // 간격 높이
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center, // 수직 정렬 방식
            mainAxisAlignment: MainAxisAlignment.spaceAround, // 수평 정렬 방식
            children: [
              for (int i = 1; i <= 5; i++)
                ElevatedButton(
                  // 활성화된 버튼
                  onPressed: () => _goToImange(i), // 클릭 이벤트 핸들러
                  child: Text(i.toString()), // 텍스트 표시
                )
            ],
          )
        ],
      ),
    );
  }
}