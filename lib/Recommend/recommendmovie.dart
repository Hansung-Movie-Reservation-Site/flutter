import 'dart:convert';

import 'package:flutter/material.dart';
import '../Common/movie.dart';
import '../Common/navbar.dart';
import '../Common/SearchModal.dart';
import 'package:http/http.dart' as http;

import '../reserve/TheaterPage.dart';

class RecommendMovie extends StatefulWidget {
  const RecommendMovie({super.key});



  @override
  State<RecommendMovie> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<RecommendMovie> {
  var scroll = ScrollController();
  Map<String, dynamic> result = {}; // 초기값을 빈 Map으로 설정
  int movie_id = 0; // 기본값 0으로 설정
  var reason ="";

  String searchKeyword = ''; // 검색어 상태
  List<Movie> products = [];

  sendPost() async {
    var url = Uri.parse('http://localhost:8080/api/v1/AIRecommand/synopsis');

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json;charset=UTF-8', // JSON 전송 시
      },
      body: jsonEncode({
        "user_id": 9
      }),
    );

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        result = responseJson;
        // null 체크 후 값을 설정
        movie_id = responseJson['movie_id'] ?? 0; // movie_id가 null일 경우 0으로 설정
        reason = responseJson['reason'] ?? '알 수 없음'; // reason이 null일 경우 기본값 설정
      });
      print(result);
    } else {
      print('오류 발생: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    sendPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('영화부기'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: SearchModalWidget(
                        onSearch: (searchKeyword) {
                          setState(() {
                            searchKeyword = searchKeyword;
                          });
                        },
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (result.isNotEmpty)
            Text(movie_id.toString()) // movie_id 출력
          else
            Center(child: Text('로딩중')),
        ],
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}


class AppContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const AppContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // ✅ 부모 너비에 맞춰 확장
      margin: margin,
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: child),
    );
  }
}