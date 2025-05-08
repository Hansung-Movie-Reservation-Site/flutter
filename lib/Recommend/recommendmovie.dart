import 'dart:convert';

import 'package:flutter/material.dart';
import '../Common/movie.dart';
import '../Common/navbar.dart';
import '../Common/SearchModal.dart';
import 'package:http/http.dart' as http;

class RecommendMovie extends StatefulWidget {
  const RecommendMovie({super.key});



  @override
  State<RecommendMovie> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<RecommendMovie> {

  var scroll = ScrollController();
  var result;
  var movie_id;
  var reason;

  var ai;
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
      setState(() {
        result = utf8.decode(response.bodyBytes);
      });
      print(result);
      // print('응답 데이터: ${response.body}');
      // result = utf8.decode(response.bodyBytes);
      // print("movie_id: " + result['movie_id']);
      // print("reason: " + result['reason']);
      // movie_id = result['movie_id'];
      // reason = result['reason'];
      // print(result);
    } else {
      print('오류 발생: ${response.statusCode}');
    }
  }
  @override
  void initState() {
    super.initState();
    //fetchProducts();
    sendPost();
  }
// flutter run -d chrome --web-port=8000
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('영화부기'),
        actions: [
          IconButton( // 검색 아이콘 관련
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
                          }
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
          if (result.isNotEmpty)Center(child: Text('완'))
          else
            Center(child: Text('로딩중')),
          ],),
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