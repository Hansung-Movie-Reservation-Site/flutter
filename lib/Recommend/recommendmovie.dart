import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Common/movie.dart';
import '../Common/navbar.dart';
import '../Common/SearchModal.dart';
import 'package:http/http.dart' as http;

import '../Reservation/MovieDetail.dart';
import '../providers/auth_provider.dart';
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
  var reason ='알 수 없음';
  int? user_id = -1;
  String username = "알 수 없음";
  Movie? movie_detail = null;
  bool _isHovering = false;

  String searchKeyword = ''; // 검색어 상태
  List<Movie> products = [];

  sendPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getKeys().forEach((key) {
      print('$key: ${prefs.get(key)} (${prefs.get(key)?.runtimeType})');
    });

    user_id = prefs.getInt("user_id");
    username = prefs.getString("username")?? username;

    var url = Uri.parse('https://hs-cinemagix.duckdns.org/api/v1/AIRecommand/synopsis');

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json;charset=UTF-8', // JSON 전송 시
      },
      body: jsonEncode({
        "user_id": user_id
      }),
    );

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        result = responseJson;
        // null 체크 후 값을 설정
        movie_id = responseJson['movie_id'] ?? 0; // movie_id가 null일 경우 0으로 설정
        reason = responseJson['reason'] ?? reason; // reason이 null일 경우 기본값 설정
      });
      print(result);
    } else {
      print('오류 발생: ${response.statusCode}');
    }
  }

  findMovie() async {
    final response = await http.get(Uri.parse('https://hs-cinemagix.duckdns.org/api/v1/movies/searchById?id=${movie_id}'));
    ///search/id
    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      Movie data = Movie.fromJson(json.decode(utf8Body));
      //final fetched = data.map((json) => Movie.fromJson(json));
      movie_detail = data;
    } else {
      print('에러 코드: ${response.statusCode}');
    }
  }
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<MovieStore>().getMovieData(); // 영화 데이터 먼저 로딩
      if(movie_id != 0) return;
      await sendPost();// movie_id 값 받아오기

      // movie_id가 설정된 후 findMovie 실행
      print("movie_id: "+movie_id.toString());
      await findMovie();

      if (movie_detail != null) {
        print("movie_detail: ${movie_detail!.id}");
      } else {
        print("해당 ID의 영화를 찾을 수 없습니다.");
      }

      setState(() {}); // 상태 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: result.isNotEmpty && movie_detail != null
          ? Container(
        child: SingleChildScrollView(
            child: Stack(
          //: MainAxisSize.min,
          //crossAxisAlignment: CrossAxisAlignment.center,
          clipBehavior: Clip.none, // ← overflow 허용
          children: [
            Expanded(
              child: Container(color: Colors.redAccent, height: 150),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                  padding: const EdgeInsets.only(top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text(
                  //   "$username 님을 위한 추천 영화",
                  //   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  // ),
                  // SizedBox(height: 7,),
                  Container(
                    padding: EdgeInsets.all(5),
                    //decoration: Border,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // 그림자 색상
                          offset: Offset(0, 4), // x=0, y=4 → 아래로 그림자
                          blurRadius: 6,        // 퍼짐 정도
                          spreadRadius: 0,      // 확장 정도
                        ),
                      ],
                    ),
                    child: ClipRRect(borderRadius: BorderRadius.circular(2),
                      child: Image.network(
                        movie_detail?.posterImage ?? '',
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.58,
                        fit: BoxFit.contain,
                      ),
                    ),),
                  SizedBox(height: 5,),
                  Container(color: Colors.white, child: Text("1")),
                  SizedBox(height: 5,),
                  Container(color: Colors.white, child: Text("1")),
                  SizedBox(height: 5,)
                ],
              ))
            )

          ],
        )),
      )
          : const Center(
        child: CircularProgressIndicator(
          strokeWidth: 4,
          color: Colors.redAccent,
        ),
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
        color: Colors.white70,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: child),
    );
  }
}