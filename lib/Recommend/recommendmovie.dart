import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie/Common/ApiService.dart';
import 'package:movie/auth/Apiservicev2.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Common/navbar.dart';
import '../Common/SearchModal.dart';
import 'package:http/http.dart' as http;

import '../Reservation/MovieDetail.dart';
import '../Response/Movie.dart';
import '../auth/LoginPage.dart';
import '../providers/auth_provider.dart';
import '../reserve/TheaterPage.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class RecommendMovie extends StatefulWidget {
  const RecommendMovie({super.key});



  @override
  State<RecommendMovie> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<RecommendMovie> {
  var scroll = ScrollController();
  Map<String, dynamic> result = {}; // 초기값을 빈 Map으로 설정
  //int movie_id = 0; // 기본값 0으로 설정
  var reason ='알 수 없음';
  int? user_id = -1;
  String username = "알 수 없음";
  Movie? movie = null;
  bool _isHovering = false;
  String movie_poster = "";

  String searchKeyword = ''; // 검색어 상태
  List<Movie> products = [];

  bool isLoading = false;
  int status = 200;
  // http://localhost:8080/
  // https://hs-cinemagix.duckdns.org/

  final Apiservicev2 apiservicev2 = new Apiservicev2();
  @override
  void initState() {
    super.initState();

    setState(() {isLoading = true;});
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try{
        //await context.read<MovieStore>().getMovieData(); // 영화 데이터 먼저 로딩

        SharedPreferences prefs = await SharedPreferences.getInstance();
        user_id = prefs.getInt("user_id");
        print("user_id: "+ user_id.toString());
        username = prefs.getString("username") ?? username;

        if (user_id == -1) {
          print("user_id가 null입니다. 요청 중단");
          return;
        }
        var result = await apiservicev2.aiRecommand(user_id!);
        print("result 요청 완.");
        if (result != null) {
          setState(() {
            //result = responseJson;
            //movie_id = result['movie_id'] ?? 0;
            movie = Movie.fromJson(result['movie']) ?? null;
            reason = result['reason'] ?? reason;
          });

          setState(() {movie_poster = movie!.posterImage; isLoading = false;});
        } else {
          // 실패 또는 예외
          print("해당 ID의 영화를 찾을 수 없습니다.");
        }
      }
      catch(e){
        Navigator.pushNamed(context, '/MyPage_Login');
      }
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
      body: isLoading == false
          ? Container(child: SingleChildScrollView(
            child: Stack(
          clipBehavior: Clip.none, // ← overflow 허용
          children: [
            Positioned(
              top: 0, left: 0, right: 0,      // 좌우 꽉 채우기
              height: 180,   // 높이 150
              child: Container(
                color: Colors.redAccent,
              ),
            ),
            if(status == 200) Align(
              alignment: Alignment.topCenter,
              child: Padding(
                  padding: const EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(margin: EdgeInsets.only(left: 30),
                      child:
                      Row(children: [
                        Image.asset('assets/AI.png', width: 50, height: 50, color: Colors.white,),
                        SizedBox(width: 20),
                        Text(username+"님을 위한 AI 추천", style: TextStyle(fontSize: 27,color: Colors.white)), Spacer(),
                        IconButton(onPressed: () async {
                          setState(() {isLoading = true;});
                          result = (await  apiservicev2.aiRecommand(user_id!))!;
                          setState(() {
                            movie = Movie.fromJson(result['movie']) ?? null;
                            reason = result['reason'] ?? reason;
                          });
                          setState(() {movie_poster = movie!.posterImage; isLoading = false;});
                          }, icon: Image.asset("assets/reload.png", height: 20, width: 20, color: Colors.white)),],)),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.all(5),
                    //decoration: Border,
                    decoration: commonBoxDecoration(top: true),
                    child: ClipRRect(
                      child: Image.network(
                        movie_poster,
                        width: MediaQuery.of(context).size.width * 0.8,
                        //height: MediaQuery.of(context).size.height * 0.58,
                        //fit: BoxFit.cover,
                          fit: BoxFit.fitWidth
                      ),
                    ),),
                  SizedBox(height: 5,),
                  Container(
                      padding: EdgeInsets.all(5),
                      //decoration: Border,
                      decoration: commonBoxDecoration(),
                      width: MediaQuery.of(context).size.width * 0.82,
                      child: Text(
                        movie!.title,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                      )
                  ),
                  Container(
                      padding: EdgeInsets.all(5),
                      //decoration: Border,
                      decoration: commonBoxDecoration(bottom: true),
                      width: MediaQuery.of(context).size.width * 0.82,
                      child:
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 2),
                        Text(" 추천 이유: $reason"),
                        const SizedBox(height: 5),
                        MouseRegion(
                          onEnter: (_) => setState(() => _isHovering = true),
                          onExit: (_) => setState(() => _isHovering = false),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MovieDetailPage(movieId: movie!.id),
                                ),
                              );
                            },
                            child: Align(alignment: Alignment.topLeft,
                                child: Text(
                              "더 자세히...",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: _isHovering ? Colors.red : Colors.black,
                              ),
                            )
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FractionallySizedBox(
                          widthFactor: 1.0,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TheaterPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              //padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text("예매하기"),
                          ),
                        ),
                      ]
                  )),
                  SizedBox(height: 5,)
                ],
              ))
            )
            else Center(child: IconButton(onPressed: () async {
              setState(() {isLoading = true;});
              result = (await  apiservicev2.aiRecommand(user_id!))!;
              setState(() {
                movie = Movie.fromJson(result['movie']) ?? null;
                reason = result['reason'] ?? reason;
              });
             // ApiService().printCookies();
              setState(() {movie_poster = movie!.posterImage; isLoading = false; status = 200;});
              },
              icon: Center(
                child: Column(
                  children: [
                    SizedBox(height: 24,),
                    Text("${status} ERROR 발생"),
                    SizedBox(height: 10,),
                    Image.asset("assets/error.png", height: 50, width: 50, color: Colors.white),
                    SizedBox(height: 10,),
                    Text("아이콘을 클릭하여 다시 시도하여 주십시오.")
                  ],
              ),
              )))
          ],
        )),)
          : const Center( child: CircularProgressIndicator(strokeWidth: 4, color: Colors.redAccent,),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}

BoxDecoration commonBoxDecoration({bool top = false, bool bottom = false}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(top ? 5 : 0),
      topRight: Radius.circular(top ? 5 : 0),
      bottomLeft: Radius.circular(bottom ? 5 : 0),
      bottomRight: Radius.circular(bottom ? 5 : 0),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        offset: Offset(0, 4),
        blurRadius: 6,
        spreadRadius: 0,
      ),
    ],
  );
}

// class AppContainer extends StatelessWidget {
//   final Widget child;
//   final EdgeInsetsGeometry? padding;
//   final EdgeInsetsGeometry? margin;
//
//   const AppContainer({
//     super.key,
//     required this.child,
//     this.padding,
//     this.margin,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity, // ✅ 부모 너비에 맞춰 확장
//       margin: margin,
//       padding: padding ?? const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white70,
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: child),
//     );
//   }
// }