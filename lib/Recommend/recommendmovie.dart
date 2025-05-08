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
          if (result.isNotEmpty)Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color(0xFFECE6F0),
                ),
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppContainer(
                        child:
                        ClipRRect(
                          //borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            'https://img.cgv.co.kr/Movie/Thumbnail/Poster/000089/89058/89058_320.jpg',
                            width: MediaQuery.of(context).size.width * 0.8,  // 화면 크기의 80%로 설정
                            height: MediaQuery.of(context).size.height * 0.4, // 화면 크기의 40%로 설정
                            fit: BoxFit.contain,
                          ),
                        )),
                    SizedBox(width: 10,height: 10),
                    AppContainer(child:
                    Container(child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("추천 영화: "+movie_id.toString()),
                        Text("추천 이유: "+reason),
                        Align(
                            alignment: Alignment.center,
                            child:  ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const TheaterPage()),
                                  );},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red, // 배경 빨간색
                                  foregroundColor: Colors.white, // 텍스트 색상 (선택사항)
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),child: Text("예매하기"))
                        )
                      ],))),
                    SizedBox(width: 10,height: 10),
                    AppContainer(child:
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Summary',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '미키 17 (15세)',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text('2시간 17분', style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 4),
                          const Text('감독: 봉준호', style: TextStyle(fontSize: 16)),
                          const Text('장르: 어드벤처, SF, 드라마', style: TextStyle(fontSize: 16)),
                          const Text('개봉: 2025.02.28', style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 10),

                          // 예매하기 버튼
                        ],),),)],)),)// movie_id 출력
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