
import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:movie/Common/Apiservicev3.dart';
import 'package:movie/Recommend/Maintab.dart';
import 'package:movie/Response/Airecommand.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Common/SearchModal.dart';
import '../Common/navbar.dart';
import '../Response/Movie.dart';
import '../Response/RecommandMovie.dart';
import '../auth/Apiservicev2.dart';
import '../providers/auth_provider.dart';
import 'Abc.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _currentIndex = 1;

  void _changeIndex(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  }

  Timer? _timer;
  final Apiservicev2 apiservicev2 = new Apiservicev2();
  final Apiservicev3 apiservicev3 = new Apiservicev3();
  int user_id = -1;
  List<Recommendmovie> result = [];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      int nextIndex = _currentIndex + 1;
      if (nextIndex > 3) nextIndex = 1;
      print("Timer tick: switching to $nextIndex");
      _changeIndex(nextIndex);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try{
        //await context.read<MovieStore>().getMovieData(); // 영화 데이터 먼저 로딩
        //if(movie_id != 0) return;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        user_id = prefs.getInt("user_id")!;
        print("mainPage의 user_id: "+ user_id.toString());

        if (user_id == -1) {
          print("user_id가 null입니다. 요청 중단");
          return;
        }
        result = await  apiservicev2.getRecommandMovies(user_id!);
        print("result 요청 완.");
        setState(() {
          //result = responseJson;
        });
      }
      catch(e){
        Navigator.pushNamed(context, '/MyPage_Login');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
      body: Container(
          child: SingleChildScrollView(child:
              SizedBox(
                height: 1700,
                  child:
              Stack(
                  clipBehavior: Clip.none, // ← overflow 허용
                  children: [
                    Positioned(
                      top: 0, left: 0, right: 0,      // 좌우 꽉 채우기
                      height: 720,   // 높이 150
                      child: Container(
                        color: Colors.white,
                        //padding: const EdgeInsets.only(top: 2),
                        child:                             Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Container(padding: const EdgeInsets.only(left: 10), child: Text("# 당신의", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
                                Container(padding: const EdgeInsets.only(left: 5), child: Text("인생영화", style: TextStyle(fontSize: 28, color: Colors.redAccent, fontWeight: FontWeight.bold))),
                                Container(padding: const EdgeInsets.only(left: 5), child: Text("를 찾아보세요", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ],
                        )
                      ),
                    ),
                 Positioned(
                      top: 45,
                      left: 0,
                      right: 0,
                      height: 240, // ← 필수
                      child: Container(padding: const EdgeInsets.only(left: 10), child: Text("당신의 리뷰를 분석하여 영화를 추천해드립니다.", style: TextStyle(fontSize: 20))),
                    ),
                    Positioned(
                      top: 70,
                      left: 0,
                      right: 0,
                      height: 240, // ← 필수
                      child:Container(padding: const EdgeInsets.only(left: 15), child: Text("나의 추천 목록", style: TextStyle(fontSize: 18))),

                    ),

                    Positioned(
            top: 100,
            left: 0,
            right: 0,
            height: 285, // ← 필수
            child: _movieRecommendationSlider(result),
          ),
          //Align(child: Text("추천 목록이 존재하지 않습니다.", style: TextStyle(fontSize: 18))),
                  Positioned(
                      top: 385,
                      left: 0,
                      right: 0,
                      height: 60, // ← 필수
                      child: Align(child: TextButton(
              style: ButtonStyle(
              ),
              onPressed: (){}, child: Container( width: double.infinity, decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(3)), child: Text("AI 추천받기", style: TextStyle(fontSize: 27, color: Colors.white), textAlign: TextAlign.center))))),
                    Positioned(
                      top: 445, left: 0, right: 0,
                      height: 150,
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(padding: const EdgeInsets.only(left: 10), child: Text("# 다른 사람과", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
                              Container(padding: const EdgeInsets.only(left: 5), child: Text("영화경험을 ", style: TextStyle(fontSize: 28, color: Colors.redAccent, fontWeight: FontWeight.bold))),
                              Container(padding: const EdgeInsets.only(left: 5), child: Text("공유해보세요", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
                            ],
                          ),
                          Container(padding: const EdgeInsets.only(left: 10), child: Text("당신의 리뷰를 분석하여 영화를 추천해드립니다.", style: TextStyle(fontSize: 20))),
                          PageTransitionSwitcher(
                            transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
                                SharedAxisTransition(
                                  animation: primaryAnimation,
                                  secondaryAnimation: secondaryAnimation,
                                  transitionType: SharedAxisTransitionType.horizontal,
                                  child: child,
                                ),
                            child: Container(
                              key: ValueKey<int>(_currentIndex),
                              color: Colors.blueAccent,
                              alignment: Alignment.center,
                              child: Text(
                                _currentIndex.toString(),
                                style: const TextStyle(fontSize: 48, color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      )
                    ), // 최신 사용자 리뷰 위젯
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                            (index) => Padding(
                          padding: EdgeInsets.only(top: 595),
                          child: ElevatedButton(
                            onPressed: () => _changeIndex(index + 1),
                            child: Text("${index + 1}"),
                          ),
                        ),
                      ),
                    )
                  ]
              ))
          )
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}

// 먼저 이 예제를 넣을 위치를 정확히 알기 위해 _yourWidget() 형태로 만들어드립니다.

Widget _movieRecommendationSlider(List<Recommendmovie> result) {
  for(var i =0; i<result.length;i++){
    print(result[i].title);
  }
  return SizedBox(
    height: 200, // 꼭 있어야 함
    child: PageView.builder(
      itemCount: result.length,
      controller: PageController(viewportFraction: 0.85),
      itemBuilder: (context, index) {
        final item = result[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(color: Colors.black12), // 배경 대체
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(result[index].posterImage,height: 100, fit: BoxFit.fill,),
                      Text(
                        "제목: ${result[index].title}",
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        item.reason,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

